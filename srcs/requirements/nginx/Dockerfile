# Use the image of debian 11
FROM debian:11

# Update apt and install nginx
RUN apt-get update && \
    apt-get install -y nginx && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* \