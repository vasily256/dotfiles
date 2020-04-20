#!/bin/bash

color=$(tput setaf 2)
err_color=$(tput setaf 1)
reset=$(tput sgr0)

echo ${color}Loading existing minikube${reset}
virsh --connect qemu:///system start minikube

echo ${color}Loading is complete.${reset}
echo

