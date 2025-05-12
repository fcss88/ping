#!/bin/bash
# create users, usergroup, shared folder, add config to smb.conf with guest access
# guest ok = yes in config-file
set -e

# === input data ===
read -rp "Name shared-directory (for example: shared): " SHARE_NAME
read -rp "Path shared-directory (for example: /srv/samba/shared): " SHARE_PATH
read -rp "enter a list of users separated by space  (for example: user1 user2): " -a USERS

# Group name for new users
GROUP="samba_${SHARE_NAME}"

# === Create group ===
echo "Create group $GROUP..."
sudo groupadd "$GROUP"

# === Create users ===
for USER in "${USERS[@]}"; do
  echo "Work with user: $USER"

  # Create system user
  sudo useradd -M -s /sbin/nologin -G "$GROUP" "$USER"

  # Add Samba-password
  echo "Enter password for $USER:"
  sudo smbpasswd -a "$USER"
  sudo smbpasswd -e "$USER"
done

# === Create directory ===
sudo mkdir -p "$SHARE_PATH"
sudo chown root:"$GROUP" "$SHARE_PATH"
sudo chmod 2775 "$SHARE_PATH"

# === create list of valid users ===
VALID_USERS=$(IFS=','; echo "${USERS[*]}")

# === Add config to smb.conf ===
sudo bash -c "cat >> /etc/samba/smb.conf" <<EOF

[$SHARE_NAME]
   path = $SHARE_PATH
   browsable = yes
   writable = yes
   guest ok = yes
   valid users = $VALID_USERS
   force group = $GROUP
   create mask = 0664
   directory mask = 2775
EOF

# === Restart Samba ===
echo "restart Samba..."
sudo systemctl restart smbd
# sudo systemctl reload smbd

echo "[$SHARE_NAME] shared for users: ${USERS[*]} (guest access is enabled)"
exit 0