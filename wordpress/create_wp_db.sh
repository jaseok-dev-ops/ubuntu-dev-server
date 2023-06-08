#!/bin/bash

echo "${GREEN}*****************************"
echo "${GREEN}*** ADDING WP DB AND USER ***"
echo "${GREEN}*****************************${NC}"

echo "Required - Enter your MySQL root user password"
until read -r -p "MySQL root password: " dbrootpw && test "$dbrootpw" != ""; do
  continue
done
history -s "$dbrootpw"

mysql -uroot -p$dbrootpw -e "CREATE DATABASE ${DEV_WP_DB_NAME};"
mysql -uroot -p$dbrootpw -e "CREATE USER '${DEV_WP_DB_USER}'@'localhost' IDENTIFIED BY '${DEV_WP_DB_PASS}'";
mysql -uroot -p$dbrootpw -e "CREATE USER '${DEV_WP_DB_USER}'@'%' IDENTIFIED BY '${DEV_WP_DB_PASS}'";
mysql -uroot -p$dbrootpw -e "GRANT ALL PRIVILEGES ON ${DEV_WP_DB_NAME}.* TO '${DEV_WP_DB_USER}'@'localhost'";
mysql -uroot -p$dbrootpw -e "GRANT ALL PRIVILEGES ON ${DEV_WP_DB_NAME}.* TO '${DEV_WP_DB_USER}'@'%'";
mysql -uroot -p$dbrootpw -e "FLUSH PRIVILEGES;";

echo "New database and user added"
