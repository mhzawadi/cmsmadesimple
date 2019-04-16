#!/bin/bash
set -eu

cd /var/www/html

if [ -f "cmsms-${CMSMS_VERSION}-install.php" ]
then
	echo "have the file ta"
else
	if [ "$(id -u)" = 0 ]; then
		rsync_options="--chown www-data:root"
	else
		rsync_options=""
	fi
	rsync $rsync_options /usr/src/cmsms-${CMSMS_VERSION}-install.php /var/www/html/
fi

cp /config.template.php /var/www/html/config.php
chown -R www-data:www-data /var/www/html/config.php
if [ -n "${MYSQL_HOST}" ]; then
	sed -i -e "s/###MYSQL_HOST###/${MYSQL_HOST}/g" /var/www/html/config.php
fi
if [ -n "${MYSQL_USER}" ]; then
	sed -i -e "s/###MYSQL_USER###/${MYSQL_USER}/g" /var/www/html/config.php
fi
if [ -n "${MYSQL_PASSWORD}" ]; then
	sed -i -e "s/###MYSQL_PASSWORD###/${MYSQL_PASSWORD}/g" /var/www/html/config.php
fi
if [ -n "${MYSQL_DATABASE}" ]; then
	sed -i -e "s/###MYSQL_DATABASE###/${MYSQL_DATABASE}/g" /var/www/html/config.php
fi

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

. docker-php-entrypoint
