#!/bin/bash

set -e  # Stop the script on error

echo "Starting MariaDB..."
mysqld_safe &

echo "Waiting for MariaDB to start..."
while ! mysqladmin ping -h localhost -u root -p${SQL_ROOT_PASSWORD} --silent; do
    sleep 1
done

echo "Creating database '${SQL_DATABASE}'..."
mysql -u root -p${SQL_ROOT_PASSWORD} -e "CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;"

echo "Creating user '${SQL_USER}'..."
mysql -u root -p${SQL_ROOT_PASSWORD} -e "CREATE USER IF NOT EXISTS \`${SQL_USER}\`@'%' IDENTIFIED BY '${SQL_PASSWORD}';"
mysql -u root -p${SQL_ROOT_PASSWORD} -e "GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO \`${SQL_USER}\`@'%';"

echo "Configuring root password..."
mysql -u root -p${SQL_ROOT_PASSWORD} -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';"

echo "Applying changes..."
mysql -u root -p${SQL_ROOT_PASSWORD} -e "FLUSH PRIVILEGES;"

echo "MariaDB is ready."

# Keep MariaDB running
wait