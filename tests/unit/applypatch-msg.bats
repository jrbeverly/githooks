#!/usr/bin/env bats
load "lib/test_helper"

#
# Variables
#
TEST_ENTRYPOINT="applypatch-msg"

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
    copy_entrypoint $TEST_ENTRYPOINT

    echo "Simple" > file
    git add file

    run git commit -a -m "Dummy"
    echo "status: $status"
    echo "output: $output"
    [ "$status" -eq 0 ]
}

@test "Empty hook directory" {
    copy_entry $TEST_ENTRYPOINT

    echo "Simple" > file
    git add file

    run git commit -a -m "Dummy"
    echo "status: $status"
    echo "output: $output"
    [ "$status" -eq 0 ]
}

@test "Simple hook" {
    copy_entry $TEST_ENTRYPOINT
    copy_resource $TEST_ENTRYPOINT "hello.sh"

    echo "Simple" > file
    git add file

    run git commit -a -m "Dummy"
    echo "status: $status"
    echo "output: $output"
    [ "$status" -eq 0 ]
    [[ "${lines[0]}" == "Hello" ]]
}

@test "Multiple hooks" {
    copy_entry $TEST_ENTRYPOINT
    copy_resource $TEST_ENTRYPOINT "hello.sh"
    copy_resource $TEST_ENTRYPOINT "world.sh"

    echo "Simple" > file
    git add file

    run git commit -a -m "Dummy"
    echo "status: $status"
    echo "output: $output"
    [ "$status" -eq 0 ]
    [[ "${lines[0]}" == "Hello" ]]
    [[ "${lines[1]}" == "World" ]]
}

@test "Test parameter passing" {
    copy_entry $TEST_ENTRYPOINT
    copy_resource $TEST_ENTRYPOINT "echo.sh"

    echo "Simple" > file
    git add file

    run git commit -a -m "Dummy"
    echo "status: $status"
    echo "output: $output"
    [ "$status" -eq 0 ]
    [[ "${lines[0]}" == *"COMMIT_EDITMSG" ]]
}

@test "Simple hook ordering" {
    copy_entry $TEST_ENTRYPOINT
    copy_resource $TEST_ENTRYPOINT "001-script.sh"
    copy_resource $TEST_ENTRYPOINT "999-script.sh"

    echo "Simple" > file
    git add file

    run git commit -a -m "Dummy"
    echo "status: $status"
    echo "output: $output"
    [ "$status" -eq 0 ]
    [[ "${lines[0]}" == "001" ]]
    [[ "${lines[1]}" == "999" ]]
}

@test "Hook ordering" {
    copy_entry $TEST_ENTRYPOINT
    copy_resource $TEST_ENTRYPOINT "001-script.sh"
    copy_resource $TEST_ENTRYPOINT "009-script.sh"
    copy_resource $TEST_ENTRYPOINT "010-script.sh"
    copy_resource $TEST_ENTRYPOINT "021-script.sh"
    copy_resource $TEST_ENTRYPOINT "999-script.sh"

    echo "Simple" > file
    git add file

    run git commit -a -m "Dummy"
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
    copy_entry $TEST_ENTRYPOINT
    copy_resource $TEST_ENTRYPOINT "010-script.sh"
    copy_resource $TEST_ENTRYPOINT "020-error.sh"
    copy_resource $TEST_ENTRYPOINT "021-script.sh"

    echo "Simple" > file
    git add file

    run git commit -a -m "Dummy"
    echo "status: $status"
    echo "output: $output"
    [ "$status" -eq 1 ]
    [[ "${lines[0]}" == "010" ]]
    [[ "${lines[1]}" != "021" ]]
    [[ "${lines[1]}" == "" ]]
}