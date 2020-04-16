#!/bin/bash

color=$(tput setaf 2)
err_color=$(tput setaf 1)
reset=$(tput sgr0)

echo ${color}Pausing minikube${reset}
virsh --connect qemu:///system suspend minikube

int_trap() {
    echo
    echo ${color}Waking up minikube${reset}
    echo
}
trap int_trap INT

read -p "${color}Minikube paused. Press enter to wake up minikube${reset}"

virsh --connect qemu:///system resume minikube
