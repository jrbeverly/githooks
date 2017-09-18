#!/bin/sh
command -v bats >/dev/null 2>&1 || { echo >&2 "The script requires 'bats' but it's not installed.  Aborting."; exit 1; }
command -v git >/dev/null 2>&1 || { echo >&2 "The script requires 'bats' but it's not installed.  Aborting."; exit 1; }

#
# Variables
#
DIR=$(dirname "$(readlink -f "$0")")

#
# Main
#
sh "$DIR/entrypoint/run.sh"
echo
echo

sh "$DIR/unit/run.sh"
echo
echo

sh "$DIR/integration/run.sh"