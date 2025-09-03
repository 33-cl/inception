#!/bin/bash

# Create PHP-FPM run directory
mkdir -p /run/php

# Set basic permissions
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

echo "Starting WordPress automatic installation..."

# Wait for MariaDB to be ready
echo "Waiting for MariaDB..."
for i in {1..60}; do
    if mysqladmin ping -h"mariadb" -u"$WORDPRESS_DB_USER" -p"$WORDPRESS_DB_PASSWORD" --silent 2>/dev/null; then
        echo "MariaDB is ready!"
        break
    fi
    echo "Attempt $i/60: Still waiting for database..."
    sleep 2
done

echo "Database connection successful!"

# Setup WordPress
cd /var/www/html

# Download WordPress if not present
if [ ! -f wp-config.php ]; then
    echo "Downloading WordPress core..."
    wp core download --allow-root

    echo "Creating wp-config.php..."
    wp config create \
        --dbname="$WORDPRESS_DB_NAME" \
        --dbuser="$WORDPRESS_DB_USER" \
        --dbpass="$WORDPRESS_DB_PASSWORD" \
        --dbhost="mariadb" \
        --allow-root

    echo "WordPress core downloaded and configured!"
fi

# Check if WordPress is installed and install if not
if ! wp core is-installed --allow-root 2>/dev/null; then
    echo "Installing WordPress automatically..."
    
    wp core install \
        --url="https://$DOMAIN_NAME" \
        --title="$WORDPRESS_TITLE" \
        --admin_user="$WORDPRESS_ADMIN_USER" \
        --admin_password="$WORDPRESS_ADMIN_PASSWORD" \
        --admin_email="$WORDPRESS_ADMIN_EMAIL" \
        --allow-root

    echo "WordPress core installation completed!"

    # Create additional user
    echo "Creating additional user..."
    wp user create "$WORDPRESS_USER" "$WORDPRESS_USER_EMAIL" \
        --user_pass="$WORDPRESS_USER_PASSWORD" \
        --role=author \
        --allow-root

    echo "Additional user created!"
    echo "WordPress installation fully completed!"
else
    echo "WordPress is already installed!"
fi

# Set correct permissions
chown -R www-data:www-data /var/www/html
find /var/www/html -type d -exec chmod 755 {} \;
find /var/www/html -type f -exec chmod 644 {} \;

echo "Starting PHP-FPM on port 9000..."

# Start PHP-FPM in foreground
exec php-fpm7.4 -F
