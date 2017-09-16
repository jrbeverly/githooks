#!/bin/sh

#
# Variables
#
JIRA_ISSUE_REGEX='(?:\s|^)([A-Z]+-[0-9]+)'
GIT_FEATURE_REGEX='^feature\/([A-Z]+-[0-9]+)'

#
# Functions
#
parse_branch() {
    git rev-parse --abbrev-ref HEAD
}

is_feature_branch() {
    [[ $1 =~ $GIT_FEATURE_REGEX ]]
}

has_issue_id() {
    [[ $1 =~ $GIT_FEATURE_REGEX ]]
}

read_message() {
    cat "$1"
}

#
# Main
#
run() {
    branch=$(parse_branch)
    commit_file="$1"
    commit=''

    is_feature_branch "$branch"
    if [ "$?" -ne 0 ]
    then
        exit 0
    fi

    commit=$(read_message "$commit_file")
    has_issue_id "$commit"
    if [ "$?" -eq 0 ]
    then
        exit 0
    fi

    echo 'No JIRA ticket present in the commit message. Please include the JIRA ticket key.' >&2
    exit 1
}

run