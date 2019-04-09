#!/usr/bin/env bash
set -e

cd /var/www/html

. docker-php-entrypoint

chown -R www-data:www-data tmp/templates_c
chown -R www-data:www-data tmp/cache
chown -R www-data:www-data uploads
chown -R www-data:www-data uploads/images
chown -R www-data:www-data modules

cp /config.template.php /var/www/html/config.php
chown -R www-data:www-data /var/www/html/config.php
sed -i -e "s/###MYSQL_HOST###/${MYSQL_HOST}/g" /var/www/html/config.php
sed -i -e "s/###MYSQL_USER###/${MYSQL_USER}/g" /var/www/html/config.php
sed -i -e "s/###MYSQL_PASSWORD###/${MYSQL_PASSWORD}/g" /var/www/html/config.php
sed -i -e "s/###MYSQL_DATABASE###/${MYSQL_DATABASE}/g" /var/www/html/config.php

if [[ -n "${REMOVE_INSTALL_FOLDER}" ]]
then
	echo "Removing install dir"
	rm -rfv install
	chmod 0640 /var/www/html/config.php
else
	echo "Making config.php writable"
	touch /var/www/html/config.php
	chmod 0666 /var/www/html/config.php
fi

exec apache2-foreground
