#!/bin/bash

cpus=8
memory=4096
driver='kvm2'

color=$(tput setaf 2)
err_color=$(tput setaf 1)
reset=$(tput sgr0)

echo ${color}Loading existing minikube${reset}
minikube start --cpus $cpus --memory $memory --vm-driver=$driver

int_trap() {
    echo
    echo ${color}Suspending minikube to disk${reset}
}
trap int_trap INT

echo ${color}Loading is complete. Press Ctrl-C to suspend minikube${reset}
echo

minikube dashboard

virsh --connect qemu:///system managedsave minikube

