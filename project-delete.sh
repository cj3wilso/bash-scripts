#!/bin/bash

# source: https://gist.github.com/francoisromain/e28069c18ebe8f3244f8e4bf2af6b2cb
# and another script to create the directories deleted by this script
# project-create.sh: https://gist.github.com/francoisromain/58cabf43c2977e48ef0804848dee46c3

# Call this file with `bash ./project-delete.sh project-name [service-name]`
# - project-name is mandatory
# - service-name is optional

# This will delete 4 directories
# - $GIT: a git repo
# - $TMP: a temporary directory for deployment
# - $WWW: a directory for the actual production files
# - $ENV: a directory for the env variables

DIR_TMP="/var/tmp/"
DIR_WWW="/var/www/"
DIR_GIT="/var/git/"
DIR_ENV="/var/env/"

function dir_delete() {
        sudo rm -rf "$1"
}

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
        WWW=$DIR_WWW$1
        ENV=$DIR_ENV$1
else
        echo "- Service name (optional):" "$2"
        GIT=$DIR_GIT$1.$2.git
        TMP=$DIR_TMP$1.$2
        WWW=$DIR_WWW$1/$2
        ENV=$DIR_ENV$1/$2
fi

echo "- git:" "$GIT"
echo "- tmp:" "$TMP"
echo "- www:" "$WWW"
echo "- env:" "$ENV"

dir_delete "$GIT"
dir_delete "$ENV"
dir_delete "$WWW"
dir_delete "$TMP"