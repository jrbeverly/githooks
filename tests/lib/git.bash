#!/bin/bash
command -v git >/dev/null 2>&1 || { echo >&2 "The tests requires 'git' but it's not installed.  Aborting."; exit 1; }

#
# Git Helpers
#
function git_init() {
    git init > /dev/null 2>&1
    git config user.email "test@test.com" > /dev/null 2>&1
    git config user.name "test" > /dev/null 2>&1
}

function git_first_commit() {
    echo "Simple" > file
    git add file > /dev/null 2>&1
    git commit -a -m "Init" > /dev/null 2>&1
}

function git_commit() {
    echo "Simple" >> file
    git commit -a -m "$1" > /dev/null 2>&1
}

function git_mock_commit() {
    echo "$1" >> $(git_mock_commit_path)
}

function git_mock_commit_path() {
    echo "EDITMSG"
}

function git_mock_commit_message() {
    cat EDITMSG
}

function git_dummy() {
    echo "Simple" >> file
    git commit -a -m "Dummy" > /dev/null 2>&1
}

function git_change() {
    echo "Simple" >> file
}

#
#
#

function get_entrypoint_dir() {
    echo "$1.d"
}

function entrypoint_touch() {
    hook="$1"
    dir=$(get_entrypoint_dir "$hook")

    mkdir -p "$dir"
}