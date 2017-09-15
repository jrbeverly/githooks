#!/usr/bin/env bats
load "lib/test_helper"

#
# Variables
#
HOOK_NAME="commit-msg"

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
    echo "Simple" > file
    git add file && git commit -a -m "Init"

    init_hook $HOOK_NAME
    copy_hook $HOOK_NAME "030-extendjira.issue"
    copy_hook $HOOK_NAME "040-checkjira.enforcekey"    
    
    BRANCH="feature/AS-100-work-branch"
    COMMIT="AS-100 is commit"

    git checkout -b $BRANCH
    echo "Simple" >> file

    run git commit -a -m "$COMMIT"
    echo "status: $status"
    echo "output: $output"
    [ "$status" -eq 0 ]
}

@test "Reject on bad commit" {
    echo "Simple" > file
    git add file && git commit -a -m "Init"

    init_hook $HOOK_NAME
    copy_hook $HOOK_NAME "030-extendjira.issue"
    copy_hook $HOOK_NAME "040-checkjira.enforcekey"    
    
    BRANCH="feature/AS-100-work-branch"
    COMMIT="Missing in commit"

    git checkout -b $BRANCH
    echo "Simple" >> file

    run git commit -a -m "$COMMIT"
    echo "status: $status"
    echo "output: $output"
    [ "$status" -ne 0 ]
}

@test "Reject on bad commit" {
    echo "Simple" > file
    git add file && git commit -a -m "Init"

    init_hook $HOOK_NAME
    copy_hook $HOOK_NAME "030-extendjira.issue"
    copy_hook $HOOK_NAME "040-checkjira.enforcekey"    
    
    CONSTANT="!#!"
    BRANCH="feature/AS-100-work-branch"
    COMMIT="$CONSTANT in commit"

    git config extendjira.substitution "$CONSTANT"
    git checkout -b $BRANCH
    echo "Simple" >> file

    run git commit -a -m "$COMMIT"
    echo "status: $status"
    echo "output: $output"
    [ "$status" -ne 0 ]
}