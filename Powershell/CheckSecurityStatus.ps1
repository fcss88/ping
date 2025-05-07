$securityStatus = Get-WmiObject -Namespace "Root\SecurityCenter2" -Class AntiVirusProduct
$securityStatus | Select-Object displayName, productState | Format-Table -AutoSize