#!/bin/bash

source util.sh
source constants.sh

#Used by message center and content cache modules
function deploy() {
    url=$1
    war_name=$2
    final_app_name=$3

    rm -rf $webapps_loc/$final_app_name* && wget $url -P $webapps_loc
    yes | unzip -j $webapps_loc/$war_name $war_config_loc/* -d $app_config_loc
}



function deploy_notification_engine() {
    temp=$tomcat_base_loc/temp
    library=rp-enrichment-0.0.1-SNAPSHOT.jar
    jar_config_path=config/$PROFILE_NAME
    library_path=WEB-INF/lib

    url=$1
    war_name=$2
    final_app_name=$3

    echo "Copying configuration from $webapps_loc/$war_config_loc to $app_config_loc"
    echo "--------------------------------------------------------------------------"

    rm -rf $webapps_loc/$final_app_name* && wget $url -P $webapps_loc
    yes | unzip -j $webapps_loc/$app_war $war_config_loc/* -d $app_config_loc

    echo "Temp: Copying library configuration from $webapps_loc/$app_war, $library_path/$library"
    echo "--------------------------------------------------------------------------"

    yes | unzip -j $webapps_loc/$app_war $library_path/$library -d $temp
    yes | unzip -j $temp/$library $jar_config_path/* -d $app_config_loc
    rm -r $temp/*
}

function main() {

    app_war=$app_name.war
    url=$artifact_base_url/$BRANCH_NAME/lastSuccessfulBuild/artifact/$app_name/target/$app_war

    case $app_name in
    "content-cache")
        deploy $url $app_war $app_name
        ;;
    "rp")
        url=$artifact_base_url/$BRANCH_NAME/lastSuccessfulBuild/artifact/rp-web/rp-api/target/$app_war
        deploy $url $app_war $rp_final_app_name
        #Rename the war name
        mv ${webapps_loc}/${app_war} ${webapps_loc}/$rp_final_app_war
        ;;
    "notification-engine")
        deploy_notification_engine $url $app_war $app_name
        ;;
    "message-center")
        deploy $url $app_war $app_name
    esac
}


################
# BACKUP CODE  #
################

function backup_data() {
    war_name=$1
    echo "$1 backup in process"
    #If war file exist in webapps
    if [ -f $webapps_loc/$war_name ]
    then
        mkdir $curr_backup_loc
        mv ${webapps_loc}/${war_name} $curr_backup_loc
        cp -r $app_config_loc $curr_backup_loc
    else
        echo "${RED} Warning: war file: $war_name doesn't exist skipping backup"
    fi
    echo "Backup completed"
}


function backup_rp_data() {
    rp_war_name=$1
    echo "$2 backup in process"
    #If war file exist in webapps
    if [ -f $webapps_loc/$rp_war_name ]
    then
        mkdir $curr_backup_loc
        mv ${webapps_loc}/${rp_war_name} $curr_backup_loc
        cp -r $app_config_loc $curr_backup_loc
    else
        echo "${RED} Warning: war file: $rp_war_name doesn't exist skipping backup"
    fi
    echo "Backup completed"
}

function execute_backup() {
    if [[ $app_name == "rp" ]]
        then
            backup_rp_data $rp_final_app_war
        else
            backup_data $app_name.war
    fi
}


function check_if_backup_required() {
    if [[ $BACK_UP == "y" ]] || [[ $BACK_UP == "Y" ]]
    then
        echo -e
        echo "${RED} Backing up: war and config files"
        echo "======================================="
        execute_backup
    fi
}


#Deployment
check_if_backup_required
main

echo "========================finished=========================="

