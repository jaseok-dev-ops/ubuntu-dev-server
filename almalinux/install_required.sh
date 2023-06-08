#!/bin/bash

# make sure this script is running as root
if [ "$EUID" -ne 0 ]
  then echo "${RED}Please run as root${NC}"
  exit
fi

# add required repositories
echo "${GREEN}************************************"
echo "${GREEN}*** ADDING REQUIRED REPOSITORIES ***"
echo "${GREEN}*********** epel-release ***********"
echo "${GREEN}*********** remi-release ***********"
echo "${GREEN}************************************${NC}"

dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm
dnf install -y https://rpms.remirepo.net/enterprise/remi-release-9.rpm
dnf install -y https://rpms.remirepo.net/enterprise/9/remi/x86_64/php-fedora-autoloader-1.0.1-2.el9.remi.noarch.rpm

# update
echo "${GREEN}***********************"
echo "${GREEN}*** GETTING UPDATES ***"
echo "${GREEN}***********************${NC}"

dnf -y update
dnf -y upgrade

# install Node and Dev Tools
echo "${GREEN}************************************"
echo "${GREEN}*** INSTALLING REQUIRED SOFTWARE ***"
echo "${GREEN}********* Development Tools ********"
echo "${GREEN}************* and more *************"
echo "${GREEN}************************************${NC}"

dnf -y groupinstall "Development Tools"
dnf -y install curl gcc-c++ make composer jpegoptim optipng pngquant gifsicle webp parallel ImageMagick ImageMagick-devel libjpeg-turbo-devel libpng-devel libwebp-devel libXpm-devel libtiff-devel libzip-devel libxml2-devel libicu-devel libmcrypt-devel libcurl-devel libedit-devel libxslt-devel libtidy-devel libargon2-devel geoip geoip-devel openssl openssl-devel sox
curl -sL https://rpm.nodesource.com/setup_14.x | sudo bash -
dnf install -y nodejs

# install node dart-sass
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

npm install -g typescript@>=2.8.0

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

echo "Required software installation completed."
