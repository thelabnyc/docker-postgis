#!/usr/bin/env bash

set -e

GREEN='\033[0;32m'
NC='\033[0m' # No Color

PLATFORMS="linux/arm64/v8,linux/amd64"

# Echo the a command, then run it. Useful for debugging CI to see what command
# is causing what output.
echoAndRun () {
    echo -e "${GREEN}$*${NC}"
    "$@"
}

buildAndPush () {
    POSTGRES_VERSION="$1"
    POSTGIS_VERSION="$2"
    echoAndRun pushd "docker-postgis/${POSTGRES_VERSION}-${POSTGIS_VERSION}/"
    echoAndRun docker buildx build \
        --platform "$PLATFORMS" \
        --pull \
        --tag "${CI_REGISTRY_IMAGE:-postgis}:${POSTGRES_VERSION}-${POSTGIS_VERSION}" \
        $EXTRA_BUILD_ARGS \
        .
    echoAndRun popd
}

# Create a buildx instance if one doesn't already exist
if [ "$(docker buildx ls | grep docker-container  | wc -l)" -le "0" ]; then
    docker context create buildx-build;
    docker buildx create --use buildx-build;
fi

# Clone the docker-postgis repo
echoAndRun mkdir -p build
echoAndRun pushd build
echoAndRun git clone "https://github.com/postgis/docker-postgis.git"

# Postgres 14
buildAndPush "14" "3.4"

# Postgres 15
buildAndPush "15" "3.4"

# Postgres 16
buildAndPush "16" "3.4"
buildAndPush "16" "3.5"

# Postgres 17
buildAndPush "17" "3.5"

popd
echoAndRun rm -rf build
