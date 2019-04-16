# cmsms-docker  [![Travis](https://img.shields.io/travis/com/mhzawadi/cmsms-docker/master.svg?label=amd64%20build)](https://travis-ci.org/mhzawadi/cmsms-docker) [![Travis](https://img.shields.io/travis/com/mhzawadi/cmsms-docker/2.2.10.svg?label=2.2.10amd64%20build)](https://travis-ci.org/mhzawadi/cmsms-docker)


This Docker Image provides cms made simple served by apache.

Docker image for CMS Made Simple, an Open Source Content Management System built using PHP and the Smarty Engine, which keeps content, functionality, and templates separated (<https://www.cmsmadesimple.org>).

## How to use this image
This image is designed to be used in a micro-service environment. There are two versions of the image you can choose from.

The arm32v7 tag contains the CMS Made Simple installation script and includes an apache web server. It is designed for the raspberry pi and be easy to use and gets you running pretty fast.

The second option is a amd64 container. This will run on most PC/Macs and servers.

## Persistent data
The CMS Made Simple installation and all data beyond what lives in the database (file uploads, etc) is stored in the [unnamed docker volume](https://docs.docker.com/engine/tutorials/dockervolumes/#adding-a-data-volume) volume `/var/www/html`. The docker daemon will store that data within the docker directory `/var/lib/docker/volumes/...`. That means your data is saved even if the container crashes, is stopped or deleted.

A named Docker volume or a mounted host directory should be used for upgrades and backups. To achieve this you need one volume for your database container and one for CMS Made Simple.

CMS Made Simple:
- `/var/www/html/` folder where all cmsms data lives
```console
$ docker run -d \
-v cmsms:/var/www/html \
cmsms-docker
```

Database:
- `/var/lib/mysql` MySQL / MariaDB Data
- `/var/lib/postgresql/data` PostgreSQL Data
```console
$ docker run -d \
-v db:/var/lib/mysql \
mariadb
```

If you want to get fine grained access to your individual files, you can mount additional volumes for data, config, your theme and custom apps.
The `data`, `config` are stored in respective subfolders inside `/var/www/html/`. The apps are split into core `apps` (which are shipped with CMS Made Simple and you don't need to take care of) and a `custom_apps` folder. If you use a custom theme it would go into the `themes` subfolder.

Overview of the folders that can be mounted as volumes:

- `/var/www/html` Main folder, needed for updating
- `/var/www/html/custom_apps` installed / modified apps
- `/var/www/html/config` local configuration
- `/var/www/html/data` the actual data of your CMS Made Simple
- `/var/www/html/themes/<YOUR_CUSTOM_THEME>` theming/branding

If you want to use named volumes for all of these it would look like this
```console
$ docker run -d \
-v cmsms:/var/www/html \
-v apps:/var/www/html/custom_apps \
-v config:/var/www/html/config \
-v data:/var/www/html/data \
-v theme:/var/www/html/themes/<YOUR_CUSTOM_THEME> \
cmsms-docekr
```

## Auto configuration via environment variables
The CMS Made Simple image supports auto configuration via environment variables. You can preconfigure everything that is asked on the install page on first run. To enable auto configuration, set your database connection via the following environment variables. ONLY use one database type!

__MYSQL/MariaDB__:
- `MYSQL_DATABASE` Name of the database using mysql / mariadb.
- `MYSQL_USER` Username for the database using mysql / mariadb.
- `MYSQL_PASSWORD` Password for the database user using mysql / mariadb.
- `MYSQL_HOST` Hostname of the database server using mysql / mariadb.

## Running this image with docker-compose
The easiest way to get a fully featured and functional setup is using a docker-compose file. There are too many different possibilities to setup your system, so here is an examples what you have to look for.

At first make sure you have chosen the right image (arm32v7 or amd64) and added the features you wanted (see below). In every case you want to add a database container and docker volumes to get easy access to your persistent data. When you want to have your server reachable from the internet adding HTTPS-encryption is mandatory! See below for more information.

```
version: '3.5'

volumes:
  db:
  cms_modules:
  cms_uploads:

services:
db:
  image: mariadb
  command: --transaction-isolation=READ-COMMITTED --binlog-format=ROW
  restart: always
  volumes:
    - db:/var/lib/mysql
  environment:
    - MYSQL_ROOT_PASSWORD=
    - MYSQL_PASSWORD=
    - MYSQL_DATABASE=cmsms
    - MYSQL_USER=cmsms
  cmsms:
     image: mhzawadi/cmsms-docker:2.2.9-arm32v7
     volumes:
       - cms_modules:/var/www/html/modules
       - cms_uploads:/var/www/html/uploads
     restart: always
     environment:
       - REMOVE_INSTALL_FOLDER=true
```

# First use
When you first access your CMS Made Simple, the setup wizard will appear and ask you to choose an administrator account, password and the database connection. For the database use `db` as host and `cmsms-docker` as table and user name. Also enter the password you chose in your `docker-compose.yml` file.

# Update to a newer version
Updating the CMS Made Simple container is done by pulling the new image, throwing away the old container and starting the new one. Since all data is stored in volumes, nothing gets lost. The startup script will check for the version in your volume and the installed docker version. If it finds a mismatch, it automatically starts the upgrade process. Don't forget to add all the volumes to your new container, so it works as expected.

```console
$ docker pull cmsms-docker
$ docker stop <your_cmsms-docker_container>
$ docker rm <your_cmsms-docker_container>
$ docker run <OPTIONS> -d cmsms-docker
```
Beware that you have to run the same command with the options that you used to initially start your CMS Made Simple. That includes  volumes, port mapping.

When using docker-compose your compose file takes care of your configuration, so you just have to run:

```console
$ docker-compose pull
$ docker-compose up -d
```
