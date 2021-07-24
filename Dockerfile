FROM redis:6.2.5-alpine3.14

RUN apk -U upgrade \
    && rm -rf /var/cache/apk/*

COPY ./overlay /

RUN chmod +x /usr/local/bin/healthcheck
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=5 CMD [ "healthcheck" ]
