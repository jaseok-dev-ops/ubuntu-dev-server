#!/bin/bash

# make sure this script is running as root
if [ "$EUID" -ne 0 ]
  then echo "${RED}Please run as root${NC}"
  exit
fi

# install apache web server
echo '${GREEN}
************************************
*** INSTALLING APACHE WEB SERVER ***
************************************
${NC}
'
apt install apache2 -y