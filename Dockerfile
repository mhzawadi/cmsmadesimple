FROM php:7.2-apache-stretch

ENV CMSMS_VERSION 2.2.10
ENV CMSMS_URL 'http://s3.amazonaws.com/cmsms/downloads/14356/cmsms-2.2.10-install.zip'

WORKDIR /var/www/html

RUN apt-get update && \
    apt-get -y install curl zip libzip-dev libgd-dev && \
    apt-get clean;
    curl -LO ${CMSMS_URL} && \
    unzip cmsms-${CMSMS_VERSION}-install.zip && \
    rm -r cmsms-${CMSMS_VERSION}-install.zip

COPY limits.ini $PHP_INI_DIR/conf.d/

RUN docker-php-ext-configure zip --with-libzip && \
    docker-php-ext-install -j$(nproc) zip; \
    docker-php-ext-install -j$(nproc) \
      mysqli \
      gd \
      opcache; \
    a2enmod rewrite \
    chown -R www-data.www-data .

EXPOSE 80
