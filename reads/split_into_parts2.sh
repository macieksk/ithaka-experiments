zcat all_reads_with_names.fa.gz | parallel --pipe --recstart '>' --block 512M --files --results all_parts  gzip -1 ::: `seq -w 1 99`


#rm all_parts -r
