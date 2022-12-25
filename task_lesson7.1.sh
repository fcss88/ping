#!/bin/bash
### Create directory tempdir and 30 files in it with random content
mkdir tempdir && cd tempdir/

### list of created files
filelist=`ls`
for (( count=1; count <= 30; count++ ))
        do
                touch file$count.log
                shuf -i 1-1000000000 -n 10000 > file$count.log
        done

echo "Sucessfully created this files:"
filelist=`ls`
echo $filelist

### Create compress file tar.gz with all filesand move  to backup directory
datefilename=`date +%d%b%G_%H-%M`
echo "Now $datefilename"
tar -cvpzf /backup/backup-$datefilename.tar.gz --absolute-names /root/tempdir

### delete all
rm -R /root/tempdir/
### delete backup-files older than 30 minutes
find /backup/ -type f -mmin +30 -name "*.gz" -execdir rm -f {} \;
exit 1
