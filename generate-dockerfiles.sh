#!/bin/bash

set -euo pipefail

docker pull bfren/alpine

BASE_VERSION="5.4.2"
echo "Base: ${BASE_VERSION}"

REDIS_VERSIONS="6 7"
for V in ${REDIS_VERSIONS} ; do

    echo "Redis ${V}"
    ALPINE_EDITION=`cat ./${V}/ALPINE_EDITION`

    DOCKERFILE=$(docker run \
        -v ${PWD}:/ws \
        -e BF_DEBUG=0 \
        bfren/alpine esh \
        "/ws/Dockerfile.esh" \
        ALPINE_EDITION=${ALPINE_EDITION} \
        BASE_VERSION=${BASE_VERSION} \
        REDIS_MAJOR=${V}
    )

    echo "${DOCKERFILE}" > ./${V}/Dockerfile

done

docker system prune -f
echo "Done."
