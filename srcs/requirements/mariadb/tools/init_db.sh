#!/bin/bash

# Start MariaDB service
if [ -d "/var/lib/mysql/mysql" ]; then
    # Database already initialized, just start MariaDB
    echo "Database already initialized, starting MariaDB..."
    # Supprime le dossier existant pour forcer une nouvelle configuration
    rm -rf /var/lib/mysql/*
    # Initialisation d'une nouvelle base de données
    echo "Reinitializing database..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
    
    # Start MariaDB to configure it
    mysqld_safe --datadir=/var/lib/mysql &
    
    # Wait for MariaDB to start
    until mysqladmin ping -hlocalhost --silent; do
        echo "Waiting for MariaDB to start..."
        sleep 1
    done

    # Configure MariaDB
    mysql -u root << EOF
-- Create database
CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;

-- Create user with full access from any host
CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';

-- Set root password and allow remote root access from any host
ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';
CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;

-- Apply privileges
FLUSH PRIVILEGES;
EOF

    # Shutdown MariaDB
    mysqladmin -u root -p$MYSQL_ROOT_PASSWORD shutdown
else
    # Initialize database
    echo "Initializing MariaDB database for the first time..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql

    # Start MariaDB to configure it
    mysqld_safe --datadir=/var/lib/mysql &
    
    # Wait for MariaDB to start
    until mysqladmin ping -hlocalhost --silent; do
        echo "Waiting for MariaDB to start..."
        sleep 1
    done

    # Configure MariaDB
    mysql -u root << EOF
-- Create database
CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;

-- Create user with full access from any host
CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';

-- Set root password and allow remote root access from any host
ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';
CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;

-- Apply privileges
FLUSH PRIVILEGES;
EOF

    # Shutdown MariaDB
    mysqladmin -u root -p$MYSQL_ROOT_PASSWORD shutdown
fi

# Start MariaDB in the foreground
exec mysqld_safe --datadir=/var/lib/mysql 