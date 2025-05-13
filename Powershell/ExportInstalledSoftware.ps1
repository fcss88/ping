Get-WmiObject -Class Win32_Product | Select-Object Name, Version | Export-Csv "output\installed_software.csv" -NoTypeInformation
Write-Output "Software list exported to output\installed_software.csv"