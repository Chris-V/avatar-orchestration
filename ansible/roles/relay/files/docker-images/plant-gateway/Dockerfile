FROM lsiobase/alpine:3.11
LABEL maintainer="avatary"

ARG PLANT_GATEWAY_VERSION=0.7.0

RUN \
    apk add --no-cache --virtual .build_deps make gcc pkgconf glib-dev libc-dev && \
    apk add --no-cache bluez python3 && \
    python3 -m ensurepip && \
    python3 -m pip install --no-cache-dir plantgateway==${PLANT_GATEWAY_VERSION} && \
    apk del .build_deps && \
    rm -rf /root/.cache && \
    rm -rf /usr/lib/python*/ensurepip

COPY root/ /

VOLUME ["/config"]

ENTRYPOINT ["/init"]
