#!/usr/bin/env bats
load "../lib/filesystem"
load "../lib/git"
load "../lib/scaffolding"
load "lib/unit"

#
# Variables
#
TEST_ENTRYPOINT="commit-msg"

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

@test "Commit with jira issue" {
    BRANCH="feature/AS-100-work-branch"
    COMMIT="AS-100 is commit"

    install_entrypoint $TEST_ENTRYPOINT .
    install_hook $TEST_ENTRYPOINT "extendjira.issue"
    install_hook $TEST_ENTRYPOINT "checkjira.enforcekey"    

    git_first_commit
    git_dummy
    git checkout -b $BRANCH > /dev/null 2>&1

    git_change
    run git commit -a -m "$COMMIT"
    echo "status: $status"
    echo "output: $output"
    [ "$status" -eq 0 ]
}

@test "Reject on bad commit" {
    BRANCH="feature/AS-100-work-branch"
    COMMIT="Missing in commit"

    install_entrypoint $TEST_ENTRYPOINT .
    install_hook $TEST_ENTRYPOINT "extendjira.issue"
    install_hook $TEST_ENTRYPOINT "checkjira.enforcekey"    

    git_first_commit
    git_dummy
    git checkout -b $BRANCH > /dev/null 2>&1

    git_change
    run git commit -a -m "$COMMIT"
    echo "status: $status"
    echo "output: $output"
    [ "$status" -ne 0 ]
}

@test "Insert issue and accept commit" {
    BRANCH="feature/AS-100-work-branch"
    COMMIT="#! in commit"

    install_entrypoint $TEST_ENTRYPOINT .
    install_hook $TEST_ENTRYPOINT "extendjira.issue"
    install_hook $TEST_ENTRYPOINT "checkjira.enforcekey"    

    git_first_commit
    git_dummy
    git checkout -b $BRANCH > /dev/null 2>&1

    git_change
    run git commit -a -m "$COMMIT"
    echo "status: $status"
    echo "output: $output"
    [ "$status" -eq 0 ]
}