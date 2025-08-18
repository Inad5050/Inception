#!/bin/sh

# Comprueba si el volumen de datos ya está inicializado.
# Estara iniciado si no es la primera vez que construimos los contenedores.
# La existencia de la carpeta 'mysql', que contiene las tablas de sistema,
# es el giveaway de si está iniciado.
# mysql_install_db: inicializa el directorio de datos de MariaDB
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Directorio de MariaDB no encontrado. Inicializando base de datos..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

# Inicia el servidor MariaDB en segundo plano para la configuración
mysqld --user=mysql --bind-address=0.0.0.0 --skip-networking &
pid="$!"

# Espera a que el servidor esté listo para aceptar conexiones (NOTA: ver script de WordPress)
until mysqladmin ping -h"localhost" --silent; do
    echo "Esperando al servidor MariaDB temporal..."
    sleep 2
done

# Ejecuta los comandos SQL para crear la base de datos y el usuario de WordPress
# Se usa un "here document" (<< EOF) para pasar múltiples comandos a mysql.
mysql -u root << EOF
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '$(cat ${MYSQL_PASSWORD_FILE})';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOFgi

# Apaga el servidor temporal de forma segura
mysqladmin -u root shutdown

# Espera a que el proceso en segundo plano termine
wait "$pid"

echo "Configuración de MariaDB completada. Iniciando servidor principal..."

# Ejecuta el comando principal del contenedor (lo que sea que esté en CMD)
exec "$@"
