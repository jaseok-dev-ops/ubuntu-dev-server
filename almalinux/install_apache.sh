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

dnf -y install apache2

# Enable Apache modules
a2enmod php7.4
a2enmod php8.0
a2enmod php8.1
a2enmod php8.2
a2enmod wordpress

# configure apache vhost
sudo mkdir -p "$vhostdir/$hostname/public_html"
sudo chown -R $username:$username "$vhostdir/$hostname"
sudo chmod -R 755 "$vhostdir/$hostname/public_html"
sudo tee "/etc/httpd/conf.d/$hostname.conf" > /dev/null <<EOF
<VirtualHost *:80>
    ServerName $hostname
    DocumentRoot $vhostdir/$hostname/public_html
    ErrorLog /var/log/httpd/$hostname_error.log
    CustomLog /var/log/httpd/$hostname_access.log combined
    <Directory $vhostdir/$hostname/public_html>
        AllowOverride All
        Require all granted
    </Directory>
    <FilesMatch \.php$>
        SetHandler "proxy:fcgi://127.0.0.1:9000"
    </FilesMatch>
</VirtualHost>
EOF

# update hosts file
sudo sed -i "/^127.0.0.1/s/$/ $hostname/" /etc/hosts