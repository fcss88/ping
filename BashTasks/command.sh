#!/bin/bash
### Create directory tempdir and 30 files in it with random content
mkdir linux_dir2 && cd linux_dir2/

echo "Creating files:"
for (( count=1; count <= 30; count++ ))
        do
                datefilename=`date +%d%b%G_%H-%M.%N`
                touch file$count--$datefilename.log
                shuf -i 1-1000000000000 -n 10000 > file$count--$datefilename.log
                echo file$count--$datefilename.log
        done

echo "Files sucessfully created"
exit 1