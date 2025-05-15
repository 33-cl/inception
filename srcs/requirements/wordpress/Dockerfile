FROM debian:bullseye

# Install required packages
RUN apt-get update && apt-get install -y \
    php7.4 \
    php7.4-fpm \
    php7.4-mysql \
    php7.4-json \
    php7.4-curl \
    php7.4-mbstring \
    php7.4-xml \
    php7.4-zip \
    php7.4-gd \
    mariadb-client \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Configure PHP-FPM
RUN mkdir -p /run/php
COPY ./conf/www.conf /etc/php/7.4/fpm/pool.d/

# Install WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# Copy initialization script
COPY ./tools/init_wordpress.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/init_wordpress.sh

# Expose port
EXPOSE 9000

# Set working directory
WORKDIR /var/www/html

# Set entrypoint
ENTRYPOINT ["/usr/local/bin/init_wordpress.sh"] 