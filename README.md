
# cmsms-docker

[![Travis](https://travis-ci.com/mhzawadi/cmsms-docker.svg?branch=master)](https://travis-ci.org/mhzawadi/cmsms-docker)


CMS Made Simple docker build

Docker image for CMS Made Simple, an Open Source Content Management System built using PHP and the Smarty Engine, which keeps content, functionality, and templates separated (<https://www.cmsmadesimple.org>).

## How to use this image

CMS Made Simple requires a MySQL DB as backend. You can launch a dockerized one with the following command (change paswords accordingly):

    $ docker run --name mysqlcms -e MYSQL_ROOT_PASSWORD=<root_password> -e MYSQL_DATABASE=cmsmadesimpledb -e MYSQL_USER=cmsmadesimple -e MYSQL_PASSWORD=<user_password> -d mysql:5.7

This will start a CMS Made Simple instance listening on port 80:

    $ docker run -d -p 80:80 --name cmsmadesimple --link mysqlcms:mysql mhzawadi/cmsms-docker

If you'd like persistance, you can create a volume for that purpose:

    $ docker volume create cmsmadesimple_web
    $ docker run -d -p 80:80 --name cmsmadesimple --link mysqlcms:mysql -v cmsmadesimple_web:/var/www/html mhzawadi/cmsms-docker

Once the container is running for the first time, navigate to `/cmsms-2.2.8-install.php` to be redirected to the upgrade and install scripts.
