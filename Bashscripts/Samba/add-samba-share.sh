#!/bin/bash

set -e
# === input data ===
read -rp "Samba-User: " SMB_USER
read -rp "Share-name folder (without spaces): " SHARE_NAME
read -rp "Path (for example /srv/samba/$SHARE_NAME): " SHARE_PATH
read -rsp "Password for Samba-user: " PASSWORD
echo

# === create os-user (no shell, no home-directory) ===
sudo useradd -M -s /sbin/nologin "$SMB_USER"

# === Add this user in Samba ===
echo -e "$PASSWORD\n$PASSWORD" | sudo smbpasswd -a "$SMB_USER"
sudo smbpasswd -e "$SMB_USER"

# === Create directory ===
sudo mkdir -p "$SHARE_PATH"
sudo chown "$SMB_USER":"$SMB_USER" "$SHARE_PATH"
sudo chmod 2770 "$SHARE_PATH"  # Access just for the owner and group

# === Add current config to smb.conf ===
sudo bash -c "cat >> /etc/samba/smb.conf" <<EOF

[$SHARE_NAME]
   path = $SHARE_PATH
   valid users = $SMB_USER
   read only = no
   browsable = yes
   guest ok = no
EOF

# === Restart Samba ===
echo "restart Samba..."
sudo systemctl restart smbd
# sudo systemctl reload smbd

echo "Shared folder [$SHARE_NAME] create successfully and avaliable"
exit 0