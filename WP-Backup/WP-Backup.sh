#!/bin/bash
### Tested on Debian 11 | Hestia control panel
### u can use variables to set domain name for backup
set -e
# describe variables
wp_config_path='/home/admin/web/mvk1.ml/public_html/wp-config.php'
files_dir='/home/admin/web/mvk1.ml/public_html'
timestamp=$(date +%Y-%m-%d_%H-%M-%S)
backup_dir='/backup'
zip_file="$backup_dir/files-$timestamp.zip"
backup_file="$backup_dir/dbdump-$timestamp.sql"

#  create directory for bckp
mkdir -p $backup_dir

# read variables from  wp-config.php
db_name=$(grep -oP "(?<=DB_NAME', ')[^']+" $wp_config_path)
db_user=$(grep -oP "(?<=DB_USER', ')[^']+" $wp_config_path)
db_password=$(grep -oP "(?<=DB_PASSWORD', ')[^']+" $wp_config_path)
db_host=$(grep -oP "(?<=DB_HOST', ')[^']+" $wp_config_path)


# Create db dump
mysqldump -u $db_user -p$db_password -h $db_host $db_name > $backup_file

# Compress directory to zip-file
zip -r -q $zip_file $files_dir

# acho that ist all ok!
echo "Thats all, friends"
