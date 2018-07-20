#!/bin/bash

zookeeper_dir=/apps/kafka/zookeeper-3.4.9
bin_dir=$zookeeper_dir/bin
conf_dir=$zookeeper_dir/conf
conf_filename=zoo_conf.cfg

set -e

case $1 in
    "start")
        echo "Starting zookeeper in port: 2181"
        nohup $bin_dir/zkServer.sh start $conf_dir/$conf_filename
     ;;
    "stop")
        echo "Stopping zookeeper"
        echo "******************"
        $bin_dir/zkServer.sh stop $conf_dir/$conf_filename
     ;;
    "status")
        echo "Zookeeper status"
        echo "****************"
        echo stat | nc localhost 2181 2> /dev/null
     ;;
    *)
       echo "Invalid option. Available options: { start | stop | status }"
esac



