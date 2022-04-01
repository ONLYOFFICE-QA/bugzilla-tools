#!/bin/bash

DB_USER=''
DB_PASS=''
DB_BASE=''

DATE=$(date '+%Y-%m-%d-%H-%M-%S')
BASE_BACKUP_PATH=/mnt/bugzilla_data_volume/bugzilla-backup-storage
BACKUP_NAME=$BASE_BACKUP_PATH/bugzilla-backup-$DATE.tar.gz
BACKUP_DIR=$BASE_BACKUP_PATH/bugzilla-backup-temp

mkdir -pv $BACKUP_DIR
mysqldump --no-tablespaces --max-allowed-packet=32M -u $DB_USER -p$DB_PASS $DB_BASE > $BACKUP_DIR/bugzilla.sql
cp -rp /var/www/html/bugzilla $BACKUP_DIR/data
tar -zcvf "$BACKUP_NAME" $BACKUP_DIR
/usr/local/bin/aws s3 cp "$BACKUP_NAME" s3://nct-bugzilla-backup/
rm "$BACKUP_NAME"
rm -rf $BACKUP_DIR
