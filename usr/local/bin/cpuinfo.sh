#!/bin/sh

refresh_rate=1

if [ ! -z $1 ] ; then
    refresh_rate=$1
fi

watch -t -n $refresh_rate --color \
"
printf 'Governor: $(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor) | '
printf 'Max freq: $(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq) | '
echo 'Turbo core: $(cat /sys/devices/system/cpu/cpu0/cpufreq/cpb)'
echo
cpufreq.sh -v
echo
sensors -A | grep Tctl
echo
nvidia-smi | sed -n -e 3p -e 6p -e 10p
"
