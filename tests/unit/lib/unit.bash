#!/bin/bash

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

function git_quick_commit() {
    entrypoint="$1"
    hook="$2"
    branch="$3"
    commit="$4"

    copy_entrypoint $entrypoint .
    copy_hook $entrypoint $hook

    git_first_commit
    git_dummy
    git checkout -b $branch > /dev/null 2>&1

    git_mock_commit "$commit"
}