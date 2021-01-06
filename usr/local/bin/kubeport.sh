#!/bin/sh

kubectl port-forward -n $1 $(kubectl get pods -n $1 | grep $2 | awk '{print $1;}') $3:$3
