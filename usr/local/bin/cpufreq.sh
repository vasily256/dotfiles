#!/bin/sh

# Used for calculation of average cpu frequency.

red_level=$(tput setaf 1)
normal_level=$(tput setaf 0)
reset=$(tput -T ansi sgr0)

cpus=$(nproc)

sum_freq=0
i=0
while [ $i -lt $cpus ]
do
    freq_mhz=$(($(cat /sys/devices/system/cpu/cpu$i/cpufreq/scaling_cur_freq)))
    freq_ghz=$(($freq_mhz/1000))
    max_freq=$(($(cat /sys/devices/system/cpu/cpu$i/cpufreq/scaling_max_freq)))
    min_freq=$(($(cat /sys/devices/system/cpu/cpu$i/cpufreq/scaling_min_freq)))

    if [ $min_freq -gt $freq_mhz ] ; then
        min_freq=$(($freq_mhz - 1))
    fi

    ratio=$(( ($freq_mhz - $min_freq) * 100 / ($max_freq - $min_freq) ))

    if [ ! -z $1 ] && [ $1 = "-v" ] ; then
        if [ $ratio -gt 95 ] ; then
            echo ${red_level}$freq_ghz **********${reset}
        elif [ $ratio -gt 90 ] ; then
            echo $freq_ghz *********.
        elif [ $ratio -gt 80 ] ; then
            echo $freq_ghz ********..
        elif [ $ratio -gt 70 ] ; then
            echo $freq_ghz *******...
        elif [ $ratio -gt 60 ] ; then
            echo $freq_ghz ******....
        elif [ $ratio -gt 50 ] ; then
            echo $freq_ghz *****.....
        elif [ $ratio -gt 40 ] ; then
            echo $freq_ghz ****......
        elif [ $ratio -gt 30 ] ; then
            echo $freq_ghz ***.......
        elif [ $ratio -gt 20 ] ; then
            echo $freq_ghz **........
        elif [ $ratio -gt 10 ] ; then
            echo $freq_ghz *.........
        else
            echo $freq_ghz ..........
        fi
        if [ `expr $i % 2` -eq 1 ] ; then
            echo
        fi
    fi

    sum_freq=`expr $sum_freq + $freq_mhz`
    i=`expr $i + 1`
done

echo $(($sum_freq / $cpus / 1000))

