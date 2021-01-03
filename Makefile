.PHONY: help build run production up down clean

help:

build:
	docker-compose pull

run:
	docker-compose

production:

up:
	docker-compose up nginx

down:
	docker-compose down

clean:
	docker-compose down --rmi all -v

