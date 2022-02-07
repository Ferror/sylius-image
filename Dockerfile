ARG UBUNTU_VERSION=20.04

FROM ubuntu:${UBUNTU_VERSION}

ARG PHP_VERSION=8.0
ARG NODE_VERSION=16
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y software-properties-common
RUN add-apt-repository ppa:ondrej/php
RUN apt-get update && apt-get install -y \
    curl \
    make \
    nginx \
    unzip \
    supervisor\
    php${PHP_VERSION}-common \
    php${PHP_VERSION}-fpm \
    php${PHP_VERSION}-cli \
    php${PHP_VERSION}-bz2 \
    php${PHP_VERSION}-curl \
    php${PHP_VERSION}-intl \
    php${PHP_VERSION}-gd \
    php${PHP_VERSION}-mbstring \
    php${PHP_VERSION}-mysql \
    php${PHP_VERSION}-pgsql \
    php${PHP_VERSION}-opcache \
    php${PHP_VERSION}-soap \
    php${PHP_VERSION}-xml \
    php${PHP_VERSION}-zip \
    php${PHP_VERSION}-apcu \
    php${PHP_VERSION}-redis \
    php${PHP_VERSION}-xdebug \
    php${PHP_VERSION}-yaml \
    php${PHP_VERSION}-sqlite


RUN curl -sL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash -
RUN apt-get install -y \
    nodejs \
    python2
RUN corepack enable

RUN apt-get clean && apt-get autoclean

RUN ln -s /usr/sbin/php-fpm${PHP_VERSION} /usr/sbin/php-fpm

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename composer

RUN mkdir -p /run/php

COPY nginx.conf         /etc/nginx/nginx.conf
COPY supervisor.conf    /etc/supervisor/conf.d/supervisor.conf
COPY www.conf           /etc/php/${PHP_VERSION}/fpm/pool.d/www.conf

WORKDIR /app

EXPOSE 80
