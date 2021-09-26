#!/bin/sh

# Used for calculation of average cpu frequency.

red_level=$(tput setaf 1)
normal_level=$(tput setaf 0)
reset=$(tput -T ansi sgr0)

ratio=0
freq_mhz=0
avg_freq_mhz=0
max_freq_mhz=0

print_header() {
    turbo=$(cat /sys/devices/system/cpu/cpufreq/boost)
    turbo_text="Turbo core: $turbo | "

    if [ $turbo -eq 1 ] ; then
        printf "${red_level}$turbo_text${reset}"
    else
        printf "$turbo_text"
    fi
        
    printf "Max freq: $(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq) | "
    echo "Governor: $(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor)"
    echo
}

calculate_ratio() {
    ratio=$(( ($freq_khz - $scaling_min_freq_khz) * 100 / ($scaling_max_freq_khz - $scaling_min_freq_khz) ))
}

print_freq() {
    calculate_ratio

    if [ $ratio -gt 95 ] ; then
        echo ${red_level}$freq_mhz **********${reset}
    elif [ $ratio -gt 90 ] ; then
        echo $freq_mhz *********.
    elif [ $ratio -gt 80 ] ; then
        echo $freq_mhz ********..
    elif [ $ratio -gt 70 ] ; then
        echo $freq_mhz *******...
    elif [ $ratio -gt 60 ] ; then
        echo $freq_mhz ******....
    elif [ $ratio -gt 50 ] ; then
        echo $freq_mhz *****.....
    elif [ $ratio -gt 40 ] ; then
        echo $freq_mhz ****......
    elif [ $ratio -gt 30 ] ; then
        echo $freq_mhz ***.......
    elif [ $ratio -gt 20 ] ; then
        echo $freq_mhz **........
    elif [ $ratio -gt 10 ] ; then
        echo $freq_mhz *.........
    else
        echo $freq_mhz ..........
    fi
    if [ `expr $i % 2` -eq 1 ] ; then
        echo
    fi
}

cpus=$(nproc)
loaded_cpus=0
sum_freq=0
i=0

[ ! -z $1 ] && [ $1 = "-v" ] && verbose=1 || verbose=0

if [ $verbose = 1 ] ; then
    print_header
fi

while [ $i -lt $cpus ]
do
    freq_khz=$(($(cat /sys/devices/system/cpu/cpu$i/cpufreq/scaling_cur_freq)))
    freq_mhz=$(($freq_khz/1000))
    scaling_max_freq_khz=$(($(cat /sys/devices/system/cpu/cpu$i/cpufreq/scaling_max_freq)))
    scaling_min_freq_khz=$(($(cat /sys/devices/system/cpu/cpu$i/cpufreq/scaling_min_freq)))

    if [ $freq_mhz -gt $max_freq_mhz ] ; then
        max_freq_mhz=$freq_mhz
    fi

    if [ $scaling_min_freq_khz -gt $freq_khz ] ; then
        scaling_min_freq_khz=$(($freq_khz - 1))
    fi

    if [ $freq_khz -gt $scaling_max_freq_khz ] ; then
        loaded_cpus=$((loaded_cpus + 1))
    fi

    if [ $verbose = 1 ] ; then
        print_freq
    fi

    sum_freq=`expr $sum_freq + $freq_khz`
    i=`expr $i + 1`
done

avg_freq_mhz=$(($sum_freq / $cpus / 1000))
if [ $verbose = 1 ] ; then
    print_freq
else
    echo "$loaded_cpus $cpus $avg_freq_mhz $max_freq_mhz"
fi

