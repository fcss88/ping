#!/bin/bash
SHARE_PATH="/srv/samba/shared"
USERS=("user1" "user2")

for user in "${USERS[@]}"; do
  echo "ACL for $user:"
  getfacl "$SHARE_PATH" | grep "$user"
done
exit 0