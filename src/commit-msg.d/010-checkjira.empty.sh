#!/bin/sh

#
# Variables
#
JIRA_ISSUE_REGEX='[A-Z]\+-[0-9]\+'
GIT_FEATURE_REGEX='feature/'

#
#
# Functions
#
get_current_branch() {
    git rev-parse --abbrev-ref HEAD
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
commit_file="$1"
branch=$(get_current_branch)

if ! is_feature_branch "$branch"; then
    exit 0
fi

commit=$(cat "$commit_file")
if [ ! -z "$commit" -a "$commit" != " " ]; then
    exit 0
fi

issue_id=$(get_issue_id "$branch")
echo "[$issue_id] WIP: Commiting a series of changes" > "$commit_file"