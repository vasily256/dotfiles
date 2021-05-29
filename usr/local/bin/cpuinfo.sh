#!/bin/sh

refresh_period=2

if [ ! -z $1 ] ; then
    refresh_period=$1
fi

watch -t -n $refresh_period --color \
"
cpufreq.sh -v
echo
sensors -A | grep -e Tctl -e Composite -e Sensor
nvidia-smi | sed -n 10p
"
#nvidia-smi | sed -n -e 3p -e 6p -e 10p
