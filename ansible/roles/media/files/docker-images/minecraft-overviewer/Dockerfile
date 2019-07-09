FROM mide/minecraft-overviewer
LABEL maintainer="avatary"

ARG PUID=1000
ARG PGID=1000

USER root

# TODO: Prefer lsio technique (set uid/gid in entrypoint)
RUN \
    groupmod -g ${PGID} minecraft && \
    usermod -g ${PGID} -u ${PUID} minecraft

USER minecraft
