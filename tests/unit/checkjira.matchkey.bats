#!/usr/bin/env bats
load "lib/test_helper"

#
# Variables
#
ENTRYPOINT="commit-msg"
HOOK="041-checkjira.matchkey"

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

# @test "Commit has issue id" {
#     echo "Simple" > file
#     git add file && git commit -a -m "Init"

#     init_hook $ENTRYPOINT
#     copy_hook $ENTRYPOINT $HOOK
    
#     BRANCH="feature/AS-100-work-branch"
#     COMMIT="AS-100 is valid"

#     git checkout -b $BRANCH >/dev/null 2>&1
#     echo "Simple" >> file

#     run git commit -a -m "$COMMIT"
#     echo "status: $status"
#     echo "output: $output"
#     [ "$status" -eq 0 ]
# }

# @test "Commit has an issue id" {
#     echo "Simple" > file
#     git add file && git commit -a -m "Init"

#     init_hook $ENTRYPOINT
#     copy_hook $ENTRYPOINT $HOOK
    
#     BRANCH="feature/AS-100-work-branch"
#     COMMIT="AS-101 is different but valid"

#     git checkout -b $BRANCH
#     echo "Simple" >> file

#     run git commit -a -m "$COMMIT"
#     echo "status: $status"
#     echo "output: $output"
#     [ "$status" -eq 0 ]
# }

# @test "Issue ID is last but valid" {
#     echo "Simple" > file
#     git add file && git commit -a -m "Init"

#     init_hook $ENTRYPOINT
#     copy_hook $ENTRYPOINT $HOOK
    
#     BRANCH="feature/AS-100-work-branch"
#     COMMIT="A commit, but in a different spot: AS-101"

#     git checkout -b $BRANCH
#     echo "Simple" >> file

#     run git commit -a -m "$COMMIT"
#     echo "status: $status"
#     echo "output: $output"
#     [ "$status" -eq 0 ]
# }

@test "Accept as not feature branch" {
    echo "Simple" > file
    git add file && git commit -a -m "Init"

    init_hook $ENTRYPOINT
    copy_hook $ENTRYPOINT $HOOK
    
    BRANCH="AS-100-work-branch"
    COMMIT="Commit has no issue id"

    git checkout -b $BRANCH
    echo "Simple" >> file

    run git commit -a -m "$COMMIT"
    echo "status: $status"
    echo "output: $output"
    [ "$status" -eq 0 ]
}

# @test "Reject commit with no issue ID" {
#     echo "Simple" > file
#     git add file && git commit -a -m "Init"

#     init_hook $ENTRYPOINT
#     copy_hook $ENTRYPOINT $HOOK
    
#     BRANCH="feature/AS-100-work-branch"
#     COMMIT="Commit has no issue id"

#     git checkout -b $BRANCH
#     echo "Simple" >> file

#     run git commit -a -m "$COMMIT"
#     echo "status: $status"
#     echo "output: $output"
#     [ "$status" -ne 0 ]
# }

# @test "Reject commit with no key" {
#     echo "Simple" > file
#     git add file && git commit -a -m "Init"

#     init_hook $ENTRYPOINT
#     copy_hook $ENTRYPOINT $HOOK
    
#     BRANCH="feature/AS-100-work-branch"
#     COMMIT="-100 Commit has no issue id"

#     git checkout -b $BRANCH
#     echo "Simple" >> file

#     run git commit -a -m "$COMMIT"
#     echo "status: $status"
#     echo "output: $output"
#     [ "$status" -ne 0 ]
# }

# @test "Reject commit with no number" {
#     echo "Simple" > file
#     git add file && git commit -a -m "Init"

#     init_hook $ENTRYPOINT
#     copy_hook $ENTRYPOINT $HOOK
    
#     BRANCH="feature/AS-100-work-branch"
#     COMMIT="AS- Commit has no issue id"

#     git checkout -b $BRANCH
#     echo "Simple" >> file

#     run git commit -a -m "$COMMIT"
#     echo "status: $status"
#     echo "output: $output"
#     [ "$status" -ne 0 ]
# }

# @test "Reject commit with bad format" {
#     echo "Simple" > file
#     git add file && git commit -a -m "Init"

#     init_hook $ENTRYPOINT
#     copy_hook $ENTRYPOINT $HOOK
    
#     BRANCH="feature/AS-100-work-branch"
#     COMMIT="AS100 Commit has no issue id"

#     git checkout -b $BRANCH
#     echo "Simple" >> file

#     run git commit -a -m "$COMMIT"
#     echo "status: $status"
#     echo "output: $output"
#     [ "$status" -ne 0 ]
# }

# @test "Reject commit with bad separation formating" {
#     echo "Simple" > file
#     git add file && git commit -a -m "Init"

#     init_hook $ENTRYPOINT
#     copy_hook $ENTRYPOINT $HOOK
    
#     BRANCH="feature/AS-100-work-branch"
#     COMMIT="AS--100 Commit has no issue id"

#     git checkout -b $BRANCH
#     echo "Simple" >> file

#     run git commit -a -m "$COMMIT"
#     echo "status: $status"
#     echo "output: $output"
#     [ "$status" -ne 0 ]
# }

# @test "Reject commit with bad spacing" {
#     echo "Simple" > file
#     git add file && git commit -a -m "Init"

#     init_hook $ENTRYPOINT
#     copy_hook $ENTRYPOINT $HOOK
    
#     BRANCH="feature/AS-100-work-branch"
#     COMMIT="AS 100 Commit has no issue id"

#     git checkout -b $BRANCH
#     echo "Simple" >> file

#     run git commit -a -m "$COMMIT"
#     echo "status: $status"
#     echo "output: $output"
#     [ "$status" -ne 0 ]
# }