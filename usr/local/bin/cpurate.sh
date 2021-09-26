#!/bin/bash

echo $1 | sudo tee /sys/devices/system/cpu/cpufreq/schedutil/rate_limit_us
