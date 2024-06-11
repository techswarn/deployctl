#!/bin/bash

set -e
set -x

chown -R root:root /workspace

/kaniko/executor \
    --dockerfile=$DOCKERFILE_PATH \
    --context=dir:///workspace \
    --destination=$APP_IMAGE_URL