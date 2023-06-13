#!/bin/bash

# do not run this script as root
if [ "$EUID" -eq 0 ]
  then echo "${RED}Please do not run as root${NC}"
  exit
fi 

# check for DEV_WP_LOCAL_DOMAIN env var and if it doesn't exist ask for domain name and do not continue until a domain name is entered
if [ -z "$DEV_LOCAL_DOMAIN" ]
  then
    echo "${RED}Please enter the domain name for your local development environment${NC}"
    read domain
    export DEV_LOCAL_DOMAIN=$domain
fi

# create the vhost directory
mkdir -p $DEV_HTTP_DIR/$DEV_LOCAL_DOMAIN

# copy the vhost template to the apache sites available directory
cp $LOCAL_SYSTEM_USER_HOME/ubuntu-dev-server/configs/apache/default.template.conf /etc/apache2/sites-availabe/$DEV_LOCAL_DOMAIN.conf

# replace the domain name in the vhost template with the domain name entered by the user
sed -i "s/DEV_LOCAL_DOMAIN/$DEV_LOCAL_DOMAIN/g" /etc/apache2/sites-availabe/$DEV_LOCAL_DOMAIN.conf

# replace the document root in the vhost template with the document root entered by the user
sed -i "s/DEV_HTTP_DIR/$DEV_HTTP_DIR/g" /etc/apache2/sites-availabe/$DEV_LOCAL_DOMAIN.conf

# replace the php version in the vhost template with the php version entered by the user
sed -i "s/DEFAULT_PHP_VERSION/$DEFAULT_PHP_VERSION/g" /etc/apache2/sites-availabe/$DEV_LOCAL_DOMAIN.conf

# enable the vhost
a2ensite $DEV_LOCAL_DOMAIN.conf

# restart apache
systemctl restart apache2
