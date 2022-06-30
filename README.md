# PostgreSQL + PostGIS

This image provides tags for running Postgres with PostGIS extensions installed. It uses the Dockerfiles from the officially maintained [docker-postgis](https://github.com/postgis/docker-postgis/blob/master/12-3.2/Dockerfile) project. Why use this image instead of [the official image](https://hub.docker.com/r/postgis/postgis)? Docker-postgis doesn't yet build or publish images for arm64 architectures. This project builds both amd64 and arm64 images.

## Usage

Images are published to the [Gitlab Container Registry](https://gitlab.com/thelabnyc/docker-postgis/container_registry).

Images:

- PostgreSQL 12 + PostGIS 3.2: `registry.gitlab.com/thelabnyc/docker-postgis:12-3.2`
- PostgreSQL 13 + PostGIS 3.2: `registry.gitlab.com/thelabnyc/docker-postgis:13-3.2`
- PostgreSQL 14 + PostGIS 3.2: `registry.gitlab.com/thelabnyc/docker-postgis:14-3.2`

Sample usage in docker-compose:

```yml
version: "3.8"

volumes:
  postgres:

services:
  db:
    image: registry.gitlab.com/thelabnyc/docker-postgis:13-3.2
    environment:
      POSTGRES_HOST_AUTH_METHOD: "trust"
    volumes:
      - postgres:/var/lib/postgresql/data
```
