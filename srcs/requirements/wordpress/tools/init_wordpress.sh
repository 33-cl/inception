#!/bin/bash

# Function to wait for MariaDB to be ready
wait_for_mariadb() {
    echo "Waiting for MariaDB to be ready..."
    
    # Try to connect to MariaDB with a timeout
    for i in {1..30}; do
        if mysqladmin ping -h mariadb -u${MYSQL_USER} -p${MYSQL_PASSWORD} --silent; then
            echo "MariaDB is ready!"
            return 0
        fi
        echo "Waiting for MariaDB... attempt $i/30"
        sleep 2
    done
    
    echo "MariaDB connection failed after multiple attempts"
    return 1
}

# Ensure www-data owns the WordPress directory
chown -R www-data:www-data /var/www/html
cd /var/www/html

# Wait for MariaDB to be ready
wait_for_mariadb

# Check if WordPress is already installed
if [ ! -f "wp-config.php" ]; then
    echo "WordPress not found, downloading..."
    
    # Download WordPress core
    wp core download --allow-root
    
    echo "Creating WordPress configuration..."
    # Create wp-config.php
    wp config create --allow-root \
        --dbname=${MYSQL_DATABASE} \
        --dbuser=${MYSQL_USER} \
        --dbpass=${MYSQL_PASSWORD} \
        --dbhost=mariadb
    
    echo "Installing WordPress..."
    # Install WordPress
    wp core install --allow-root \
        --url=${DOMAIN_NAME} \
        --title="${WP_TITLE}" \
        --admin_user=${WP_ADMIN_USER} \
        --admin_password=${WP_ADMIN_PASSWORD} \
        --admin_email=${WP_ADMIN_EMAIL} \
        --skip-email
    
    echo "Creating additional user..."
    # Create additional user
    wp user create --allow-root \
        ${WP_USER} ${WP_USER_EMAIL} \
        --user_pass=${WP_USER_PASSWORD} \
        --role=author
    
    # Set up the theme and configuration
    wp theme install twentytwentyfour --activate --allow-root
    
    # Create sample content
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
    
    echo "WordPress installation complete!"
else
    echo "WordPress already installed"
fi

echo "Updating permissions..."
# Ensure proper permissions
chown -R www-data:www-data /var/www/html
find /var/www/html -type d -exec chmod 755 {} \;
find /var/www/html -type f -exec chmod 644 {} \;

echo "Starting PHP-FPM..."
# Start PHP-FPM in foreground
exec php-fpm7.4 -F 