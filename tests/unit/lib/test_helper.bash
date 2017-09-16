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
# Testing Scaffolding
#

function test_setup() {
    test_path="$(get_target_dir)/${BATS_TEST_NAME}"

    mkdir -p "$test_path"
    cd "$test_path"

    git init > /dev/null 2>&1
    git config user.email "test@test.com" > /dev/null 2>&1
    git config user.name "test" > /dev/null 2>&1
}

function test_teardown() {  
    rm -rf "$(get_target_dir)/${BATS_TEST_NAME}"
}

#
# Git Helpers
#
function init_commit() {
    echo "Simple" > file
    git add file > /dev/null 2>&1
    git commit -a -m "Init" > /dev/null 2>&1
}

function dummy_commit() {
    echo "Simple" >> file
    git commit -a -m "Dummy" > /dev/null 2>&1
}

#
# Testing Helpers
#
function copy_entrypoint() {
    ENTRYPOINT="$1"

    DIR_SRC="$(get_source_dir)"
    DIR_HOOKS="$ENTRYPOINT.d"
    
    cp "$DIR_SRC/$ENTRYPOINT" ".git/hooks/$ENTRYPOINT"
    chmod +x ".git/hooks/$ENTRYPOINT" 
}

function copy_resource() {
    ENTRYPOINT="$1"
    RESOURCE="$2"
    
    DIR_RESOURCE="$(get_resource_dir)"
    DIR_HOOKS="$ENTRYPOINT.d"
    
    cp "$DIR_RESOURCE/$RESOURCE" ".git/hooks/$DIR_HOOKS/$RESOURCE"
}

function copy_script() {
    DIR_SRC=$(get_source_dir)
    cp "$DIR_SRC/$1" "$2"
}

function copy_hook() {
    ENTRYPOINT="$1"
    HOOK="$2"
    
    DIR_SRC="$(get_source_dir)"
    DIR_HOOKS="$ENTRYPOINT.d"
    
    cp "$DIR_SRC/$DIR_HOOKS/$HOOK.sh" ".git/hooks/$DIR_HOOKS/$HOOK.sh"
}


function init_hook() {
    ENTRYPOINT="$1"

    copy_entrypoint "$ENTRYPOINT"
    mkdir -p ".git/hooks/$DIR_HOOKS"    
}