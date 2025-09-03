FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    nginx \
    openssl \
    && rm -rf /var/lib/apt/lists/*

# Create SSL certificates
RUN mkdir -p /etc/ssl/certs /etc/ssl/private && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/ssl/private/maeferre.42.fr.key \
    -out /etc/ssl/certs/maeferre.42.fr.crt \
    -subj "/C=FR/ST=France/L=Paris/O=42/CN=maeferre.42.fr"

# Copy nginx configuration
COPY conf/nginx.conf /etc/nginx/nginx.conf

# Create log directory
RUN mkdir -p /var/log/nginx

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]