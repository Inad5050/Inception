#!/bin/sh
set -e

if [ ! -f /etc/nginx/ssl/inception.crt ]; then
    echo "Generando certificado SSL..."
    mkdir -p /etc/nginx/ssl
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout /etc/nginx/ssl/inception.key \
        -out /etc/nginx/ssl/inception.crt \
        -subj "/C=ES/ST=Bizkaia/L=Bilbao/O=42/CN=${DOMAIN_NAME}"
fi

exec "$@"