FROM php:8.0-alpine

COPY --from=composer:2.3 /usr/bin/composer /usr/bin/composer
COPY --from=spiralscout/roadrunner:2.9.4 /usr/bin/rr /usr/bin/rr
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/bin/install-php-extensions

COPY --from=node:14-alpine /usr/lib /usr/lib
COPY --from=node:14-alpine /usr/local/share /usr/local/share
COPY --from=node:14-alpine /usr/local/lib /usr/local/lib
COPY --from=node:14-alpine /usr/local/include /usr/local/include
COPY --from=node:14-alpine /usr/local/bin /usr/local/bin

RUN apk update && apk add unzip make yarn python2 g++

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
    sockets \
    xml \
    xsl \
    zip

RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/* /usr/share/man/* /var/cache/apk/*

COPY .docker/php.ini    /usr/local/etc/php/php.ini

WORKDIR /app

EXPOSE 80

ENTRYPOINT ["/usr/bin/rr"]
CMD ["serve"]
