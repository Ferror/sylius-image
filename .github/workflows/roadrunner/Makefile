run:
	php bin/console doctrine:database:create --if-not-exists
	php bin/console sylius:install:database --no-interaction
	php bin/console sylius:install:setup --no-interaction
	php bin/console sylius:fixtures:load default --no-interaction
	rr serve -d
