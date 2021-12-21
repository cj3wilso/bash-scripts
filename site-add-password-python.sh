#!/bin/bash

if [ $# -eq 0 ]; then
	echo 'No project name provided (mandatory)'
	exit 1
else
	echo "- Project name:" "$1"
fi

#If no domain provided
if [ -z "$3" ]; then
	#set the subdomain
	site_url=${2}".christinewilson.ca"
else
	#set the domain name
	site_url="staging."${3}
fi

# create conf file
sudo sh -c 'echo "<VirtualHost *:80>
	<Directory /var/www/html/'$1'>
		Options +ExecCGI
		DirectoryIndex index.py
		AuthType basic
		AuthName "private"
		AuthUserFile /etc/apache2/.htpasswd
		Require valid-user
	</Directory>
	AddHandler cgi-script .py

	ServerAdmin info@christinewilson.ca
	ServerName '$site_url'
	DocumentRoot /var/www/html/'$1'

	ErrorLog \${APACHE_LOG_DIR}/error.log
	CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>" >> /etc/apache2/sites-available/'$2'.christinewilson.ca.conf'
# enable domain
echo "Enabling site in Apache... a2ensite $site_url"
sudo sh -c 'a2ensite '$site_url'.conf'
sudo certbot certonly --agree-tos --email cj3wilso@gmail.com --webroot -w /var/lib/letsencrypt/ -d $site_url
sudo rm /etc/apache2/sites-available/$site_url.conf
sudo sh -c 'echo "<VirtualHost *:80>
	ServerName '$site_url'
	DocumentRoot /var/www/html/'$1'

	Redirect permanent / https://'$site_url'/
</VirtualHost>

<VirtualHost *:443>
	ServerAdmin info@christinewilson.ca
	ServerName '$site_url'
	#ServerAlias www.'$site_url'
	Protocols h2 http:/1.1

	DocumentRoot /var/www/html/'$1'
	ErrorLog ${APACHE_LOG_DIR}/'$site_url'-error.log
	CustomLog ${APACHE_LOG_DIR}/'$site_url'-access.log combined

	#SSLEngine On
	SSLCertificateFile /etc/letsencrypt/live/'$site_url'/fullchain.pem
	SSLCertificateKeyFile /etc/letsencrypt/live/'$site_url'/privkey.pem

	<Directory /var/www/html/'$1'>
		Options +ExecCGI
		DirectoryIndex index.py
		AuthType basic
		AuthName "private"
		AuthUserFile /etc/apache2/.htpasswd
		Require valid-user
	</Directory>
	AddHandler cgi-script .py
</VirtualHost>" >> /etc/apache2/sites-available/'$site_url'.conf'

# restart apache
echo "Restarting Apache..."
sudo sh -c 'service apache2 reload'