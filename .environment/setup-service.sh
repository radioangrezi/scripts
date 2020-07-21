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

# empty var produces bug
[ -d "./$repo" ] && checkProceed "$repo exists. do you want to update configuration?"

echo "Setting up $repo..."

sudo rm -rf ./.temp
mkdir .temp

#cloning repo into temp
git clone --quiet "https://github.com/radioangrezi/$repo.git" ./.temp/repo
mkdir -p "$repo"

checkDir "./.temp/repo/.environment/" ".environment folder does not exists in repository. exiting..."

sudo cp -rf ./.temp/repo/.environment/. "./$repo/"
# cp -r ./.temp/repo/.environment/. ./angrezi-tusd-hooks/

# link service files
shopt -s nullglob
for file in "$PWD"/"$repo"/*.service ; do
  echo "Registering service file ${file##*/}..."
  ln -sf "$file" /etc/systemd/system/"${file##*/}"
  sudo systemctl enable "${file##*/}"
done
sudo systemctl daemon-reload

checkFile "./$repo/deploy.sh" "no deploy script found. exiting..."
sudo chown -R root:root "./$repo"
sudo chmod -R 775 "./$repo"

# deploying manually once: build step is missing this makes no sense
# export DEPLOY_REPO_NAME="$repo"
# export DEPLOY_DEST="/opt/services/$repo/run"
# export DEPLOY_FROM="/opt/services/.temp/repo"
# source ./$repo/deploy.sh
