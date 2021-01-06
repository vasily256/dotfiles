#!/bin/bash

watch -t -n $1 \
"
cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor &&
cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq &&
cat /sys/devices/system/cpu/cpu0/cpufreq/cpb &&
lscpu | grep CPU.MHz &&
sensors -A | grep Tctl
"
