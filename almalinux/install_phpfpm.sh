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
  echo "${GREEN}*****************************"
  echo "${GREEN}*** ENABLE PHP-FPM ${ver} ***"
  echo "${GREEN}*****************************${NC}"
  
  dnf module enable php:remi-${ver} -yx
done

echo "${GREEN}*********************************"
echo "${GREEN}*** INSTALLING PHP-FPM ${ver} ***"
echo "${GREEN}*********************************${NC}"

dnf install php-fpm php-cli php-mysqlnd php-gd php-json php-mbstring php-xml php-zip php-intl php-opcache -y

for ver in "${phpvers[@]}";
do
  echo "${GREEN}**********************************"
  echo "${GREEN}*** RESTARTINGs PHP-FPM ${ver} ***"
  echo "${GREEN}**********************************${NC}"

  systemctl enable php-fpm${ver}
  systemctl restart php-fpm${ver}
done