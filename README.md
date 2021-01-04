# Demo Technical Assessment

This is a demo project with an example infrastructure. With complete documentation
that will allow anyone else to be able to go through the architecture. Links to
the documentation will be placed at the end of this file.

## Basic Requirements:

This is a demo repo with a sample setup.

This sample project needs to contain the following:

* ✓ Setup files (Makefiles, docker files, ...) to create this project : `Makefile`|`docker-compose.yml`
* ✓ Simple setup script, to build, and run : `make build`
* ✓ Should contain help files (or help commands) : `make help` and [Help File](docs/index.md)
* ✓ Must contain a health check command : (`make health`)
* ✓ Simple architecture diagram : ([Image](docs/infrastructure.png))
* ✓ Configurable environment : use ``nginx.env``
* ✓ Must have a valid SSL certificate
* ✓ May use pre-existing applications for the backend : (Currently use redmine)

## Possible extras:

* Use a database, with backup/restore functionality
* Application should be able to be horizontally scalable
* ✓ Should preferably use docker
* Use a local name resolver (custom web URL to main container)
* Should have multiple service applications

## Documentation

Documentation for this repo can be found at: [Update docs](docs/index.md)

