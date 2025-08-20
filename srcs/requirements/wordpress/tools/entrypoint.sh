#!/bin/sh

# 'set -e' hace que el script falle inmediatamente si un comando devuelve un error.
# Esto evita fallos silenciosos y facilita la depuración.
set -e

# --- 1. Espera a que MariaDB esté listo ---
echo "Esperando a que la base de datos MariaDB esté disponible..."
# Este bucle utiliza 'mysqladmin ping' para comprobar activamente la conexión.
# El script no continuará hasta que la base de datos responda.
# -h es el host (el nombre del servicio de MariaDB).
# -u y -p son el usuario y la contraseña (no necesarios para un 'ping' básico
# si la configuración de red lo permite, pero es buena práctica incluirlos).
# '--silent' evita que se imprima la salida del comando.
until mysqladmin ping -h"$WORDPRESS_DB_HOST" --silent; do
    echo "MariaDB no está listo todavía. Esperando..."
    sleep 2
done
echo "La base de datos MariaDB está lista."

# --- 2. Comprueba si WordPress ya está instalado ---
# Esto evita que el script intente reinstalar WordPress cada vez que el contenedor se reinicia,
# lo que corrompería la base de datos y los archivos.
if [ ! -f "wp-config.php" ]; then
    echo "WordPress no está instalado. Iniciando instalación..."

    # --- 3. Crea el archivo de configuración wp-config.php ---
    # Este comando se conecta a la base de datos para verificar las credenciales.
    wp config create \
        --dbname="$WORDPRESS_DB_NAME" \
        --dbuser="$MYSQL_USER" \
        --dbpass="$(cat "$MYSQL_PASSWORD_FILE")" \
        --dbhost="$WORDPRESS_DB_HOST" \
        --allow-root

    # --- 4. Instala WordPress ---
    # Esto crea las tablas en la base de datos y configura el sitio.
    # El usuario administrador 'wp_admin' cumple la norma de no usar 'admin'[cite: 107].
    wp core install \
        --url="$DOMAIN_NAME" \
        --title="Inception" \
        --admin_user="wp_admin" \
        --admin_password="wp_admin_pass" \
        --admin_email="admin@example.com" \
        --allow-root

    # Crea un segundo usuario, como se requiere en el subject.
    wp user create editor_user editor@example.com --role=editor --user_pass=editor_pass --allow-root

    echo "Instalación de WordPress completada."
fi

# --- 5. Asegura los permisos correctos ---
# WP-CLI, al ejecutarse como root, puede crear archivos propiedad de root.
# Cambiamos el propietario al usuario 'www-data' para que el servidor web pueda
# gestionar los archivos (ej. subir imágenes, instalar plugins).
chown -R www-data:www-data /var/www/html

echo "Servidor listo. Iniciando PHP-FPM..."
# --- 6. Pasa el control al comando principal del contenedor (CMD) ---
# 'exec "$@"' reemplaza este script por el proceso de PHP-FPM,
# convirtiéndolo en el proceso principal (PID 1) del contenedor[cite: 105].
exec "$@"
