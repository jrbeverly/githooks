#!/bin/sh
set -x

#
# Variables
#
JIRA_ISSUE_REGEX='^([A-Z]+-[0-9]+)'
GIT_FEATURE_REGEX='^feature\/([A-Z]+-[0-9]+)'

#
# Main
#
commit_file="$1"
branch=$(git rev-parse --abbrev-ref HEAD)

if "$branch" | grep -q "$JIRA_ISSUE_REGEX"; then
    exit 0
fi

commit=$(cat "$commit_file")
if echo "$commit" | grep -q "$GIT_FEATURE_REGEX"; then
    echo "No JIRA ticket present in the commit message. Please include the JIRA ticket key." >&2 
    exit 1
fi