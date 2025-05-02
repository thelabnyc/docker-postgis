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

# Postgres 16
buildAndPush "16" "3.5"

# Postgres 17
buildAndPush "17" "3.5"
