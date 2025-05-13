#!/bin/bash

# IP\hostname Samba-client
CLIENT="$1"

if [[ -z "$CLIENT" ]]; then
  echo "Use: $0 <IP or hostname samba-client> "
  exit 1
fi

echo "check support SMB protocol on client: $CLIENT"

# Use nmap for checking SMB support
nmap -p 139,445 --script smb-protocols "$CLIENT" -oN scan_result.txt > /dev/null

# results output
if grep -q "SMBv1" scan_result.txt; then
  echo "Samba-client support SMBv1 (NetBIOS). Ports 137..139 u need to use"
else
  echo "Samba-client support SMBv2 or SMBv3. Port 445 is enough"
fi

# cleanup
rm -f scan_result.txt
exit 0