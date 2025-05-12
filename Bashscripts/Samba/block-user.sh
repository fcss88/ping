#!/bin/bash
LOG="/var/log/samba/log.smbd"
THRESHOLD=5

grep "authentication for user" "$LOG" | grep "was not successful" | awk '{print $NF}' | sort | uniq -c |
while read -r count user; do
  if (( count >= THRESHOLD )); then
    echo "block user $user (not successful: $count)"
    smbpasswd -d "$user"
  fi
done

# for enable user run 
# sudo smbpasswd -e username
