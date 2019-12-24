#!/bin/bash

export PATH=/bin:/usr/bin:/usr/local/bin
 
################################################################
################## Update below values  ########################

MYSQL_HOST='localhost'
MYSQL_PORT='3306'
MYSQL_USER='root'
MYSQL_PASSWORD='57575757aA'
PROJECT_PASSWORD='575757aA'
DATABASE_NAME='copy'
TABLE_PREFIX='jyymliwhjxbt'
 
#################################################################

mysqldump -h ${MYSQL_HOST} \
   -P ${MYSQL_PORT} \
   -u ${MYSQL_USER} \
   -p${MYSQL_PASSWORD} \
   ${DATABASE_NAME} > ${DATABASE_NAME}.sql
 
if [ $? -eq 0 ]; then
  echo "Database backup successfully completed"
else
  echo "Error found during backup"
  exit 1
fi

#Create database and user for database
echo "Creating database: ${1} and user: ${1}"	
mysql -h ${MYSQL_HOST} \
	-P ${MYSQL_PORT} \
	-u ${MYSQL_USER} \
	-p${MYSQL_PASSWORD} \
	-e "
	CREATE DATABASE ${1} /*\!40100 DEFAULT CHARACTER SET utf8 */;
	CREATE USER ${1}@localhost IDENTIFIED BY '${PROJECT_PASSWORD}';
	GRANT ALL PRIVILEGES ON ${1}.* TO '${1}'@'localhost';
	FLUSH PRIVILEGES;"

#Import copy database into new project database
echo "Importing database: ${DATABASE_NAME} into database: ${1}"	
mysql -u${MYSQL_USER} -p${MYSQL_PASSWORD} ${1} < ${DATABASE_NAME}.sql

#Updating URLs in project database
echo "Updating URLs in project database: ${1}"	
mysql -h ${MYSQL_HOST} \
	-P ${MYSQL_PORT} \
	-u ${MYSQL_USER} \
	-p${MYSQL_PASSWORD} \
	${1} \
	-e "
	UPDATE ${TABLE_PREFIX}_options SET option_value = replace(option_value, 'http://${DATABASE_NAME}.christinewilson.ca', 'http://${1}.christinewilson.ca') WHERE option_name = 'home' OR option_name = 'siteurl';
	UPDATE ${TABLE_PREFIX}_posts SET guid = replace(guid, 'http://${DATABASE_NAME}.christinewilson.ca','http://${1}.christinewilson.ca');
	UPDATE ${TABLE_PREFIX}_postmeta SET meta_value = replace(meta_value,'http://${DATABASE_NAME}.christinewilson.ca','http://${1}.christinewilson.ca');
	"
	
echo "Updating wp-config to have current database and table prefix"	
sed -i "s/default_/${TABLE_PREFIX}_/g" /var/www/${1}/public_html/wp-config.php
sed -i "s/default/${1}/g" /var/www/${1}/public_html/wp-config.php