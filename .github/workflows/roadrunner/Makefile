run:
	php bin/console sylius:install:database --no-interaction
	php bin/console sylius:install:setup --no-interaction
	php bin/console sylius:fixtures:load default --no-interaction
	tail -f /dev/null
	#rr serve -d
