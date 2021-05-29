#!/bin/sh

quiet_delay=5
norm_delay=3
high_delay=3
norm_cpu_load=33
high_cpu_load=33
norm_cpu_tdp=35000
high_cpu_tdp=35000

#norm_cpu_tdp=23000
#high_cpu_tdp=23000

QUIET_MODE=0
NORM_MODE=1
HIGH_MODE=2
UNDEFINED_MODE=-1

echo "quiet_delay:   $quiet_delay"
echo "norm_delay:    $norm_delay"
echo "high_delay:    $high_delay"
echo "norm_cpu_load: $norm_cpu_load"
echo "high_cpu_load: $high_cpu_load"
echo "norm_cpu_tdp:  $norm_cpu_tdp"
echo "high_cpu_tdp:  $high_cpu_tdp"

determine_mode() {
    delay=$1

    mode=$QUIET_MODE
    for cpu_idle in $(sar -P ALL $delay 1 | awk '!/CPU|all|Average/ {print $8}' | awk -F "," '{print $1}')
    do
        cpu_load=$((100 - $cpu_idle))
        if [ $cpu_load -gt $norm_cpu_load ] ; then
            if [ $cpu_load -gt $high_cpu_load ] ; then
                mode=$HIGH_MODE
                break
            fi
            mode=$NORM_MODE
        fi
    done

    echo $mode
}

rm -r /run/cpu-booster
mkdir /run/cpu-booster

current_mode=$UNDEFINED_MODE
current_delay=$quiet_delay

while :
do
    new_mode=$(($(determine_mode $current_delay) + 0))

    if [ ! $new_mode -eq $current_mode ] ; then
        case $new_mode in
            $QUIET_MODE)
                echo 0 > /sys/devices/system/cpu/cpufreq/boost
                : $(ryzenadj --slow-limit=$norm_cpu_tdp --fast-limit=$norm_cpu_tdp)
                current_delay=$quiet_delay
            ;;
            $NORM_MODE)
                echo 1 > /sys/devices/system/cpu/cpufreq/boost
                : $(ryzenadj --slow-limit=$norm_cpu_tdp --fast-limit=$norm_cpu_tdp)
                current_delay=$norm_delay
            ;;
            $HIGH_MODE)
                echo 1 > /sys/devices/system/cpu/cpufreq/boost
                : $(ryzenadj --slow-limit=$high_cpu_tdp --fast-limit=$high_cpu_tdp)
                current_delay=$high_delay
            ;;
        esac

        echo $new_mode

        current_mode=$new_mode
        echo $current_mode > /run/cpu-booster/current-mode
    fi
done

