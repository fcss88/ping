# Create list of installed software to file InstalledPrograms.txt
Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | 
Select-Object DisplayName, DisplayVersion, Publisher, InstallDate |
Format-Table -AutoSize | Out-File -FilePath "C:\PC\InstalledPrograms.txt"