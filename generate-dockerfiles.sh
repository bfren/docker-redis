#!/bin/bash

set -euo pipefail

docker pull bfren/alpine

BASE_VERSION="5.0.0"
echo "Base: ${BASE_VERSION}"

REDIS_VERSIONS="6 7"
for V in ${REDIS_VERSIONS} ; do

    echo "Redis ${V}"
    ALPINE_MINOR=`cat ./${V}/ALPINE_MINOR`

    DOCKERFILE=$(docker run \
        -v ${PWD}:/ws \
        -e BF_DEBUG=0 \
        bfren/alpine esh \
        "/ws/Dockerfile.esh" \
        ALPINE_EDITION=${ALPINE_MINOR} \
        BASE_VERSION=${BASE_VERSION} \
        REDIS_MAJOR=${V}
    )

    echo "${DOCKERFILE}" > ./${V}/Dockerfile

done

docker system prune -f
echo "Done."
