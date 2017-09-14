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
    copy_resource_to_hook $HOOK_NAME "hello.sh"
    
    run sh $HOOK_NAME
    echo "status: $status"
    echo "output: $output"
    [ "$status" -eq 0 ]
    [[ "$output" == "Hello World" ]]
}

@test "Simple hook" {
    copy_script $HOOK_NAME $HOOK_NAME
    touch_hook $HOOK_NAME
    copy_resource_to_hook $HOOK_NAME "hello.sh"
    
    run sh $HOOK_NAME
    echo "status: $status"
    echo "output: $output"
    [ "$status" -eq 0 ]
    [[ "$output" == "Hello" ]]
}

@test "Multiple hooks" {
    copy_script $HOOK_NAME $HOOK_NAME
    touch_hook $HOOK_NAME
    copy_resource_to_hook $HOOK_NAME "hello.sh"
    copy_resource_to_hook $HOOK_NAME "world.sh"
    
    run sh $HOOK_NAME
    echo "status: $status"
    echo "output: $output"
    [ "$status" -eq 0 ]
    [[ "${lines[0]}" == "Hello" ]]
    [[ "${lines[1]}" == "World" ]]
}

@test "Test parameter passing" {
    copy_script $HOOK_NAME $HOOK_NAME
    touch_hook $HOOK_NAME
    copy_resource_to_hook $HOOK_NAME "echo.sh"
    
    my_echo="ECHO ECHO ECHO"

    run sh $HOOK_NAME "$my_echo"
    echo "status: $status"
    echo "output: $output"
    [ "$status" -eq 0 ]
    [[ "$output" == "$my_echo" ]]
}

@test "Test parameter passing" {
    copy_script $HOOK_NAME $HOOK_NAME
    touch_hook $HOOK_NAME
    copy_resource_to_hook $HOOK_NAME "echo.sh"
    
    my_echo="ECHO ECHO ECHO"

    run sh $HOOK_NAME "$my_echo"
    echo "status: $status"
    echo "output: $output"
    [ "$status" -eq 0 ]
    [[ "$output" == "$my_echo" ]]
}

@test "Simple hook ordering" {
    copy_script $HOOK_NAME $HOOK_NAME
    touch_hook $HOOK_NAME
    copy_resource_to_hook $HOOK_NAME "001-script.sh"
    copy_resource_to_hook $HOOK_NAME "999-script.sh"
    
    run sh $HOOK_NAME
    echo "status: $status"
    echo "output: $output"
    [ "$status" -eq 0 ]
    [[ "${lines[0]}" == "001" ]]
    [[ "${lines[1]}" == "999" ]]
}

@test "Hook ordering" {
    copy_script $HOOK_NAME $HOOK_NAME
    touch_hook $HOOK_NAME
    copy_resource_to_hook $HOOK_NAME "001-script.sh"
    copy_resource_to_hook $HOOK_NAME "009-script.sh"
    copy_resource_to_hook $HOOK_NAME "010-script.sh"
    copy_resource_to_hook $HOOK_NAME "021-script.sh"
    copy_resource_to_hook $HOOK_NAME "999-script.sh"
    
    run sh $HOOK_NAME
    echo "status: $status"
    echo "output: $output"
    [ "$status" -eq 0 ]
    [[ "${lines[0]}" == "001" ]]
    [[ "${lines[1]}" == "009" ]]
    [[ "${lines[2]}" == "010" ]]
    [[ "${lines[3]}" == "021" ]]
    [[ "${lines[4]}" == "999" ]]
}