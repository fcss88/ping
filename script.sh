#!/bin/bash
### Run scenario creating files
### List of files run in command.sh script
/root/command.sh
### Change work directory
cd /root/linux_dir2/
### Seek for files and compress in in backup directory
find . -type f -print | while read fname ; do
        tar -c "$fname" > "/backup/$fname.tar.gz"
done
### Delete work directory
rm -R /root/linux_dir2/
### delete files from directory older than 30 minutes
find /backup/ -type f -mmin +30 -name "*.gz" -execdir rm -f {} \;

exit 1