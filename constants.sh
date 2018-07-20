#!/bin/bash

#Tomcat globals
tomcat_base_loc=/apps/tomcat/instances/$TOMCAT_INSTANCE
webapps_loc=$tomcat_base_loc/webapps

#App
app_dir=/apps/tomcat/rp-app
app_name=$APP_NAME
app_config_loc=$app_dir/config/$app_name

#war
war_config_loc=WEB-INF/classes/config/${PROFILE_NAME}

#backup
backup_loc=$app_dir/backup/$app_name
curr_backup_name=`date +%Y%m%d-%H-%M-%S`
curr_backup_loc=$backup_loc/$curr_backup_name

#Jenkins
artifact_base_url=http://uklvadapp005:8080/job

#rp
rp_final_app_name=research#api#application#v1.0#rp
rp_final_app_war=research#api#application#v1.0#rp.war


function war_config_path() {
    if [ -z $DATA_CENTER ]
    then
        war_config_loc=$war_config_loc/$DATA_CENTER
        echo "Configuration path inside war file: "$war_config_loc
    fi
}
