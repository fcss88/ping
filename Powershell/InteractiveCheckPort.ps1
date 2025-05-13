# Ask host
$hostName = Read-Host "Enter hostname or IP"

# Ask Port
$portInput = Read-Host "Enter port number"
if (-not ($portInput -as [int])) {
    Write-Output "Port number must be an integer."
    exit
}
$portNumber = [int]$portInput

# Check if the port is valid
$result = Test-NetConnection -ComputerName $hostName -Port $portNumber -InformationLevel Quiet

if ($result) {
    Write-Output "Port $portNumber opened on $hostName"
} else {
    Write-Output "Port $portNumber closed or unavailable on $hostName"
}