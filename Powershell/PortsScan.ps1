$server = "ukr.net"
$ports = Get-Content "input\portslist.txt"

foreach ($port in $ports) {
    $connection = Test-NetConnection -ComputerName $server -Port $port
    if ($connection.TcpTestSucceeded) {
        Write-Output "$port port open on $server"
    } else {
        Write-Output "$port port close or disabled on $server"
    }
}