#!/bin/bash

case $2 in
    "start")
        /apps/tomcat/instances/$1/bin/tomcat.sh start
     ;;
    "stop")
        /apps/tomcat/instances/$1/bin/tomcat.sh stop
    ;;
    "status")
        /apps/tomcat/instances/$1/bin/tomcat.sh status
esac

