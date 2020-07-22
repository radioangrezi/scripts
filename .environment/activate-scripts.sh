#!/bin/bash

# accessible var DEPLOY_REPO_NAME
# accessible var DEPLOY_DEST
# accessible var DEPLOY_FROM

echo Symlinking scripts into /usr/local/sbin ...

thisDir=$(dirname "$0"/..)


shopt -s nullglob
for file in "$thisDir"/*.sh ; do
  scriptFile="${file##*/}"
  echo symlinking script file "$serviceFile"...
  [ ! -f "$file"] && ln -s "$file" /etc/systemd/system/"$serviceFile"
  sudo chown root:root "$file"
  sudo chmod +x "$file"
done
