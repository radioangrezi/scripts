#!/bin/bash

# accessible var DEPLOY_REPO_NAME
# accessible var DEPLOY_DEST
# accessible var DEPLOY_FROM

echo Symlinking scripts into /usr/local/sbin ...

scriptDir=/opt/scripts
echo Running in "$scriptDir"

shopt -s nullglob
for file in "$scriptDir"/*.sh ; do
  scriptFile="$(basename "$file" .sh)"
  if [[ ! -f /usr/local/sbin/"$scriptFile" ]]
  then
     echo symlinking script file "$file"...
     sudo ln -s "$file" /usr/local/sbin/"$scriptFile"
  else
     echo symlink to file "$scriptFile" already present
  fi

  sudo chown root:root "$file"
  sudo chmod +x "$file"
done
