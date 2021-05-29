#!/bin/sh

color=$(tput setaf 2)
reset=$(tput sgr0)

echo ${color}Saving minikube to disk${reset}
virsh --connect qemu:///system managedsave minikube

echo ${color}Saving is complete.${reset}
echo

