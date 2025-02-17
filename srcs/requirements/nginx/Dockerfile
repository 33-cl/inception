# Use the image of debian 11
FROM debian:bullseye

# Update apt and install nginx
RUN apt-get update && \
    apt-get install -y nginx && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* \