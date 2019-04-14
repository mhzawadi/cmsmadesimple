
# cmsms-docker

[![Travis](https://travis-ci.com/mhzawadi/cmsms-docker.svg?branch=master)](https://travis-ci.org/mhzawadi/cmsms-docker)


This Docker Image provides cms made simple served by apache.

Docker image for CMS Made Simple, an Open Source Content Management System built using PHP and the Smarty Engine, which keeps content, functionality, and templates separated (<https://www.cmsmadesimple.org>).

## How to use this image

For persisting uploaded data you should mount the volumes:

- /var/www/html/uploads
- /var/www/html/modules

## docker-compose

```
version: '3.5'

volumes:
  cms_config:
  cms_modules:
  cms_uploads:

services:
  cmsms:
     image: mhzawadi/cmsms-docker:2.2.9-arm32v7
     volumes:
       - cms_config:/var/www/html/config.php
       - cms_modules:/var/www/html/modules
       - cms_uploads:/var/www/html/uploads
     restart: always
     environment:
       - REMOVE_INSTALL_FOLDER=true
```
