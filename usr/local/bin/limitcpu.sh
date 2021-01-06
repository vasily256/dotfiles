#!/bin/bash

sudo cgcreate -a vasily:vasily -t vasily:vasily -g cpu:/cpulimit
sudo cgset -r cpu.cfs_period_us=1000000 cpulimit
sudo cgset -r cpu.cfs_quota_us=$(expr $1 \* 10000) cpulimit
cgexec -g cpu:cpulimit $2
