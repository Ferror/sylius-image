# syntax=docker/dockerfile:1

ARG ALPINE_VERSION=3.15

FROM composer:2.3 AS composer
FROM spiralscout/roadrunner:2.9.4 AS roadrunner
FROM node:14-alpine${ALPINE_VERSION} AS node
FROM php:8.0-fpm-alpine${ALPINE_VERSION}

COPY --from=composer                        /usr/bin/composer               /usr/bin/composer
COPY --from=roadrunner                      /usr/bin/rr                     /usr/bin/rr
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/bin/install-php-extensions

COPY --from=node /usr/lib             /usr/lib
COPY --from=node /usr/local/share     /usr/local/share
COPY --from=node /usr/local/lib       /usr/local/lib
COPY --from=node /usr/local/include   /usr/local/include
COPY --from=node /usr/local/bin       /usr/local/bin

RUN <<EOT
apk update --no-cache
apk add --no-cache unzip make yarn python2 g++
install-php-extensions \
    calendar \
    ctype \
    curl \
    dom \
    exif \
    gd \
    hash \
    iconv \
    intl \
    mbstring \
    opcache \
    pdo \
    pdo_mysql \
    pdo_pgsql \
    pdo_sqlite \
    pgsql \
    sockets \
    xml \
    xsl \
    zip
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/* /usr/share/man/* /var/cache/apk/*
EOT

COPY .docker/php.ini    /usr/local/etc/php/php.ini

WORKDIR /app

EXPOSE 80

CMD ["make", "run"]
