#!/bin/bash
# Samba Configuration Backup Script
# This script backs up Samba configuration files and user data.
# It creates a timestamped archive of the configuration files and user data.
# It also includes a list of Samba users in the backup.
BACKUP_DIR="/backup/samba"
TIMESTAMP=$(date '+%Y%m%d_%H%M%S')
ARCHIVE="$BACKUP_DIR/samba_backup_$TIMESTAMP.tar.gz"

mkdir -p "$BACKUP_DIR"
pdbedit -L > /tmp/samba_users_$TIMESTAMP.txt

tar -czf "$ARCHIVE" \
  /etc/samba/smb.conf \
  /var/lib/samba/private \
  /etc/samba/smbpasswd \
  /tmp/samba_users_$TIMESTAMP.txt

rm /tmp/samba_users_$TIMESTAMP.txt
echo "thats all $ARCHIVE"
exit 0