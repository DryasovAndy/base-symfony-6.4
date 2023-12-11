up:
	docker-compose up -d

down:
	docker-compose down

re:
	make down
	make up

build:
	docker-compose up -d --build

composer-install:
	docker-compose exec -e XDEBUG_MODE=off --user=www-data php composer install

bash:
	docker-compose exec --user=application php bash

cc:
	rm -rf app/var/cache/
	docker-compose exec -T --user=www-data php bin/console ca:cl

drop-db:
	docker-compose exec --user=www-data php bin/console doctrine:database:drop --if-exists --force

create-db:
	docker-compose exec --user=www-data php bin/console doctrine:database:create --if-not-exists

migration:
	docker-compose exec --user=www-data -T php bin/console doctrine:migrations:migrate --no-interaction

install:
	make down
	make build
	make permissions
	docker-compose exec --user=www-data php composer install
	make drop-db
	make create-db
	make -i migration
	make cc
	make database-permissions

permissions:
	sudo chmod 775 -R ./

database-permissions:
	sudo chown 1000:www-data -R ./
	sudo chown 1000:1000 -R docker/mysql_database/
	sudo chmod 777 -R docker/mysql_database/

npm-v:
	docker-compose run --rm nodejs npm -v

npm-build:
	docker-compose run --rm nodejs npm install --force
	docker-compose run --rm nodejs npm run build

npm-dev:
	docker-compose run --rm nodejs npm run dev-server

nb:
	make npm-build

prepare-test-environment:
	rm -rf var/cache/test/*
	docker-compose exec -e XDEBUG_MODE=off --user=www-data php php bin/console d:d:d --force --if-exists --env=test
	docker-compose exec -e XDEBUG_MODE=off --user=www-data php php bin/console d:d:c --env=test
	docker-compose exec -e XDEBUG_MODE=off --user=www-data php php bin/console d:s:u --force --env=test

run-tests:
	docker-compose exec -e XDEBUG_MODE=off --user=www-data php php bin/phpunit