#!/bin/sh
set -e

# Comprueba si el directorio del sistema 'mysql' ya existe.
if [ -d "/var/lib/mysql/mysql" ]; then
    echo "MariaDB ya está inicializado. Omitiendo configuración."
else
    echo "Inicializando la base de datos MariaDB..."

    # Inicializa la estructura de directorios de MariaDB.
    mysql_install_db --user=mysql --datadir=/var/lib/mysql

    # Ejecuta el script de configuración inicial en modo seguro.
    mysqld --user=mysql --bootstrap << EOF
USE mysql;
FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY '$(cat $MYSQL_ROOT_PASSWORD_FILE)';
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '$(cat $MYSQL_PASSWORD_FILE)';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF
fi

# Pasa el control al comando principal del contenedor (CMD).
exec "$@"