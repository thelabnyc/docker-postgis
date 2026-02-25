#!/usr/bin/env bash

set -euxo pipefail

GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Get all version directories, excluding 'master' builds
VERSION_DIRS=$(ls -d build/docker-postgis/[0-9]*-[0-9]* 2>/dev/null | xargs -n1 basename)

# Extract unique PostgreSQL versions and get the last 1
PG_VERSIONS=$(echo "$VERSION_DIRS" | cut -d'-' -f1 | sort -n -u | tail -1)

# For each PG version, find its latest PostGIS version and create manifest
for PG_VERSION in $PG_VERSIONS; do
    # Find latest PostGIS for this PG version (exclude master, sort numerically)
    POSTGIS_VERSION=$(echo "$VERSION_DIRS" | grep "^${PG_VERSION}-" | cut -d'-' -f2 | sort -t. -k1,1n -k2,2n | tail -1)

    if [ -n "$POSTGIS_VERSION" ]; then
        POSTGIS_STRIPPED="${POSTGIS_VERSION//.}"
        BASE_TAG="${CI_REGISTRY_IMAGE}:${PG_VERSION}-${POSTGIS_STRIPPED}.${CI_PIPELINE_IID}"
        SOURCE_AMD64="${BASE_TAG}-amd64"
        SOURCE_ARM64="${BASE_TAG}-arm64"
        MANIFEST_TAG="${BASE_TAG}${TAG_SUFFIX}"

        echo -e "${GREEN}Creating manifest for PostgreSQL ${PG_VERSION} with PostGIS ${POSTGIS_VERSION}${NC}"
        docker buildx imagetools create \
            --tag "$MANIFEST_TAG" \
            "$SOURCE_AMD64" \
            "$SOURCE_ARM64"
    fi
done
