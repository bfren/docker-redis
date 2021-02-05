FROM redis:6.0.10-alpine3.13

LABEL maintainer="Ben Green <ben@bcgdesign.com>" \
    org.label-schema.name="Redis" \
    org.label-schema.version="latest" \
    org.label-schema.vendor="Ben Green" \
    org.label-schema.schema-version="1.0"

RUN apk -U upgrade \
    && rm -rf /var/cache/apk/*

COPY ./overlay /

RUN chmod +x /usr/local/bin/healthcheck
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=5 CMD [ "healthcheck" ]
