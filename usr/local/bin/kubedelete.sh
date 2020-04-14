#!/bin/bash

guest_name='k8s.test'
hosts_file='/etc/hosts'

color=$(tput setaf 2)
reset=$(tput sgr0)

echo ${color}Deleting minikube${reset}

docker stop registry && docker rm registry
minikube delete

echo ${color}Removing entry for $guest_name in the host $hosts_file${reset}
sudo sed -i '/'$guest_name'$/ d' $hosts_file
echo
