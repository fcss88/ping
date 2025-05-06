#!/bin/bash
### Create directory tmpdir and 30 files in it
## just one command :)
mkdir tmpdir && cd tmpdir/ && touch file{001..029}.txt
### list of created files
filelist=`ls`
echo $filelist
exit 0
