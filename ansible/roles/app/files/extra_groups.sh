#!/usr/bin/with-contenv bash

# /config/custom-cont-init.d/extra_groups.sh

USER="abc"

if [ -n "${EXTRA_GID:-}" ]; then
  echo "Resolving supplementary GIDs: $EXTRA_GID"
  supplementary_groups=()

  for gid in $EXTRA_GID; do
    group="$(getent group "$gid" | cut -d: -f1 || true)"

    if [ -z "$group" ]; then
      group="$USER-$gid"
      addgroup --gid "$gid" "$group"
    fi

    supplementary_groups+=( "$group" )
  done

  echo "Appending supplementary groups:" "${supplementary_groups[@]}"
  for group in "${supplementary_groups[@]}"; do
    usermod -a -G "$group" "$USER"
  done
fi
