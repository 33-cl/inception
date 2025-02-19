# Use the image of debian 11
FROM debian:bullseye

# Update apt and install nginx
RUN apt update && apt upgrade -y
RUN apt install -y nginx
RUN apt install -y openssl
RUN mkdir -p /etc/nginx/ssl

# install minishell for

RUN openssl req -x509 -nodes -out /etc/nginx/ssl/inception.crt -keyout /etc/nginx/ssl/inception.key -subj "/C=FR/ST=Rhone/L=Lyon/O=42/OU=42/CN=login.42.fr/UID=login"

RUN chmod 644 /etc/nginx/ssl/inception.crt
RUN chmod 600 /etc/nginx/ssl/inception.key

RUN chmod 755 /var/www/html
RUN chown -R www-data:www-data /var/www/html

# Nginx configuration file
COPY conf/nginx.conf /etc/nginx/nginx.conf

# Expose port 443
EXPOSE 443

# Start nginx
CMD ["nginx", "-g", "daemon off;"]