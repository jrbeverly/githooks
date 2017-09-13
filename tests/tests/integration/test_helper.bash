#!/bin/bash

#
# Pathing
# 

function get_root_dir() {
    dirname $(dirname $(dirname $BATS_TEST_DIRNAME))
}

function get_test_dir() {
    echo "$(dirname $(dirname $BATS_TEST_DIRNAME))"
}

function get_target_dir() {
    echo "$(get_test_dir)/target"
}

function get_source_dir() {
    echo "$(get_root_dir)/src"
}

#
#
#

function new_uuid() {
    cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 8 | head -n 1
}

function create_test() {
    test_uuid=$(new_uuid)
    test_path="$(get_target_dir)/$test_uuid"

    mkdir -p "$test_path"
    cd "$test_path"
}

function clean() {
    rm -rf "$(get_target_dir)/*"
}

function copy_script() {
    DIR_SRC=$(get_source_dir)
    cp "$DIR_SRC/$1" "$2"
}