#!/bin/bash

# Configure MariaDB to accept connections from any host
sed -i 's/bind-address.*=.*/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf

# Initialize MySQL data directory if it doesn't exist
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MySQL data directory..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

# Start MySQL temporarily to configure it
echo "Starting MySQL temporarily for configuration..."
mysqld_safe --user=mysql --datadir=/var/lib/mysql --skip-networking &
MYSQL_PID=$!

# Wait for MySQL to start
echo "Waiting for MySQL to start..."
while ! mysqladmin ping --silent; do
    sleep 1
done

echo "MySQL is running, configuring database..."

# Create database and user
mysql -u root <<EOF
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
FLUSH PRIVILEGES;
EOF

echo "Database configuration completed!"

# Stop the temporary MySQL instance
mysqladmin -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown
wait $MYSQL_PID

echo "Starting MySQL in foreground..."
# Start MySQL in foreground
exec mysqld_safe --user=mysql --datadir=/var/lib/mysql
