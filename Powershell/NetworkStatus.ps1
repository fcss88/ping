# info about network interfaces
Get-NetIPAddress | Select-Object IPAddress, InterfaceAlias, AddressFamily, PrefixLength