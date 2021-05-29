#!/bin/sh

xrandr -q | grep 'HDMI-0 connected'

if [ $? -eq 0 ] ; then
    exec xrandr --output HDMI-0 --mode 1920x1080 --pos 1920x0 --rotate left --output DP-2 --primary --mode 1920x1080 --pos 0x840 --rotate normal --output DP-1 --off --output DP-0 --off
else
    exec xrandr --output HDMI-0 --off --output DP-2 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output DP-1 --off --output DP-0 --off
fi

