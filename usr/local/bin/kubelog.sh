#!/bin/sh

kubectl exec -n $1 -it $(kubectl get pods -n $1 | grep $2 | awk '{print $1;}') -- tail -F /deployments/spring.log
