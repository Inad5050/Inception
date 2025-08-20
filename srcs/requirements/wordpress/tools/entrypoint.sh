#!/bin/sh
set -e

# Pausa inicial para dar tiempo a los servicios a estabilizarse.
echo "Pausa de 5 segundos para estabilizar la red..."
sleep 5

# Espera activa hasta que el puerto de MariaDB esté abierto.
echo "Esperando a que el puerto de MariaDB esté abierto..."
while ! nc -z mariadb 3306; do
    echo "El puerto de MariaDB no responde. Reintentando en 1 segundo..."
    sleep 1
done
echo "El puerto de MariaDB está abierto. Conexión posible."

# Si no hay una instalación de WordPress, la realiza.
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

# Asegura que el usuario de PHP-FPM sea el propietario de los archivos.
chown -R www-data:www-data /var/www/html

echo "Iniciando PHP-FPM..."
exec "$@"