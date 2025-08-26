#!/bin/bash

MYSQL_PASSWORD = $(cat "${MYSQL_PASSWORD_FILE}")

echo "Starting WordPress setup..."
echo "Database: $MYSQL_DATABASE"
echo "User: $MYSQL_USER" 
echo "Domain: $DOMAIN_NAME"

# Descarga la herramienta de línea de comandos de WordPress, WP-CLI. Para facilitar la instalación de WP.
# -O guarda el fichero con su nombre original, wp-cli.phar.
# lo mueve a /usr/local/bin/, es un directorio estándar para programas.
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp

# /var/www/html es la raíz estándar para los ficheros de una web. 
# chown cambia el propietario de la carpeta y de todos sus archivos (-R).
# www-data es el usuario que usan los servidores web como Nginx en Debian/Ubuntu.
mkdir -p /var/www/html
cd /var/www/html
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

# es un bucle de espera. 
# mariadb: es el cliente de Mariadb. 
# h mariadb: Intenta conectarse al servicio (que tambíen hemos llamado mariadb) de nuestro docker-compose.
# envía las credenciales de inicio de sesión user (-u) y password (-p).
# SELECT 1: Ejecuta una consulta SQL muy simple.
# &>/dev/null: redirige las salidas estandrd y de error a dev/null para mantener la consola vacía.
echo "Waiting for database..."
while ! mariadb -h mariadb -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_DATABASE" -e "SELECT 1;" &>/dev/null; do
    echo "Database not ready, waiting..."
    sleep 5
done
echo "✅ Database is ready!"

# comprueba si el archivo wp-load.php (un archivo clave de WP) existe. Si no descarga WP. 
if [ ! -f wp-load.php ]; then
    echo "Downloading WordPress..."
    wp core download --allow-root
fi

# comprueba si el archivo el archivo de configuración existe. 
# Si no lo crea con las variables de entorno de docker-compose.
# --allow-root: por defecto WP no deja usar root para evitar accidentes. Lo permitimos.
if [ ! -f wp-config.php ]; then
    echo "Creating wp-config.php..."
    wp config create \
        --dbname="$MYSQL_DATABASE" \
        --dbuser="$MYSQL_USER" \
        --dbpass="$MYSQL_PASSWORD" \
        --dbhost=mariadb:3306 \
        --allow-root
fi

# le pregunta a WP-CLI si WP está instalado. Si no lo instala.
if ! wp core is-installed --allow-root; then
    echo "Installing WordPress..."
    wp core install \
        --url=$DOMAIN_NAME \
        --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --allow-root
fi

# comprueba si el usuario WP_USERNAME existe. Si no existe lo crea. 
if ! wp user get "$WP_USERNAME" --field=ID --allow-root &> /dev/null; then
    echo "Creating user: $WP_USERNAME"
    wp user create \
        "$WP_USERNAME" "$WP_USER_EMAIL" \
        --user_pass="$WP_USER_PASSWORD" \
        --role="$WP_USER_ROLE" \
        --allow-root
fi

# sed -i ...: Usa el editor de texto sed para modificar un fichero de configuración de PHP-FPM.
# 's|...|...|': Busca la línea que empieza por listen = y la reemplaza por listen = 0.0.0.0:9000.
# Esto hace que PHP-FPM escuche peticiones en el puerto 9000 desde cualquier dirección de red 
# (para que Nginx pueda conectarse a él), en lugar de en un socket local.
echo "Configuring PHP-FPM..."
sed -i 's|^listen = .*|listen = 0.0.0.0:9000|' /etc/php/7.4/fpm/pool.d/www.conf

echo "✅ Starting PHP-FPM..."
exec "$@"
