
#!/bin/bash

server_name=$1

if [[ $1 == "-h" ]]
then
  echo -e
  echo "usage [ options ] [ SIT_eReseach_HK_01 | SIT_eReseach_HK_02 | PROD_eReseach_HK_01 | PROD_eReseach_HK_02 | DC_eReseach_HK_01 | DC_eReseach_HK_02 ]"
  echo -e
  exit 0
fi

if [ -z $server_name ]
then
  echo "Server name not found. Type -h for help"
  exit 0
fi

echo "One time app configuration started for server $server_name"
echo "=============================================================================="
echo -e

root_dir_loc=/apps/tomcat
tomcat_conf_loc=/apps/tomcat/instances/$server_name/conf
app_conf_filename=prod.conf


#Update tomcat configuration with app configuration
echo "Updating tomcat $server_name configuration with app configuration"
echo "==============================================================================="
echo -e

cd $tomcat_conf_loc && wget 'http://uklvadapp004:8081/artifactory/libs-release-local/com/scb/channels/rp/webapps/scripts/'$app_conf_filename
cat $tomcat_conf_loc/$app_conf_filename >> $tomcat_conf_loc/tomcat.conf
rm -r $tomcat_conf_loc/$app_conf_filename

#Initialize the directories

echo "Initializing directories $root_dir_loc"
echo "=============================================================="
echo -e 

server_backup_loc=$root_dir_loc/rp-app/backup
server_config_loc=$root_dir_loc/rp-app/config
app_loc=$root_dir_loc/rp-app
app_script_dir=script
app_backup_dir=backup
app_config_dir=config


mkdir $app_loc
mkdir $app_loc/$app_script_dir
mkdir $app_loc/$app_backup_dir
mkdir $app_loc/$app_config_dir

mkdir $server_config_loc/content-cache
mkdir $server_config_loc/notification-engine
mkdir $server_config_loc/rp
mkdir $server_config_loc/message-center

mkdir $server_backup_loc/content-cache
mkdir $server_backup_loc/notification-engine
mkdir $server_backup_loc/rp
mkdir $server_backup_loc/message-center

echo "Downloading scripts"
echo "==================="
echo -e

cd $app_loc/$app_script_dir &&  wget 'http://uklvadapp004:8081/artifactory/libs-release-local/com/scb/channels/rp/webapps/scripts/deploy.zip' && unzip deploy.zip -d . && cp deploy/* . && rm -r deploy && rm -r deploy.zip
chmod +x *.sh

echo "Finished app configuration for server $server_name"
