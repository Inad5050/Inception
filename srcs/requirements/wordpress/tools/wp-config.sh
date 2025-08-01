#!/bin/bash

# Espera a que el servicio MariaDB esté disponible para aceptar conexiones.
# La directiva depends_on: en en docker-compose solo garantiza que MariaDB se inicie antes de WP,
# no garantiza que MariaDB este disponible.
#	until [comand]: ejecuta el código entre do y done hasta que el comando tenga éxito (return 0).
#	mysqladmin ping: comprueba si el servidor está disponible.
#	-h"$WORDPRESS_DB_HOST": especifica el servidor.
#	--silent: suprime la salida del comando en la terminal.
until mysqladmin ping -h"$WORDPRESS_DB_HOST" --silent; do
    echo "Waiting for database..."
    sleep 2
done

# if [] Comprueba si WP ya ha sido instalado.
#	! -> operador de negación. -f "wp-config.php" -> comprueba si el archivo wp-config.php existe.
#	Si no existe, ejecuta el código entre then y fi.
#	Si intentasemos reinstalar wordpress sobre la instalación anterior, en los volumenes de docker 
#	(y por lo tanto persistente tras docker-compose down), se dañaria la instalación y el contenedor se dentendría.
# wp config create: crea el archivo de configuración wp-config.php que contiene las credenciales
#	(dbname, dbuser...) con las que conectarse a MariaDB.
#	cat "$WORDPRESS_DB_PASSWORD_FILE": la directiva _FILE es compatible con los procesos principales de
#		WP y MariaDB, pero no con un script de shell, tenemos que leer manualmente el contenido del archivo.
#		$(...) ejecuta el comando que está dentro del parentesis.
#	--allow-root: wp-cli se niega a ejecutarse si detecta que el usuario del sistema operativo que lo invoca es root.
#		Se hace para prevenir errores accidentales. --allow-root desactiva esa comprobación.
# wp core install: usa wp-config.php para conectarse a la base de datos y configura WP.
#	La instalación no puede completarse sin crear una cuenta de administrador inicial.
if [ ! -f "wp-config.php" ]; then
    wp config create \
        --dbname="$WORDPRESS_DB_NAME" \
        --dbuser="$WORDPRESS_DB_USER" \
        --dbpass="$(cat "$WORDPRESS_DB_PASSWORD_FILE")" \
        --dbhost="$WORDPRESS_DB_HOST" \
        --allow-root

    wp core install \
        --url="$DOMAIN_NAME" \
        --title="My WordPress Site" \
        --admin_user="My WordPress Admin" \
        --admin_password="My WordPress Password" \
        --admin_email="admin@example.com" \
        --allow-root
fi

# Ejecuta el comando principal del contenedor (CMD).
# Usar CMD en lugar de pasarle a exec un valor directo nos permite modicar el script 
# alterando CMD desde la línea de comandos (docker run) o desde docker-compose (command:).
exec "$@"
