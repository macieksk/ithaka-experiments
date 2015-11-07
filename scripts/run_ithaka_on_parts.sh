#!/bin/bash

LOG="run_parts_script.log"
OUTD="query_results/"

for f in reads/all_parts/1/*/stdout.fa.gz; 
do 
	NUM="`echo $f | cut -d '/' -f 4`"
	echo Processing part number $NUM | tee -a $LOG
	{ time ithaka-query.py -i db/workdir/index_h16_s#########################/ -r $OUTD -m 16G -t 8 $f ; } >> $LOG 2>&1
	mv $OUTD/results_stdout.fa.gz.bam $OUTD/results_stdout_$NUM.fa.gz.bam
	{ time samtools sort -@ 8 -n $OUTD/results_stdout_$NUM.fa.gz.bam $OUTD/results_stdout_$NUM.fa.gz_readsorted ; } >> $LOG 2>&1  
done 

