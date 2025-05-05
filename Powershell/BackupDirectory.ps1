# Create backup
$sourcePath = "C:\ImportantData"
$backupPath = "C:\Backup\ImportantData"

if (!(Test-Path -Path $backupPath)) {
    New-Item -ItemType Directory -Path $backupPath
}

Get-ChildItem -Path $sourcePath -Recurse | ForEach-Object {
    $dest = $_.FullName -replace [regex]::Escape($sourcePath), [regex]::Escape($backupPath)
    Copy-Item -Path $_.FullName -Destination $dest -Force
}
