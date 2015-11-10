jellyfish dump db/workdir/blooms_unionall/UNION_ALL_s$2.jellyfish -L $1 -U $1 | wc -l | sed "s/$/\/2/" | bc | sed "s/$/ "$1" '"$2"'/"
#echo -e 'a\nb' | wc -l | sed "s/$/\/2/" | bc | sed "s/$/ "$1"/" 
