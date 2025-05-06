# Free Disk Space Check Script
$disks = Get-WmiObject Win32_LogicalDisk -Filter "DriveType=3"
foreach ($disk in $disks) {
    $freeSpaceGB = [math]::round($disk.FreeSpace / 1GB, 2)
    $totalSizeGB = [math]::round($disk.Size / 1GB, 2)

    Write-Output "Disk $($disk.DeviceID): Free = $freeSpaceGB GB / Total = $totalSizeGB GB"

    if ($freeSpaceGB -lt 10) {
        Write-Output "WARNING: Disk $($disk.DeviceID) has only $freeSpaceGB GB free out of $totalSizeGB GB."
    }
}

# Table view of free disk space
$disks = Get-WmiObject Win32_LogicalDisk -Filter "DriveType=3" | Select-Object DeviceID,
    @{Name="Free(GB)"; Expression = {[math]::round($_.FreeSpace / 1GB, 2)}},
    @{Name="Total(GB)"; Expression = {[math]::round($_.Size / 1GB, 2)}}
$disks | Format-Table -AutoSize