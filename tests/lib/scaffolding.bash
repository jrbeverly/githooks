#!/bin/bash

#
# Testing Scaffolding
#

function test_setup() {
    test_path="$(get_target_dir)/${BATS_TEST_NAME}"
    rm -rf "$test_path"

    mkdir -p "$test_path"
    cd "$test_path"

    git_init
}

function test_teardown() {
    rm -rf "$(get_target_dir)/${BATS_TEST_NAME}"
}