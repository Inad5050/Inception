# FROM Utiliza la imagen oficial de Debian Bookworm slim como base.
# RUN Instala el servidor de MariaDB y su cliente.
#	server: el motor de la base de datos, gestiona los datos y ejecuta las consultas.
#	cliente: conjunto de herramientas para interactuar con el servidor desde la línea de comandos.
#	La opción -y (yes) responde automáticamente "sí" a cualquier pregunta que el gestor de paquetes apt pueda hacer durante la instalación.
# COPY Copia el fichero de configuración personalizado a una ruta que MariaDB lee al arrancar.
#	Los sistemas como MariaDB leen los archivos de configuración en orden alfabético. El prefijo 50- es una convención para asegurar que tu
#	configuración personalizada se cargue en un punto intermedio, después de los valores por defecto del sistema pero antes de posibles ajustes finales.
# EXPOSE Expone el puerto estándar de MariaDB.
# CMD define el proceso principal que el contenedor debe ejecutar al arrancar.
#	Un contenedor está diseñado para ejecutar un único proceso principal.
#	La vida del contenedor está ligada a la vida de este proceso: si el proceso termina, el contenedor se detiene.
#	Si no se define ningun proceso, el contenedor arrancará y se detendrá al instante porque no tiene ninguna tarea que realizar.

FROM debian:bookworm-slim
RUN apt-get update && \
    apt-get install -y mariadb-server mariadb-client
COPY ./conf/server.cfg /etc/mysql/mariadb.conf.d/50-server.cnf
EXPOSE 3306
CMD ["mysqld"]

# Las capas son los bloques de construcción de una imagen de Docker.
# Cada instrucción en un Dockerfile que modifica el sistema de archivos (RUN, COPY, ADD) crea una nueva capa sobre la anterior.
# Cada nueva capa le añade tamaño a la imagen

# --- NOTAS ---

# ENTRYPOINT es una alternativa a CMD, ejecuta un script de shell, que puede realizar tareas de inicialización más complejas
# antes de ejecutar el proceso principal (como mysqld).

# MY - nombre de la hija del creador
# SQL - Structured Query Language
# D - daemon, nombre dado a los procesos que proveen un servicio permanente y autónomo que se ejecuta en segundo plano