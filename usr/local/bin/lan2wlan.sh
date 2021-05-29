#!/bin/sh

eth='eno1'
wlan='wlp4s0'

if [ $(cat /sys/class/net/$wlan/operstate) = "down" ] ; then
    ifdown $eth
    ifup $wlan
else
    ifdown $wlan
    ifup $eth
fi

