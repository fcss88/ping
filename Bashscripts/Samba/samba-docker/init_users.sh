#!/bin/bash
# samba-users init

USERS=(
  "sambauser1:password1"
  "sambauser2:password2"
)

for userpass in "${USERS[@]}"; do
  IFS=':' read -r USER PASS <<< "$userpass"

  id "$USER" &>/dev/null || useradd -M -s /sbin/nologin "$USER"
  (echo "$PASS"; echo "$PASS") | smbpasswd -a -s "$USER"
  smbpasswd -e "$USER"

  mkdir -p /shared/"$USER"
  chown "$USER":"$USER" /shared/"$USER"
  chmod 0775 /shared/"$USER"
done

# access to guest
mkdir -p /shared/guest
chmod 0777 /shared/guest
chown nobody:nogroup /shared/guest
