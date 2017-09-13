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

@test "No hook directory" {
    copy_script $HOOK_NAME $HOOK_NAME
    
    run sh $HOOK_NAME
    echo "status: $status"
    echo "output: $output"
    [ "$status" -eq 0 ]
}

@test "Empty hook directory" {
    copy_script $HOOK_NAME $HOOK_NAME
    touch_hook $HOOK_NAME
    
    run sh $HOOK_NAME
    echo "status: $status"
    echo "output: $output"
    [ "$status" -eq 0 ]
}

@test "Simple hook" {
    copy_script $HOOK_NAME $HOOK_NAME
    touch_hook $HOOK_NAME
    copy_resource "simple.sh" "$HOOK_NAME.d/simple.sh"
    
    run sh $HOOK_NAME
    echo "status: $status"
    echo "output: $output"
    [ "$status" -eq 0 ]
}