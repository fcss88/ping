# Create compressed backup of a folder
$sourcePath = "C:\Temp\somedirectory"
$backupPath = "d:\backup\backup.zip"
Compress-Archive -Path $sourcePath -DestinationPath $backupPath
Write-Output "Create backup here: $backupPath"