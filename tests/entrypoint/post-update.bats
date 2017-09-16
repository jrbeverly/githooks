#!/usr/bin/env bats
load "../lib/filesystem"
load "../lib/git"
load "../lib/scaffolding"
load "lib/unit"

#
# Variables
#
TEST_ENTRYPOINT="post-update"

#
# Setup/Teardown
#
function setup() {
    test_prepare
}

function teardown() {
    test_cleanup
}

#
# Tests
#

@test "No hook directory" {
    copy_entrypoint $TEST_ENTRYPOINT .

    git_first_commit
    git_dummy   

    run sh $TEST_ENTRYPOINT
    echo "status: $status"
    echo "output: $output"
    [ "$status" -eq 0 ]
}

@test "Empty hook directory" {
    copy_entrypoint $TEST_ENTRYPOINT .

    git_first_commit
    git_dummy 
    entrypoint_touch $TEST_ENTRYPOINT

    run sh $TEST_ENTRYPOINT
    echo "status: $status"
    echo "output: $output"
    [ "$status" -eq 0 ]
}

@test "Simple hook" {
    copy_entrypoint $TEST_ENTRYPOINT .
    copy_resource $TEST_ENTRYPOINT "hello.sh"

    git_first_commit
    git_dummy 

    run sh $TEST_ENTRYPOINT
    echo "status: $status"
    echo "output: $output"
    [ "$status" -eq 0 ]
    [[ "${lines[0]}" == "Hello" ]]
}

@test "Multiple hooks" {
    copy_entrypoint $TEST_ENTRYPOINT .
    copy_resource $TEST_ENTRYPOINT "hello.sh"
    copy_resource $TEST_ENTRYPOINT "world.sh"

    git_first_commit
    git_dummy 

    run sh $TEST_ENTRYPOINT
    echo "status: $status"
    echo "output: $output"
    [ "$status" -eq 0 ]
    [[ "${lines[0]}" == "Hello" ]]
    [[ "${lines[1]}" == "World" ]]
}

@test "Test parameter passing" {
    copy_entrypoint $TEST_ENTRYPOINT .
    copy_resource $TEST_ENTRYPOINT "echo.sh"

    git_first_commit
    git_dummy 

    echo="ECHO ECHO ECHO"

    run sh $TEST_ENTRYPOINT "$echo"
    echo "status: $status"
    echo "output: $output"
    [ "$status" -eq 0 ]
    [[ "${lines[0]}" == $echo ]]
}

@test "Simple hook ordering" {
    copy_entrypoint $TEST_ENTRYPOINT .
    copy_resource $TEST_ENTRYPOINT "001-script.sh"
    copy_resource $TEST_ENTRYPOINT "999-script.sh"

    git_first_commit
    git_dummy 

    run sh $TEST_ENTRYPOINT
    echo "status: $status"
    echo "output: $output"
    [ "$status" -eq 0 ]
    [[ "${lines[0]}" == "001" ]]
    [[ "${lines[1]}" == "999" ]]
}

@test "Hook ordering" {
    copy_entrypoint $TEST_ENTRYPOINT .
    copy_resource $TEST_ENTRYPOINT "001-script.sh"
    copy_resource $TEST_ENTRYPOINT "009-script.sh"
    copy_resource $TEST_ENTRYPOINT "010-script.sh"
    copy_resource $TEST_ENTRYPOINT "021-script.sh"
    copy_resource $TEST_ENTRYPOINT "999-script.sh"

    git_first_commit
    git_dummy 

    run sh $TEST_ENTRYPOINT
    echo "status: $status"
    echo "output: $output"
    [ "$status" -eq 0 ]
    [[ "${lines[0]}" == "001" ]]
    [[ "${lines[1]}" == "009" ]]
    [[ "${lines[2]}" == "010" ]]
    [[ "${lines[3]}" == "021" ]]
    [[ "${lines[4]}" == "999" ]]
}

@test "Terminate on error" {
    copy_entrypoint $TEST_ENTRYPOINT .
    copy_resource $TEST_ENTRYPOINT "010-script.sh"
    copy_resource $TEST_ENTRYPOINT "020-error.sh"
    copy_resource $TEST_ENTRYPOINT "021-script.sh"

    git_first_commit
    git_dummy 

    run sh $TEST_ENTRYPOINT
    echo "status: $status"
    echo "output: $output"
    [ "$status" -eq 1 ]
    [[ "${lines[0]}" == "010" ]]
    [[ "${lines[1]}" != "021" ]]
    [[ "${lines[1]}" == "" ]]
}