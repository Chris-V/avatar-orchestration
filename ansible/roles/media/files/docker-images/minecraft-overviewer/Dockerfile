FROM mide/minecraft-overviewer:2019-05
LABEL maintainer="avatary"

ARG PUID=1000
ARG PGID=1000

USER root

RUN \
    # {{ system_appdata_gid }}
    groupmod -g ${PGID} minecraft && \
    # {{ system_appdata_uid }}
    usermod -g ${PGID} -u ${PUID} minecraft

USER minecraft
