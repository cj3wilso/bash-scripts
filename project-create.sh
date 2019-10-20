#!/bin/bash

# source: https://gist.github.com/francoisromain/58cabf43c2977e48ef0804848dee46c3
# and another script to delete the directories created by this script
# project-delete.sh: https://gist.github.com/francoisromain/e28069c18ebe8f3244f8e4bf2af6b2cb

# Call this file with `bash ./project-create.sh project-name [service-name]`
# - project-name is mandatory
# - service-name is optional

# This will creates 4 directories and a git `post-receive` hook.
# The 4 directories are:
# - $GIT: a git repo
# - $TMP: a temporary directory for deployment
# - $WWW: a directory for the actual production files
# - $ENV: a directory for the env variables

# When you push your code to the git repo,
# the `post-receive` hook will deploy the code
# in the $TMP directory, then copy it to $WWW.

DIR_TMP="/var/tmp/"
DIR_WWW="/var/www/"
DIR_GIT="/var/git/"
DIR_ENV="/var/env/"
DIR_HTML="/public_html"

if [ $# -eq 0 ]; then
	echo 'No project name provided (mandatory)'
	exit 1
else
	echo "- Project name:" "$1"
fi


if [ -z "$2" ]; then
	echo '- Service name (optional): not provided'
	GIT=$DIR_GIT$1.git
	TMP=$DIR_TMP$1
	WWW=$DIR_WWW$1$DIR_HTML
	ENV=$DIR_ENV$1
	
	# Create $WWW parent directory
	sudo mkdir -p "$DIR_WWW$1$DIR_HTML"
	cd "$DIR_WWW"
	sudo chown -R www-data:www-data "$1"
	sudo chmod -R g+rwX "$1"
else
	echo "- Service name (optional):" "$2"
	GIT=$DIR_GIT$1.$2.git
	TMP=$DIR_TMP$1.$2
	WWW=$DIR_WWW$1$DIR_HTML/$2
	ENV=$DIR_ENV$1/$2
fi

echo "- git:" "$GIT"
echo "- tmp:" "$TMP"
echo "- www:" "$WWW"
echo "- env:" "$ENV"

export GIT
export TMP
export WWW
export ENV

# Create a directory for the env repository
sudo mkdir -p "$ENV"
cd "$ENV" || exit
sudo touch .env

# Create a directory for the git repository
sudo mkdir -p "$GIT"
cd "$GIT" || exit

# Init the repo as an empty git repository
sudo git init --bare

# Define group recursively to "www-data", on the directories
sudo chgrp -R www-data .

# Define permissions recursively, on the sub-directories
# g = group, + add rights, r = read, w = write, X = directories only
# . = curent directory as a reference
sudo chmod -R g+rwX .

# Sets the setgid bit on all the directories
# https://www.gnu.org/software/coreutils/manual/html_node/Directory-Setuid-and-Setgid.html
sudo find . -type d -exec chmod g+s '{}' +

# Make the directory a shared repo
sudo git config core.sharedRepository group

cd hooks || exit

# create a post-receive file
sudo tee post-receive <<EOF
#!/bin/bash
# The production directory
WWW="${WWW}"
# A temporary directory for deployment
TMP="${TMP}"
# The Git repo
GIT="${GIT}"
# The Env  repo
ENV="${ENV}"
# Deploy the content to the temporary directory
mkdir -p \$TMP
git --work-tree=\$TMP --git-dir=\$GIT checkout -f
# Copy the env variable to the temporary directory
cp -a \$ENV/. \$TMP
# Do stuffs, like npm install
cd \$TMP || exit
# Replace the content of the production directory
# with the temporary directory
cd / || exit
rm -rf \$WWW
mv \$TMP \$WWW
# Do stuff like starting docker
cd \$WWW || exit
# docker-compose up -d --build
EOF

# make it executable
sudo chmod +x post-receive