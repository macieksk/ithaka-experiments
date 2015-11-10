parallel scripts/kmer_stats_from_bam_files.py -n db/workdir/index_h16_s#########################/id_tree_bin.newick query_results/results_stdout_{}.fa.gz_readsorted.bam ">" query_results/kmer_stats_{}.tab ::: `seq -w 9 82`

