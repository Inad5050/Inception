# FROM Utiliza una imagen base debian.
# RUN (1) Instala las extensiones de PHP necesarias para WordPress (MySQL, GD, etc.) y herramientas:
#	mariadb-client: para poder usar "mysqladmin ping" en el script del ENTRYPOINT
# COPY (1) copia el script inicial.
# RUN (2) se le otorga al script.
# RUN (3) Crea el directorio para los ficheros de WordPress.
#	Conviene encadenar comandos RUN para crear menos capas y reducir el tamaño de la imagen
#	cuando instalamos paquetes o descargamos archivos, 
#	en el caso de chmod y mkdir las ganancias son insignificantes.
# EXPOSE Expone el puerto 9000 para la comunicación con Nginx (PHP-FPM).
#	Solo indica que puerto quiere usar el contenedor, los puertos se abren en el docker-compose.yml

FROM debian:bullseye
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y \
    curl \
    php7.4-fpm \
    php7.4-mysql \
    php7.4-curl \
    mariadb-client
COPY ./tools/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
RUN mkdir -p /var/www/html /run/php
EXPOSE 9000
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/usr/sbin/php-fpm7.4", "-F"]

# ENTRYPOINT Punto de entrada para la configuración inicial. Ejecuta un script de shell.
# CMD Comando por defecto para iniciar PHP-FPM en primer plano.
#	Le proporciona argumentos al script del ENTRYPOINT.
#	La última linea del script es exec "$@", lo que significa que
#	el script reemplaza su código por el del comando que recibe como argumento.
#	Así podemos ejecutar un script inicial y luego cederle el control
#	al proceso principal del servicio (php-fpm7.4), que es persistente, así evitamos que el contenedor
#	(que se detendra si el proceso principal termina) se cierre cuando acaba el script.
#	-F (foreground) evita que php-fpm7.4 se ejecute como daemon en segundo plano,
#	es una bandera propia de PHP-FPM, igual que "-g daemon off" lo es de NGINX.

# --- NOTAS ---

# Diferencias entre las bases de Alpine y Debian
#	Alpine: es más ligero
#	Debian: tiene más compatibilidades
