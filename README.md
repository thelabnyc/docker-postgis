# PostgreSQL + PostGIS

This image provides tags for running Postgres with PostGIS extensions installed. It uses the Dockerfiles from the officially maintained [docker-postgis](https://github.com/postgis/docker-postgis/blob/master/15-3.3/Dockerfile) project. Why use this image instead of [the official image](https://hub.docker.com/r/postgis/postgis)? Docker-postgis doesn't yet build or publish images for arm64 architectures. This project builds both amd64 and arm64 images.

## Usage

Images are published to the [Gitlab Container Registry](https://gitlab.com/thelabnyc/docker-postgis/container_registry).

Images:

- PostgreSQL 13 + PostGIS 3.4: `registry.gitlab.com/thelabnyc/docker-postgis:13-3.4`
- PostgreSQL 14 + PostGIS 3.4: `registry.gitlab.com/thelabnyc/docker-postgis:14-3.4`
- PostgreSQL 15 + PostGIS 3.4: `registry.gitlab.com/thelabnyc/docker-postgis:15-3.4`
- PostgreSQL 16 + PostGIS 3.4: `registry.gitlab.com/thelabnyc/docker-postgis:16-3.4`

Sample usage in docker-compose:

```yml
volumes:
  postgres:

services:
  db:
    image: registry.gitlab.com/thelabnyc/docker-postgis:16-3.4
    environment:
      POSTGRES_HOST_AUTH_METHOD: "trust"
    volumes:
      - postgres:/var/lib/postgresql/data
```
