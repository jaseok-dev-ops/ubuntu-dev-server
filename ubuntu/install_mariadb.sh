#!/bin/bash

# make sure this script is running as root
if [ "$EUID" -ne 0 ]
  then echo "${RED}Please run as root${NC}"
  exit
fi

# install mariadb server
echo "${GREEN}
*********************************
*** INSTALLING MARIADB SERVER ***
*********************************
${NC}
"
apt install mariadb-server -y
mysql_secure_installation
systemctl enable mariadb
systemctl restart mariadb
