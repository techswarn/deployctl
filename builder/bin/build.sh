#!/bin/bash

set -e
set -x

if [[ ! -v APP_IMAGE_URL ]]; then
    echo "APP_IMAGE_URL not defined" >&2
    exit 1
fi

DOCKERFILE_PATH=${DOCKERFILE_PATH:-Dockerfile}
export DOCKERFILE_PATH

DOCKER_CONFIG=/etc/docker
export DOCKER_CONFIG

echo "APP_IMAGE_URL: $APP_IMAGE_URL"
echo "DOCKERFILE_PATH: $DOCKERFILE_PATH"

if [[ -f "/workspace/$DOCKERFILE_PATH" ]]; then
    echo "Building image with kaniko..."
#    /bin/build-kaniko.sh
#    Temporary hack added
    /bin/build-buildpacks.sh
else
    echo "Building image with buildpacks..."
    /bin/build-buildpacks.sh
fi