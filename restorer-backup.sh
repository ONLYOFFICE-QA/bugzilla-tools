#!/bin/bash

AWS_ACCESS_KEY_ID=''
AWS_SECRET_ACCESS_KEY=''
BACKUP_NAME='bugzilla-backup-2021-05-26-16-00-01.tar.gz'
BUGZILLA_DB_USER=''
BUGZILLA_DB_PASSWORD=''
TEMP_FOLDER='/tmp'

apt-get -y update
apt-get -y install apache2 \
                   awscli \
                   gcc \
                   g++ \
                   libapache2-mod-perl2 \
                   libgd-dev \
                   libmysqlclient-dev \
                   make \
                   mysql-server \
                   pkg-config

a2enmod cgi
a2enmod expires
a2enmod headers
a2enmod rewrite
service apache2 restart

if compgen -G "/tmp/bugzilla-backup-*.tar.gz" > /dev/null; then
  echo "bugzilla backup file already downloaded"
else
  aws configure set aws_access_key_id "$AWS_ACCESS_KEY_ID"
  aws configure set aws_secret_access_key "$AWS_SECRET_ACCESS_KEY"
  aws s3 cp s3://nct-bugzilla-backup/$BACKUP_NAME $TEMP_FOLDER
fi

# Unpack backup
tar xvf $TEMP_FOLDER/$BACKUP_NAME -C $TEMP_FOLDER
mkdir -pv /var/www/html/bugzilla
mv $TEMP_FOLDER/mnt/bugzilla_data_volume/bugzilla-backup-temp/data /var/www/html/
mv /var/www/html/data /var/www/html/bugzilla

# Restore database
service mysql start
mysql -u root -e "CREATE USER '$BUGZILLA_DB_USER'@'localhost' IDENTIFIED BY '$BUGZILLA_DB_PASSWORD';"
mysql -u root -e "GRANT ALL ON $BUGZILLA_DB_USER.* TO '$BUGZILLA_DB_USER'@'localhost';"
pv $TEMP_FOLDER/var/backups/bugzilla/bugz.sql.gz | gunzip | mysql -u "$BUGZILLA_DB_USER" -p"$BUGZILLA_DB_PASSWORD" bugz

# Install perl dependencies
cd /var/www/html/bugzilla
/usr/bin/perl install-module.pl --all
/usr/bin/perl install-module.pl Email::Send::SMTP::TLS

service apache2 restart