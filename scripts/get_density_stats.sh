#!/bin/bash

DIR="$1"
parallel --tag ../ithaka/ulysses stats $DIR/{} "|" grep Density ::: `ls -1 $DIR | grep '\.bf$'`

