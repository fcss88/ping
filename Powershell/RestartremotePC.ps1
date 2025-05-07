$computerName = "server1"
Restart-Computer -ComputerName $computerName -Force
Write-Output "$computerName restated"