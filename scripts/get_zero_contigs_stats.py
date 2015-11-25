#!/usr/bin/env python3

import sys

block_nums=[]
block_lens=[]

for line in sys.stdin.readlines():
    spl=line.split(" ")
    block_nums.append(len(spl))
    for zc in spl:
        block_lens.append(len(zc))


pref=sys.argv[1]

f=open("{}_block_nums.csv".format(pref),"wt")
f.writelines(str(x)+"\n" for x in block_nums)
f.close()

f=open("{}_block_lens.csv".format(pref),"wt")
f.writelines(str(x)+"\n" for x in block_lens)
f.close()


