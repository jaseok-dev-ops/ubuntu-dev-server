#!/bin/bash

# install wpcli if not already installed
if typeset -f wp > /dev/null; then
    sudo $DEV_SCRIPT_PATH/wordpress/install_wpcli.sh
fi

# install wordpress
echo "${GREEN}****************************"
echo "${GREEN}*** INSTALLING WORDPRESS ***"
echo "${GREEN}****************************${NC}"

mkdir -p $DEV_HTTP_DIR/$DEV_WP_LOCAL_DOMAIN
cd $DEV_HTTP_DIR/$DEV_WP_LOCAL_DOMAIN

wp core download --force
wp config create --dbname=$DEV_WP_DB_NAME --dbuser=$DEV_WP_DB_USER --dbpass=$DEV_WP_DB_PASS --dbprefix=$DEV_WP_DB_PREFIX --dbhost=localhost --skip-check --force
wp core install --url=$DEV_WP_LOCAL_DOMAIN --title=$DEV_WP_SITE_TITLE --admin_user=$DEV_WP_ADMIN_USER --admin_password=$DEV_WP_ADMIN_PASS

echo "WordPress installation completed."
