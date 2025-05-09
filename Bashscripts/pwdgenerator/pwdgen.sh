#!/bin/bash
SYMBOLS=""

#create password string

for symbol in {A..Z} {a..z} {0..9}; do SYMBOLS=$SYMBOLS$symbol; done
SYMBOLS=$SYMBOLS'!@#$%&*()?/\[]{}-+_=<>.,'
PWD_LENGTH=$1  # as a parameter of command line
PASSWORD=""    # password variable
RANDOM=256     # random generator

for i in `seq 1 $PWD_LENGTH`
do
        PASSWORD=$PASSWORD${SYMBOLS:$(expr $RANDOM % ${#SYMBOLS}):1}
done

echo $PASSWORD
