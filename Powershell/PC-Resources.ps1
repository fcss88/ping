# info about CPU, memory and disk space
$cpu = Get-WmiObject Win32_Processor | Measure-Object -Property LoadPercentage -Average | Select-Object -ExpandProperty Average
$memory = Get-WmiObject Win32_OperatingSystem | Select-Object -ExpandProperty FreePhysicalMemory
$disk = Get-WmiObject Win32_LogicalDisk -Filter "DriveType=3" | Select-Object DeviceID, FreeSpace, Size

# Output
Write-Output "CPU Load: $cpu%"
Write-Output "Free Memory: $([math]::round($memory/1MB, 2)) MB"
$disk | ForEach-Object {
    $freeSpace = [math]::round($_.FreeSpace/1GB, 2)
    $size = [math]::round($_.Size/1GB, 2)
    Write-Output "Drive $_.DeviceID: $freeSpace GB free of $size GB"
}