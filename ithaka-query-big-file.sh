#!/bin/bash

set -eu -o pipefail
#set -x

if [ "$#" -lt 6 ]; then
    echo "Illegal number of parameters." 
    echo "This script uses block size as the first argument, "
    echo "and then accepts the same arguments as ithaka-query.py command."
    echo "Don't use -h parameter with this script!"
    ithaka-query.py
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
echo "Reading input and creating the correct number of fifos..."
zcat -f $last | parallel -k --pipe --fifo --recstart '>' --block $block -P 100 ./cat_null_exit.sh {} ">" /dev/null ";" mkfifo "$prefix"_part{#} 
allfifos=$(seq 1 `ls -1 ${prefix}_part* | wc -l` | sed 's/^/'${prefix}_part'/' | tr '\n' ' ')
echo Allfifos: $allfifos
#exit 1
#Copy content into the files
echo "Splitting file into fifo `echo $allfifos | wc -w` pipes..."
zcat -f $last | parallel -k --pipe --fifo --recstart '>' --block $block -P 100 -v cp {} ${prefix}_part{#} &

echo "Running Ithaka..."
ithaka-query.py $array $allfifos

rm ${prefix}_part*
wait

