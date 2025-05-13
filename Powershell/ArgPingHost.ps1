if ($args.Count -eq 1) {
    $targetHost = $args[0]
    $ping = Test-Connection -ComputerName $targetHost -Count 2 -Quiet
    if ($ping) {
        Write-Output "$targetHost avaliable"
    } else {
        Write-Output "$targetHost unavaliable"
    }
}

else {
    Write-Output "Args error, need one parameter, for example: .\ArgPingHost.ps1 google.com"
}
