#!/bin/sh

while read app;
do
    echo $(adb shell pm disable-user $app)
done < $1

