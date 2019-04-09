ARG MH_ARCH
ARG MH_TAG
FROM ${MH_ARCH}:${MH_TAG}
MAINTAINER Matthew Horwood <matt@horwood.biz>

ENV CMSMS_VERSION 2.2.10
ENV CMSMS_URL 'http://s3.amazonaws.com/cmsms/downloads/14357/cmsms-${CMSMS_VERSION}-install.zip'

WORKDIR /var/www/html

RUN apt-get update && \
    apt-get -y install curl zip libzip-dev libgd-dev && \
    apt-get clean; \
    curl -LO ${CMSMS_URL} && \
    unzip cmsms-${CMSMS_VERSION}-install.zip && \
    rm -r cmsms-${CMSMS_VERSION}-install.zip

COPY dist /
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
RUN docker-php-ext-configure zip --with-libzip && \
    docker-php-ext-install -j$(nproc) zip; \
    docker-php-ext-install -j$(nproc) \
      mysqli \
      gd \
      opcache; \
    a2enmod rewrite; \
    chown -R www-data.www-data .

EXPOSE 80
ENTRYPOINT ["entrypoint.sh"]
