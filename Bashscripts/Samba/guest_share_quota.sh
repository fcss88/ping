#!/bin/bash
SHARE_PATH="/srv/samba/guest"
mkdir -p "$SHARE_PATH"
chmod 0777 "$SHARE_PATH"
setfacl -m u:nobody:rwx "$SHARE_PATH"

# quota 1Gb (for ext4 you need to activate user/group quota manually )
setquota -u nobody 0 1048576 0 0 /  # 1Gb = 1048576 blocks

echo -e "\n[GuestShare]
   path = $SHARE_PATH
   browsable = yes
   writable = yes
   guest ok = yes" | sudo tee -a /etc/samba/smb.conf

systemctl restart smbd
echo "succesfully added guest share with quota 1Gb"
echo "You can check the quota with the command: quota -u nobody"
echo "You can check the share with the command: smbclient -L localhost -U nobody"
echo "You can check the share with the command: smbclient //localhost/GuestShare -U nobody"
