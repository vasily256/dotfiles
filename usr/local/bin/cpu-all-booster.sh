#!/bin/sh

peak_critical_cpu_load=95
peak_period_seconds=1
norm_critical_cpu_load=50
norm_period_seconds=15

check_critical_load() {
    period=$1
    load=$2
    for cpu_idle in $(sar -P ALL $period 1 | awk '!/CPU|all|Average/ {print $8}' | awk -F "," '{print $1}')
    do
        cpu_load=$((100 - $cpu_idle))
        if [ $cpu_load -gt $load ] ; then
            result=1
            break
        fi
        result=0
    done
    echo $result
}

critical_cpu_load=$peak_critical_cpu_load
period_seconds=$peak_period_seconds

while :
do
    boost_current=$(cat /sys/devices/system/cpu/cpufreq/boost)
    boost_needed=$((0 + $(check_critical_load $period_seconds $critical_cpu_load)))

    if [ ! $boost_needed -eq $boost_current ] ; then
        echo $boost_needed | tee /sys/devices/system/cpu/cpufreq/boost
        if [ $boost_needed -eq 1 ] ; then
            period_seconds=$norm_period_seconds
            critical_cpu_load=$norm_critical_cpu_load
        else
            period_seconds=$peak_period_seconds
            critical_cpu_load=$peak_critical_cpu_load
        fi
    fi
done
