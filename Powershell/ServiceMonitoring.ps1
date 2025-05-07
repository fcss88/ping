$service = Get-Service -Name "wuauserv"
if ($service.Status -eq 'Running') {
    Write-Output "Service Running"
} else {
    Write-Output "Service not Running"
}