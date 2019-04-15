#!/usr/bin/env bash
set -e

cd /var/www/html

. docker-php-entrypoint

if [[ -n "${REMOVE_INSTALL_FOLDER}" ]]
then
	echo "Removing install dir"
	rm -rfv cmsms-${CMSMS_VERSION}-install.php
	chmod 0640 /var/www/html/config/config.php
else
	echo "Making config.php writable"
	touch /var/www/html/config.php
	chmod 0666 /var/www/html/config/config.php
fi

exec apache2-foreground
