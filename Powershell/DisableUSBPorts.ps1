$usbPorts = Get-WmiObject -Query "SELECT * FROM Win32_PnPEntity WHERE DeviceID LIKE 'USB%'" 
foreach ($port in $usbPorts) {
    Disable-WmiObject -Path $port.PSPath
}
Write-Output "USB ports are disabled"