#!/bin/bash

# make sure this script is running as root
if [ "$EUID" -ne 0 ]
  then echo "${RED}Please run as root${NC}"
  exit
fi

# install multiple versions of php-fpm
echo "${GREEN}**************************"
echo "${GREEN}*** INSTALLING PHP FPM ${PHP_VERSIONS} ***"
echo "${GREEN}**************************${NC}"

php_versions=( ${PHP_VERSIONS} )
for ver in "${php_versions[@]}";
do
    echo "${GREEN}*** INSTALLING PHP $ver ***${NC}"
    source ~/.bashrc
    apt-get install php$ver php$ver-fpm php$ver-mysql php$ver-curl php$ver-gd php$ver-mbstring php$ver-xml php$ver-zip php$ver-imagick libapache2-mod-php$ver libapache2-mod-fcgid -y

    # Set worker and group in PHP-FPM config file
    sed -i "s/www-data/$LOCAL_SYSTEM_USER/g" /etc/php/$ver/fpm/pool.d/www.conf

    # Restart PHP-FPM service
    systemctl enable php$ver-fpm
    systemctl restart php$ver-fpm
done

update-alternatives --set php /usr/bin/php$DEFAULT_PHP_VERSION
update-alternatives --set phar /usr/bin/phar$DEFAULT_PHP_VERSION
update-alternatives --set phar.phar /usr/bin/phar.phar$DEFAULT_PHP_VERSION
update-alternatives --set phpize /usr/bin/phpize$DEFAULT_PHP_VERSION
update-alternatives --set php-config /usr/bin/php-config$DEFAULT_PHP_VERSION
