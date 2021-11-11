#!/bin/bash
#Zabbix Backup

#Stops service
sudo service zabbix-server.service stop
#Backsup all zabbix folders(on this specific machine)
sudo yes | cp -rf "usr/share/zabbix folder" /zabbix/backups/zabbix_usr_share.backup/ 
sudo yes | cp -rf "etc/zabbix folder" /zabbix/backups/zabbix.backup/
sudo yes | cp -rf "usr/share/doc/zabbix folder" /zabbix/backups/
sudo yes | cp -rf "httpd config file"  /zabbix/backups/

#Zabbix database backup

# Database credentials
user="backup user"
password="backup user password"
host="host"
db_name="database"

# DB folder name with date time
backup_path="('path used as backup folder on server')"
date=$(date +"%d-%b-%Y")

# Dump database into SQL file
sudo mysqldump --user=$user --password=$password --host=$host $db_name > $backup_path/$db_name-$date.sql

# Starts services and give a status to a file on the backup folder
sudo service zabbix-server.service start
sudo service zabbix-server.service status > $backup_path/zabbbixstatus.$date.txt

#Transder folder from local to network share
bktarget=('Shared folder mount')
bksource=('path used as backup folder on server')

foldername=${bktarget}/zabbixbk.$(date +%Y_%m_%d_%H_%M)
mkdir -p $foldername
cp ${bksource}/* ${foldername}/
