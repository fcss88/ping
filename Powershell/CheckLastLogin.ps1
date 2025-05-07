$users = Get-LocalUser

foreach ($user in $users) {
    $logonEvent = Get-WinEvent -LogName Security -MaxEvents 1000 |
        Where-Object {
            $_.Id -eq 4624 -and
            $_.Properties[5].Value -eq $user.Name
        } |
        Select-Object -First 1

    if ($logonEvent) {
        $lastLogin = $logonEvent.TimeCreated
        Write-Output "$($user.Name) - Last login: $lastLogin"
    } else {
        Write-Output "$($user.Name) - Last login: no data"
    }
}