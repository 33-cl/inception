# Use the image of debian 11
FROM debian:bullseye

# Update apt and install nginx
RUN apt-get update && \
    apt-get install -y nginx && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Nginx configuration file
COPY nginx.conf /etc/nginx/nginx.conf

# Expose port 443 as required in the subject
EXPOSE  443

# Launch nginx
ENTRYPOINT ["nginx", "-g", "daemon off;"]
