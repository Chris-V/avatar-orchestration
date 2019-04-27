FROM lsiobase/alpine:3.9

RUN \
    apk add --no-cache bluez python3 make gcc pkgconf glib-dev libc-dev && \
    python3 -m ensurepip && \
    python3 -m pip install --no-cache-dir 'plantgateway==0.5.1' && \
    apk del --no-cache make gcc pkgconf glib-dev libc-dev && \
    rm -rf /root/.cache && \
    rm -rf /usr/lib/python*/ensurepip

COPY root/ /

VOLUME ["/config"]

ENTRYPOINT ["/init"]
