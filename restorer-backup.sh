#!/bin/bash

AWS_ACCESS_KEY_ID=''
AWS_SECRET_ACCESS_KEY=''
BACKUP_NAME='bugzilla-backup-2021-05-26-16-00-01.tar.gz'
BUGZILLA_DB_USER=''
BUGZILLA_DB_PASSWORD=''
TEMP_FOLDER='/tmp'

aws configure set aws_access_key_id "$AWS_ACCESS_KEY_ID"
aws configure set aws_secret_access_key "$AWS_SECRET_ACCESS_KEY"
aws s3 cp s3://nct-bugzilla-backup/$BACKUP_NAME $TEMP_FOLDER

# Unpack backup
tar xvf $TEMP_FOLDER/$BACKUP_NAME -C $TEMP_FOLDER
mv $TEMP_FOLDER/var/backups/bugzilla /var/www/html

# Restore database
service mysql start
mysql -u root -e "CREATE USER '$BUGZILLA_DB_USER'@'localhost' IDENTIFIED BY '$BUGZILLA_DB_PASSWORD';"
mysql -u root -e "GRANT ALL ON $BUGZILLA_DB_USER.* TO '$BUGZILLA_DB_USER'@'localhost';"
pv $TEMP_FOLDER/var/backups/bugzilla/bugz.sql.gz | gunzip | mysql -u "$BUGZILLA_DB_USER" -p"$BUGZILLA_DB_PASSWORD" testrail

