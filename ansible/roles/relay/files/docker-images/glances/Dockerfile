FROM arm64v8/alpine:3.9
LABEL maintainer="avatary"

ARG GLANCES_VERSION=3.1.0-r1
RUN apk add --no-cache glances=${GLANCES_VERSION}

# XMLRPC
EXPOSE 61209
# Web UI
EXPOSE 61208

ENTRYPOINT ["/usr/bin/glances"]
