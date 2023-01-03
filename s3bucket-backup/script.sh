#!/bin/bash
### Run scenario creating files
### List of files run in command.sh script
/home/ubuntu/command.sh
### Change work directory
cd /home/ubuntu/dir/
### Seek for files and compress in in backup directory
find . -type f -print | while read fname ; do
        tar -c "$fname" > "/home/ubuntu/backup/$fname.tar.gz"
done
### Delete work directory
rm -R /home/ubuntu/dir/
### delete files from directory older than 30 minutes
###find /home/ubuntu/backup/ -type f -mmin +30 -name "*.gz" -execdir rm -f {} \;
### move flies to directory 2bucket/ older than 30 minutes
find /home/ubuntu/backup/ -mmin +30 -exec mv "{}" /home/ubuntu/2bucket/ \;

cd /home/ubuntu/
### moving files to my s3bucket
aws s3 mv 2bucket s3://fcss88bucket --recursive
exit 1
