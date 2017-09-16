#!/bin/bash

#
# Variables
#

#
# Pathing
# 

function get_root_dir() {
    dirname $(dirname $BATS_TEST_DIRNAME)
}

function get_test_dir() {
    echo "$BATS_TEST_DIRNAME"
}

function get_target_dir() {
    echo "$(get_test_dir)/target"
}

function get_source_dir() {
    echo "$(get_root_dir)/src"
}

function get_resource_dir() {
    echo "$(get_test_dir)/resources"
}

#
#
#

function test_setup() {
    test_path="$(get_target_dir)/${BATS_TEST_NAME}"

    mkdir -p "$test_path"
    cd "$test_path"
}

function test_teardown() {
    rm -rf "$(get_target_dir)/${BATS_TEST_NAME}"
}

function copy_resource() {
    DIR_RESOURCE=$(get_resource_dir)

    cp "$DIR_RESOURCE/$1" "$2"
}

function copy_resource_to_hook() {
    DIR_RESOURCE=$(get_resource_dir)
    HOOK_DIR="$1.d"
    
    cp "$DIR_RESOURCE/$2" "$HOOK_DIR/$2"
}

function copy_script() {
    DIR_SRC=$(get_source_dir)
    cp "$DIR_SRC/$1" "$2"
}

function touch_hook() {
    HOOK_DIR="$1.d"
    mkdir -p "$HOOK_DIR"
}

function copy_hook() {
    HOOK_DIR="$1.d"

    DIR_SRC=$(get_source_dir)
    DIR_HOOK="$DIR_SRC/$HOOK_DIR"
    
    mkdir -p "$HOOK_DIR"
    cp "$DIR_HOOK/$2.sh" "$HOOK_DIR/$2.sh"
}