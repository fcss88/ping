# This script starts a specified application using PowerShell.
$programPath = "C:\Program Files\SomeApp\app.exe"
#$programPath = "C:\Program Files\7-zip\7zFM.exe"
Start-Process -FilePath $programPath
