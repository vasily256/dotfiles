#!/bin/sh

refresh_rate=1

if [ ! -z $1 ] ; then
    refresh_rate=$1
fi

watch -t -n $refresh_rate \
"
cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
cat /sys/devices/system/cpu/cpu0/cpufreq/cpb
echo
cpufreq.sh -v
echo
sensors -A | grep Tctl
"
