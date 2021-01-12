#!/bin/sh

# Used for calculation of average cpu frequency.

red_level=$(tput setaf 1)
normal_level=$(tput setaf 0)
reset=$(tput -T ansi sgr0)

ratio=0
freq_ghz=0

calculate_ratio() {
    ratio=$(( ($freq_mhz - $min_freq) * 100 / ($max_freq - $min_freq) ))
}

print_freq() {
    calculate_ratio

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
}

cpus=$(nproc)
sum_freq=0
i=0

[ ! -z $1 ] && [ $1 = "-v" ] && verbose=1 || verbose=0

while [ $i -lt $cpus ]
do
    freq_mhz=$(($(cat /sys/devices/system/cpu/cpu$i/cpufreq/scaling_cur_freq)))
    freq_ghz=$(($freq_mhz/1000))
    max_freq=$(($(cat /sys/devices/system/cpu/cpu$i/cpufreq/scaling_max_freq)))
    min_freq=$(($(cat /sys/devices/system/cpu/cpu$i/cpufreq/scaling_min_freq)))

    if [ $min_freq -gt $freq_mhz ] ; then
        min_freq=$(($freq_mhz - 1))
    fi

    if [ $verbose = 1 ] ; then
        print_freq
    fi

    sum_freq=`expr $sum_freq + $freq_mhz`
    i=`expr $i + 1`
done

freq_ghz=$(($sum_freq / $cpus / 1000))
if [ $verbose = 1 ] ; then
    print_freq
else
    echo $freq_ghz
fi

