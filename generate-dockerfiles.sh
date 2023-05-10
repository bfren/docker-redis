#!/bin/bash

set -euo pipefail

docker pull bfren/alpine

BASE_REVISION="4.5.0"
echo "Base: ${BASE_REVISION}"

REDIS_VERSIONS="6 7"
for V in ${REDIS_VERSIONS} ; do

    echo "Redis ${V}"
    ALPINE_MINOR=`cat ./${V}/ALPINE_MINOR`

    DOCKERFILE=$(docker run \
        -v ${PWD}:/ws \
        -e BF_DEBUG=0 \
        bfren/alpine esh \
        "/ws/Dockerfile.esh" \
        ALPINE_MINOR=${ALPINE_MINOR} \
        BASE_REVISION=${BASE_REVISION} \
        REDIS_MAJOR=${V}
    )

    echo "${DOCKERFILE}" > ./${V}/Dockerfile

done

docker system prune -f
echo "Done."
