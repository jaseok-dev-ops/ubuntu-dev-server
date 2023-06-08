#!/bin/bash

# make sure this script is running as root
if [ "$EUID" -ne 0 ]
  then echo "${RED}Please run as root${NC}"
  exit
fi

# install apache web server
echo "${GREEN}************************************"
echo "${GREEN}*** INSTALLING APACHE WEB SERVER ***"
echo "${GREEN}************************************${NC}"

apt install apache2 -y

a2enmod rewrite
a2enmod expires
a2enmod cache
a2enmod headers
a2enmod ssl
a2enmod proxy
a2enmod proxy_http

systemctl restart apache2

echo "${GREEN} Apache Web Server finished successfully${NC}"
