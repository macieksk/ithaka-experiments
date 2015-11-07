jellyfish dump db/workdir/blooms_unionall/UNION_ALL_s#########################.jellyfish -L $1 -U $1 | wc -l | sed "s/$/\/2/" | bc | sed "s/$/ "$1"/"
#echo -e 'a\nb' | wc -l | sed "s/$/\/2/" | bc | sed "s/$/ "$1"/" 
