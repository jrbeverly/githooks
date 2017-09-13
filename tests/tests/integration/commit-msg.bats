#!/usr/bin/env bats
load "test_helper"

#
# Variables
#
HOOK_NAME="commit-msg"

#
# Tests
#

@test "No hooks in directory" {
    create_test 
    copy_script $HOOK_NAME $HOOK_NAME
    
    run sh $HOOK_NAME
    echo "status: $status"
    echo "output: $output"
    [ "$status" -eq 0 ]
}