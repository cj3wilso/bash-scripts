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
	site_url=${3}
fi

# create conf file
sudo sh -c 'echo "<VirtualHost *:80>
	ServerName '$site_url'
	DocumentRoot /var/www/html/'$1'
	<Directory /var/www/html/'$1'/>
		Options FollowSymLinks
		AllowOverride All
		Order allow,deny
		Allow from all
	</Directory>
</VirtualHost>" >> /etc/apache2/sites-available/'$site_url'.conf'
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

	#<If \"%{HTTP_HOST} == www.'$site_url'\">
	#	Redirect permanent / https://'$site_url'/
	#</If>
	DocumentRoot /var/www/html/'$1'
	ErrorLog ${APACHE_LOG_DIR}/'$site_url'-error.log
	CustomLog ${APACHE_LOG_DIR}/'$site_url'-access.log combined

	#SSLEngine On
	SSLCertificateFile /etc/letsencrypt/live/'$site_url'/fullchain.pem
	SSLCertificateKeyFile /etc/letsencrypt/live/'$site_url'/privkey.pem

	# Other Apache Configuration
	<FilesMatch \.php$>
		# 2.4.10+ can proxy to unix socket
		SetHandler \"proxy:unix:/run/php/php7.4-fpm.sock|fcgi://localhost\"
	</FilesMatch>

	<Directory /var/www/html/'$1'/>
		Options FollowSymLinks
		AllowOverride All
		Order allow,deny
		Allow from all
	</Directory>
</VirtualHost>" >> /etc/apache2/sites-available/'$site_url'.conf'

# restart apache
echo "Restarting Apache..."
sudo sh -c 'service apache2 reload'