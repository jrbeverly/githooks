#!/usr/bin/env bats
load "../lib/filesystem"
load "../lib/git"
load "../lib/scaffolding"
load "lib/unit"

#
# Variables
#
TEST_ENTRYPOINT="commit-msg"
TEST_HOOK="checkjira.empty"

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

@test "Standard commit message" {
    BRANCH="feature/AS-100-work-branch"
    COMMIT="Commit has no issue id"

    copy_entrypoint $TEST_ENTRYPOINT .
    copy_hook $TEST_ENTRYPOINT $TEST_HOOK

    git_first_commit
    git_dummy
    git checkout -b $BRANCH > /dev/null 2>&1

    git_mock_commit "$COMMIT"
    run sh $TEST_ENTRYPOINT "$(git_mock_commit_path)"
    commit=$(git_mock_commit_message)

    echo "status: $status"
    echo "output: $output"
    echo "commit: $commit"
    [ "$status" -eq 0 ]
    [[ "$commit" == $COMMIT ]]
}

@test "Branch is not feature" {
    BRANCH="AS-100-work-branch"
    COMMIT="Commit has no issue id"

    copy_entrypoint $TEST_ENTRYPOINT .
    copy_hook $TEST_ENTRYPOINT $TEST_HOOK

    git_first_commit
    git_dummy
    git checkout -b $BRANCH > /dev/null 2>&1

    git_mock_commit "$COMMIT"
    run sh $TEST_ENTRYPOINT "$(git_mock_commit_path)"
    commit=$(git_mock_commit_message)

    echo "status: $status"
    echo "output: $output"
    echo "commit: $commit"
    [ "$status" -eq 0 ]
}

@test "Empty commit on normal branch" {
    BRANCH="AS-100-work-branch"
    COMMIT=""

    copy_entrypoint $TEST_ENTRYPOINT .
    copy_hook $TEST_ENTRYPOINT $TEST_HOOK

    git_first_commit
    git_dummy
    git checkout -b $BRANCH > /dev/null 2>&1

    git_mock_commit "$COMMIT"
    run sh $TEST_ENTRYPOINT "$(git_mock_commit_path)"
    commit=$(git_mock_commit_message)

    echo "status: $status"
    echo "output: $output"
    echo "commit: $commit"
    [ "$status" -eq 0 ]
}

@test "Empty commit on branch" {
    BRANCH="feature/AS-100-work-branch"
    COMMIT=""

    copy_entrypoint $TEST_ENTRYPOINT .
    copy_hook $TEST_ENTRYPOINT $TEST_HOOK

    git_first_commit
    git_dummy
    git checkout -b $BRANCH > /dev/null 2>&1

    git_mock_commit "$COMMIT"
    run sh $TEST_ENTRYPOINT "$(git_mock_commit_path)"
    commit=$(git_mock_commit_message)

    echo "status: $status"
    echo "output: $output"
    echo "commit: $commit"
    [ "$status" -eq 0 ]
    [[ "$commit" ==  "[AS-100]"* ]]
}
