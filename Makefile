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

build:
	docker-compose pull
	docker-compose build

run:
	docker-compose

production:

up:
	docker-compose up --detach

up_geo:
	docker-compose up geoserver

down:
	docker-compose down

clean:
	docker-compose down --rmi all -v

health:
	@if [ "$(call get_container_state,nginx)" != "running" ] ; then echo "nginx is down" ; false ; fi
	@if [ "$(call get_container_state,db)" != "running" ] ; then echo "database is down" ; false ; fi
	@curl --silent  "https://$$(cat nginx.env | grep SITE_HOST | cut -d'=' -f2)/" > /dev/null

backup:
restore:
