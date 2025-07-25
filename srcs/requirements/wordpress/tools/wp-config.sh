#!/bin/bash

# Espera a que el host de la base de datos esté disponible.
until mysqladmin ping -h"$WORDPRESS_DB_HOST" --silent; do
    echo "Waiting for database..."
    sleep 2
done

# Si el fichero wp-config.php no existe, créalo.
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
        --admin_user=dangonz3 \
        --admin_password=password \
        --admin_email=dangonz3@example.com \
        --allow-root
fi

# Ejecuta el comando principal del contenedor (CMD).
exec "$@"
