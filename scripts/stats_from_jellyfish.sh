OUT="stats_from_jellyfish.csv"
parallel  -k scripts/jellyfish_exact.sh {} ::: `seq 151 698` >> $OUT

