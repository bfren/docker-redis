#!/bin/sh

IMAGE=`cat VERSION`
REDIS=${1:-8}

docker buildx build \
    --load \
    --no-cache \
    --progress plain \
    --build-arg BF_IMAGE=redis \
    --build-arg BF_VERSION=${IMAGE} \
    -f ${REDIS}/Dockerfile \
    -t redis${REDIS}-dev \
    . \
    && \
    docker run -it -e BF_DEBUG=1 redis${REDIS}-dev sh
