#!/bin/sh

color=$(tput setaf 2)
err_color=$(tput setaf 1)
reset=$(tput sgr0)

echo ${color}Pausing minikube${reset}
virsh --connect qemu:///system suspend minikube

echo "${color}Minikube paused. Press enter to wake up minikube${reset}"

while read answer; do
  if [ -z "$answer" ]; then
    break
  fi
done

virsh --connect qemu:///system resume minikube
