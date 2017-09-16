#!/bin/sh
err=0

#
# Variables
#
DIR=$(dirname "$(readlink -f "$0")")
DIR_ROOT=$(dirname "$DIR")
DIR_BIN="$DIR_ROOT/bin"
FILES="$DIR_BIN/*"

#
# Verification
#
command -v shellcheck >/dev/null 2>&1 || { echo >&2 "The script requires 'shellcheck' but it's not installed.  Aborting."; exit 1; }

#
# Main
#
rm -rf "${DIR_BIN:?}"/* && mkdir -p "$DIR_BIN"
cp -R "$DIR_ROOT/src/"* "$DIR_BIN/"
cd "$DIR_BIN/"

echo "/*       _\|/_"
echo "         (o o)"
echo " +----oOO-{_}-OOo----------------------+"
echo " |                                     |"
echo " |                                     |"
echo " |                                     |"
echo " |          Building githooks          |"
echo " |                                     |"
echo " |                                     |"
echo " |                                     |"
echo " +------------------------------------*/"

for primary_hook in $FILES; do
    if [ -f "$primary_hook" ]
    then
        hookname=$(basename "$primary_hook")

        echo
        echo
        echo "/**********************/"
        echo "/* Linting $hookname"
        echo "/**********************/"
        shellcheck --shell=sh "$primary_hook" && echo "Passed: $hookname"
        [ $? -ne 0 ] && err=$((err+1))

        if [ -d "$primary_hook.d/" ]
        then
            for hookscript in $primary_hook.d/*.sh; do
                if [ -f "$hookscript" ]
                then
                    scriptname=$(basename "$hookscript")
                    shellcheck --shell=sh "$hookscript" && echo "Passed: $hookname/$scriptname"
                    [ $? -ne 0 ] && err=$((err+1))
                fi
            done
        fi
    fi
done

if [ $err -ne 0 ]; then
    echo
    echo "Build failed. See errors above."
else
    echo
    echo "Build passed."
fi 

exit $err