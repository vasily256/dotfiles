#!/bin/bash

cpus=8
memory=4096
disk='16G'
driver='kvm2'

color=$(tput setaf 2)
err_color=$(tput setaf 1)
reset=$(tput sgr0)

echo ${color}Starting minikube${reset}
minikube start --cpus $cpus --memory=$memory --disk-size=$disk --vm-driver=$driver

echo ${color}Setting up container registry${reset}
minikube addons enable registry
minikube addons enable dashboard
minikube addons enable ingress
minikube addons enable metrics-server
docker run --restart always -it -d --network=host --name=registry alpine ash -c "apk add socat && socat TCP-LISTEN:5000,reuseaddr,fork TCP:$(minikube ip):5000"

guest_ip=$(minikube ip)
guest_name='k8s.test'
host_ip=$(minikube ssh "route -n | grep ^0.0.0.0 | awk '{ print \$2 }'")
host_name='host.test'
ip_pattern='^([0-9]{1,3}[\.]){3}[0-9]{1,3}$'
hosts_file='/etc/hosts'

#echo ${color}Setting up host-machine domain in the minikube $hosts_file${reset}
#minikube ssh "echo $host_ip $host_name | sudo tee --append $hosts_file"

echo ${color}Setting up minikube domain in the host $hosts_file${reset}
if [[ $guest_ip =~ $ip_pattern ]];
then
    sudo sed -i '/'$guest_name'$/ d' $hosts_file
    echo $guest_ip $guest_name | sudo tee --append $hosts_file
else
    echo ${err_color}Error editing $hosts_file${reset}
fi

echo ${color}Starting is complete.${reset}
echo

