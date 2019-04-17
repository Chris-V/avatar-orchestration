# Source: https://github.com/eyJhb/docker-images/blob/master/backup-rotate/
# Forked to use lsiobase/alpine as a base image (coherent w/ my other images)

FROM lsiobase/alpine:3.9

ENV APP_VERSION 6.0

RUN \
    apk add --no-cache docker python3 rsyslog tar && \
    python3 -m ensurepip && \
    python3 -m pip install --no-cache-dir rotate-backups==$APP_VERSION && \
    rm -rf /root/.cache && \
    rm -rf /usr/lib/python*/ensurepip

COPY root/ /

HEALTHCHECK --interval=90s --timeout=10s --retries=3 \
    CMD /bin/sh /healthcheck.sh

VOLUME ["/config"]

ENTRYPOINT ["/init"]
