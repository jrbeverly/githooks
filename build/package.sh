#!/bin/sh
command -v zip >/dev/null 2>&1 || { echo >&2 "The script requires 'zip' but it's not installed.  Aborting."; exit 1; }

#
# Variables
#
DIR=$(dirname "$(readlink -f "$0")")
DIR_ROOT=$(dirname "$DIR")
DIR_SRC="$DIR_ROOT/src"
DIR_BUILD="$DIR_ROOT/build"
DIR_OUT="$DIR_ROOT/out"

VERSION=$(cat "$DIR_BUILD/VERSION")
RELEASE="githooks-$VERSION.zip"

#
# Main
#
rm -rf "${DIR_OUT:?}"/*
mkdir -p "$DIR_OUT"
cd "$DIR_SRC/"

zip -r "$DIR_OUT/$RELEASE" .