FROM debian:12-slim

RUN apt-get update \
	&& apt-get install --no-install-recommends -y mariadb-server \
	&& rm -rf /var/lib/apt/lists/* \
	&& mkdir -p /run/mysqld \
	&& chown mysql:mysql /run/mysqld

COPY conf/99-inception.cnf /etc/mysql/mariadb.conf.d/99-inception.cnf
COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod 755 /usr/local/bin/entrypoint.sh

EXPOSE 3306

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["mariadbd", "--user=mysql"]
