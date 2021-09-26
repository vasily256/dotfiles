#!/bin/sh

xrandr -q | grep 'HDMI-0 connected'

if [ $? -eq 0 ] ; then
    xrandr --output HDMI-0 --mode 1920x1080 --pos 1920x0 --rotate left --output DP-2 --primary --mode 1920x1080 --pos 0x840 --rotate normal --output DP-1 --off --output DP-0 --off
else
    xrandr --output HDMI-0 --off --output DP-2 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output DP-1 --off --output DP-0 --off
fi

feh --bg-fill ~/pic/2560x1600_px_galaxy_Purple_render_space_stars-660837.jpg

