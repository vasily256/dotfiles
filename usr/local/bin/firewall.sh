#!/bin/sh

sudo iptables -$1 INPUT -i lo -p tcp --destination-port $2 -j DROP
