#!/bin/bash
# batch ufraw-batch, multithread using 4 cores

one=`ls *[135].{ORF,dng}`
two=`ls *[024].{ORF,dng}`
three=`ls *[79].{ORF,dng}`
four=`ls *[68].{ORF,dng}`

options="--wb=camera \
		--exposure=auto \
		--out-type=jpeg \
		--compression=96 \
		--out-path=./processed-images \
                --out-type=jpg"
for oneraw in $one; do ufraw-batch $options $oneraw; done &
for tworaw in $two; do ufraw-batch $options $tworaw; done &
for threeraw in $three; do ufraw-batch $options $threeraw; done &
for fourraw in $four; do ufraw-batch $options $fourraw; done &
