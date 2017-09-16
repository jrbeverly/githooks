#!/bin/bash

#
# Testing Scaffolding
#

function test_prepare() {
    test_path="$(get_target_dir)/${BATS_TEST_NAME}"

    mkdir -p "$test_path"
    cd "$test_path"

    git_init
}

function test_cleanup() {
    rm -rf "$(get_target_dir)/${BATS_TEST_NAME}"
}
