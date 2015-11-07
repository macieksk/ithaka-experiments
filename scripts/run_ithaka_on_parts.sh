#!/bin/bash

for f in reads/all_parts/1/*/stdout.fa.gz; 
do 
	NUM="`echo $f | cut -d '/' -f 4`"
	echo Processing part number $NUM | tee $LOG
	time ithaka-query.py -i db/workdir/index_h16_s#########################/ -r query_results/ -m 16G -t 8 $f 2>&1 > $LOG
	mv query_results/results_stdout.fa.gz.bam query_results/results_stdout_$NUM.fa.gz.bam
	time samtools sort -@ 8 -n results_stdout_$NUM.fa.gz.bam results_stdout_$NUM.fa.gz_readsorted 2>&1 > $LOG 
done 

