init:
	composer install --no-interaction --no-scripts
	bin/console sylius:install --no-interaction
	bin/console sylius:fixtures:load default --no-interaction
	yarn install --ignore-scripts && yarn add node-sass && GULP_ENV=prod yarn build
