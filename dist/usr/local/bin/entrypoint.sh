#!/usr/bin/env bash
set -e

cd /var/www/html

. docker-php-entrypoint

cp /config.template.php /var/www/html/config.php
chown -R www-data:www-data /var/www/html/config.php

if [[ -n "${REMOVE_INSTALL_FOLDER}" ]]
then
	echo "Removing install dir"
	rm -rfv cmsms-${CMSMS_VERSION}-install.php
fi

exec apache2-foreground
