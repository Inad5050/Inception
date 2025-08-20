#!/bin/sh
set -e

# Espera activa hasta que el servicio de MariaDB esté listo para aceptar conexiones.
echo "Esperando a MariaDB..."
until mysqladmin ping -h"mariadb" --silent; do
    sleep 1
done
echo "MariaDB está listo."

# Si no hay una instalación de WordPress, la realiza.
if [ ! -f "wp-config.php" ]; then
    echo "Configurando WordPress por primera vez..."

    # Descarga los archivos de WordPress y los coloca en el directorio actual.
    wp core download --allow-root

    # Crea el archivo wp-config.php usando las variables de entorno.
    wp config create \
        --dbname="$WORDPRESS_DB_NAME" \
        --dbuser="$WORDPRESS_DB_USER" \
        --dbpass="$(cat "$WORDPRESS_DB_PASSWORD_FILE")" \
        --dbhost="$WORDPRESS_DB_HOST" \
        --allow-root

    # Instala WordPress, creando el usuario administrador.
    wp core install \
        --url="$DOMAIN_NAME" \
        --title="Inception" \
        --admin_user="wp_admin" \
        --admin_password="wp_admin_pass" \
        --admin_email="admin@example.com" \
        --allow-root

    # Crea un segundo usuario no administrador.
    wp user create editor_user editor@example.com --role=editor --user_pass=editor_pass --allow-root
    
    echo "WordPress instalado correctamente."
fi

# Asegura que el usuario de PHP-FPM (www-data) sea el propietario de los archivos.
# Esto es crucial para que WordPress pueda gestionar plugins y subidas de archivos.
chown -R www-data:www-data /var/www/html

echo "Iniciando PHP-FPM..."
exec "$@"
