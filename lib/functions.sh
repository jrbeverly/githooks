#!/bin/sh

#############
# Git Functions
#############

get_current_branch() {
    git rev-parse --abbrev-ref HEAD
}

run_by_grep() {
    value="$1"
    regex="$2"

    echo "$value" | grep -q "$regex"
}