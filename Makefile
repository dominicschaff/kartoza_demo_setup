.PHONY: help ssl build run production up down clean health db-backup db-restore

get_container_id = $$(docker-compose ps -q $(1))
get_container_state = $$(echo $(call get_container_id,$(1)) | xargs -I ID docker inspect -f '{{.State.Status}}' ID)


help: ## Get help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

check-env:
	@if ! [ -f nginx.env ]; then echo "Missing nginx.env"; false; fi
	@if ! grep -q SITE_HOST "nginx.env"; then echo "Missing SITE_HOST"; false; fi

build: ## Build main containers
	docker-compose pull db redmin check_db check_redmin nginx nginx_dev

up-base:
	docker-compose up --detach db
	docker-compose run check_db
	docker-compose up --detach redmin
	docker-compose run check_redmin

get-cert:
	bash init-letsencrypt.sh
	chmod -R 777 data

up: up-base ## Bring dev up
	docker-compose up --detach nginx_dev

production: check-env up-base prod-up get-cert ## Run the production environment (Includes building)

prod-up: up-base  ## Bring production up
	docker-compose up --detach nginx

down: ## Take everything down
	docker-compose down

clean: ## Take everything down and clean
	docker-compose down --rmi all -v
	rm -rf data logs redmine_datadir pg

health-base:
	@if [ "$(call get_container_state,db)" != "running" ] ; then echo "database is down" ; false ; fi
	@if [ "$(call get_container_state,redmin)" != "running" ] ; then echo "redmin is down" ; false ; fi

health: health-base ## Run health check in production
	@if [ "$(call get_container_state,nginx)" != "running" ] ; then echo "nginx is down" ; false ; fi
	@curl --silent  "https://$$(cat nginx.env | grep SITE_HOST | cut -d'=' -f2)/" > /dev/null

health-dev: health-base  ## Run health check in dev
	@if [ "$(call get_container_state,nginx_dev)" != "running" ] ; then echo "nginx is down" ; false ; fi

db-backup: ## Backup database
	docker exec demo_postgres sh -c "PGPASSWORD=docker pg_dumpall -U postgres -h localhost" | gzip -9 > latest.sql.gz

db-restore: ## Restore database
	zcat latest.sql.gz | docker exec -i demo_postgres sh -c 'PGPASSWORD=docker psql -U postgres -h localhost postgres'
