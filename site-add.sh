#!/bin/bash

if [ $# -eq 0 ]; then
	echo 'No project name provided (mandatory)'
	exit 1
else
	echo "- Project name:" "$1"
fi

#set the subdomain
site_url=${2}".christinewilson.ca"

# create conf file
sudo sh -c 'echo "<VirtualHost *:80>
	<Directory /var/www/html/'$1'>
		Options Indexes FollowSymLinks MultiViews
		AllowOverride All
		Require all granted
	</Directory>

	ServerAdmin info@christinewilson.ca
	ServerName '$site_url'
	DocumentRoot /var/www/html/'$1'

	ErrorLog \${APACHE_LOG_DIR}/error.log
	CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>" >> /etc/apache2/sites-available/'$2'.christinewilson.ca.conf'

# restart apache
echo "Enabling site in Apache... a2ensite $site_url"
sudo sh -c 'a2ensite '$site_url'.conf'

echo "Restarting Apache..."
sudo sh -c 'service apache2 reload'