#!/bin/bash

if [ $# -eq 0 ]; then
	echo 'No project name provided (mandatory)'
	exit 1
else
	echo "- Project name:" "$1"
fi

#set the subdomain
site_url=${1}".christinewilson.ca"
staging="-staging"

#disable site
echo "Disabling site in Apache..."
sudo sh -c 'a2dissite '$site_url

# remove conf file
sudo sh -c 'rm /etc/apache2/sites-available/'$site_url'.conf'

project_name=${1}
if [[ $1 == *${staging}* ]]; 
then
	project_name=${project_name//$staging/}
	sudo sh -c 'a2dissite staging.'$project_name'.ca'
	sudo sh -c 'a2dissite staging.'$project_name'.com'
	sudo sh -c 'a2dissite staging.'$project_name'.uk'
	sudo sh -c 'a2dissite staging.'$project_name'.co.uk'
	sudo sh -c 'rm /etc/apache2/sites-available/staging.'$project_name'.ca.conf'
	sudo sh -c 'rm /etc/apache2/sites-available/staging.'$project_name'.com.conf'
	sudo sh -c 'rm /etc/apache2/sites-available/staging.'$project_name'.uk.conf'
	sudo sh -c 'rm /etc/apache2/sites-available/staging.'$project_name'.co.uk.conf'
else
	sudo sh -c 'a2dissite '$project_name'.ca'
	sudo sh -c 'a2dissite '$project_name'.com'
	sudo sh -c 'a2dissite '$project_name'.uk'
	sudo sh -c 'a2dissite '$project_name'.co.uk'
	sudo sh -c 'rm /etc/apache2/sites-available/'$project_name'.ca.conf'
	sudo sh -c 'rm /etc/apache2/sites-available/'$project_name'.com.conf'
	sudo sh -c 'rm /etc/apache2/sites-available/'$project_name'.uk.conf'
	sudo sh -c 'rm /etc/apache2/sites-available/'$project_name'.co.uk.conf'
fi

# restart apache
echo "Restarting Apache..."
sudo sh -c 'service apache2 reload'