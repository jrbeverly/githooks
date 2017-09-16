#!/usr/bin/env bats
load "../lib/filesystem"
load "../lib/git"
load "../lib/scaffolding"
load "lib/unit"

#
# Variables
#
TEST_ENTRYPOINT="commit-msg"
TEST_HOOK="checkjira.enforcekey"
TEST_CONFIG_HOOK="checkjira.enforcekey.enabled"

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

@test "Hook is disabled" {
    BRANCH="feature/AS-100-work-branch"
    COMMIT="Commit has no issue id"

    git config --add "$TEST_CONFIG_HOOK" false
    git_quick_commit "$TEST_ENTRYPOINT" "$TEST_HOOK" "$BRANCH" "$COMMIT"

    run sh $TEST_ENTRYPOINT "$(git_mock_commit_path)"
    commit=$(git_mock_commit_message)

    echo "status: $status"
    echo "output: $output"
    echo "commit: $commit"
    echo "configuration: " $(git config "$TEST_CONFIG_HOOK")
    [ "$status" -eq 0 ]
}

@test "Hook is enabled, and commit is rejected" {
    BRANCH="feature/AS-100-work-branch"
    COMMIT="Commit has no issue id"

    git config --add "$TEST_CONFIG_HOOK" true
    git_quick_commit "$TEST_ENTRYPOINT" "$TEST_HOOK" "$BRANCH" "$COMMIT"

    run sh $TEST_ENTRYPOINT "$(git_mock_commit_path)"
    commit=$(git_mock_commit_message)

    echo "status: $status"
    echo "output: $output"
    echo "commit: $commit"
    echo "configuration: " $(git config "$TEST_CONFIG_HOOK")
    [ "$status" -ne 0 ]
}

@test "Commit has exact issue id" {
    BRANCH="feature/AS-100-work-branch"
    COMMIT="AS-100 is valid"

    git_quick_commit "$TEST_ENTRYPOINT" "$TEST_HOOK" "$BRANCH" "$COMMIT"

    run sh $TEST_ENTRYPOINT "$(git_mock_commit_path)"
    commit=$(git_mock_commit_message)

    echo "status: $status"
    echo "output: $output"
    echo "commit: $commit"
    [ "$status" -eq 0 ]
}

@test "Commit is missing exact issue id" {
    BRANCH="feature/AS-100-work-branch"
    COMMIT="AS-101 is different but valid"

    git_quick_commit "$TEST_ENTRYPOINT" "$TEST_HOOK" "$BRANCH" "$COMMIT"

    run sh $TEST_ENTRYPOINT "$(git_mock_commit_path)"
    commit=$(git_mock_commit_message)

    echo "status: $status"
    echo "output: $output"
    echo "commit: $commit"
    [ "$status" -ne 0 ]
}

@test "Issue ID is last but valid" {
    BRANCH="feature/AS-100-work-branch"
    COMMIT="A commit, but in a different spot: AS-100"

    git_quick_commit "$TEST_ENTRYPOINT" "$TEST_HOOK" "$BRANCH" "$COMMIT"

    run sh $TEST_ENTRYPOINT "$(git_mock_commit_path)"
    commit=$(git_mock_commit_message)

    echo "status: $status"
    echo "output: $output"
    echo "commit: $commit"
    [ "$status" -eq 0 ]
}

@test "Branch is not feature" {
    BRANCH="AS-100-work-branch"
    COMMIT="Commit has no issue id"

    git_quick_commit "$TEST_ENTRYPOINT" "$TEST_HOOK" "$BRANCH" "$COMMIT"

    run sh $TEST_ENTRYPOINT "$(git_mock_commit_path)"
    commit=$(git_mock_commit_message)

    echo "status: $status"
    echo "output: $output"
    echo "commit: $commit"
    [ "$status" -eq 0 ]
}

@test "Reject commit with no issue ID" {
    BRANCH="feature/AS-100-work-branch"
    COMMIT="Commit has no issue id"

    git_quick_commit "$TEST_ENTRYPOINT" "$TEST_HOOK" "$BRANCH" "$COMMIT"

    run sh $TEST_ENTRYPOINT "$(git_mock_commit_path)"
    commit=$(git_mock_commit_message)

    echo "status: $status"
    echo "output: $output"
    echo "commit: $commit"
    [ "$status" -ne 0 ]
}

@test "Reject commit with no key" {
    BRANCH="feature/AS-100-work-branch"
    COMMIT="-100 Commit has no issue id"

    git_quick_commit "$TEST_ENTRYPOINT" "$TEST_HOOK" "$BRANCH" "$COMMIT"

    run sh $TEST_ENTRYPOINT "$(git_mock_commit_path)"
    commit=$(git_mock_commit_message)

    echo "status: $status"
    echo "output: $output"
    echo "commit: $commit"
    [ "$status" -ne 0 ]
}

@test "Reject commit with no number" {
    BRANCH="feature/AS-100-work-branch"
    COMMIT="AS- Commit has no issue id"

    git_quick_commit "$TEST_ENTRYPOINT" "$TEST_HOOK" "$BRANCH" "$COMMIT"

    run sh $TEST_ENTRYPOINT "$(git_mock_commit_path)"
    commit=$(git_mock_commit_message)

    echo "status: $status"
    echo "output: $output"
    echo "commit: $commit"
    [ "$status" -ne 0 ]
}

@test "Reject commit with bad format" {
    BRANCH="feature/AS-100-work-branch"
    COMMIT="AS100 Commit has no issue id"

    git_quick_commit "$TEST_ENTRYPOINT" "$TEST_HOOK" "$BRANCH" "$COMMIT"

    run sh $TEST_ENTRYPOINT "$(git_mock_commit_path)"
    commit=$(git_mock_commit_message)

    echo "status: $status"
    echo "output: $output"
    echo "commit: $commit"
    [ "$status" -ne 0 ]
}

@test "Reject commit with bad separation formating" {
    BRANCH="feature/AS-100-work-branch"
    COMMIT="AS--100 Commit has no issue id"

    git_quick_commit "$TEST_ENTRYPOINT" "$TEST_HOOK" "$BRANCH" "$COMMIT"

    run sh $TEST_ENTRYPOINT "$(git_mock_commit_path)"
    commit=$(git_mock_commit_message)

    echo "status: $status"
    echo "output: $output"
    echo "commit: $commit"
    [ "$status" -ne 0 ]
}

@test "Reject commit with bad spacing" {
    BRANCH="feature/AS-100-work-branch"
    COMMIT="AS 100 Commit has no issue id"

    git_quick_commit "$TEST_ENTRYPOINT" "$TEST_HOOK" "$BRANCH" "$COMMIT"

    run sh $TEST_ENTRYPOINT "$(git_mock_commit_path)"
    commit=$(git_mock_commit_message)

    echo "status: $status"
    echo "output: $output"
    echo "commit: $commit"
    [ "$status" -ne 0 ]
}