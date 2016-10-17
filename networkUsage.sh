#!/bin/bash

data=`/usr/bin/ifstat 5 1 | awk 'NR>2'`
output=`echo $data | tr " " "\t"`
arr=($output)


max=(
$(for i in ${arr[*]}
do
        echo "$i"
done | sort -nr | head -1)
)

echo ${max%.*} #convert max to integer

