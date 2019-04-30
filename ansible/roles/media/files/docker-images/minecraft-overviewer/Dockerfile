FROM mide/minecraft-overviewer

ARG PUID=1000
ARG PGID=1000

USER root

RUN \
    # {{ system_appdata_gid }}
    groupmod -g ${PGID} minecraft && \
    # {{ system_appdata_uid }}
    usermod -g ${PGID} -u ${PUID} minecraft

USER minecraft
