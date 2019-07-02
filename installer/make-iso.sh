#!/usr/bin/env bash

set -e -u

SOURCE_FILE="${BASH_SOURCE[0]}"
while [[ -h "$SOURCE_FILE" ]]; do # resolve $SOURCE until the file is no longer a symlink
  SOURCE_DIR="$( cd -P "$( dirname "$SOURCE_FILE" )" >/dev/null 2>&1 && pwd )"
  SOURCE_FILE="$(readlink "$SOURCE_FILE")"
  [[ ${SOURCE_FILE} != /* ]] && SOURCE_FILE="$SOURCE_DIR/$SOURCE_FILE"
done
SOURCE_DIR="$( cd -P "$( dirname "$SOURCE_FILE" )" >/dev/null 2>&1 && pwd )"

# ---

if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "root is required by archiso"
    exit 1
fi

rm -rf "${SOURCE_DIR}/build"
mkdir -p "${SOURCE_DIR}/build"

exec 1> >(tee "${SOURCE_DIR}/build/stdout.log")
exec 2> >(tee "${SOURCE_DIR}/build/stderr.log")

# ---

cp -r /usr/share/archiso/configs/releng/ "${SOURCE_DIR}/build/files"

cp -r "${SOURCE_DIR}/files/airootfs/etc/skel/" "${SOURCE_DIR}/build/files/airootfs/etc/skel/"
cat "${SOURCE_DIR}/files/packages.x86_64" >> "${SOURCE_DIR}/build/files/packages.x86_64"

echo "Time to do manual customizations."
read -n 1 -s -r -p "Press any key to continue."

"${SOURCE_DIR}/build/files/build.sh" -v \
    -N archlinux-avatar \
    -L "ARCH_AVATAR_$(date +%Y%m)" \
    -w "${SOURCE_DIR}/build/work" \
    -o "${SOURCE_DIR}/build/out"

echo
echo "ISO generated. Time to DD it"
echo "\$ dd if=$SOURCE_DIR/build/out/*.iso of=/dev/myusbdrive status=progress"
