#!/bin/sh
set -eu

: "${DOMAIN_NAME:?DOMAIN_NAME must be set}"

envsubst '${DOMAIN_NAME}' \
    < /etc/nginx/templates/nginx.conf.template \
    > /etc/nginx/nginx.conf

if [ ! -f /etc/nginx/ssl/server.crt ] || [ ! -f /etc/nginx/ssl/server.key ]; then
    openssl req -x509 -nodes -newkey rsa:2048 -days 365 \
        -keyout /etc/nginx/ssl/server.key \
        -out /etc/nginx/ssl/server.crt \
        -subj "/C=FR/ST=Ile-de-France/L=Paris/O=42/OU=Inception/CN=${DOMAIN_NAME}"
fi

nginx -t
exec "$@"