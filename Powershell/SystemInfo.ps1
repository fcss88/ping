# collect system info
$sysInfo = Get-ComputerInfo

# Info output
Write-Output "Operating System: $($sysInfo.WindowsVersion)"
Write-Output "Computer Name: $($sysInfo.CsName)"
Write-Output "Manufacturer: $($sysInfo.CsManufacturer)"
Write-Output "Model: $($sysInfo.CsModel)"
Write-Output "Total Physical Memory: $([math]::round($sysInfo.CsTotalPhysicalMemory/1GB, 2)) GB"
Write-Output "System Type: $($sysInfo.OsArchitecture)"