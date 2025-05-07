# Create directory if it doesn't exist
$outputDir = ".\output"
if (-not (Test-Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir | Out-Null
}

# report filepath
$reportFile = Join-Path $outputDir "hardware_report.txt"

# get data from WMI
$cpu = Get-WmiObject Win32_Processor | Select-Object -First 1 Name, NumberOfCores, NumberOfLogicalProcessors
$ram = Get-WmiObject Win32_OperatingSystem | Select-Object TotalVisibleMemorySize
$disks = Get-WmiObject Win32_LogicalDisk -Filter "DriveType=3" | Select-Object DeviceID, Size, FreeSpace

# Create report
$report = @()
$report += "=== Hardware Report ==="
$report += "Date: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
$report += ""
$report += "CPU: $($cpu.Name)"
$report += "Cores: $($cpu.NumberOfCores)"
$report += "Logical CPUs: $($cpu.NumberOfLogicalProcessors)"
$report += ""
$report += "RAM: $([math]::round($ram.TotalVisibleMemorySize / 1MB, 2)) GB"
$report += ""

foreach ($disk in $disks) {
    $sizeGB = [math]::Round($disk.Size / 1GB, 2)
    $freeGB = [math]::Round($disk.FreeSpace / 1GB, 2)
    $report += "Disk $($disk.DeviceID): Total = $sizeGB GB, Free = $freeGB GB"
}

# add to a file
$report | Out-File -FilePath $reportFile -Encoding UTF8

Write-Output "create report in: $reportFile"