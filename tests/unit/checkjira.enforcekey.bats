#!/usr/bin/env bats
load "../lib/filesystem"
load "../lib/git"
load "../lib/scaffolding"
load "lib/unit"

#
# Variables
#
TEST_ENTRYPOINT="commit-msg"
TEST_HOOK="040-checkjira.enforcekey"
TEST_CONFIG_HOOK="checkjira.enforcekey.enabled"

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

@test "Hook is disabled" {
    init_commit

    copy_entry $TEST_ENTRYPOINT
    copy_hook $TEST_ENTRYPOINT $TEST_HOOK

    BRANCH="feature/AS-100-work-branch"
    COMMIT="Commit has no issue id"

    git config --add "$TEST_CONFIG_HOOK" false
    git checkout -b $BRANCH > /dev/null 2>&1
    echo "Simple" >> file

    run git commit -a -m "$COMMIT"
    echo "status: $status"
    echo "output: $output"
    echo "configuration: " $(git config "$TEST_CONFIG_HOOK")
    [ "$status" -eq 0 ]
}

@test "Hook is enabled, and commit is rejected" {
    init_commit

    copy_entry $TEST_ENTRYPOINT
    copy_hook $TEST_ENTRYPOINT $TEST_HOOK

    BRANCH="feature/AS-100-work-branch"
    COMMIT="Commit has no issue id"

    git config --add "$TEST_CONFIG_HOOK" true
    git checkout -b $BRANCH > /dev/null 2>&1
    echo "Simple" >> file

    run git commit -a -m "$COMMIT"
    echo "status: $status"
    echo "output: $output"
    echo "configuration: " $(git config "$TEST_CONFIG_HOOK")
    [ "$status" -ne 0 ]
}

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

@test "Commit is missing exact issue id" {
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
    [ "$status" -ne 0 ]
}

@test "Issue ID is last but valid" {
    init_commit

    copy_entry $TEST_ENTRYPOINT
    copy_hook $TEST_ENTRYPOINT $TEST_HOOK

    BRANCH="feature/AS-100-work-branch"
    COMMIT="A commit, but in a different spot: AS-100"

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