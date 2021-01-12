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
    local str="$4"
    local number

    if [ -z $5 ] ; then
        number=${str%.*}
    else
        number="$5"
    fi

    local color="#00FF00"

    if [ $number -gt $red_level ] ; then
        color="#FF0000"
    elif [ $number -gt $yellow_level ] ; then
        color="#FFFF00"
    fi
    local json="{ \"full_text\": \"$str\", \"color\": \"$color\" }"
    json_array=$(update_holder "$holder_name" "$json")
}

i3status | (read line; echo "$line"; read line ; echo "$line" ; read line ; echo "$line" ; while true
do
  read line
  json_array="$(echo $line | sed -e 's/^,//')"
  fill_holder    holder__cpu_freq    2000 2800    $(($(cpufreq.sh)))
  fill_holder    holder__cpu_temp    50 80        $(sensors | awk '/^Tctl/ {print $2 " " $3}')
  fill_holder    holder__ram         50 60        $(free -g | awk '/^Mem/ {print $3"/"$2}')    $(free -g | awk '/^Mem/ {print $3}')
  echo ",$json_array" 
done)

