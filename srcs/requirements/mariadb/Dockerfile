FROM debian:bullseye

# Install MariaDB
RUN apt-get update && apt-get install -y \
    mariadb-server \
    mariadb-client \
    && rm -rf /var/lib/apt/lists/*

# Copy configuration files
COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/
COPY ./tools/init_db.sh /tmp/

# Set execute permission on the script
RUN chmod +x /tmp/init_db.sh

# Expose MariaDB port
EXPOSE 3306

# Set entrypoint
ENTRYPOINT ["/tmp/init_db.sh"] 