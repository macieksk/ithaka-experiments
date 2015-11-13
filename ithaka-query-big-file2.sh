#!/bin/bash

set -eu -o pipefail
#set -x

if [ "$#" -lt 6 ]; then
    echo "Illegal number of parameters." 
    echo "This script uses block size as the first argument, "
    echo "and then accepts the same arguments as ithaka-query.py command."
    echo "Don't use -h parameter with this script!"
    ithaka-query.py -h
    exit 1
fi

block=${1}
length=$(($#-2))
array=${@:2:$length}
last=${@: -1}
prefix=`basename $last`

#echo $block
#echo $array
#echo $last
#echo $prefix
#exit 1

#First just create the right ammount of fifos
echo "Running Ithaka in parallel..."
zcat -f $last | parallel --pipe --fifo --recstart '>' --block $block -P 1 ithaka-query.py $array {} 

