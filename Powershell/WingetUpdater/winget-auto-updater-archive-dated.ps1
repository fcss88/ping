<#
.SYNOPSIS
  Winget auto-update with dated ZIP archives and cleanup of logs.
.DESCRIPTION
  - Updates Winget sources
  - Separates known and unknown packages
  - Updates known-version packages
  - Saves report temporarily in Documents\WingetReports
  - Archives reports to Desktop with timestamp in filename
  - Deletes local report files after archiving
#>

# -----------------------------
# 1. Paths
# -----------------------------
$ReportFolder = "$env:USERPROFILE\Documents\WingetReports"
$DesktopFolder = [Environment]::GetFolderPath("Desktop")
$Timestamp = Get-Date -Format 'yyyyMMdd_HHmmss'
$ReportFile = Join-Path $ReportFolder "winget_report_$Timestamp.txt"
$ZipFile = Join-Path $DesktopFolder "WingetReports_$Timestamp.zip"

# Ensure report folder exists
if (-not (Test-Path $ReportFolder)) {
    New-Item -ItemType Directory -Force -Path $ReportFolder | Out-Null
}

# -----------------------------
# 2. Update Winget sources
# -----------------------------
Write-Host ""
Write-Host "Updating Winget sources..." -ForegroundColor Cyan
try {
    winget source update --disable-interactivity | Out-Null
    Write-Host "Winget sources updated." -ForegroundColor Green
} catch {
    Write-Host "Warning: winget source update failed: $_" -ForegroundColor Yellow
}

# -----------------------------
# 3. Get all packages
# -----------------------------
Write-Host "Checking for available updates..." -ForegroundColor Cyan
$rawOutput = winget upgrade --include-unknown 2>$null

# If winget returned nothing, make sure $rawOutput is an array
if ($null -eq $rawOutput) { $rawOutput = @() }

$lines = $rawOutput | Where-Object {
    ($_ -ne $null) -and
    ($_.ToString().Trim() -ne "") -and
    ($_ -match "^\S") -and
    ($_ -notmatch "^-{2,}") -and
    ($_ -notmatch "Version") -and
    ($_ -notmatch "Available")
}

$known = @()
$unknown = @()

foreach ($line in $lines) {
    if ($line -match "Unknown") { $unknown += $line }
    else { $known += $line }
}

# -----------------------------
# 4. Save report
# -----------------------------
$reportContent = @(
    "Winget Auto Update Report - $Timestamp",
    "----------------------------------------",
    "Known packages ($($known.Count)):",
    $known,
    "",
    "Unknown packages ($($unknown.Count)):",
    $unknown,
    "",
    "----------------------------------------"
)
$reportContent | Out-File -FilePath $ReportFile -Encoding UTF8

# -----------------------------
# 5. Upgrade known packages
# -----------------------------
if ($known.Count -gt 0) {
    Write-Host ""
    Write-Host "Upgrading known packages..." -ForegroundColor Magenta
    try {
        winget upgrade --all --accept-source-agreements --accept-package-agreements 2>&1 | Tee-Object -FilePath $ReportFile -Append
        Write-Host "Upgrade completed." -ForegroundColor Green
    } catch {
        Write-Host "Upgrade encountered errors: $_" -ForegroundColor Red
        Add-Content -Path $ReportFile -Value ("ERROR during upgrade: " + $_.ToString())
    }
} else {
    Write-Host "No known-version packages to upgrade." -ForegroundColor DarkGray
    Add-Content -Path $ReportFile -Value "No known-version packages to upgrade."
}

# -----------------------------
# 6. Archive report with date
# -----------------------------
Write-Host ""
Write-Host "Archiving reports to Desktop..." -ForegroundColor Cyan

try {
    # Use Compress-Archive for reliability; include all files currently in $ReportFolder
    if (Test-Path $ZipFile) {
        Remove-Item -Path $ZipFile -Force -ErrorAction SilentlyContinue
    }

    Compress-Archive -Path (Join-Path $ReportFolder '*') -DestinationPath $ZipFile -Force
    Write-Host "Archive created at: $ZipFile" -ForegroundColor Green
} catch {
    Write-Host "Failed to create archive: $_" -ForegroundColor Red
    Add-Content -Path $ReportFile -Value ("Failed to create archive: " + $_.ToString())
}

# -----------------------------
# 7. Delete local logs
# -----------------------------
Write-Host "Deleting local log files in report folder..." -ForegroundColor Yellow
try {
    Get-ChildItem -Path $ReportFolder -File -Filter '*.txt' -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue
    Write-Host "Local logs cleaned." -ForegroundColor Green
} catch {
    Write-Host "Failed to delete local logs: $_" -ForegroundColor Red
    Add-Content -Path $ReportFile -Value ("Failed to delete local logs: " + $_.ToString())
}

Write-Host "Report archived and local logs cleaned." -ForegroundColor Green
