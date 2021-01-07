#!/bin/sh

# Used for calculation of average cpu frequency.

i=0
cpus=$(nproc)
sum_freq=0

while [ $i -lt $cpus ]
do
    freq=$(cat /sys/devices/system/cpu/cpu$i/cpufreq/scaling_cur_freq)
#echo $freq
    sum_freq=`expr $sum_freq + $freq`
    i=`expr $i + 1`
done

#echo $i
#echo $cpus
#echo $sum_freq
echo $(($sum_freq/cpus))

