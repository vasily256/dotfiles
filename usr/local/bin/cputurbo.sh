#!/bin/sh

boost=$1

if [ -z $boost ] ; then
    boost=$(cat /sys/devices/system/cpu/cpufreq/boost)
    if [ $boost -eq 0 ] ; then
        boost=1
    else
        boost=0
    fi
fi

echo $boost | sudo tee /sys/devices/system/cpu/cpufreq/boost
echo $boost | sudo tee /usr/local/etc/cputurbo
