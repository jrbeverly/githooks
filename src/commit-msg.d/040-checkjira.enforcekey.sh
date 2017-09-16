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

get_config() {
    git config "checkjira.enforcekey.enabled"
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

if [ "$(get_config)" = "false" ]; then
    exit 0
fi

commit_file="$1"
branch=$(get_current_branch)

if ! is_feature_branch "$branch"; then
    exit 0
fi

issue_id=$(get_issue_id "$branch")
commit=$(cat "$commit_file")
if is_id_present "$commit" "$issue_id"; then
    exit 0  
fi

echo "No JIRA ticket ($issue_id) present in the commit message. Please include the JIRA ticket key." >&2 
exit 1