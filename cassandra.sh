#!/bin/bash


cassandra_dir=/apps/cassandra/apache-cassandra-3.7/bin

echo -e

case $1 in
    "start")
        echo "Starting cassandra"
        echo "******************"
        $cassandra_dir/cassandra
     ;;
    "stop")
        echo "Stopping cassandra"
        echo "******************"
        user=`whoami`
        pgrep -u $user -f cassandra | xargs kill -9
    ;;
    "status")
        echo "Cassandra status"
        echo "****************"
        ss -lptn 'sport = :9042'
    ;;
    *)
       echo "Invalid option. Available options: { start | stop | status }"

esac

