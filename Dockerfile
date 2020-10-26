FROM redis:alpine

LABEL maintainer="Ben Green <ben@bcgdesign.com>" \
  org.label-schema.name="Redis" \
  org.label-schema.version="latest" \
  org.label-schema.vendor="Ben Green" \
  org.label-schema.schema-version="1.0"

COPY ./overlay /

RUN /bin/bash -c 'chmod +x /usr/bin/fixpermissions' && \
  /usr/bin/fixpermissions
