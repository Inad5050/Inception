#!/bin/bash

# Espera a que el servicio MariaDB esté disponible para aceptar conexiones.
# La directiva depends_on: en en docker-compose solo garantiza que MariaDB se inicie antes de WP,
# no garantiza que MariaDB este disponible.
until mysqladmin ping -h"$WORDPRESS_DB_HOST" --silent; do
    echo "Waiting for database..."
    sleep 2
done

# if [] Comprueba si WP ya ha sido instalado.
# 	! es el operador de negación.
# 	-f "wp-config.php" comprueba si el archivo wp-config.php existe.
# 	Si no existe, ejecuta los comandos de wp-cli para crear el archivo de configuración wp-config.php
# 	e instala el nucleo de WP.
# "wp config create" es uno de los comandos de wp-cli
#	nos ahorra tener que usar curl y similares
if [ ! -f "wp-config.php" ]; then
    # Usa wp-cli para generar el fichero wp-config.php con las credenciales de la base de datos.
    wp config create \
        --dbname="$WORDPRESS_DB_NAME" \
        --dbuser="$WORDPRESS_DB_USER" \
        --dbpass="$WORDPRESS_DB_PASSWORD" \
        --dbhost="$WORDPRESS_DB_HOST" \
        --allow-root

    # Instala WordPress (título del sitio, usuario admin, etc.).
    wp core install \
        --url=${DOMAIN_NAME} \
        --title="My WordPress Site" \
        --admin_user="$WORDPRESS_DB_ADMIN_USER" \
        --admin_password="$WORDPRESS_DB_ADMIN_PASSWORD" \
        --admin_email=dangonz3@example.com \
        --allow-root
fi

# Ejecuta el comando principal del contenedor (CMD).
exec "$@"
