# Network Scan Script
# This script scans a local network for active IP addresses and outputs the results.
$subnet = "192.168.88."
1..254 | ForEach-Object {
    $ip = "$subnet$_"
    if (Test-Connection -ComputerName $ip -Count 1 -Quiet) {
        Write-Output "$ip is up."
    }
}
