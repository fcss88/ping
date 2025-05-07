# CheckPort.ps1

if ($args.Count -ne 2) {
    Write-Output "wrong number of arguments. Expected 2 arguments: <host> <port>"
    Write-Output "Example: .\CheckPort.ps1 google.com 443"
    exit
}

$hostName = $args[0]
$portNumber = [int]$args[1]

$result = Test-NetConnection -ComputerName $hostName -Port $portNumber -InformationLevel Quiet

if ($result) {
    Write-Output "Port $portNumber opened on $hostName"
} else {
    Write-Output "Port $portNumber closed or unavaliable on $hostName"
}