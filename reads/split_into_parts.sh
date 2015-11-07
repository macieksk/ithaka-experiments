zcat all_reads_with_names.fa.gz | parallel --pipe --recstart '>' --block 8G --files --results all_parts  gzip -1 ::: `seq -w 1 99`

cat `seq -w 1 3 | sed 's|\(.*\)|all_parts/1/0\1/stdout|' | tr '\n' ' '` > all_reads_wn_1.fa.gz & 
cat `seq -w 4 6 | sed 's|\(.*\)|all_parts/1/0\1/stdout|' | tr '\n' ' '` > all_reads_wn_2.fa.gz & 
cat `seq -w 7 9 | sed 's|\(.*\)|all_parts/1/0\1/stdout|' | tr '\n' ' '` > all_reads_wn_3.fa.gz &
cat `seq -w 10 12 | sed 's|\(.*\)|all_parts/1/\1/stdout|' | tr '\n' ' '` > all_reads_wn_4.fa.gz &
cat `seq -w 13 15 | sed 's|\(.*\)|all_parts/1/\1/stdout|' | tr '\n' ' '` > all_reads_wn_5.fa.gz &
cat `seq -w 16 18 | sed 's|\(.*\)|all_parts/1/\1/stdout|' | tr '\n' ' '` > all_reads_wn_6.fa.gz &
cat `seq -w 19 21 | sed 's|\(.*\)|all_parts/1/\1/stdout|' | tr '\n' ' '` > all_reads_wn_7.fa.gz & 

wait

#rm all_parts -r
