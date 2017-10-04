#!/usr/bin/env bats
load "../lib/filesystem"
load "../lib/git"
load "../lib/scaffolding"
load "lib/unit"

#
# Variables
#
TEST_ENTRYPOINT="commit-msg"
TEST_HOOK="extendjira.ref"
TEST_CONFIG_HOOK="extendjira.refkey"

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

@test "Replace using default constant" {
    BRANCH="feature/AS-100-work-branch"
    COMMIT="## Commit has no issue id"

    git_quick_commit "$TEST_ENTRYPOINT" "$TEST_HOOK" "$BRANCH" "$COMMIT"

    run sh $TEST_ENTRYPOINT "$(git_mock_commit_path)"
    commit=$(git_mock_commit_message)

    echo "status: $status"
    echo "output: $output"
    echo "commit: $commit"
    [ "$status" -eq 0 ]
    [[ "$commit" == "[AS-100] Commit has no issue id" ]]
}


@test "Replace using custom constant" {
    BRANCH="feature/AS-100-work-branch"
    COMMIT="!!!! Commit has no issue id"

    git config --add "$TEST_CONFIG_HOOK" "!!!!"
    git_quick_commit "$TEST_ENTRYPOINT" "$TEST_HOOK" "$BRANCH" "$COMMIT"

    run sh $TEST_ENTRYPOINT "$(git_mock_commit_path)"
    commit=$(git_mock_commit_message)

    echo "status: $status"
    echo "output: $output"
    echo "commit: $commit"
    [ "$status" -eq 0 ]
    [[ "$commit" == "[AS-100] Commit has no issue id" ]]
}

@test "Replace multiple using custom constant" {
    BRANCH="feature/AS-100-work-branch"
    COMMIT="!!!! Commit has no issue id !!!!"

    git config --add "$TEST_CONFIG_HOOK" "!!!!"
    git_quick_commit "$TEST_ENTRYPOINT" "$TEST_HOOK" "$BRANCH" "$COMMIT"

    run sh $TEST_ENTRYPOINT "$(git_mock_commit_path)"
    commit=$(git_mock_commit_message)

    echo "status: $status"
    echo "output: $output"
    echo "commit: $commit"
    [ "$status" -eq 0 ]
    [[ "$commit" == "[AS-100] Commit has no issue id [AS-100]" ]]
}

@test "Branch is not feature" {
    BRANCH="AS-100-work-branch"
    COMMIT="#! Commit has no issue id"

    git_quick_commit "$TEST_ENTRYPOINT" "$TEST_HOOK" "$BRANCH" "$COMMIT"

    run sh $TEST_ENTRYPOINT "$(git_mock_commit_path)"
    commit=$(git_mock_commit_message)

    echo "status: $status"
    echo "output: $output"
    echo "commit: $commit"
    [ "$status" -eq 0 ]
    [[ "$commit" == $COMMIT ]]
}

@test "Custom constant while using default constant" {
    BRANCH="feature/AS-100-work-branch"
    COMMIT="#! Commit has no issue id"

    git config --add "$TEST_CONFIG_HOOK" "!!!!"
    git_quick_commit "$TEST_ENTRYPOINT" "$TEST_HOOK" "$BRANCH" "$COMMIT"

    run sh $TEST_ENTRYPOINT "$(git_mock_commit_path)"
    commit=$(git_mock_commit_message)

    echo "status: $status"
    echo "output: $output"
    echo "commit: $commit"
    [ "$status" -eq 0 ]
    [[ "$commit" == $COMMIT ]]
}

@test "Commit has nothing to replace" {
    BRANCH="feature/AS-100-work-branch"
    COMMIT="Commit has no issue id"

    git config --add "$TEST_CONFIG_HOOK" "!!!!"
    git_quick_commit "$TEST_ENTRYPOINT" "$TEST_HOOK" "$BRANCH" "$COMMIT"

    run sh $TEST_ENTRYPOINT "$(git_mock_commit_path)"
    commit=$(git_mock_commit_message)

    echo "status: $status"
    echo "output: $output"
    echo "commit: $commit"
    [ "$status" -eq 0 ]
    [[ "$commit" == $COMMIT ]]
}

@test "Incorrect constant placement" {
    BRANCH="feature/AS-100-work-branch"
    COMMIT="!##! Commit has no issue id"

    git config --add "$TEST_CONFIG_HOOK" "!#!"
    git_quick_commit "$TEST_ENTRYPOINT" "$TEST_HOOK" "$BRANCH" "$COMMIT"

    run sh $TEST_ENTRYPOINT "$(git_mock_commit_path)"
    commit=$(git_mock_commit_message)

    echo "status: $status"
    echo "output: $output"
    echo "commit: $commit"
    [ "$status" -eq 0 ]
    [[ "$commit" == $COMMIT ]]
}

@test "Partial constant in text" {
    BRANCH="feature/AS-100-work-branch"
    COMMIT="#! Commit has no issue id"

    git config --add "$TEST_CONFIG_HOOK" "!#!"
    git_quick_commit "$TEST_ENTRYPOINT" "$TEST_HOOK" "$BRANCH" "$COMMIT"

    run sh $TEST_ENTRYPOINT "$(git_mock_commit_path)"
    commit=$(git_mock_commit_message)

    echo "status: $status"
    echo "output: $output"
    echo "commit: $commit"
    [ "$status" -eq 0 ]
    [[ "$commit" == $COMMIT ]]
}