#!/bin/sh

#
# Functions
#
create_msg() {
    echo "My_Commit_Msg"
}

#
# Variables
#
DIR=$(dirname $(readlink -f "$0"))
DIR_ROOT=$(dirname $DIR)
DIR_BIN="$DIR_ROOT/bin"
FILES="$DIR_BIN/*"

#
# Verification
#
command -v boxes >/dev/null 2>&1 || { echo >&2 "The script requires 'boxes' but it's not installed.  Aborting."; exit 1; }
command -v shellcheck >/dev/null 2>&1 || { echo >&2 "The script requires 'shellcheck' but it's not installed.  Aborting."; exit 1; }

#
# Main
#
rm -rf $DIR_BIN && mkdir -p $DIR_BIN
cp -R $DIR_ROOT/src/* $DIR_BIN/
cd $DIR_BIN/

echo "Building githooks" | boxes -d dog

for primary_hook in $FILES; do
    if [ -f "$primary_hook" ]
    then
        hookname=$(basename "$primary_hook")

        echo
        echo
        echo "Linting $hookname" | boxes
        shellcheck --shell=sh "$primary_hook" && echo "Passed: $hookname"

        if [ -d "$primary_hook.d/" ]
        then
            for hookscript in $primary_hook.d/*.sh; do
                scriptname=$(basename "$hookscript")
                shellcheck --shell=sh "$hookscript" && echo "Passed: $scriptname"
            done
        fi
    fi
done