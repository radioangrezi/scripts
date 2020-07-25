#!/bin/bash

repoDir="$(basename $1)"
expectedParentDir="/opt/services/"
deployScript="/opt/services/$repoDir/deploy.sh"

function testDir() {
  arg=$1
  if [[ ! -f $arg ]]
  then
      echo "no deployment script found."
      echo "setup the service with: sudo /opt/services/setup.sh $repoDir?"
      exit 1
  fi
  rpath=$(realpath "$arg")
  if [[ $rpath != ${expectedParentDir}* ]]
  then
   echo "Please only reference files under $expectedParentDir directory."
   exit 2
  fi
}

testDir "$deployScript"

#export variables accessible in script
export DEPLOY_REPO_NAME="$repoDir"
export DEPLOY_DEST="/opt/services/$repoDir/run"
export DEPLOY_FROM="/var/github/actions-runner/_work/$repoDir/$repoDir"

#create run dir of not present
mkdir -p "$DEPLOY_DEST"

# run the services deploy script
# shellcheck source=/dev/null
source "$deployScript"
