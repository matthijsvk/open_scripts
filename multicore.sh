#!/bin/bash
# batch ufraw-batch, multithread using 4 cores

# usage: eg bash ~/.scripts/multicore.sh 'jpegoptim --size=3000 --dest=compressed' ./*.jpg


command="$1" # needs to be between ' .......  '

length=$(($#-1)) #all other arguments, this is regex expanded data to be processed
array=${@:2:$length-1}
data=$array

one=`echo $data | grep -E --regexp=*[135].{ORF,dng,jpg}`
two=`echo $data | grep -E --regexp=*[024].{ORF,dng,jpg}`
three=`echo $data | grep -E --regexp=*[79].{ORF,dng,jpg}`
four=`echo $data | grep -E --regexp=*[68].{ORF,dng,jpg}`

for oneraw in $one; do $command $oneraw; done &
for tworaw in $two; do $command $tworaw; done &
for threeraw in $three; do $command $threeraw; done &
for fourraw in $four; do $command $fourraw; done &
