#!/bin/sh
DIR=$(dirname "$(readlink -f "$0")")

#
# Verification
#
command -v bats >/dev/null 2>&1 || { echo >&2 "The script requires 'bats' but it's not installed.  Aborting."; exit 1; }
command -v git >/dev/null 2>&1 || { echo >&2 "The script requires 'git' but it's not installed.  Aborting."; exit 1; }

#
# Main
#
echo "/*       _\|/_"
echo "         (o o)"
echo " +----oOO-{_}-OOo----------------------+"
echo " |                                     |"
echo " |                                     |"
echo " |                                     |"
echo " |        Running unit tests.          |"
echo " |                                     |"
echo " |                                     |"
echo " |                                     |"
echo " +------------------------------------*/"

for file in "$DIR/"*.bats; do
    if [ -f "$file" ]
    then
        test=$(basename "$file")
        testname="${test%.*}"

        echo
        echo
        echo "/********************************/"
        echo "/* Running $testname tests."
        echo "/********************************/"
        bats --pretty "$file"

    fi
done