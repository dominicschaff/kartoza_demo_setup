.PHONY: help ssl build run production up down clean health

get_container_id = $$(docker-compose ps -q $(1))
get_container_state = $$(echo $(call get_container_id,$(1)) | xargs -I ID docker inspect -f '{{.State.Status}}' ID)


help:
	@echo "Help on available commands:"
	@echo
	@echo "build: Build the dev environment"
	@echo "dev-up: Bring the dev system up"
	@echo
	@echo "build-prod: Build the prod environment"
	@echo "prod-up: Bring the dev system up"
	@echo "production: Bring prod up from scratch"
	@echo
	@echo "down: Bring the system down"
	@echo "clean: Bring down the system and kill it"
	@echo
	@echo "backup: Backup the database"
	@echo "restore: Restore a copy of the database"
	@echo
	@echo "health: Run a health check - exit with error on failure"

check-env:
	@if ! [ -f nginx.env ]; then echo "Missing nginx.env"; false; fi
	@if ! grep -q SITE_HOST "nginx.env"; then echo "Missing SITE_HOST"; false; fi

build:
	docker-compose build nginx_dev

build-prod:
	docker-compose build nginx

run:
	docker-compose

get-cert:
	bash init-letsencrypt.sh
	chmod -R 777 data

production: check-env build-prod get-cert prod-up

dev-up:
	docker-compose up --detach nginx_dev

prod-up:
	docker-compose up --detach nginx

down:
	docker-compose down

clean:
	docker-compose down --rmi all -v
	rm -rf data logs

health:
	@if [ "$(call get_container_state,nginx)" != "running" ] ; then echo "nginx is down" ; false ; fi
	@if [ "$(call get_container_state,db)" != "running" ] ; then echo "database is down" ; false ; fi
	@if [ "$(call get_container_state,redmin)" != "running" ] ; then echo "redmin is down" ; false ; fi
	@curl --silent  "https://$$(cat nginx.env | grep SITE_HOST | cut -d'=' -f2)/" > /dev/null

backup:
	docker-compose exec db sh -c 'su - postgres -c "pg_dumpall"' | gzip -9 > latest.sql.gz

restore:
	gunzip latest.sql.gz
	mv latest.sql pg/
	docker-compose exec db sh -c 'su - postgres -c "psql -f/var/lib/postgresql/latest.sql postgres"'
