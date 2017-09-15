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

function new_uuid() {
    cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 4 | head -n 1
}

function test_setup() {
    test_path="$(get_target_dir)/${BATS_TEST_NAME}"

    mkdir -p "$test_path"
    cd "$test_path"

    git init
    git config user.email "test@test.com"
    git config user.name "test"
}

function test_teardown() {  
    rm -rf "$(get_target_dir)/${BATS_TEST_NAME}"
}

function clean() {
    rm -rf "$(get_target_dir)/*"
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
    mkdir -p ".git/hooks/$HOOK_DIR"
}

function init_hook() {
    HOOK="$1"
    HOOK_DIR="$HOOK.d"
    DIR_SRC=$(get_source_dir)

    cp "$DIR_SRC/$HOOK" ".git/hooks/$HOOK"
    mkdir -p ".git/hooks/$HOOK_DIR"    
}

function copy_hook() {
    HOOK="$1"
    HOOK_DIR="$HOOK.d"
    DIR_SRC=$(get_source_dir)
    
    cp "$DIR_SRC/$HOOK_DIR/$2.sh" ".git/hooks/$HOOK_DIR/$2.sh"
}