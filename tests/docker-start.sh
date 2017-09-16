#!/bin/sh
DIR=$(dirname "$(readlink -f "$0")")
DIR_ROOT=$(dirname "$DIR")

#
# Verification
#
command -v docker >/dev/null 2>&1 || { echo >&2 "The script requires 'docker' but it's not installed.  Aborting."; exit 1; }

#
# Main
#
docker pull jrbeverly/bats:baseimage

echo
echo "/***********************************************/"
echo "/* Please run 'sh tests/.docker/provision.sh'  */"
echo "/* before attempting to run any tests          */"
echo "/***********************************************/"
echo
docker run --rm -it \
    -v "$DIR_ROOT":/media \
    jrbeverly/bats:baseimage sh