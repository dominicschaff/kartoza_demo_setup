.PHONY: help build run production up down clean health

get_container_id = $$(docker-compose ps -q $(1))
get_container_state = $$(echo $(call get_container_id,$(1)) | xargs -I ID docker inspect -f '{{.State.Status}}' ID)


help:

build:
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
