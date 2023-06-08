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
apt install build-essential software-properties-common uglifyjs npm composer jpegoptim optipng webp curl zip unzip -y

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
source ~/.bashrc
nvm install lts/gallium

# install node yarn
echo "${GREEN}********************"
echo "${GREEN}*** INSTALL YARN ***"
echo "${GREEN}********************${NC}"

npm install -g yarn

# install node dart-sass
echo "${GREEN}******************************"
echo "${GREEN}*** INSTALL NODE DART-SASS ***"
echo "${GREEN}******************************${NC}"

npm install -g sass

# install node minify
echo "${GREEN}***************************"
echo "${GREEN}*** INSTALL NODE MINIFY ***"
echo "${GREEN}***************************${NC}"

npm install -g minify

# install node gulp
echo "${GREEN}*************************"
echo "${GREEN}*** INSTALL NODE GULP ***"
echo "${GREEN}*************************${NC}"

npm install -g gulp gulp-cli

# install node react
echo "${GREEN}**************************"
echo "${GREEN}*** INSTALL NODE REACT ***"
echo "${GREEN}**************************${NC}"

npm install -g react react-dom

# install node typescript
echo "${GREEN}*******************************"
echo "${GREEN}*** INSTALL NODE TYPESCRIPT ***"
echo "${GREEN}*******************************${NC}"

npm install -g typescript@2.8.0

# install node dir-archiver
echo "${GREEN}*********************************"
echo "${GREEN}*** INSTALL NODE DIR-ARCHIVER ***"
echo "${GREEN}*********************************${NC}"
npm install -g dir-archiver

# install node uglifyjs
echo "${GREEN}*****************************"
echo "${GREEN}*** INSTALL NODE UGLIFYJS ***"
echo "${GREEN}*****************************${NC}"
npm install -g uglifyjs
