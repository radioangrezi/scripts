#!/bin/bash

# accessible var DEPLOY_REPO_NAME
# accessible var DEPLOY_DEST
# accessible var DEPLOY_FROM

echo deploy!

$scriptDir="$(dirname $test)"

runDeployScript="$scriptDir"/run-deploy.sh
sudo chown root:root "$runDeployScript"
sudo cp -f "$runDeployScript" /usr/local/sbin/run-deploy
sudo chmod +x /usr/local/sbin/run-deploy

setupServiceScript="$scriptDir"/setup-service.sh
sudo chown root:root "$setupServiceScript"
sudo cp -f "$setupServiceScript" /usr/local/sbin/setup-service
sudo chmod +x /usr/local/sbin/run-deploy
