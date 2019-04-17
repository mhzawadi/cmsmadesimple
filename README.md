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

If you want to get fine grained access to your individual files, you can mount additional volumes for content and modules.

Overview of the folders that can be mounted as volumes:

- `/var/www/html` Main folder, needed for updating
- `/var/www/html/modules` installed / modified modules
- `/var/www/html/uploads` all your content


If you want to use named volumes for all of these it would look like this
```console
$ docker run -d \
-v cmsms:/var/www/html \
-v cms_modules:/var/www/html/modules \
-v cms_uploads:/var/www/html/uploads \
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

At first make sure you have chosen the right image (arm32v7 or amd64) and added the features you wanted (see below). In every case you want to add a database container and docker volumes to get easy access to your persistent data. See below for more information.

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
You will need to run the setup wizard located at `http://server/cmsms-<version>-install.php`, once you have run the setup wizard you should see your site.

# Update to a newer version
Updating the CMS Made Simple container is done by pulling the new image, throwing away the old container and starting the new one. Since all data is stored in volumes, nothing gets lost. You will then need to navigate to the setup wizard for the new version to complete the update process.

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

# Custom builds
If you want to fork this and run a custom build, you can use the build.sh file included.
You will need to store the below in ~/.docker_build, if you provide a pushover token and username you can get alerts once the build has finished.

```
DOCKER_USERNAME=''
DOCKER_PASSWORD=''
PUSHOVER_USER=''
PUSHOVER_TOKEN=''
SOURCE_IMAGE=''
SOURCE_IMAGE_TAG=''
TARGET_IMAGE=''
DOCKERFILE=''
TAG_SUFFIX=''
ALT_SUFFIX=''
```
