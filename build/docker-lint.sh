#!/bin/sh
command -v docker >/dev/null 2>&1 || { echo >&2 "The script requires 'docker' but it's not installed.  Aborting."; exit 1; }

#
# Variables
#
DIR=$(dirname "$(readlink -f "$0")")
DIR_ROOT=$(dirname "$DIR")

#
# Main
#
docker run --rm \
    -v "$DIR_ROOT":/media \
    --workdir /media \
    davidhrbac/docker-shellcheck sh build/lint.sh