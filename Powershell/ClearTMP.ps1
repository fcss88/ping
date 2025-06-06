$tempPaths = @("$env:TEMP", "$env:WINDIR\Temp")
foreach ($path in $tempPaths) {
    Get-ChildItem -Path $path -Recurse -Force -ErrorAction SilentlyContinue | 
        Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
}
Write-Output "Temporary files cleared from $tempPaths"