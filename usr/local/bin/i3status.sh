#!/usr/bin/env bash

# This i3status wrapper allows to add custom information in any position of the statusline
# It was developed for i3bar (JSON format)

# The idea is to define "holder" modules in i3status config and then replace them

# In order to make this example work you need to add
# order += "tztime holder__hey_man"
# and 
# tztime holder__hey_man {
#        format = "holder__hey_man"
# }
# in i3staus config 

# Don't forget that i3status config should contain:
# general {
#   output_format = i3bar
# }
#
# and i3 config should contain:
# bar {
#   status_command exec /path/to/this/script.sh
# }

# Make sure jq is installed
# That's it

# You can easily add multiple custom modules using additional "holders"

function update_holder {

  local instance="$1"
  local replacement="$2"
  echo "$json_array" | jq --argjson arg_j "$replacement" "(.[] | (select(.instance==\"$instance\"))) |= \$arg_j" 
}

function remove_holder {

  local instance="$1"
  echo "$json_array" | jq "del(.[] | (select(.instance==\"$instance\")))"
}

function fill_holder {

    local holder_name="$1"
    local yellow_level="$2"
    local red_level="$3"
    local start="$4"
    local number_str=$5
    local number="$(echo "$number_str" | grep -oP "\d+" | head -1)"

    local end="$6"

    local color="#00FF00"

    if [ $number -ge $red_level ] ; then
        color="#FF0000"
    elif [ $number -ge $yellow_level ] ; then
        color="#FFFF00"
    fi

    local json="{ \"full_text\": \"$start$number_str$end\", \"color\": \"$color\" }"
    json_array=$(update_holder "$holder_name" "$json")
}

i3status | (read line; echo "$line"; read line ; echo "$line" ; read line ; echo "$line" ; while true
do
  read line
  json_array="$(echo $line | sed -e 's/^,//')"

  cpufreq=$(cpufreq.sh)
  sensors=$(sensors -A)    
  free=$(free -g)
  vpn_enabled=$(ip addr | grep tun > /dev/null 2>&1; echo $?)
  #turbo_mode=$(cat /run/cpu-booster/current-mode)
  turbo_mode=$(cat /sys/devices/system/cpu/cpufreq/boost)
                           
  fill_holder  VPN         1     1     "VPN "      "$vpn_enabled"                                                  ""
  fill_holder  RAM         40    60    "RAM "      $(echo "$free" | awk '/^Mem/ {print $3}')                        "$(echo "$free" | awk '/^Mem/ {print "/"$2}') GiB"
  fill_holder  CPU_LOADED  8     10    "CPU "      $(echo $cpufreq | awk '{print $1}')                              "/$(echo $cpufreq | awk '{print $2}')"
  fill_holder  TURBO       1     2     "Turbo "    "$turbo_mode"                                                    ""
  fill_holder  CPU_FREQ    2000  2900  ""           $(echo $cpufreq | awk '{print $4}')                              " MHz"
  fill_holder  CPU_TEMP    50    80    ""           $(echo "$sensors" | grep -oP "(Tctl).*:\s+\K\+\d+\.\d+")         "°"
  fill_holder  S1_TEMP     50    70    "NVMe "     $(echo "$sensors" | grep -oP "(Sensor 1).*:\s+\K\+\d+\.\d+")     "°"
  fill_holder  S2_TEMP     50    70    ""           $(echo "$sensors" | grep -oP "(Sensor 2).*:\s+\K\+\d+\.\d+")     "°"
  fill_holder  GPU_TEMP    50    80    "GPU "      $(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader)  "°"

  echo ",$json_array" 
done)

