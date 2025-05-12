#!/bin/bash
BACKUP_DIR="/backup/samba_migration"
mkdir -p "$BACKUP_DIR"

echo "Compressed smb.conf, passwords and db"
cp /etc/samba/smb.conf "$BACKUP_DIR/"
cp /etc/samba/smbpasswd "$BACKUP_DIR/"
cp -R /var/lib/samba/private "$BACKUP_DIR/"

echo "copy samba share data"
rsync -avz /srv/samba/ "$BACKUP_DIR/shared/"

echo "Data for migration saved in $BACKUP_DIR"
exit 0