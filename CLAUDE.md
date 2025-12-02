# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This repository builds multi-architecture (amd64 + arm64) PostgreSQL + PostGIS Docker images. It wraps the official [docker-postgis](https://github.com/postgis/docker-postgis) project to provide arm64 support not yet available in official images.

Images are published to GitLab Container Registry at `registry.gitlab.com/thelabnyc/docker-postgis`.

## Repository Structure

- `build/docker-postgis/` - Git submodule containing upstream docker-postgis Dockerfiles
- `bin/build.sh` - Main build script that builds and pushes multi-arch images
- `.gitlab-ci.yml` - CI pipeline configuration

## Build Commands

Build locally (requires Docker buildx):
```bash
./bin/build.sh
```

The build script:
1. Creates a buildx instance if needed
2. Builds images for `linux/arm64/v8,linux/amd64` platforms
3. Uses Dockerfiles from `build/docker-postgis/{PG_VERSION}-{POSTGIS_VERSION}/`

## CI/CD

GitLab CI builds and pushes images on:
- Merge requests (tagged with `-mr{MR_IID}` suffix)
- Default branch merges (no suffix)

Image tag format: `{POSTGRES_VERSION}-{POSTGIS_VERSION}.{PIPELINE_IID}{TAG_SUFFIX}`

## Adding New PostgreSQL/PostGIS Versions

1. Update the `build/docker-postgis` submodule if needed
2. Add new `buildAndPush` calls in `bin/build.sh`
3. Update README.md with new image tags
