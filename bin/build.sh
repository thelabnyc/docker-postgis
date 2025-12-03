#!/usr/bin/env bash

set -euxo pipefail

GREEN='\033[0;32m'
NC='\033[0m' # No Color

PLATFORMS="linux/arm64/v8,linux/amd64"

buildAndPush () {
    POSTGRES_VERSION="$1"
    POSTGIS_VERSION="$2"
    pushd "build/docker-postgis/${POSTGRES_VERSION}-${POSTGIS_VERSION}/"
    docker buildx build \
        --platform "$PLATFORMS" \
        --pull \
        --tag "${CI_REGISTRY_IMAGE:-postgis}:${POSTGRES_VERSION}-${POSTGIS_VERSION//.}.${CI_PIPELINE_IID}${TAG_SUFFIX}" \
        ${EXTRA_BUILD_ARGS:-} \
        .
    popd
}

# Create a buildx instance if one doesn't already exist
if [ "$(docker buildx ls | grep docker-container  | wc -l)" -le "0" ]; then
    docker context create buildx-build;
    docker buildx create --use buildx-build;
fi

# Get all version directories, excluding 'master' builds
VERSION_DIRS=$(ls -d build/docker-postgis/[0-9]*-[0-9]* 2>/dev/null | xargs -n1 basename)

# Extract unique PostgreSQL versions and get the last 1
PG_VERSIONS=$(echo "$VERSION_DIRS" | cut -d'-' -f1 | sort -n -u | tail -1)

# For each PG version, find its latest PostGIS version and build
for PG_VERSION in $PG_VERSIONS; do
    # Find latest PostGIS for this PG version (exclude master, sort numerically)
    POSTGIS_VERSION=$(echo "$VERSION_DIRS" | grep "^${PG_VERSION}-" | cut -d'-' -f2 | sort -t. -k1,1n -k2,2n | tail -1)

    if [ -n "$POSTGIS_VERSION" ]; then
        echo -e "${GREEN}Building PostgreSQL ${PG_VERSION} with PostGIS ${POSTGIS_VERSION}${NC}"
        buildAndPush "$PG_VERSION" "$POSTGIS_VERSION"
    fi
done
