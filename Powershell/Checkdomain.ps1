$domain = (Get-WmiObject Win32_ComputerSystem).Domain
Write-Output "current domain: $domain"