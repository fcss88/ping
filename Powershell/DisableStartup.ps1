$startupPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"

Get-Item $startupPath | Get-ItemProperty | ForEach-Object {
    $_.PSObject.Properties | ForEach-Object {
        Remove-ItemProperty -Path $startupPath -Name $_.Name -ErrorAction SilentlyContinue
    }
}

Write-Output "Startup cleared"