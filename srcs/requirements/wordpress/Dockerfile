FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    php7.4-fpm \
    php7.4-mysql \
    php7.4-curl \
    php7.4-gd \
    php7.4-xml \
    php7.4-mbstring \
    php7.4-zip \
    wget \
    curl \
    unzip \
    mariadb-client \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install WP-CLI correctly
RUN wget https://github.com/wp-cli/wp-cli/releases/download/v2.8.1/wp-cli-2.8.1.phar -O /usr/local/bin/wp && \
    chmod +x /usr/local/bin/wp

# Configure PHP-FPM
RUN sed -i 's/listen = \/run\/php\/php7.4-fpm.sock/listen = 0.0.0.0:9000/g' /etc/php/7.4/fpm/pool.d/www.conf && \
    sed -i 's/;listen.owner = www-data/listen.owner = www-data/g' /etc/php/7.4/fpm/pool.d/www.conf && \
    sed -i 's/;listen.group = www-data/listen.group = www-data/g' /etc/php/7.4/fpm/pool.d/www.conf && \
    sed -i 's/;clear_env = no/clear_env = no/g' /etc/php/7.4/fpm/pool.d/www.conf && \
    mkdir -p /run/php

# Create wordpress directory
RUN mkdir -p /var/www/html && \
    chown -R www-data:www-data /var/www/html

COPY tools/wp-auto-install.sh /usr/local/bin/wp-auto-install.sh
RUN chmod +x /usr/local/bin/wp-auto-install.sh

WORKDIR /var/www/html

EXPOSE 9000

CMD ["/usr/local/bin/wp-auto-install.sh"]