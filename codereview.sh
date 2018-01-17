#!/bin/bash

# Usage:
# ./codereview.sh [description] [issue_number]

if [ $# -gt 0 ]; then
    if [ ! -z "$1" ]; then
        DESC=" $1";
    fi
    shift
fi

# get current branch
function get_git_branch() {
    git branch --no-color 2> /dev/null | sed -e "/^[^*]/d" -e "s/* \(.*\)/\1/"
}

if [ -z "${JIRA_TICKET}" ]; then
    JIRA_TICKET=`get_git_branch | sed -e "s/^.*-\([A-Z]*-[0-9]*\).*/\1/"`
fi
JIRA_FLAG="--jira=${JIRA_TICKET}"

# get merge base
if [ -z "${MERGE_BASE}" ]; then
    MERGE_BASE=$(git merge-base master HEAD)
fi

# if issue number is provided, this
# is not first submission. Turn off jira comment.
if [ $# -gt 0 ]; then
    ISSUE_FLAG="--issue=$1";
    JIRA_FLAG="--nojira";
    shift
fi

if [ -z "${ISSUE_FLAG}" ]; then
    DESCRIPTION_FLAG="--description=https://jira.mongodb.org/browse/${JIRA_TICKET}"
fi

# get path to the cr tool
if [ -z "${UPLOAD_PATH}" ]; then
    UPLOAD_PATH="exec python $HOME/mongodb/tools/upload.py"
fi

echo "JIRA Ticket: ${JIRA_TICKET}"
echo "Desc: ${DESC}"
echo "Merge Base: ${MERGE_BASE}"
echo "Desicription Flag: ${DESCRIPTION_FLAG}"
echo "Issue Flag: ${ISSUE_FLAG}"
echo "Jira Flag: ${ISSUE_FLAG}"
echo "@: $@"

SERVER=mongodbcr.appspot.com
EMAIL='william.schultz@mongodb.com'
CC='codereview-mongo@10gen.com,serverteam-replication@10gen.com'
JIRA_USER='william.schultz'
   
#--check-clang-format \
#--check-eslint \

set -x
${UPLOAD_PATH} --rev=${MERGE_BASE} \
    ${DESCRIPTION_FLAG} \
    ${ISSUE_FLAG} ${JIRA_FLAG} \
    --assume_yes \
    --oauth2 \
    --host=${SERVER} \
    --server=${SERVER} \
    --email=${EMAIL} \
    --cc=${CC} \
    --jira_user ${JIRA_USER} \
    --title="${JIRA_TICKET}${DESC}" "$@"
