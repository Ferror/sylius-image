FROM sylius-image:cache

ARG SYLIUS_VERSION=1.12

ENV APP_ENV=prod
ENV APP_DEBUG=0
ENV DATABASE_URL="mysql://root@mysql/sylius_prod"
ENV PHP_DATE_TIMEZONE="Europe/Warsaw"
ENV COMPOSER_ALLOW_SUPERUSER=1

WORKDIR /

RUN composer create-project sylius/sylius-standard app "${SYLIUS_VERSION}.x@dev" \
    --no-scripts \
    --no-progress \
    --no-interaction \
    --no-plugins \
    --no-install

WORKDIR /app/

RUN composer install --no-scripts --no-interaction --no-dev --no-progress
RUN php bin/console cache:warmup --no-debug --env=prod # --no-optional-warmers

RUN php bin/console sylius:install:check-requirements --no-interaction
RUN php bin/console sylius:install:jwt-setup --no-interaction
RUN php bin/console sylius:install:assets --no-interaction

# You shall not load fixtures and configure database here
RUN php bin/console sylius:install:database --no-interaction
RUN php bin/console sylius:install:setup --no-interaction
RUN php bin/console sylius:fixtures:load default --no-interaction

RUN mkdir -p public/media/image/
RUN chmod -R 777 var/
