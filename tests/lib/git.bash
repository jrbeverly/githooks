#!/bin/bash

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

function git_dummy() {
    echo "Simple" >> file
    git commit -a -m "Dummy" > /dev/null 2>&1
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