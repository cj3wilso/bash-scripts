#!/bin/bash

if [ $# -eq 0 ]; then
	echo 'No project name provided (mandatory)'
	exit 1
else
	echo "- Project name:" "$1"
fi

#set the subdomain
site_url=${1}".christinewilson.ca"

# restart apache
echo "Disabling site in Apache..."
sudo sh -c 'a2dissite '$site_url

# create conf file
sudo sh -c 'rm /etc/apache2/sites-available/'$1'.christinewilson.ca.conf'

echo "Restarting Apache..."
sudo sh -c 'service apache2 reload'