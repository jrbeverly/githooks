#!/usr/bin/env bats
load "lib/test_helper"

#
# Variables
#
TEST_ENTRYPOINT="commit-msg"
TEST_HOOK="031-extendjira.ref"
TEST_CONFIG_HOOK="extendjira.refkey"

#
# Setup/Teardown
#
function setup() {
    test_setup
}

function teardown() {
    test_teardown
}

#
# Tests
#

@test "Replace using default constant" {
    init_commit

    copy_entry $TEST_ENTRYPOINT
    copy_hook $TEST_ENTRYPOINT $TEST_HOOK

    BRANCH="feature/AS-100-work-branch"
    COMMIT="## Commit has no issue id"

    git checkout -b $BRANCH > /dev/null 2>&1
    echo "Simple" >> file

    git commit -a -m "$COMMIT"

    run git log -1 --pretty=%B
    echo "status: $status"
    echo "output: $output"
    [ "$status" -eq 0 ]
    [[ "$output" == "[AS-100] Commit has no issue id" ]]
}


@test "Replace using custom constant" {
    init_commit

    copy_entry $TEST_ENTRYPOINT
    copy_hook $TEST_ENTRYPOINT $TEST_HOOK

    BRANCH="feature/AS-100-work-branch"
    COMMIT="!!!! Commit has no issue id"

    git config --add "$TEST_CONFIG_HOOK" "!!!!"
    git checkout -b $BRANCH > /dev/null 2>&1
    echo "Simple" >> file

    git commit -a -m "$COMMIT"

    run git log -1 --pretty=%B
    echo "status: $status"
    echo "output: $output"
    [ "$status" -eq 0 ]
    [[ "$output" == "[AS-100] Commit has no issue id" ]]
}

@test "Branch is not feature" {
    init_commit

    copy_entry $TEST_ENTRYPOINT
    copy_hook $TEST_ENTRYPOINT $TEST_HOOK

    BRANCH="AS-100-work-branch"
    COMMIT="#! Commit has no issue id"

    git checkout -b $BRANCH > /dev/null 2>&1
    echo "Simple" >> file

    git commit -a -m "$COMMIT"

    run git log -1 --pretty=%B
    echo "status: $status"
    echo "output: $output"
    [ "$status" -eq 0 ]
    [[ "$output" == $COMMIT ]]
}

@test "Custom constant while using default constant" {
    init_commit

    copy_entry $TEST_ENTRYPOINT
    copy_hook $TEST_ENTRYPOINT $TEST_HOOK

    BRANCH="feature/AS-100-work-branch"
    COMMIT="#! Commit has no issue id"

    git config --add "$TEST_CONFIG_HOOK" "!!!!"
    git checkout -b $BRANCH > /dev/null 2>&1
    echo "Simple" >> file

    git commit -a -m "$COMMIT"

    run git log -1 --pretty=%B
    echo "status: $status"
    echo "output: $output"
    [ "$status" -eq 0 ]
    [[ "$output" == $COMMIT ]]
}

@test "Commit has nothing to replace" {
    init_commit

    copy_entry $TEST_ENTRYPOINT
    copy_hook $TEST_ENTRYPOINT $TEST_HOOK

    BRANCH="feature/AS-100-work-branch"
    COMMIT="Commit has no issue id"

    git config --add "$TEST_CONFIG_HOOK" "!!!!"
    git checkout -b $BRANCH > /dev/null 2>&1
    echo "Simple" >> file

    git commit -a -m "$COMMIT"

    run git log -1 --pretty=%B
    echo "status: $status"
    echo "output: $output"
    [ "$status" -eq 0 ]
    [[ "$output" == $COMMIT ]]
}

@test "Incorrect constant placement" {
    init_commit

    copy_entry $TEST_ENTRYPOINT
    copy_hook $TEST_ENTRYPOINT $TEST_HOOK

    BRANCH="feature/AS-100-work-branch"
    COMMIT="!##! Commit has no issue id"

    git config --add "$TEST_CONFIG_HOOK" "!#!"
    git checkout -b $BRANCH > /dev/null 2>&1
    echo "Simple" >> file

    git commit -a -m "$COMMIT"

    run git log -1 --pretty=%B
    echo "status: $status"
    echo "output: $output"
    [ "$status" -eq 0 ]
    [[ "$output" == $COMMIT ]]
}

@test "Partial constant in text" {
    init_commit

    copy_entry $TEST_ENTRYPOINT
    copy_hook $TEST_ENTRYPOINT $TEST_HOOK

    BRANCH="feature/AS-100-work-branch"
    COMMIT="#! Commit has no issue id"

    git config --add "$TEST_CONFIG_HOOK" "!#!"
    git checkout -b $BRANCH > /dev/null 2>&1
    echo "Simple" >> file

    git commit -a -m "$COMMIT"

    run git log -1 --pretty=%B
    echo "status: $status"
    echo "output: $output"
    [ "$status" -eq 0 ]
    [[ "$output" == $COMMIT ]]
}