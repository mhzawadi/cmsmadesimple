#!/usr/bin/env bash
set -e

cd /var/www/html

. docker-php-entrypoint

if [ -f "/var/www/html/cmsms-${CMSMS_VERSION}-install.php" ]
then
	echo "have the file ta"
else
	wget ${CMSMS_URL} && \
	unzip cmsms-${CMSMS_VERSION}-install.zip && \
	rm -r cmsms-${CMSMS_VERSION}-install.zip
fi

cp /config.template.php /var/www/html/config.php
chown -R www-data:www-data /var/www/html/config.php
sed -i -e "s/###MYSQL_HOST###/${MYSQL_HOST}/g" /var/www/html/config.php
sed -i -e "s/###MYSQL_USER###/${MYSQL_USER}/g" /var/www/html/config.php
sed -i -e "s/###MYSQL_PASSWORD###/${MYSQL_PASSWORD}/g" /var/www/html/config.php
sed -i -e "s/###MYSQL_DATABASE###/${MYSQL_DATABASE}/g" /var/www/html/config.php

if [[ -n "${REMOVE_INSTALL_FOLDER}" ]]
then
	echo "Removing install dir"
	rm -rfv cmsms-${CMSMS_VERSION}-install.php
	chown -R www-data:www-data /var/www/html/config.php
	chmod 0640 /var/www/html/config.php
else
	echo "Making config.php writable"
	touch /var/www/html/config.php
	chown -R www-data:www-data /var/www/html/config.php
	chmod 0666 /var/www/html/config.php
fi
