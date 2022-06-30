# PostgreSQL + PostGIS

This image provides tags for running Postgres with PostGIS extensions installed. It uses the Dockerfiles from the officially maintained [docker-postgis][docker-postgis] project. Why use this image instead of [the official image]? Docker-postgis doesn't yet build or publish images for arm64 architectures. This project builds both amd64 and arm64 images.

[docker-postgis]: https://github.com/postgis/docker-postgis/blob/master/12-3.2/Dockerfile
[official-image]: https://hub.docker.com/r/postgis/postgis
