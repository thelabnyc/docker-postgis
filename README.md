# PostgreSQL + PostGIS

This image provides tags for running Postgres with PostGIS extensions installed. It uses the Dockerfiles from the officially maintained [docker-postgis](https://github.com/postgis/docker-postgis) project. Why use this image instead of [the official image](https://hub.docker.com/r/postgis/postgis)? Docker-postgis doesn't yet build or publish images for arm64 architectures. This project builds both amd64 and arm64 images.

## Usage

Images are published to the [Gitlab Container Registry](https://gitlab.com/thelabnyc/docker-postgis/container_registry).

Each pipeline builds the newest stable PostgreSQL release with its newest stable PostGIS release. Tags take the form `<postgres>-<postgis without dots>.<pipeline number>`, for example `registry.gitlab.com/thelabnyc/docker-postgis:18-36.538` for PostgreSQL 18 + PostGIS 3.6.

Sample usage in docker-compose:

```yml
volumes:
  postgres:

services:
  db:
    image: registry.gitlab.com/thelabnyc/docker-postgis:18-36.538
    environment:
      POSTGRES_HOST_AUTH_METHOD: "trust"
    volumes:
      - postgres:/var/lib/postgresql/data
```
