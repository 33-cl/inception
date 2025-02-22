#!/bin/bash

# source /root/.env

# Launch MariaDB
service mariadb start;

# Wait for MariaDB to be ready
# while ! mysqladmin ping -h localhost --silent; do
#     sleep 1
# done

# Create table
mysql -e "CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;"

# Create user
mysql -e "CREATE USER IF NOT EXISTS \`${SQL_USER}\`@'localhost' IDENTIFIED BY '${SQL_PASSWORD}';"
mysql -e "GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO \`${SQL_USER}\`@'%' IDENTIFIED BY '${SQL_PASSWORD}';"

# Change root password
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';"

# Reset privileges
mysql -e "FLUSH PRIVILEGES;"

# Restart MySQL
mysqladmin -u root -p${SQL_ROOT_PASSWORD} shutdown
exec mysqld_safe