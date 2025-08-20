#!/bin/sh

# 'set -e' asegura que el script falle si cualquier comando falla.
set -e

# Comprueba si la base de datos ya está inicializada mirando si existe el directorio 'mysql'.
if [ -d "/var/lib/mysql/mysql" ]; then
    echo "La base de datos MariaDB ya existe. Omitiendo inicialización."
else
    echo "Inicializando la base de datos MariaDB por primera vez..."

    # Inicializa la estructura de directorios de MariaDB.
    mysql_install_db --user=mysql --datadir=/var/lib/mysql

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
    echo "Base de datos inicializada y configurada."
fi

# Pasa el control al comando principal (CMD), que es 'mysqld'.
exec "$@"

# ----------

# Usa Debian Bullseye como base, una distribución estable y ligera.
# FROM debian:bullseye-slim

# # Instala el servidor de MariaDB y procps para poder usar 'ps' si es necesario.
# RUN apt-get update && \
#     apt-get install -y mariadb-server && \
#     rm -rf /var/lib/apt/lists/*

# # Copia el script de entrada que configurará la base de datos.
# COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh
# RUN chmod +x /usr/local/bin/entrypoint.sh

# # Expone el puerto estándar de MariaDB.
# EXPOSE 3306

# # Define el script de entrada y el comando por defecto.
# ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
# CMD ["mysqld", "--user=mysql"]

# ----------

# FROM Utiliza la imagen oficial de Debian bullseye slim como base.
# RUN (1) Instala el servidor de MariaDB y su cliente.
#	server: el motor de la base de datos, gestiona los datos y ejecuta las consultas.
#	cliente: conjunto de herramientas para interactuar con el servidor desde la línea de comandos.
#	La opción -y (yes) responde automáticamente "sí" a cualquier pregunta que el gestor de paquetes apt pueda hacer durante la instalación.
#	mkdir -p /run/mysqld: crea un directorio que el proceso mysqld necesitara.
#	chown -R mysql:mysql /run/mysqld: nombra como dueño del dir al usuario mysql (el user que mysqld usa), así le da los permisos que necesita.
# COPY copia el script de arrance.
# RUN (2) le da al script permisos de ejecución.
# EXPOSE Expone user el puerto estándar de MariaDB.
# ENTRYPOINT Ejecuta el script de configuración inicial, recibe CMD como argumento.
#	Usamos el script para inicializar bind volumes (volumenes preexistentes en el host), al contrario que los named volumes
#	estos no los gestiona docker, su configuración (con mysql_install_db) corre de nuestra cuenta.
#	El script arrancara un servidor temporal, ejecutara los comandos de configuración, lo apagara y iniciara el servidor real.
#	El script usara exec para sustituir su código por el de mysqld, así tendremos el proceso persistente que el container necesita. 
# CMD define el proceso principal que el contenedor debe ejecutar al arrancar.
#	Un contenedor está diseñado para ejecutar un único proceso principal.
#	La vida del contenedor está ligada a la vida de este proceso: si el proceso termina, el contenedor se detiene.
#	Si no se define ningun proceso, el contenedor arrancará y se detendrá al instante porque no tiene ninguna tarea que realizar.
#	El ejecutable mysqld está diseñado para ejecutarse en primer plano por defecto, a pesar de ser un daemon.
# "mysqld" ejecuta automáticamente los comandos SQL necesarios para crear la base de datos y los usuarios.
#	Recibe las variables de entorno y los secretos desde el docker-compose.yml.
#	Durante la configuración inicial MariaDB necesita permisos root para: crear la base de datos para WordPress, 
#	crear el usuario para WordPress y otorgar privilegios a ese usuario.
#	Tras la configuración inicial, WordPress ya no necesita el acceso root y utiliza el usuario con privilegios limitados que se acaba de crear.
# --user=mysql
#	Nuestra lógica depende del uso del user mysql, por los permisos concedidos por chmod, nos aseguramos de que mysqld lo use.
# --bind-address=0.0.0.0
#	MariaDB escuchara en todas las interfaces de red dentro del contenedor, no solo en localhost.

# FROM debian:bullseye-slim
# RUN apt update && \ 
#     apt install -y mariadb-server mariadb-client && \ 
# 	mkdir -p /run/mysqld && \ 
#     chown -R mysql:mysql /run/mysqld
# COPY ./tools/entrypoint.sh /usr/local/bin/entrypoint.sh
# RUN chmod +x /usr/local/bin/entrypoint.sh
# EXPOSE 3306
# ENTRYPOINT ["entrypoint.sh"]
# CMD ["mysqld", "--user=mysql", "--bind-address=0.0.0.0"]

# --- NOTAS ---

# Las capas son los bloques de construcción de una imagen de Docker.
# Cada instrucción en un Dockerfile que modifica el sistema de archivos (RUN, COPY, ADD) crea una nueva capa sobre la anterior.
# Cada nueva capa le añade tamaño a la imagen, por es mejor encadenar comandos como en este RUN

# ENTRYPOINT es una alternativa a CMD, ejecuta un script de shell, que puede realizar tareas de inicialización más complejas
# antes de ejecutar el proceso principal (como mysqld).

# MY - nombre de la hija del creador
# SQL - Structured Query Language
# D - daemon, nombre dado a los procesos que proveen un servicio permanente y autónomo que se ejecuta en segundo plano
