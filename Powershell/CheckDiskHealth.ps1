$disks = Get-WmiObject Win32_DiskDrive

foreach ($disk in $disks) {
    Write-Output "$($disk.DeviceID) disk state: $($disk.Status)"
}