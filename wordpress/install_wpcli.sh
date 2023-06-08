#!/bin/bash

# WP-CLI installation script for Linux
# Created by JASEOK DEV OPS

# make sure this script is running as root
if [ "$EUID" -ne 0 ]
  then echo "${RED}Please run as root${NC}"
  exit
fi

echo "${GREEN}*************************"
echo "${GREEN}*** INSTALLING WP CLI ***"
echo "${GREEN}*************************${NC}"

curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp

echo "${GREEN} wp cli installation completed."
