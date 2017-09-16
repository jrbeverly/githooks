#!/usr/bin/env bats
load "lib/test_helper"

#
# Variables
#
TEST_ENTRYPOINT="commit-msg"
TEST_HOOK="041-checkjira.matchkey"

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

@test "Commit has exact issue id" {
    init_commit

    copy_entry $TEST_ENTRYPOINT
    copy_hook $TEST_ENTRYPOINT $TEST_HOOK
    
    BRANCH="feature/AS-100-work-branch"
    COMMIT="AS-100 is valid"

    git checkout -b $BRANCH >/dev/null 2>&1
    echo "Simple" >> file

    run git commit -a -m "$COMMIT"
    echo "status: $status"
    echo "output: $output"
    [ "$status" -eq 0 ]
}

@test "Commit has an issue id" {
    init_commit

    copy_entry $TEST_ENTRYPOINT
    copy_hook $TEST_ENTRYPOINT $TEST_HOOK
    
    BRANCH="feature/AS-100-work-branch"
    COMMIT="AS-101 is different but valid"

    git checkout -b $BRANCH
    echo "Simple" >> file

    run git commit -a -m "$COMMIT"
    echo "status: $status"
    echo "output: $output"
    [ "$status" -eq 0 ]
}

@test "Issue ID is last but valid" {
    init_commit

    copy_entry $TEST_ENTRYPOINT
    copy_hook $TEST_ENTRYPOINT $TEST_HOOK
    
    BRANCH="feature/AS-100-work-branch"
    COMMIT="A commit, but in a different spot: AS-101"

    git checkout -b $BRANCH
    echo "Simple" >> file

    run git commit -a -m "$COMMIT"
    echo "status: $status"
    echo "output: $output"
    [ "$status" -eq 0 ]
}

@test "Branch is not feature" {
    init_commit

    copy_entry $TEST_ENTRYPOINT
    copy_hook $TEST_ENTRYPOINT $TEST_HOOK
    
    BRANCH="AS-100-work-branch"
    COMMIT="Commit has no issue id"

    git checkout -b $BRANCH
    echo "Simple" >> file

    run git commit -a -m "$COMMIT"
    echo "status: $status"
    echo "output: $output"
    [ "$status" -eq 0 ]
}

@test "Reject commit with no issue ID" {
    init_commit

    copy_entry $TEST_ENTRYPOINT
    copy_hook $TEST_ENTRYPOINT $TEST_HOOK
    
    BRANCH="feature/AS-100-work-branch"
    COMMIT="Commit has no issue id"

    git checkout -b $BRANCH > /dev/null 2>&1
    echo "Simple" >> file

    run git commit -a -m "$COMMIT"
    echo "status: $status"
    echo "output: $output"
    [ "$status" -ne 0 ]
}

@test "Reject commit with no key" {
    init_commit

    copy_entry $TEST_ENTRYPOINT
    copy_hook $TEST_ENTRYPOINT $TEST_HOOK
    
    BRANCH="feature/AS-100-work-branch"
    COMMIT="-100 Commit has no issue id"

    git checkout -b $BRANCH
    echo "Simple" >> file

    run git commit -a -m "$COMMIT"
    echo "status: $status"
    echo "output: $output"
    [ "$status" -ne 0 ]
}

@test "Reject commit with no number" {
    init_commit

    copy_entry $TEST_ENTRYPOINT
    copy_hook $TEST_ENTRYPOINT $TEST_HOOK
    
    BRANCH="feature/AS-100-work-branch"
    COMMIT="AS- Commit has no issue id"

    git checkout -b $BRANCH
    echo "Simple" >> file

    run git commit -a -m "$COMMIT"
    echo "status: $status"
    echo "output: $output"
    [ "$status" -ne 0 ]
}

@test "Reject commit with bad format" {
    init_commit

    copy_entry $TEST_ENTRYPOINT
    copy_hook $TEST_ENTRYPOINT $TEST_HOOK
    
    BRANCH="feature/AS-100-work-branch"
    COMMIT="AS100 Commit has no issue id"

    git checkout -b $BRANCH
    echo "Simple" >> file

    run git commit -a -m "$COMMIT"
    echo "status: $status"
    echo "output: $output"
    [ "$status" -ne 0 ]
}

@test "Reject commit with bad separation formating" {
    init_commit

    copy_entry $TEST_ENTRYPOINT
    copy_hook $TEST_ENTRYPOINT $TEST_HOOK
    
    BRANCH="feature/AS-100-work-branch"
    COMMIT="AS--100 Commit has no issue id"

    git checkout -b $BRANCH
    echo "Simple" >> file

    run git commit -a -m "$COMMIT"
    echo "status: $status"
    echo "output: $output"
    [ "$status" -ne 0 ]
}

@test "Reject commit with bad spacing" {
    init_commit

    copy_entry $TEST_ENTRYPOINT
    copy_hook $TEST_ENTRYPOINT $TEST_HOOK
    
    BRANCH="feature/AS-100-work-branch"
    COMMIT="AS 100 Commit has no issue id"

    git checkout -b $BRANCH
    echo "Simple" >> file

    run git commit -a -m "$COMMIT"
    echo "status: $status"
    echo "output: $output"
    [ "$status" -ne 0 ]
}