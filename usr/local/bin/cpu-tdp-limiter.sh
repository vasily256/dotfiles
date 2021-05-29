#!/bin/sh

min_tdp=41000
max_tdp=41000
max_time=60
max_temp=85

while :
do
    line_count=$(ryzenadj --info | grep -e "$(($max_tdp / 1000))\..*fast-limit" -e "$(($min_tdp / 1000))\..*slow-limit" -e "$max_time\..*slow-time" -e "$max_temp\..*tctl-temp" | wc -l)
    if [ ! $line_count -eq 4 ] ; then
        ryzenadj --power-saving --slow-time=$max_time --slow-limit=$min_tdp --fast-limit=$max_tdp --tctl-temp=$max_temp
        echo
    fi
    
    sleep 5
done

