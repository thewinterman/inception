FROM debian:12-slim

RUN apt-get update \
	&& apt-get install --no-install-recommends -y \
		curl \
		gettext-base \
		nginx \
		openssl \
	&& rm -rf /var/lib/apt/lists/* \
	&& rm -f /etc/nginx/sites-enabled/default \
	&& mkdir -p /etc/nginx/ssl /run/nginx

COPY conf/nginx.conf.template /etc/nginx/templates/nginx.conf.template
COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod 755 /usr/local/bin/entrypoint.sh

EXPOSE 443

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
