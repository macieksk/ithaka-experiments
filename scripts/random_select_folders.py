#!/usr/bin/python
# -*- coding: utf-8 -*-
from __future__ import print_function

import os
import argparse
import shutil, errno

import random
random.seed(1)

def copy(src, dst):    
    try:
        dst2 = os.path.join(dst,os.path.basename(os.path.realpath(src)))
        return shutil.copytree(src, dst2)
    except OSError as exc: # python >2.5
        if exc.errno == errno.ENOTDIR:
            return shutil.copy(src, dst)
        else: raise

move = shutil.move    

parser = argparse.ArgumentParser(description='Random selection of folders',                                 
                                 formatter_class=argparse.ArgumentDefaultsHelpFormatter)
def validate_dir(s):
    if not os.path.isdir(s):
        raise argparse.ArgumentTypeError("{} is not a directory.".format(s))
    return s
parser.add_argument('-i','--input-folder',dest="i",help='directory with all input folders to select from',type=validate_dir,required=True)
parser.add_argument('-o','--output-folder',dest="o",help='directory where to copy/move folders', type=validate_dir,required=True)
parser.add_argument('-m','--move',dest="copy",help='move folders', action='store_const',const=move,default=copy)
parser.add_argument('-p','--power',dest="p",help='power of polynomial', 
                    default=9,type=int)

def randomly_select(it, dist_fun):
    lst = list(it)
    n = len(lst)
    for i,el in enumerate(lst):
        #rng = (float(i)/n, float(i+1)/n)
        #fval = map(dist_fun,rng)
        p = dist_fun(float(n-i)/(n+1)) #(fval[1]-fval[0])*(rng[1]-rng[0])
        print("p={},el={}".format(p,el))
        if p>=random.random():
            yield el
            
def list_directories(d):
    return [os.path.join(d,o) for o in os.listdir(d) 
                        if os.path.isdir(os.path.join(d,o))]
            
def random_select_files(from_dr,to_dr, op=copy, dist_fun=lambda x:x**9):
    for src in randomly_select(sorted(list_directories(from_dr)),dist_fun):
        op(src,to_dr)
    

if __name__ == "__main__":
    args = parser.parse_args()
    random_select_files(args.i,args.o,args.copy,
                        lambda x:x**args.p)
    