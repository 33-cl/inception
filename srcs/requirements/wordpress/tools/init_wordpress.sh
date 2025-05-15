#!/bin/bash

# Wait for MariaDB to be ready (simpler approach)
echo "Waiting for MariaDB to be ready..."
sleep 10

# Check if WordPress is already installed
if [ ! -f "wp-config.php" ]; then
    echo "WordPress not found, downloading..."
    # Download WordPress core
    wp core download --allow-root

    # Create wp-config.php
    wp config create --allow-root \
        --dbname=${MYSQL_DATABASE} \
        --dbuser=${MYSQL_USER} \
        --dbpass=${MYSQL_PASSWORD} \
        --dbhost=mariadb

    # Wait a bit more for MariaDB to be fully ready for connections
    sleep 5

    # Install WordPress (completely automated, no installation page)
    wp core install --allow-root \
        --url=${DOMAIN_NAME} \
        --title=${WP_TITLE} \
        --admin_user=${WP_ADMIN_USER} \
        --admin_password=${WP_ADMIN_PASSWORD} \
        --admin_email=${WP_ADMIN_EMAIL} \
        --skip-email

    # Create additional user
    wp user create --allow-root \
        ${WP_USER} ${WP_USER_EMAIL} \
        --user_pass=${WP_USER_PASSWORD} \
        --role=author

    # Set up the theme and configuration
    wp theme install twentytwentyfour --activate --allow-root
    
    # Create a sample post and page
    wp post create --allow-root \
        --post_type=post \
        --post_title='Welcome to Inception' \
        --post_content='This is the Inception project by maeferre at 42.' \
        --post_status=publish
    
    wp post create --allow-root \
        --post_type=page \
        --post_title='About Inception' \
        --post_content='This is a WordPress site created for the Inception project at 42.' \
        --post_status=publish

    # Update options
    wp option update --allow-root blogdescription "Projet Inception 42"
    wp option update --allow-root permalink_structure '/%postname%/'

    # Update permissions
    chown -R www-data:www-data /var/www/html
else
    echo "WordPress already installed"
fi

echo "Starting PHP-FPM..."
# Start PHP-FPM in foreground
exec php-fpm7.4 -F 