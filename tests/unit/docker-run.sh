#!/bin/sh
DIR=$(dirname "$(readlink -f "$0")")
DIR_TESTS=$(dirname "$DIR")
DIR_ROOT=$(dirname "$DIR_TESTS")

#
# Verification
#
command -v docker >/dev/null 2>&1 || { echo >&2 "The script requires 'docker' but it's not installed.  Aborting."; exit 1; }

#
# Main
#
docker run --rm \
    -v "$DIR_ROOT":/media \
    jrbeverly/bats:baseimage sh tests/unit/run.sh