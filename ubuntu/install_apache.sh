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