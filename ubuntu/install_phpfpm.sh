#!/bin/bash

# make sure this script is running as root
if [ "$EUID" -ne 0 ]
  then echo "${RED}Please run as root${NC}"
  exit
fi

# install multiple versions of php-fpm
IFS=' '
read -a phpvers <<< "$PHP_VERSIONS"
for ver in "${phpvers[@]}";
do
  source ~/.bashrc
  apt-get install php$ver php$ver-fpm php$ver-mysql php$ver-curl php$ver-gd php$ver-mbstring php$ver-xml php$ver-zip php$ver-imagick libapache2-mod-php$ver libapache2-mod-fcgid -y
done