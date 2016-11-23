#!/bin/sh

if [ -z $1 ]; then
  echo "Git repository directory path is required.";
  exit 1;
fi

_SOURCE_GIT_REPO_DIR=$1
_SINCE="2015-03-23"
_UNTIL="2015-04-22"
_TARGET_GIT_ADDR="git@github.com:fluidic/dartdoc.git"
#_TARGET_GIT_ADDR="git@github.com:joojis/dartdoc.git"
_INTERVAL=1m

_COMMITS=`git -C $_SOURCE_GIT_REPO_DIR log --since=$_SINCE --until=$_UNTIL --oneline | tac - | awk '{print $1}'`
_NUM_OF_COMMITS=`echo $_COMMITS | wc -w`
_BASE_COMMIT=`echo $_COMMITS | awk '{print $1}'`

# Uncomment the below line to force reset.
# git -C $_SOURCE_GIT_REPO_DIR push -f $_TARGET_GIT_ADDR $_BASE_COMMIT:refs/heads/master

_TARGET_CURRENT=`git ls-remote --heads $_TARGET_GIT_ADDR | awk '{print $1}'`

_SKIP_FLAG=true
for _CURRENT in $_COMMITS; do
  if $_SKIP_FLAG; then
    if echo $_TARGET_CURRENT | grep \^$_CURRENT; then
      _SKIP_FLAG=false;
    fi
    continue
  fi
  git -C $_SOURCE_GIT_REPO_DIR push $_TARGET_GIT_ADDR $_CURRENT:refs/heads/master && sleep $_INTERVAL
done

if $_SKIP_FLAG; then
  echo "Run below command to reset test target repository:"
  echo "git -C $_SOURCE_GIT_REPO_DIR push -f $_TARGET_GIT_ADDR $_BASE_COMMIT:refs/heads/master"
fi
