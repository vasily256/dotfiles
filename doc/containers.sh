docker run --restart always --name redis -d -p 6379:6379 redis redis-server --appendonly yes

docker network create net0 --driver bridge

docker run --restart always -p 2181:2181 -d --name zookeeper \
    --network net0 \
    -e ZOOKEEPER_CLIENT_PORT=2181 \
    -e ZOOKEEPER_TICK_TIME=2000 \
    -e ZOOKEEPER_SYNC_LIMIT=2 \
    confluentinc/cp-zookeeper:5.5.5

docker run --restart always -p 9092:9092 -d --name kafka \
    --network net0 \
    -e KAFKA_ZOOKEEPER_CONNECT=zookeeper:2181 \
    -e KAFKA_ADVERTISED_LISTENERS=PLAINTEXT://kafka:9092 \
    -e KAFKA_BROKER_ID=2 \
    -e KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR=1 \
    confluentinc/cp-kafka:5.5.5

docker run --restart always -p 8081:8081 -d --name schema_registry \
    --network net0 \
      -e SCHEMA_REGISTRY_KAFKASTORE_CONNECTION_URL=zookeeper:2181 \
      -e SCHEMA_REGISTRY_HOST_NAME=localhost \
      -e SCHEMA_REGISTRY_DEBUG=true \
      confluentinc/cp-schema-registry:5.5.5

