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
#	El script usara exec para sustituir su código por el de mariadbd, así tendremos el proceso persistente que el container necesita. 
# CMD define el proceso principal que el contenedor debe ejecutar al arrancar.
#	Un contenedor está diseñado para ejecutar un único proceso principal.
#	La vida del contenedor está ligada a la vida de este proceso: si el proceso termina, el contenedor se detiene.
#	Si no se define ningun proceso, el contenedor arrancará y se detendrá al instante porque no tiene ninguna tarea que realizar.
#	El ejecutable mariadbd está diseñado para ejecutarse en primer plano por defecto, a pesar de ser un daemon.
# "mariadbd" ejecuta automáticamente los comandos SQL necesarios para crear la base de datos y los usuarios.
#	Recibe las variables de entorno y los secretos desde el docker-compose.yml.
#	Durante la configuración inicial MariaDB necesita permisos root para: crear la base de datos para WordPress, 
#	crear el usuario para WordPress y otorgar privilegios a ese usuario.
#	Tras la configuración inicial, WordPress ya no necesita el acceso root y utiliza el usuario con privilegios limitados que se acaba de crear.
# --bind-address=0.0.0.0
#	MariaDB escuchara en todas las interfaces de red dentro del contenedor, no solo en localhost.

FROM debian:bullseye
RUN apt-get update && apt-get install -y mariadb-server
COPY tools/db_entrypoint.sh /usr/local/bin/db_entrypoint.sh
RUN chmod +x /usr/local/bin/db_entrypoint.sh
EXPOSE 3306
ENTRYPOINT ["/usr/local/bin/db_entrypoint.sh"]
CMD ["mariadbd", "--bind-address=0.0.0.0"]

# --- NOTAS ---

# Las capas son los bloques de construcción de una imagen de Docker.
# Cada instrucción en un Dockerfile que modifica el sistema de archivos (RUN, COPY, ADD) crea una nueva capa sobre la anterior.
# Cada nueva capa le añade tamaño a la imagen, por es mejor encadenar comandos como en este RUN

# ENTRYPOINT es una alternativa a CMD, ejecuta un script de shell, que puede realizar tareas de inicialización más complejas
# antes de ejecutar el proceso principal (como mysqld).

# MY - nombre de la hija del creador.
# SQL - Structured Query Language.
# D - daemon, nombre dado a los procesos que proveen un servicio permanente y autónomo que se ejecuta en segundo plano.
