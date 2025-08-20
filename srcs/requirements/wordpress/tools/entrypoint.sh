#!/bin/sh
set -e

# La lógica de espera manual ha sido eliminada.
# Docker no ejecutará este script hasta que MariaDB esté 'healthy'.
echo "MariaDB está listo. Iniciando configuración de WordPress..."

if [ ! -f "/var/www/html/wp-config.php" ]; then
    echo "'wp-config.php' no encontrado. Iniciando instalación..."

    wp core download --allow-root
    
    wp config create \
        --dbname="$WORDPRESS_DB_NAME" \
        --dbuser="$WORDPRESS_DB_USER" \
        --dbpass="$(cat "$WORDPRESS_DB_PASSWORD_FILE")" \
        --dbhost="$WORDPRESS_DB_HOST" \
        --allow-root

    wp core install \
        --url="$DOMAIN_NAME" \
        --title="Inception" \
        --admin_user="wp_admin" \
        --admin_password="wp_admin_pass" \
        --admin_email="admin@example.com" \
        --allow-root

    wp user create editor_user editor@example.com --role=editor --user_pass="editor_pass" --allow-root
else
    echo "'wp-config.php' encontrado. Omitiendo instalación."
fi

chown -R www-data:www-data /var/www/html

echo "Iniciando PHP-FPM..."
exec "$@"