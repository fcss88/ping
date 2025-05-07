# === setup ===
$sitePath = "C:\inetpub\wwwroot\MySite"             # website path
$backupRoot = "D:\Backups"                          # backup directory
$dbUser = "root"                                    # MySQL username
$dbPass = "MySecretPassword"                        # MySQL password
$dbName = "mydatabase"                              # DB name
$mysqlDumpPath = "C:\xampp\mysql\bin\mysqldump.exe" # mysqldump path

$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$tempDir = "$env:TEMP\backup_temp_$timestamp"
$zipFileName = "backup_$timestamp.zip"
$zipFilePath = Join-Path -Path $backupRoot -ChildPath $zipFileName

New-Item -ItemType Directory -Path $tempDir -Force | Out-Null

# === backup website dir ===
$siteBackupDir = Join-Path $tempDir "site"
Copy-Item -Path $sitePath -Destination $siteBackupDir -Recurse

# === backup MySQL DB ===
$dbDumpFile = Join-Path $tempDir "$dbName.sql"
& $mysqlDumpPath --user=$dbUser --password=$dbPass $dbName > $dbDumpFile

# === Create zip-file ===
Compress-Archive -Path "$tempDir\*" -DestinationPath $zipFilePath

# === remove files from temp dir ===
Remove-Item $tempDir -Recurse -Force

# === result ===
Write-Output "Backup process completed. Here your backup-file : $zipFilePath"
