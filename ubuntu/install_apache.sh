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

apt install apache2 libapache2-mod-php libapache2-mod-security2 -y

a2enmod rewrite expires headers ssl http2 cache proxy proxy_http proxy_fcgi setenvif security2 unique_id remoteip filter deflate mime

sed -i "s/www-data/$LOCAL_SYSTEM_USER/g" /etc/apache2/envvars

systemctl enable apache2
systemctl restart apache2

echo "${GREEN} Apache Web Server finished successfully${NC}"
