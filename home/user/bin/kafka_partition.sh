#!/bin/sh

docker exec -it kafka kafka-topics.sh --zookeeper zookeeper:2181 --alter --topic $1 --partitions $2

