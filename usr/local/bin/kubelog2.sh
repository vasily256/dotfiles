#!/bin/sh

podname=$1
container=$2
namespace=$3

if [ -z $container ] ; then
    container="$podname"
fi
if [ -z $namespace ] ; then
    namespace="default"
fi

podname=$(kubectl get pods -n $namespace | grep $podname | awk '{print $1;}') 
kubectl logs -f -n $namespace $podname $container | lnav

