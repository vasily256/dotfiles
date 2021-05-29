#!/bin/sh

podname=$1
port=$2
namespace=$3

if [ -z $namespace ] ; then
    namespace="default"
fi

kubectl port-forward -n $namespace $(kubectl get pods -n $namespace | grep $podname | awk '{print $1;}') $port:$port
