#!/bin/sh
# 'set -x' imprime cada comando antes de ejecutarlo.
# 'set -e' hace que el script falle si cualquier comando falla.
set -xe

echo "--- INICIANDO SCRIPT DE MARIADB ---"
echo "DEBUG: Variables de entorno recibidas:"
echo "MYSQL_DATABASE: ${MYSQL_DATABASE}"
echo "MYSQL_USER: ${MYSQL_USER}"
echo "-----------------------------------"

if [ -d "/var/lib/mysql/$MYSQL_DATABASE" ]; then
    echo "DEBUG: La base de datos '$MYSQL_DATABASE' ya existe. Omitiendo inicialización."
else
    echo "DEBUG: La base de datos no existe. Inicializando por primera vez..."

    # Inicializa la estructura de directorios de MariaDB.
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
    echo "DEBUG: 'mysql_install_db' completado."

    # Inicia el servidor en modo seguro para la configuración inicial.
    mysqld --user=mysql --bootstrap << EOF
USE mysql;
FLUSH PRIVILEGES;

ALTER USER 'root'@'localhost' IDENTIFIED BY '$(cat $MYSQL_ROOT_PASSWORD_FILE)';
CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\`;
CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$(cat $MYSQL_PASSWORD_FILE)';
GRANT ALL PRIVILEGES ON \`$MYSQL_DATABASE\`.* TO '$MYSQL_USER'@'%';

FLUSH PRIVILEGES;
EOF
    echo "DEBUG: Base de datos y usuarios creados."
fi

echo "--- FINALIZANDO SCRIPT DE MARIADB. Pasando control a mysqld ---"
exec "$@"