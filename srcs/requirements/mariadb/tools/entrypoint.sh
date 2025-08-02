#!/bin/sh

# Comprueba si el volumen de datos ya está inicializado.
# Estara iniciado si no es la primera vez que construimos los contenedores.
# La existencia de la carpeta 'mysql', que contiene las tablas de sistema,
# es el giveaway de si está iniciado.
# mysql_install_db: inicializa el directorio de datos de MariaDB
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Directorio de MariaDB no encontrado. Inicializando base de datos..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
else
    echo "Directorio de MariaDB encontrado. Omitiendo inicialización."
fi

# Ejecuta el comando principal del contenedor (lo que sea que esté en CMD)
exec "$@"
