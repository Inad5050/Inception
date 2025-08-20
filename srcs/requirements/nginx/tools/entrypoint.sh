#!/bin/sh
set -e

# Comprueba si el certificado SSL ya existe.
if [ ! -f /etc/nginx/ssl/inception.crt ]; then
    echo "Generando certificado SSL por primera vez..."
    # Crea el directorio si no existe.
    mkdir -p /etc/nginx/ssl
    # Genera el certificado usando la variable de entorno DOMAIN_NAME.
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout /etc/nginx/ssl/inception.key \
        -out /etc/nginx/ssl/inception.crt \
        -subj "/C=ES/ST=Bizkaia/L=Bilbao/O=42/CN=${DOMAIN_NAME}"
fi

# Pasa el control al comando principal (CMD), que es 'nginx'.
exec "$@"