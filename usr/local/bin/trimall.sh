#!/bin/sh

sudo fstrim -v /boot
sudo fstrim -v /
sudo fstrim -v /var
sudo fstrim -v /tmp
sudo fstrim -v /home
