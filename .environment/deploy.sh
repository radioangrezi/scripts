#!/bin/bash

# accessible var DEPLOY_REPO_NAME
# accessible var DEPLOY_DEST
# accessible var DEPLOY_FROM

echo deploy!

runDeployScript="$DEPLOY_DEST"/../run-deploy.sh

sudo chown root:root "$runDeployScript"
sudo ln -s "$runDeployScript" /usr/local/sbin/run-deploy
