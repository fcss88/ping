# finds files larger than a specified size in a directory and its subdirectories

# change the size in MB and the directory to search
$thresholdSizeMB = 10
$directory = "C:\TEMP"
#Get-ChildItem -Path $directory -Recurse | Where-Object { $_.Length -gt ($thresholdSizeMB * 1MB) } | Select-Object Name, Length | Format-Table -AutoSize
#Get-ChildItem -Path $directory -Recurse -File -ErrorAction SilentlyContinue |
#    Where-Object { $_.Length -gt ($thresholdSizeMB * 1MB) } |
#    Select-Object Name, @{Name="Path";Expression={$_.FullName}}, @{Name="SizeMB";Expression={"{0:N2}" -f ($_.Length / 1MB)}} |
#    Format-Table -AutoSize

# change the output file name and path
# don't forget to create the output directory first
$outputCsv = "output\large_files.csv"

$results = Get-ChildItem -Path $directory -Recurse -File -ErrorAction SilentlyContinue |
    Where-Object { $_.Length -gt ($thresholdSizeMB * 1MB) } |
    Select-Object Name, @{Name="Path";Expression={$_.FullName}}, @{Name="SizeMB";Expression={[math]::Round($_.Length / 1MB, 2)}}

$results | Format-Table -AutoSize
$results | Export-Csv -Path $outputCsv -NoTypeInformation -Encoding UTF8

Write-Output "files over $thresholdSizeMB MB saved in: $outputCsv"