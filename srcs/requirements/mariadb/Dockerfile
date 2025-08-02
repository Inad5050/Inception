# FROM Utiliza la imagen oficial de Debian bullseye slim como base.
# RUN Instala el servidor de MariaDB y su cliente.
#	server: el motor de la base de datos, gestiona los datos y ejecuta las consultas.
#	cliente: conjunto de herramientas para interactuar con el servidor desde la línea de comandos.
#	La opción -y (yes) responde automáticamente "sí" a cualquier pregunta que el gestor de paquetes apt pueda hacer durante la instalación.
#	mkdir -p /run/mysqld: crea un directorio que el proceso mysqld 	ecesitara.
#	chown -R mysql:mysql /run/mysqld: nombra como dueño al usuario mysql (el user que usa mysqld) para darle permisos
# EXPOSE Expone user el puerto estándar de MariaDB.
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
# --bind-address=0.0.0.0
#	MariaDB escuchara en todas las interfaces de red dentro del contenedor, no solo en localhost.

FROM debian:bullseye-slim
RUN apt update && \ 
    apt install -y mariadb-server mariadb-client && \ 
	mkdir -p /run/mysqld && \ 
    chown -R mysql:mysql /run/mysqld
EXPOSE 3306
CMD ["mysqld", "--bind-address=0.0.0.0"]

# --- NOTAS ---

# Las capas son los bloques de construcción de una imagen de Docker.
# Cada instrucción en un Dockerfile que modifica el sistema de archivos (RUN, COPY, ADD) crea una nueva capa sobre la anterior.
# Cada nueva capa le añade tamaño a la imagen, por es mejor encadenar comandos como en este RUN

# ENTRYPOINT es una alternativa a CMD, ejecuta un script de shell, que puede realizar tareas de inicialización más complejas
# antes de ejecutar el proceso principal (como mysqld).

# MY - nombre de la hija del creador
# SQL - Structured Query Language
# D - daemon, nombre dado a los procesos que proveen un servicio permanente y autónomo que se ejecuta en segundo plano
