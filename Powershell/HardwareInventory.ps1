# Get hardware inventory information from a Windows machine
$cpu = Get-WmiObject Win32_Processor | Select-Object Name, NumberOfCores, NumberOfLogicalProcessors
$ram = Get-WmiObject Win32_OperatingSystem | Select-Object TotalVisibleMemorySize
$disks = Get-WmiObject Win32_LogicalDisk -Filter "DriveType=3" | Select-Object DeviceID, Size, FreeSpace

# CPU
Write-Output "CPU: $($cpu.Name), Cores: $($cpu.NumberOfCores), Logical CPUs: $($cpu.NumberOfLogicalProcessors)"

# RAM
Write-Output "RAM: $([math]::round($ram.TotalVisibleMemorySize / 1MB, 2)) MB"

# disk
foreach ($disk in $disks) {
    $sizeGB = [math]::Round($disk.Size / 1GB, 2)
    $freeGB = [math]::Round($disk.FreeSpace / 1GB, 2)
    Write-Output "Disk $($disk.DeviceID): Total: $sizeGB GB, Free: $freeGB GB"
}