#/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

samtools view $1 | grep '_ROOT_' | awk '{print $12}' | cut -d : -f 3 | sed 's/1\+/ /g' | sed 's/^ \+//' | sed 's/ \+$//' | $DIR/get_zero_contigs_stats.py `basename $1` 

