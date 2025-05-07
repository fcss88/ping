$logPath = "C:\inetpub\logs\LogFiles"

# Get logs IIS
$logs = Get-ChildItem -Path $logPath -Recurse -File | Sort-Object LastWriteTime

# output logs list
foreach ($log in $logs) {
    Write-Output "Logfile: $($log.FullName) | Changed: $($log.LastWriteTime)"
}