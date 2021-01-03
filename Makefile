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

ssl:
	mkdir -p certs
	openssl req -x509 -out certs/cert.crt -keyout certs/localhost.key \
		-newkey rsa:2048 -nodes -sha256 -days 365

build: ssl
	docker-compose pull

run:
	docker-compose

production:

up:
	docker-compose up --detach

down:
	docker-compose down

clean:
	docker-compose down --rmi all -v

health:
	@if [ "$(call get_container_state,nginx)" != "running" ] ; then echo "nginx is down" ; false ; fi
	@if [ "$(call get_container_state,db)" != "running" ] ; then echo "database is down" ; false ; fi
	@if [ "$(call get_container_state,geoserver)" != "running" ] ; then echo "geoserver is down" ; false ; fi

backup:
restore:
