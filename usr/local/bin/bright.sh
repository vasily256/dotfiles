#!/bin/bash

# Line in /etc/default/grub is required
# GRUB_CMDLINE_LINUX_DEFAULT="quiet splash nvidia.NVreg_RegistryDwords=EnableBrightnessControl=1"

BRIGHTNESS_FILE="/sys/class/backlight/nvidia_0/brightness"
MAX_BRIGHTNESS_FILE="/sys/class/backlight/nvidia_0/max_brightness"

step=$1
current_brightness=$(cat $BRIGHTNESS_FILE)
dummy=$(tee $BRIGHTNESS_FILE <<< $(($current_brightness + $step)))

