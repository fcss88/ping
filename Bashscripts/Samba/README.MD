# some samba-tricks






## Mannual for guest_share_quota.sh

1. enable quota on ext4
```
sudo tune2fs -l /dev/sdX | grep 'Default mount options'
```
if u dont see **usrquota** or **grpquota**, set them in fstab.

2. Change fstab, додай usrquota,grpquota
open /etc/fstab:

```
sudo nano /etc/fstab
```
find string with needed dirctory (example /home, /srv, /).

Add **usrquota,grpquota** to mount options:

```UUID=xxx /srv ext4 defaults,usrquota,grpquota 0 2```

remount quota or reboot: ```sudo mount -o remount /srv```

3. Create quota-file:

```sudo quotacheck -cum /srv      # for user quota```

```sudo quotacheck -cgm /srv      # for group quota```



**-c** — create new
**-u** — user quota
**-g** — group quota
**-m** — not mount in read-only

4. Enable quotas
```sudo quotaon -v /srv```


 5. Set quotas:
for user:
```sudo setquota -u nobody 0 1048576 0 0 /srv```

for group:
```sudo setquota -g sambaguest 0 524288 0 0 /srv```

check quota ```sudo repquota /srv```
