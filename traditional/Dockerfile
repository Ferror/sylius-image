FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive
ARG SYLIUS_PHP_VERSION=8.0

ENV LC_ALL=C.UTF-8

# Install basic tools
RUN apt-get update && apt-get install -y \
    software-properties-common \
    curl \
    supervisor \
    unzip \
    python2 \
    make \
    g++

# Append NODE, NGINX and PHP repositories
RUN add-apt-repository ppa:ondrej/php \
    && add-apt-repository ppa:ondrej/nginx \
    && curl -sL https://deb.nodesource.com/setup_14.x | bash -

# Install required PHP extensions
RUN apt-get update && apt-get install -y \
    nodejs \
    nginx \
    php${SYLIUS_PHP_VERSION} \
    php${SYLIUS_PHP_VERSION}-common \
    php${SYLIUS_PHP_VERSION}-cli \
    php${SYLIUS_PHP_VERSION}-xml \
    php${SYLIUS_PHP_VERSION}-curl \
    php${SYLIUS_PHP_VERSION}-gd \
    php${SYLIUS_PHP_VERSION}-intl \
    php${SYLIUS_PHP_VERSION}-opcache \
    php${SYLIUS_PHP_VERSION}-pdo \
    php${SYLIUS_PHP_VERSION}-ctype \
    php${SYLIUS_PHP_VERSION}-calendar \
    php${SYLIUS_PHP_VERSION}-dom \
    php${SYLIUS_PHP_VERSION}-exif \
    php${SYLIUS_PHP_VERSION}-xsl \
    php${SYLIUS_PHP_VERSION}-zip \
    php${SYLIUS_PHP_VERSION}-fpm \
    php${SYLIUS_PHP_VERSION}-mysql \
    php${SYLIUS_PHP_VERSION}-mbstring \
    php${SYLIUS_PHP_VERSION}-sqlite \
    php${SYLIUS_PHP_VERSION}-pgsql \
    php${SYLIUS_PHP_VERSION}-yaml

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename composer

# Cleanup
RUN apt-get remove --purge -y software-properties-common curl && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/* /usr/share/man/*

# Link php-fpm binary file without version
RUN ln -s /usr/sbin/php-fpm${SYLIUS_PHP_VERSION} /usr/sbin/php-fpm

# Create directory for php-fpm socket
RUN mkdir -p /run/php

# Install yarn
RUN npm install -g yarn && npm cache clean --force

# Initialize config files
COPY .docker/supervisord.conf   /etc/supervisor/conf.d/supervisor.conf
COPY .docker/nginx.conf         /etc/nginx/nginx.conf
COPY .docker/fpm.conf           /etc/php/${SYLIUS_PHP_VERSION}/fpm/pool.d/www.conf
COPY .docker/php.ini            /etc/php/${SYLIUS_PHP_VERSION}/fpm/php.ini
COPY .docker/php.ini            /etc/php/${SYLIUS_PHP_VERSION}/cli/php.ini

WORKDIR /app

EXPOSE 80

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
