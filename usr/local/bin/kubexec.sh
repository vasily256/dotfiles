#!/bin/sh

podname=$1
namespace=$2

if [ -z $namespace ] ; then
    namespace="default"
fi

kubectl exec -n $namespace -it $(kubectl get pods -n $namespace | grep $podname | awk '{print $1;}') -- bash
