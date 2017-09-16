#!/bin/bash

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

function copy_entrypoint() {
    entrypoint="$1"
    path="$2"

    dir_src="$(get_source_dir)"
    dir_hooks="$entrypoint.d"

    cp "$dir_src/$entrypoint" "$2"
    chmod +x "$2"
}

function copy_resource() {
    entrypoint="$1"
    resource="$2"

    dir_resource="$(get_resource_dir)"
    dir_hooks="$entrypoint.d/"

    mkdir -p "$dir_hooks"
    cp "$dir_resource/$resource" "$dir_hooks"
}