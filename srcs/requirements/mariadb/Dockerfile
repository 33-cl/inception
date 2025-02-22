FROM debian:11

RUN apt update -y && apt upgrade -y

RUN apt install -y mariadb-server

COPY conf/50-server.cnf	/etc/mysql/mariadb.conf.d/50-server.cnf

COPY init_db.sh /init_db.sh
RUN chmod +x /init_db.sh

COPY .env /root/.env

EXPOSE 3306

ENTRYPOINT ["/init_db.sh"]

CMD ["mysqld_safe"]