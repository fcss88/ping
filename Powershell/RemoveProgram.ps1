# remove toolbar from Windows
Get-WmiObject -Query "SELECT * FROM Win32_Product WHERE Name LIKE '%toolbar%'" | ForEach-Object {
    $_.Uninstall()
}

# remove chrome from Windows
Get-WmiObject -Query "SELECT * FROM Win32_Product WHERE Name LIKE '%chrome%'" | ForEach-Object {
    $_.Uninstall()
}