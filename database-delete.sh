#!/bin/bash

export PATH=/bin:/usr/bin:/usr/local/bin
 
################################################################
################## Update below values  ########################

MYSQL_HOST='localhost'
MYSQL_PORT='3306'
MYSQL_USER='root'
MYSQL_PASSWORD='57575757aA'
 
#################################################################

#Updating URLs in project database
echo "Dropping database and user: ${1}"	
mysql -h ${MYSQL_HOST} \
	-P ${MYSQL_PORT} \
	-u ${MYSQL_USER} \
	-p${MYSQL_PASSWORD} \
	${1} \
	-e "
	DROP USER '${1}'@'localhost';
	DROP DATABASE ${1};
	"