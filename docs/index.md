# Documentation on this project.

Services in use:

* PostgreSQL/PostGIS
* Redmine
* Nginx
* Custom docker container to check for readiness
* certbot to get letsencrypt certificates

## Main Commands:

Run `make` or `make help` to get the commands.

However, basic dev commands:
* `make build`: Build the dev environment
* `make dev-up`: Bring the dev system up
* `make down`: Bring the system down
* `make clean`: Bring down the system and kill it
* `make health-dev`: Run a health check - exit with error on failure


## Service Diagram

![Service Architecture Diagram](infrastructure.png)
