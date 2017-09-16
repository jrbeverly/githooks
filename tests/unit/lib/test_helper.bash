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

#
# Testing Scaffolding
#

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

#
# Testing Helpers
#

function init_hook() {
    ENTRYPOINT="$1"

    DIR_SRC=$(get_source_dir)
    DIR_HOOKS="$ENTRYPOINT.d"
    
    cp "$DIR_SRC/$ENTRYPOINT" ".git/hooks/$ENTRYPOINT"
    mkdir -p ".git/hooks/$DIR_HOOKS"    
}

function copy_hook() {
    ENTRYPOINT="$1"
    HOOK="$2"
    
    DIR_SRC=$(get_source_dir)
    DIR_HOOKS="$ENTRYPOINT.d"
    
    cp "$DIR_SRC/$DIR_HOOKS/$HOOK.sh" ".git/hooks/$DIR_HOOKS/$HOOK.sh"
}