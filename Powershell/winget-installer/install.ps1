<# 
.SYNOPSIS
  Installs applications using Winget with logging, validation, and auto-upgrade.
.DESCRIPTION
  - Reads package IDs from packages.lst
  - Checks if a package is installed before installing
  - Logs everything into install_DDMMYYYY_HH-MM.log
  - Updates Winget sources
  - Runs winget upgrade at the end
#>

param()

# ---------------------------
# 1. Paths & timestamp
# ---------------------------
$ScriptDir = Split-Path -Parent $PSCommandPath
$LogDir = Join-Path $ScriptDir "logs"

if (-not (Test-Path $LogDir)) {
    New-Item -ItemType Directory -Path $LogDir | Out-Null
}

$Timestamp = Get-Date -Format "ddMMyyyy_HH-mm"
$LogFile = Join-Path $LogDir "install_$Timestamp.log"

# Logging helper
function Write-Log {
    param([string]$Message)
    $Message | Tee-Object -FilePath $LogFile -Append
}

Write-Log "===== Winget Installer Started: $(Get-Date) ====="
Write-Log "Log file: $LogFile"
Write-Host ""

# ---------------------------
# 2. Check Winget availability
# ---------------------------
Write-Host "Checking Winget..." -ForegroundColor Cyan
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Log "ERROR: winget not found. Install App Installer from Microsoft Store."
    exit 1
}

# ---------------------------
# 3. Update Winget sources
# ---------------------------
Write-Host "Updating Winget sources..." -ForegroundColor Cyan
winget source update | Out-Null

# ---------------------------
# 4. Read package list
# ---------------------------
$ListFile = Join-Path $ScriptDir "packages.lst"

if (-not (Test-Path $ListFile)) {
    Write-Log "ERROR: packages.lst not found in script directory."
    exit 1
}

$Packages = Get-Content $ListFile | Where-Object { $_.Trim() -ne "" }

Write-Host "Packages loaded: $($Packages.Count)" -ForegroundColor Yellow
Write-Log "Packages: $($Packages -join ', ')"

# ---------------------------
# 5. Process packages
# ---------------------------
foreach ($Pkg in $Packages) {

    Write-Host "`n➡ Processing: $Pkg" -ForegroundColor White
    Write-Log "`n-------- PACKAGE: $Pkg --------"

    # Check if installed
    $installed = winget list --id $Pkg --exact | Select-String $Pkg

    if ($installed) {
        Write-Host "Already installed: $Pkg" -ForegroundColor Green
        Write-Log "SKIP: $Pkg already installed."
        continue
    }

    Write-Host "Installing: $Pkg" -ForegroundColor Magenta
    Write-Log "Installing $Pkg..."

    winget install --id $Pkg --exact `
        --accept-source-agreements `
        --accept-package-agreements `
        --silent `
        | Tee-Object -FilePath $LogFile -Append

    if ($LASTEXITCODE -eq 0) {
        Write-Host "SUCCESS: $Pkg installed" -ForegroundColor Green
        Write-Log "SUCCESS: Installed $Pkg"
    }
    else {
        Write-Host "ERROR installing: $Pkg" -ForegroundColor Red
        Write-Log "ERROR installing $Pkg (exit $LASTEXITCODE)"
    }
}

# ---------------------------
# 6. Upgrade everything
# ---------------------------
Write-Host "`n Running winget upgrade --all ..." -ForegroundColor Cyan
Write-Log "`n*** Running full upgrade ***"

winget upgrade --all --include-unknown --accept-source-agreements --accept-package-agreements `
    | Tee-Object -FilePath $LogFile -Append

Write-Host "DONE!" -ForegroundColor Green
Write-Log "===== Completed at: $(Get-Date) ====="
