-include .env

THIS_FILE := $(lastword $(MAKEFILE_LIST))

app := $(COMPOSE_PROJECT_NAME)-php
nginx := $(COMPOSE_PROJECT_NAME)-nginx
mysql := $(COMPOSE_PROJECT_NAME)-mysql
app-npm := npm
path := /var/www/app
run := docker exec $(app)

#docker
.PHONY: init
init: build install

.PHONY: build
build:
	docker-compose -f docker-compose.yml up --build -d $(c)
	@echo "Run command: make install"
	@echo "$(APP_URL)"

.PHONY: install
install: composer-install composer-update migrate-fresh npm-install npm-update npm-build restart-worker check
	@echo "$(APP_URL)"

.PHONY: rebuild
rebuild:
	docker compose down --remove-orphans
	IMAGES=$$(docker images --filter=reference="$(COMPOSE_PROJECT_NAME)*:*" -q); \
	if [ -n "$$IMAGES" ]; then docker rmi $$IMAGES -f; else echo "No images to remove"; fi
	make build

.PHONY: rebuild-app
rebuild-app:
	docker-compose up -d --force-recreate --no-deps --build php

.PHONY: restart-worker
restart-worker:
	docker restart $(COMPOSE_PROJECT_NAME)-worker

.PHONY: up
up:
	docker-compose -f docker-compose.yml up -d $(c)
	@echo "$(APP_URL)"

.PHONY: stop
stop:
	docker-compose -f docker-compose.yml stop $(c)

.PHONY: it
it:
	docker exec -it $(to) /bin/bash

.PHONY: it-app
it-app:
	docker exec -it $(app) /bin/bash

.PHONY: it-nginx
it-nginx:
	docker exec -it $(nginx) /bin/bash

.PHONY: it-mysql
it-mysql:
	docker exec -it $(mysql) /bin/bash

.PHONY: migrate
migrate:
	$(run) php artisan migrate

.PHONY: migrate-rollback
migrate-rollback:
	$(run) php artisan migrate:rollback

.PHONY: migrate-fresh
migrate-fresh:
	$(run) php artisan migrate:fresh --seed

.PHONY: migration
migration:
	$(run) php artisan make:migration $(m)

#composer
.PHONY: composer-install
composer-install:
	$(run) composer install

.PHONY: composer-update
composer-update:
	$(run) composer update

.PHONY: composer-du
composer-du:
	$(run) composer du

#Tools
.PHONY: test
test:
	$(run) php artisan test

.PHONY: rector
rector:
	$(run) tools/rector/vendor/bin/rector process --dry-run

.PHONY: fix-rector
fix-rector:
	$(run) tools/rector/vendor/bin/rector process

.PHONY: analyse
analyse:
	$(run) php -d memory_limit=-1 tools/larastan/vendor/bin/phpstan analyse -c phpstan.neon

.PHONY: fixcs
fixcs:
	$(run) tools/php-cs-fixer/vendor/bin/php-cs-fixer fix --config=.php-cs-fixer.dist.php

.PHONY: lint
lint:
	$(run) tools/php-cs-fixer/vendor/bin/php-cs-fixer fix --config=.php-cs-fixer.dist.php --dry-run

.PHONY: check
check: rector lint analyse test

#npm
.PHONY: npm
npm:
	docker-compose run --rm --service-ports $(app-npm) $(c)

.PHONY: npm-install
npm-install:
	docker-compose run --rm --service-ports $(app-npm) install $(c)

.PHONY: npm-update
npm-update:
	docker-compose run --rm --service-ports $(app-npm) update $(c)

.PHONY: npm-build
npm-build:
	docker-compose run --rm --service-ports $(app-npm) run build $(c)

.PHONY: npm-host
npm-host:
	docker-compose run --rm --service-ports $(app-npm) run dev --host $(c)