#!/bin/bash

set -e
set -x

chown -R appsail:appsail /workspace
su - appsail

cd /layers

/cnb/lifecycle/detector
# skipping the restorer for now since we are not doing any caching at the moment
# /cnb/lifecycle/restorer
/cnb/lifecycle/analyzer $APP_IMAGE_URL
/cnb/lifecycle/builder
/cnb/lifecycle/exporter $APP_IMAGE_URL
# skipping the cacher for now since we are not doing any caching at the moment
# /cnb/lifecycle/cacher