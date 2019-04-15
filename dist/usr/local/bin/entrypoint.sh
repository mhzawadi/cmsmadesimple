#!/usr/bin/env bash
set -e

cd /var/www/html

. docker-php-entrypoint

if [ ! -d /var/www/config ]
then
	mkdir /var/www/config
fi
cp /config.template.php /var/www/config/config.php
chown -R www-data:www-data /var/www/config/config.php
ln -s config/config.php config.php

if [[ -n "${REMOVE_INSTALL_FOLDER}" ]]
then
	echo "Removing install dir"
	rm -rfv cmsms-${CMSMS_VERSION}-install.php
	chmod 0640 /var/www/html/config.php
else
	echo "Making config.php writable"
	touch /var/www/html/config.php
	chmod 0666 /var/www/html/config.php
fi

exec apache2-foreground
