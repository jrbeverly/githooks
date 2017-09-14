#!/bin/sh
DIR=$(dirname $(readlink -f "$0"))

echo "Running integration tests." | boxes -d dog

for file in "$DIR/"*.bats; do
    if [ -f "$file" ]
    then
        test=$(basename $file)
        testname="${test%.*}"

        echo
        echo
        echo "Running $testname tests." | boxes
        bats --pretty $file

    fi
done