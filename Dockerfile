FROM redis:6.0.9-alpine3.12

LABEL maintainer="Ben Green <ben@bcgdesign.com>" \
  org.label-schema.name="Redis" \
  org.label-schema.version="latest" \
  org.label-schema.vendor="Ben Green" \
  org.label-schema.schema-version="1.0"

COPY ./overlay /

RUN chmod +x /usr/bin/healthcheck
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=5 CMD [ "/usr/bin/healthcheck" ]
