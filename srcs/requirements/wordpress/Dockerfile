FROM debian:bullseye

RUN apt update -y && apt upgrade -y

RUN apt install -y wget
RUN apt-get install -y php7.4 php-fpm php-mysql mariadb-client

# Import wordpress as a tar file
RUN wget https://fr.wordpress.org/wordpress-6.0-fr_FR.tar.gz -P /var/www

# Extract the tar file
RUN cd /var/www && tar -xzf wordpress-6.0-fr_FR.tar.gz && rm wordpress-6.0-fr_FR.tar.gz

# Giving root permission to wordpress folder
RUN	chown -R root:root /var/www/wordpress

COPY conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf

RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp

EXPOSE 9000

CMD ["/usr/sbin/php-fpm7.4", "-F"]