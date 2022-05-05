FROM php:8.0-fpm-alpine

COPY --from=composer:2.3 /usr/bin/composer /usr/bin/composer
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/bin/install-php-extensions

RUN install-php-extensions \
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
    xml \
    xsl \
    zip

COPY .docker/fpm.conf   /usr/local/etc/php-fpm.conf
COPY .docker/php.ini    /usr/local/etc/php/php.ini

WORKDIR /app

EXPOSE 9000

ENTRYPOINT ["/usr/local/sbin/php-fpm"]
