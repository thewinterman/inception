FROM debian:12-slim

ARG WORDPRESS_VERSION=6.8.3

RUN apt-get update \
	&& apt-get install --no-install-recommends -y \
		ca-certificates \
		curl \
		mariadb-client \
		php-cli \
		php-fpm \
		php-curl \
		php-gd \
		php-mbstring \
		php-mysql \
		php-xml \
		php-zip \
		unzip \
	&& mkdir -p /usr/src/wordpress /var/www/html \
	&& curl -fsSL "https://wordpress.org/wordpress-${WORDPRESS_VERSION}.zip" -o /tmp/wordpress.zip \
	&& unzip -q /tmp/wordpress.zip -d /tmp \
	&& mv /tmp/wordpress/* /usr/src/wordpress/ \
	&& curl -fsSL https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -o /usr/local/bin/wp \
	&& chmod 755 /usr/local/bin/wp \
	&& sed -ri 's!^error_log = .*!error_log = /proc/self/fd/2!' /etc/php/8.2/fpm/php-fpm.conf \
	&& rm -rf /tmp/* /var/lib/apt/lists/*

COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf
COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod 755 /usr/local/bin/entrypoint.sh

WORKDIR /var/www/html

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["php-fpm8.2", "-F"]
