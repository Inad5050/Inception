# FROM Utiliza una imagen base con PHP 8.2 y FPM sobre Alpine para un menor tamaño.
# RUN (1) Instala las extensiones de PHP necesarias para WordPress (MySQL, GD, etc.) y herramientas:
#	wget: permite descargar archivos de la web (wget https://wordpress.org/latest.tar.gz)
#	mariadb-client: para poder usar "mysqladmin ping" en el script del ENTRYPOINT
# COPY (1) Copia la herramienta wp-cli (WordPess CommandLineInterface):
#	wp-cli se utiliza en el script de WordPress (wp-config.sh).
#	Permite gestionar WordPress desde la terminal, sin necesidad de navegador.
#	Proporciona comandos como "wp config create" y "wp core install" que automatizan la instalación,
#	y evitan que tengamos que usar comandos como curl y similares.
# RUN (2) se le otorga a wp-cli permisos de ejecución.
# RUN (3) Crea el directorio para los ficheros de WordPress.
#	Conviene encadenar comandos RUN para crear menos capas y reducir el tamaño de la imagen
#	cuando instalamos paquetes o descargamos archivos, 
#	en el caso de chmod y mkdir las ganancias son insignificantes.
# WORKDIR establece el directorio de trabajo para cualquier instrucción
# 	(RUN, COPY, CMD, ENTRYPOINT...) posterior en el Dockerfile.
# RUN (4) Descarga y descomprime WordPress.
#	--strip-components=1 le indica a tar que elimine el primer nivel de directorios
#	del archivo que está extrayendo, en lugar de extraer latest.tar.gz en /var/www/html/wordpress/
#	lo extraera en /var/www/html/, dónde NGINX espera encontrarlos.
#	chown (ChangeOwner) cambia el propietario y grupo de archivos de un archivo o directorio,
#	sintaxis: "chown nuevo_usuario:nuevo_grupo archivos_a_cambiar".
#	Cambia el propietario de lo contenido en /var/www/html para otorgarle permisos
#	de lectura y escritura al usuario www-data, el usuario por defecto de NGINX y PHP-FPM.
#	Los permisos por defecto son 644 (archivos) y 755 (directorios) (leer:4 escribir:2 ejecutar:1).
# COPY (2) Copia el script de configuración que se ejecutará al arranque.
# RUN (5) Le otorga al script permisos de ejecución.
# EXPOSE Expone el puerto 9000 para la comunicación con Nginx (PHP-FPM).
#	Solo indica que puerto quiere usar el contenedor, los puertos se abren en el docker-compose.yml

FROM php:8.2-fpm-alpine
RUN apk update && apk add --no-cache \
    wget \
    mariadb-client \
    php82-fpm \
    php82-mysqli \
    php82-gd \
    php82-curl \
    php82-zip \
    php82-mbstring
COPY ./tools/wp-cli.phar /usr/local/bin/wp
RUN chmod +x /usr/local/bin/wp
RUN mkdir -p /var/www/html
WORKDIR /var/www/html
RUN wget https://wordpress.org/latest.tar.gz && \
    tar -xzf latest.tar.gz --strip-components=1 && \
    rm latest.tar.gz && \
    chown -R www-data:www-data /var/www/html
COPY ./tools/wp-config.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/wp-config.sh
EXPOSE 9000
ENTRYPOINT ["/usr/local/bin/wp-config.sh"]
CMD ["php-fpm82", "-F"]

# ENTRYPOINT Punto de entrada para la configuración inicial. Ejecuta un script de shell
# CMD Comando por defecto para iniciar PHP-FPM en primer plano.
#	Le proporciona argumentos (php-fpm82 -F) al script del ENTRYPOINT.
#	La última linea del script es exec "$@", lo que significa que
#	el script reemplaza su código por el del comando que recibe como argumento.
#	Así podemos ejecutar un script inicial y luego cederle el control
#	al proceso principal del servicio (php-fpm82), que es persistente, así evitamos que el contenedor
#	(que se detendra si el proceso principal termina) se cierre cuando acaba el script.
#	-F (foreground) evita que php-fpm82 se ejecute como daemon en segundo plano,
#	es una bandera propia de PHP-FPM, igual que "-g daemon off" lo es de NGINX.

# --- NOTAS ---

# Diferencias entre las bases de Alpine y Debian
#	Alpine: es más ligero
#	Debian: tiene más compatibilidades  