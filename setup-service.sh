#!/bin/bash

# setup a new service on the angrezi server or update environment specific configuration
# automatically links and updates systemd service files
# other config files need to be symlinked in the respective folders manually

function checkProceed {
  read -r -p "$1 [Y/n] " input
  case $input in
      [yY][eE][sS]|[yY])
   ;;
      [nN][oO]|[nN])
   echo "exiting..."
   exit 1
         ;;
      *)
   echo "Invalid input..."
   exit 1
   ;;
  esac
}

function checkDir {
  if [ ! -d "$1" ]; then
    echo "$2"
    exit 1
  fi
  }

  function checkFile {
  if [ ! -f "$1" ]; then
    echo "$2"
    exit 1
  fi
}

repo="$1"
tempDir=/tmp/setup-service/repository
serviceDir=/opt/services/"$repo"

# empty var produces bug
[ -d "./$repo" ] && checkProceed "$repo exists. do you want to update configuration?"

echo "Setting up $repo..."

mkdir -p /tmp/setup-service
sudo rm -rf "$tempDir"

#cloning repo into temp
git clone --quiet "https://github.com/radioangrezi/$repo.git" "$tempDir"
mkdir -p "$serviceDir"

checkDir "$tempDir"/.environment/ ".environment folder does not exists in repository. exiting..."

sudo cp -rf "$tempDir"/.environment/. "$serviceDir"/

# link service files
shopt -s nullglob
for file in "$serviceDir"/*.service ; do
  serviceFile="${file##*/}"
  echo Registering service file "$serviceFile"...
  ln -sf "$file" /etc/systemd/system/"$serviceFile"
  sudo systemctl enable "$serviceFile"
done

# reload systemd daemon
sudo systemctl daemon-reload

checkFile "$serviceDir"/deploy.sh "no deploy script found. exiting..."
sudo chown -R root:root "$serviceDir"/deploy.sh
sudo chmod -R 775 "$serviceDir"/deploy.sh

# deploying manually once: build step is missing this makes no sense
# export DEPLOY_REPO_NAME="$repo"
# export DEPLOY_DEST="/opt/services/$repo/run"
# export DEPLOY_FROM="/opt/services/.temp/repo"
# source ./$repo/deploy.sh
