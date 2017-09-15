#!/bin/sh
DIR=$(dirname "$(readlink -f "$0")")

#
# Verification
#
command -v bats >/dev/null 2>&1 || { echo >&2 "The script requires 'bats' but it's not installed.  Aborting."; exit 1; }

#
# Main
#
sh "$DIR/unit/run.sh"
sh "$DIR/integration/run.sh"