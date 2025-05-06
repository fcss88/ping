# finds files larger than a specified size in a directory and its subdirectories
$thresholdSizeMB = 10
$directory = "C:\TEMP"
#Get-ChildItem -Path $directory -Recurse | Where-Object { $_.Length -gt ($thresholdSizeMB * 1MB) } | Select-Object Name, Length | Format-Table -AutoSize
Get-ChildItem -Path $directory -Recurse -File -ErrorAction SilentlyContinue |
    Where-Object { $_.Length -gt ($thresholdSizeMB * 1MB) } |
    Select-Object Name, @{Name="Path";Expression={$_.FullName}}, @{Name="SizeMB";Expression={"{0:N2}" -f ($_.Length / 1MB)}} |
    Format-Table -AutoSize