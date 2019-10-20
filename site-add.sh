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
	<Directory /var/www/'$1'/public_html>
		Options Indexes FollowSymLinks MultiViews
		AllowOverride All
		Require all granted
	</Directory>

	ServerAdmin info@christinewilson.ca
	ServerName '$site_url'
	DocumentRoot /var/www/'$1'/public_html

	ErrorLog \${APACHE_LOG_DIR}/error.log
	CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>" >> /etc/apache2/sites-available/'$2'.christinewilson.ca.conf'

# restart apache
echo "Enabling site in Apache... a2ensite $site_url"
sudo sh -c 'a2ensite '$site_url

echo "Restarting Apache..."
sudo sh -c 'service apache2 reload'

#create a simple index page to see url works
sudo sh -c 'echo "<!DOCTYPE html>
<html>
<body>

<h1>Project '$1' is set up</h1>

<p>Move your Git files to put real site up ;)</p>

</body>
</html>" >> /var/www/'$1'/public_html/index.html'

