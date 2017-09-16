#!/bin/sh

#
# Variables
#
JIRA_ISSUE_REGEX='[A-Z]\+-[0-9]\+' 
GIT_FEATURE_REGEX='feature/'
DEFAULT_CONSTANT="#!"

#
#
# Functions
#
get_current_branch() {
    git rev-parse --abbrev-ref HEAD
}

get_constant() {
    git config "extendjira.subkey" || echo $DEFAULT_CONSTANT
}

is_feature_branch() {
    echo "$1" | grep -q "$GIT_FEATURE_REGEX"
}

is_id_present() {
    echo "$1" | grep -q "$2"
}

get_issue_id() {
    echo "$1" | grep -o "$JIRA_ISSUE_REGEX"
}

#
# Main
#
constant=$(get_constant)
commit_file="$1"
branch=$(get_current_branch)

if ! is_feature_branch "$branch"; then
    exit 0
fi

issue_id=$(get_issue_id "$branch")
sed -i "s/$constant/$issue_id/g" "$commit_file"