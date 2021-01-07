.PHONY: help ssl build run production up down clean health db-backup db-restore

get_container_id = $$(docker-compose ps -q $(1))
get_container_state = $$(echo $(call get_container_id,$(1)) | xargs -I ID docker inspect -f '{{.State.Status}}' ID)


help: ## Get help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

check-env:
	@if ! [ -f nginx.env ]; then echo "Missing nginx.env"; false; fi
	@if ! grep -q SITE_HOST "nginx.env"; then echo "Missing SITE_HOST"; false; fi

build: ## Build develop instance
	docker-compose build nginx_dev

build-prod: ## Build the prod environment
	docker-compose build nginx

get-cert:
	bash init-letsencrypt.sh
	chmod -R 777 data

production: check-env build-prod get-cert prod-up ## Run the production environment (Includes building)

up: dev-up ## Bring dev up
dev-up: ## Bring dev up
	docker-compose up --detach nginx_dev

prod-up: ## Bring production up
	docker-compose up --detach nginx

down: ## Take everything down
	docker-compose down

clean: ## Take everything down and clean
	docker-compose down --rmi all -v
	rm -rf data logs

health: ## Do health checks - exit on error
	@if [ "$(call get_container_state,nginx)" != "running" ] ; then echo "nginx is down" ; false ; fi
	@if [ "$(call get_container_state,db)" != "running" ] ; then echo "database is down" ; false ; fi
	@if [ "$(call get_container_state,redmin)" != "running" ] ; then echo "redmin is down" ; false ; fi
	@curl --silent  "https://$$(cat nginx.env | grep SITE_HOST | cut -d'=' -f2)/" > /dev/null

health-dev: ## Run health check in dev
	@if [ "$(call get_container_state,nginx_dev)" != "running" ] ; then echo "nginx is down" ; false ; fi
	@if [ "$(call get_container_state,db)" != "running" ] ; then echo "database is down" ; false ; fi
	@if [ "$(call get_container_state,redmin)" != "running" ] ; then echo "redmin is down" ; false ; fi

db-backup: ## do a backup
	docker-compose exec db sh -c 'su - postgres -c "pg_dumpall"' | gzip -9 > latest.sql.gz

db-restore: ## do a restore
	gunzip latest.sql.gz
	mv latest.sql pg/
	docker-compose exec db sh -c 'su - postgres -c "psql -f/var/lib/postgresql/latest.sql postgres"'
