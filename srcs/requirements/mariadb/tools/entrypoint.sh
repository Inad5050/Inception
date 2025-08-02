#!/bin/sh

# Comprueba si el directorio de datos ya está inicializado.
# Busca la carpeta 'mysql', que contiene las tablas de sistema.
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Directorio de MariaDB no encontrado. Inicializando base de datos..."

    # Inicializa el directorio de datos de MariaDB
    mysql_install_db --user=mysql --datadir=/var/lib/mysql

    # Aquí iría la lógica para crear la base de datos, el usuario y la contraseña
    # usando los secretos y variables de entorno. Por simplicidad, el
    # proceso mysqld lo manejará, pero un script más robusto lo haría aquí.

else
    echo "Directorio de MariaDB encontrado. Omitiendo inicialización."
fi

# Ejecuta el comando principal del contenedor (lo que sea que esté en CMD)
exec "$@"