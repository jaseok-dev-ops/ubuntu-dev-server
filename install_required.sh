#!/bin/bash

# make sure this script is running as root
if [ "$EUID" -ne 0 ]
  then echo "${RED}Please run as root${NC}"
  exit
fi

# add required repositories
echo '${GREEN}
************************************
*** ADDING REQUIRED REPOSITORIES ***
********** ppa:ondrej/php **********
************************************
${NC}
'
add-apt-repository ppa:ondrej/php

# update
echo '${GREEN}
***********************
*** GETTING UPDATES ***
***********************
${NC}
'
apt update -y

# install software
echo '${GREEN}
************************************
*** INSTALLING REQUIRED SOFTWARE ***
********** build-essential *********
**** software-properties-common ****
************* npm node *************
************************************
${NC}
'
apt install build-essential software-properties-common npm node

# install node dart-sass
echo '${GREEN}
******************************
*** INSTALL NODE DART-SASS ***
******************************
${NC}
'
npm install -g sass

# install node minify
echo '${GREEN}
***************************
*** INSTALL NODE MINIFY ***
***************************
${NC}
'
npm install -g minify
