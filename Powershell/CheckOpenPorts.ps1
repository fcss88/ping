# Check open ports on the local machine
# This script checks for open ports on the local machine and lists them along with the owning process ID.
Get-NetTCPConnection | Where-Object { $_.State -eq 'Listen' } | Select-Object LocalPort, OwningProcess