#!/bin/sh
set -xe

echo "--- INICIANDO SCRIPT DE WORDPRESS ---"
echo "DEBUG: Variables de entorno recibidas:"
echo "WORDPRESS_DB_NAME: ${WORDPRESS_DB_NAME}"
echo "WORDPRESS_DB_USER: ${WORDPRESS_DB_USER}"
echo "WORDPRESS_DB_HOST: ${WORDPRESS_DB_HOST}"
echo "DOMAIN_NAME: ${DOMAIN_NAME}"
echo "-------------------------------------"
echo "DEBUG: Esperando a MariaDB en el host '${WORDPRESS_DB_HOST}'..."

# Bucle de espera activo.
until mysqladmin ping -h"mariadb" --silent; do
    echo "DEBUG: MariaDB no responde, reintentando en 2 segundos..."
    sleep 2
done
echo "DEBUG: Conexión con MariaDB establecida."

echo "DEBUG: Verificando estado del volumen en /var/www/html..."
ls -la /var/www/html

if [ ! -f "/var/www/html/wp-config.php" ]; then
    echo "DEBUG: 'wp-config.php' no encontrado. Iniciando instalación de WordPress..."

    wp core download --allow-root
    echo "DEBUG: Archivos de WordPress descargados. Estado del directorio:"
    ls -la /var/www/html

    wp config create \
        --dbname="$WORDPRESS_DB_NAME" \
        --dbuser="$WORDPRESS_DB_USER" \
        --dbpass="$(cat "$WORDPRESS_DB_PASSWORD_FILE")" \
        --dbhost="$WORDPRESS_DB_HOST" \
        --allow-root
    echo "DEBUG: 'wp-config.php' creado."

    wp core install \
        --url="$DOMAIN_NAME" \
        --title="Inception" \
        --admin_user="wp_admin" \
        --admin_password="wp_admin_pass" \
        --admin_email="admin@example.com" \
        --allow-root
    echo "DEBUG: 'wp core install' completado."

    wp user create editor_user editor@example.com --role=editor --user_pass=editor_pass --allow-root
    echo "DEBUG: Usuario adicional 'editor_user' creado."
else
    echo "DEBUG: 'wp-config.php' encontrado. Omitiendo instalación."
fi

echo "DEBUG: Asegurando que 'www-data' sea el propietario de /var/www/html..."
chown -R www-data:www-data /var/www/html
echo "DEBUG: Permisos finales en /var/www/html:"
ls -la /var/www/html

echo "--- FINALIZANDO SCRIPT DE WORDPRESS. Pasando control a php-fpm ---"
exec "$@"
