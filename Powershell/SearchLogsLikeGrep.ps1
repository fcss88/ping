$logPath = "C:\inetpub\logs\LogFiles"
$outputPath = "output\404.log"
$keyword = "404"

# create directory output\ if it doesn't exist
if (-not (Test-Path -Path "output")) {
    New-Item -Path "output" -ItemType Directory | Out-Null
}

# write to file output\404.log
Get-ChildItem -Path $logPath -Recurse -File |
    Select-String -Pattern $keyword |
    ForEach-Object { $_.Line } |
    Out-File -FilePath $outputPath -Encoding UTF8
