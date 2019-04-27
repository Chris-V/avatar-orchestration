FROM arm64v8/alpine:3.9

RUN \
    apk add --no-cache python3 py3-psutil py3-bottle && \
    python3 -m ensurepip && \
    python3 -m pip install --no-cache-dir 'glances==3.1.0' && \
    rm -rf /root/.cache && \
    rm -rf /usr/lib/python*/ensurepip

# XMLRPC
EXPOSE 61209
# Web UI
EXPOSE 61208

ENTRYPOINT ["/usr/bin/glances"]
