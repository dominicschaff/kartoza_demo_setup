.PHONY: help ssl build run production up down clean health

get_container_id = $$(docker-compose ps -q $(1))
get_container_state = $$(echo $(call get_container_id,$(1)) | xargs -I ID docker inspect -f '{{.State.Status}}' ID)


help:
	@echo "Help on available commands:"
	@echo
	@echo "build: Build this environment"
	@echo "up: Bring the system up"
	@echo "down: Bring the system down"
	@echo "health: Run a health check - exit with error on failure"

check-env:
	@if ! [ -f nginx.env ]; then echo "Missing nginx.env"; false; fi
	@if ! grep -q SITE_HOST "nginx.env"; then echo "Missing SITE_HOST"; false; fi

build:
	docker-compose build nginx_dev

run:
	docker-compose

production: check-env
	docker-compose build nginx
	bash init-letsencrypt.sh

dev:
	docker-compose up --detach nginx_dev

down:
	docker-compose down

clean:
	docker-compose down --rmi all -v
	rm -rf data logs

health:
	@if [ "$(call get_container_state,nginx)" != "running" ] ; then echo "nginx is down" ; false ; fi
	@if [ "$(call get_container_state,db)" != "running" ] ; then echo "database is down" ; false ; fi
	@curl --silent  "https://$$(cat nginx.env | grep SITE_HOST | cut -d'=' -f2)/" > /dev/null

backup:
restore:
