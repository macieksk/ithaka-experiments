#!/usr/bin/env python2
# -*- coding: utf-8 -*-
#!/usr/bin/python22 -OO -u
from __future__ import print_function

import os, sys, inspect
# realpath() will make your script run, even if you symlink it :)
cmd_folder = os.path.realpath(os.path.abspath("../ithaka/"))
if cmd_folder not in sys.path:
    sys.path.insert(0, cmd_folder)
import ithaka.tree_formatter as trf


import argparse
import subprocess as sbp
from collections import Counter, defaultdict    


parser = argparse.ArgumentParser(description='Ithaka BAM analyzer')
def validate_file(s):
    try: open(s,"r").close()
    except:
        msg = "cannot open file {} for reading".format(s)
        raise argparse.ArgumentTypeError(msg)
    return s
parser.add_argument('-n','--newick',type=validate_file,
                    help="file containing newick_tree",required=True)

parser.add_argument('bam_file', nargs='+',type=validate_file,
                    help="BAM file")


        
class ParseBAM(object):
        
    def __init__(self, newick):
        print("Opening taxonomy tree {}".format(newick),file=sys.stderr)
        self.tree = trf.read_newick(newick,format=10)   
        
        self.prepare_tree_dict()
        
        self.rank_counts = defaultdict(lambda:[0]*1000)
        self.genome_counts = [0]*1000
        
        self._file=None
            
    def prepare_tree_dict(self):
        self.name_to_rank={}
        self.genomes=set()
        for i,node in enumerate(self.tree.get_descendants()+[self.tree]):
            if "rank" in node.features:
                self.name_to_rank[node.name]=node.rank
            if "fastapath" in node.features:
                #print(name_to_rank[node.name],file=sys.stderr)
                self.genomes.add(node.name)
        self.ranks=set()
        for k,v in self.name_to_rank.iteritems():
            self.ranks.add(v)
        return self.name_to_rank,self.ranks,self.genomes
    
    def init_bamfile(self,bam_file):
        self.__exit__(None,None,None)     
        print("Opening BAM file {} for reading.".format(bam_file),file=sys.stderr)
        self._bam_proc = sbp.Popen(['samtools','view',bam_file],
                                    stdout=sbp.PIPE)
        self._file = self._bam_proc.stdout        
    
    def __enter__(self):
        return self
    
    def __exit__(self, exc_type, exc_val, exc_tb):
        if self._file is not None:
            self._file.close()
            self._bam_proc.terminate()
        
    def readline(self):
        rl=self._file.readline()
        if rl=='':
            return None
        else:
            return rl.split("\t")
            
    def register_kmer_stats(self,seqids):
        rank_counter=Counter()
        gen_cnt = 0
        for si in seqids:
	    try: rank_counter[self.name_to_rank[si]]+=1
	    except KeyError: pass
            if si in self.genomes:
                gen_cnt+=1
                
        for k,v in rank_counter.iteritems():
            self.rank_counts[k][v]+=1
            
        self.genome_counts[gen_cnt]+=1
    
    def cutoff_array(self,a):
        i = len(a)-1
        while i>=0:
            if a[i]>0:
                return a[:i+1]
            i-=1
        return [0,0]
    
    def output_stats(self):        
        for rank,a in self.rank_counts.iteritems():
            for i,c in enumerate(self.cutoff_array(a)):
                if i>0:
                    print("{} {} {}".format(rank,i,c))
        rank = "genome"
        for i,c in enumerate(self.cutoff_array(self.genome_counts)):
            if i>0:
                print("{} {} {}".format(rank,i,c))
        

if __name__ == "__main__":    
    args = parser.parse_args()
    with ParseBAM(args.newick) as pbam:
        for bamf in args.bam_file:
            pbam.init_bamfile(bamf)
            curr_rec = None        
            rec = pbam.readline()
            curr_rec = rec[0]
            seqids=[]
            i = 0
            while rec is not None:
                i+=1
                if i%100000==0:
                    print("Processed {} records".format(i),file=sys.stderr)
                    #break
                if rec[0]!=curr_rec:
                    curr_rec=rec[0]
                    pbam.register_kmer_stats(seqids)
                    seqids=[]
		seqids.append(rec[2])            
                rec = pbam.readline()
            
        pbam.output_stats()
            
    
