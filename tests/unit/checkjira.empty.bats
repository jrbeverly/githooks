#!/usr/bin/env bats
load "lib/test_helper"

#
# Variables
#
TEST_ENTRYPOINT="commit-msg"
TEST_HOOK="010-checkjira.empty"

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

@test "Standard commit message" {
    init_commit

    copy_entry $TEST_ENTRYPOINT
    copy_hook $TEST_ENTRYPOINT $TEST_HOOK
    
    BRANCH="feature/AS-100-work-branch"
    COMMIT="Commit has no issue id"

    git checkout -b $BRANCH > /dev/null 2>&1
    echo "Simple" >> file

    git commit -a -m "$COMMIT"

    run git log -1 --pretty=%B
    echo "status: $status"
    echo "output: $output"
    [ "$status" -eq 0 ]
    [[ "$output" == $COMMIT ]]
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

@test "Empty commit on normal branch" {
    init_commit

    copy_entry $TEST_ENTRYPOINT
    copy_hook $TEST_ENTRYPOINT $TEST_HOOK
    
    BRANCH="AS-100-work-branch"
    COMMIT=""

    git checkout -b $BRANCH > /dev/null 2>&1
    echo "Simple" >> file

    run git commit -a -m "$COMMIT"
    echo "status: $status"
    echo "output: $output"
    [ "$status" -ne 0 ]
}

@test "Empty commit on branch" {
    init_commit

    copy_entry $TEST_ENTRYPOINT
    copy_hook $TEST_ENTRYPOINT $TEST_HOOK
    
    BRANCH="feature/AS-100-work-branch"
    COMMIT=""

    git checkout -b $BRANCH > /dev/null 2>&1
    echo "Simple" >> file

    git commit -a -m "$COMMIT"

    run git log -1 --pretty=%B
    echo "status: $status"
    echo "output: $output"
    [ "$status" -eq 0 ]
    [[ "$output" ==  "[AS-100]"* ]]
}
