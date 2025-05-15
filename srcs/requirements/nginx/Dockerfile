FROM debian:bullseye

# Install NGINX and OpenSSL
RUN apt-get update && apt-get install -y \
    nginx \
    openssl \
    && rm -rf /var/lib/apt/lists/*

# Create SSL certificate
RUN mkdir -p /etc/nginx/ssl
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/nginx.key \
    -out /etc/nginx/ssl/nginx.crt \
    -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=maeferre.42.fr"

# Copy NGINX configuration
COPY ./conf/nginx.conf /etc/nginx/conf.d/default.conf

# Expose HTTPS port
EXPOSE 443

# Start NGINX in foreground
CMD ["nginx", "-g", "daemon off;"] 