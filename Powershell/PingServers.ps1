# Get servers list
$servers = Get-Content ".\input\serverslist.txt"

foreach ($server in $servers) {
    # Check if the server is available
    $ping = Test-Connection -ComputerName $server -Count 2 -Quiet
    if ($ping) {
        Write-Output "$server online"
    } else {
        Write-Output "$server offline"
    }
}