#!/usr/bin/env bash

set -euo pipefail

docker_services="deluge jackett plex radarr sonarr"
docker_stop_timeout=30

backup_src="/appdata"
backup_dir="/backups"
backup_file="${backup_dir}/$(date +%Y-%m-%dT%H:%M:%S).tar.gz"

function unpause {
    echo "Unpausing containers..."
    docker unpause ${docker_services}
}
trap unpause EXIT

echo "Pausing containers..."
docker pause ${docker_services}

sleep 10

tar \
    --gzip \
    --create \
    --verbose \
    --preserve-permissions \
    --file="${backup_file}" \
    --directory="${backup_src}/.." \
    --exclude="*.bak" \
    --exclude="*.conf~" \
    --exclude="*.db-shm" \
    --exclude="*.db-wal" \
    --exclude="*.log" \
    --exclude="*.pid" \
    --exclude="log.txt" \
    --exclude="logs.db" \
    --exclude="${backup_src}/deluge/*.state" \
    --exclude="${backup_src}/deluge/icons" \
    --exclude="${backup_src}/deluge/state" \
    --exclude="${backup_src}/jackett/Jackett/log.*" \
    --exclude="${backup_src}/sonarr/Backups" \
    --exclude="${backup_src}/sonarr/logs" \
    --exclude="${backup_src}/radarr/Backups" \
    --exclude="${backup_src}/radarr/logs" \
    --exclude="${backup_src}/plex/Library/Application Support/Plex Media Server/Cache" \
    --exclude="${backup_src}/plex/Library/Application Support/Plex Media Server/Codecs" \
    --exclude="${backup_src}/plex/Library/Application Support/Plex Media Server/Crash Reports" \
    --exclude="${backup_src}/plex/Library/Application Support/Plex Media Server/Diagnostics" \
    --exclude="${backup_src}/plex/Library/Application Support/Plex Media Server/Logs" \
    --exclude="${backup_src}/plex/Library/Application Support/Plex Media Server/Metadata" \
    --exclude="${backup_src}/plex/Library/Application Support/Plex Media Server/Media" \
    --exclude="${backup_src}/plex/Library/Application Support/Plex Media Server/Plug-in Support" \
    --exclude="${backup_src}/plex/Library/Application Support/Plex Media Server/Plug-ins" \
    "${backup_src}"

chown abc:abc "${backup_file}"
chmod 640 "${backup_file}"
