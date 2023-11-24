FROM bfren/alpine-s6:alpine3.15-5.0.1

LABEL org.opencontainers.image.source="https://github.com/bfren/docker-redis"

ARG BF_IMAGE
ARG BF_VERSION

EXPOSE 6379

COPY ./overlay /
COPY ./6/overlay /

ENV \
    # see https://redis.io/topics/persistence
    BF_REDIS_APPEND_ONLY=no \
    # see http://antirez.com/post/redis-persistence-demystified.html
    BF_REDIS_APPEND_FSYNC=everysec \
    # leave this blank to bind Redis to all network interfaces - only do
    # this if you are using Redis within a private Docker network
    BF_REDIS_BIND= \
    # log level: debug, verbose, notice, warning
    BF_REDIS_LOG_LEVEL=notice \
    # the maximum number of clients this instance can serve
    BF_REDIS_MAX_CLIENTS=10000 \
    # if set, you will be required to use AUTH when accessing this instance
    BF_REDIS_PASS= \
    # change this to 'yes' if you are exposing Redis to the internet,
    # and set REDIS_BIND to the server IP (you should not normally do this!)
    BF_REDIS_PROTECTED_MODE=no

RUN bf-install

VOLUME [ "/data" ]
