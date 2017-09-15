#!/bin/sh
DIR=$(dirname "$(readlink -f "$0")")

#
# Verification
#
command -v docker >/dev/null 2>&1 || { echo >&2 "The script requires 'docker' but it's not installed.  Aborting."; exit 1; }

#
# Main
#
docker run --rm \
    -v "$DIR":/my-tests \
    --workdir /my-tests \
    --entrypoint "" \
    dduportal/bats sh run.sh