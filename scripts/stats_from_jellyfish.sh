OUT="stats_from_jellyfish_many_seeds.csv"
parallel -k scripts/jellyfish_exact.sh {} {} ::: `seq 2 700` ::: `cat seeds_to_jellyfish.txt` >> $OUT

