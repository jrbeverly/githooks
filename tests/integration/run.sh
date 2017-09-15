#!/bin/sh
DIR=$(dirname "$(readlink -f "$0")")

#
# Verification
#
command -v bats >/dev/null 2>&1 || { echo >&2 "The script requires 'bats' but it's not installed.  Aborting."; exit 1; }
command -v boxes >/dev/null 2>&1 || { echo >&2 "The script requires 'boxes' but it's not installed.  Aborting."; exit 1; }

#
# Main
#
echo "Running integration tests." | boxes -d peek -a c -s 40x11

for file in "$DIR/"*.bats; do
    if [ -f "$file" ]
    then
        test=$(basename "$file")
        testname="${test%.*}"

        echo
        echo
        echo "Running $testname tests." | boxes
        bats --pretty "$file"

    fi
done