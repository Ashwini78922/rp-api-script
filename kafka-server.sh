#!/bin/bash

kafka_dir=/apps/kafka/kafka_2.11-0.10.0.1

echo -e

case $1 in
    "start")
        echo "Starting kafka"
        echo "**************"
        nohup $kafka_dir/bin/kafka-server-start.sh $kafka_dir/config/server.properties &
     ;;
    "stop")
        echo "Stopping kafka"
        echo "**************"
        $kafka_dir/bin/kafka-server-stop.sh
    ;;
    "status")
        echo "Kafka status"
        echo "************"
        #netstat -a -n -o | grep "9092"
        ss -lptn 'sport = :9092'
    ;;
    *)
       echo "Invalid option. Available options: { start | stop | status }"

esac
