!#/bin/bash

#!/bin/bash

# make sure this script is running as root
if [ "$EUID" -ne 0 ]
  then echo "${RED}Please run as root${NC}"
  exit
fi

read -p "Do you want to install phpMyAdmin (optional)? (Y|y/N|n): " answer

# Convert the answer to lowercase
answer=${answer,,}

if [[ $answer == "y" ]]; then
    # Install phpMyAdmin
    echo "${GREEN}*****************************"
    echo "${GREEN}*** INSTALLING PHPMYADMIN ***"
    echo "${GREEN}*****************************${NC}"

    # Download and install phpMyAdmin
    sudo dnf install -y phpMyAdmin

    # Configure Apache to allow access to phpMyAdmin
    sudo cp /etc/httpd/conf.d/phpMyAdmin.conf /etc/httpd/conf.d/phpMyAdmin.conf.bak
    sudo sed -i 's/Require ip 127.0.0.1/Require all granted/' /etc/httpd/conf.d/phpMyAdmin.conf

    # Restart Apache
    sudo systemctl restart httpd

    echo "phpMyAdmin has been installed successfully."
else
    echo "phpMyAdmin installation skipped."
fi