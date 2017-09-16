#!/bin/bash

#
# Testing Scaffolding
#

function git_quick_commit() {
    entrypoint="$1"
    hook="$2"
    branch="$3"
    commit="$4"

    copy_entrypoint $entrypoint .
    copy_hook $entrypoint $hook

    git_first_commit
    git_dummy
    git checkout -b $branch > /dev/null 2>&1

    git_mock_commit "$commit"
}