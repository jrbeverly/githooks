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

#
# Main
#
commit_file="$1"
branch=$(git rev-parse --abbrev-ref HEAD)

if ! echo "$branch" | grep -q "$GIT_FEATURE_REGEX"; then
    exit 0
fi

commit=$(cat "$commit_file")
if echo "$commit" | grep -q "$JIRA_ISSUE_REGEX"; then
    exit 0  
fi

echo "No JIRA ticket present in the commit message. Please include the JIRA ticket key." >&2 
exit 1