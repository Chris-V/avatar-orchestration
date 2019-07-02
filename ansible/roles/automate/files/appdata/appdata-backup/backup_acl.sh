#!/bin/sh

set -e

echo "INFO: Backup appdata facl"

if ! [ -x "$(command -v /usr/bin/getfacl)" ]; then
  echo "INFO: Installing acl package"
  /sbin/apk add --quiet --no-cache acl
fi

/usr/bin/getfacl -R "$SYNC_SRC" > "$SYNC_SRC"/acl.txt

echo "INFO: ACL written to '$SYNC_SRC/acl.txt'"
