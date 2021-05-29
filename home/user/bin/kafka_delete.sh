#!/bin/sh

docker exec -it kafka kafka-topics.sh --zookeeper zookeeper:2181 --delete --topic $1

