#!/usr/bin/env bash

set -euxo pipefail

GREEN='\033[0;32m'
NC='\033[0m' # No Color

# When ARCH is set (CI), append it as a tag suffix
ARCH_SUFFIX="${ARCH:+-${ARCH}}"

buildAndPush () {
    POSTGRES_VERSION="$1"
    POSTGIS_VERSION="$2"
    TAG="${CI_REGISTRY_IMAGE:-postgis}:${POSTGRES_VERSION}-${POSTGIS_VERSION//.}.${CI_PIPELINE_IID}${TAG_SUFFIX}${ARCH_SUFFIX}"
    pushd "build/docker-postgis/${POSTGRES_VERSION}-${POSTGIS_VERSION}/"
    docker build \
        --pull \
        --tag "$TAG" \
        .
    if [ "${CI_COMMIT_BRANCH:-}" == "${CI_DEFAULT_BRANCH:-}" ]; then
        docker push "$TAG"
    fi
    popd
}

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
