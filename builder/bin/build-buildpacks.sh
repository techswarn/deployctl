#!/bin/bash

set -e
set -x
echo $(cut -d: -f1 /etc/passwd)

#chown -R appship:appship /workspace
#su - appship
echo "----------DEBUGING------------- "\n
DIR=$(pwd)
echo ${DIR}

echo "${CNB_APP_DIR}"
echo "----------DEBUGING------------- "\n
cd /layers

/cnb/lifecycle/detector
# skipping the restorer for now since we are not doing any caching at the moment
# /cnb/lifecycle/restorer
/cnb/lifecycle/analyzer $APP_IMAGE_URL
/cnb/lifecycle/builder
/cnb/lifecycle/exporter $APP_IMAGE_URL
# skipping the cacher for now since we are not doing any caching at the moment
# /cnb/lifecycle/cacher