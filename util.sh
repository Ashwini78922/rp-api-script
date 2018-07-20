#!/bin/bash

#Helper functions
function display_usage() {
    echo "---------------------------------------------------------------------------------------"
    echo "usage: [ options... ] [ -t,-p,-b,-n,-d ]"
    echo -e
    echo "  -t : tomcat instance name"
    echo "  -p : profile name {dev|sit|prod}"
    echo "  -c : data center {dc1|dc2}"
    echo "  -n : name of the app to deploy {content-cache|notification-engine|rp|message-center}"
    echo "  -b : branch name to deploy"
    echo "  -d : backup required? {y|n}"
    echo "  -h : display help"
    echo -e
    echo "mandatory : [-t -p -n ]"
    echo "optional  : [ -b -d -c ]"
    echo "note      : default branch value [ -b ] set to develop, override with [ -b ] tag"
    echo -e "-----------------------------------------------------------------------------------"
}

function not_found() {
    if [ -z "$1" ]
    then
       echo "Option values cannot be empty. Exiting"
       exit 0
    fi
}

#Validation functions
if [  $# -le 5 ]
   then
      display_usage
      exit 1
fi

# check if user had supplied -h. If yes display usage
if [ $# == "-h" ]
then
    display_usage
    exit 0
fi


#Initializing values
while [[ $# -gt 1 ]]
do
    key=$1
    case $key in
        -t)
        not_found $2
        TOMCAT_INSTANCE=$2
        shift
        ;;
        -d)
        BACK_UP=$2
        shift
        ;;
        -c)
        DATA_CENTER=$2
        shift
        ;;
        -p)
        not_found $2
        PROFILE_NAME=$2
        shift
        ;;
        -n)
        not_found $2
        APP_NAME=$2
        shift
        ;;
        -b)
        BRANCH_NAME=$2
        shift
        ;;
       *)
        ;;
    esac
    shift
done

if [[ -z $BRANCH_NAME ]]
then
    BRANCH_NAME="FOUNDATION-SERVICES_develop"
fi

#Info
echo -e
echo "Deployment started "
echo "====================================="
echo "APP             :" $APP_NAME
echo "TOMCAT INSTANCE :" $TOMCAT_INSTANCE
echo "PROFILE_NAME    :" $PROFILE_NAME
echo "DATA_CENTER     :" $DATA_CENTER
echo "BRANCH_NAME     :" $BRANCH_NAME
echo "BACKUP          :" $BACK_UP
echo "====================================="
