#!/bin/bash

# make sure this script is running as root
if [ "$EUID" -ne 0 ]
  then echo "${RED}Please run as root${NC}"
  exit
fi

# install mariadb server
echo "${GREEN}*********************************"
echo "${GREEN}*** INSTALLING MARIADB SERVER ***"
echo "${GREEN}*********************************${NC}"

dnf -y install mariadb-server
systemctl start mariadb
mysql_secure_installations
systemctl enable mariadb
systemctl restart mariadb

echo "MariadDB server installation completed."
