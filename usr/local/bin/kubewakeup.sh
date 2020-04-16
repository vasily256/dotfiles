#!/bin/bash

color=$(tput setaf 2)
err_color=$(tput setaf 1)
reset=$(tput sgr0)

echo ${color}Loading existing minikube${reset}
virsh --connect qemu:///system start minikube
minikube start

int_trap() {
    echo
    echo ${color}Suspending minikube to disk${reset}
}
trap int_trap INT

echo ${color}Loading is complete. Press Ctrl-C to suspend minikube${reset}
echo

minikube dashboard

virsh --connect qemu:///system managedsave minikube
minikube stop
