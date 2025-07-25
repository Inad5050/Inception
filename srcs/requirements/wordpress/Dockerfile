# Utiliza una imagen base con PHP 8.2 y FPM sobre Alpine para un menor tamaño.
FROM php:8.2-fpm-alpine

# Metadato del mantenedor.
LABEL maintainer="dangonz3 <dangonz3@student.42urduliz.com>"

# Instala las extensiones de PHP necesarias para WordPress (MySQL, GD, etc.) y herramientas como wget y unzip.
RUN apk update && apk add --no-cache \
    wget \
    unzip \
    mariadb-client \
    php82-fpm \
    php82-mysqli \
    php82-gd \
    php82-curl \
    php82-zip \
    php82-mbstring

# Copia la herramienta wp-cli (interfaz de línea de comandos de WordPress).
COPY ./tools/wp-cli.phar /usr/local/bin/wp
RUN chmod +x /usr/local/bin/wp

# Crea el directorio para los ficheros de WordPress.
RUN mkdir -p /var/www/html
WORKDIR /var/www/html

# Descarga y descomprime WordPress.
RUN wget https://wordpress.org/latest.tar.gz && \
    tar -xzf latest.tar.gz --strip-components=1 && \
    rm latest.tar.gz && \
    chown -R www-data:www-data /var/www/html

# Copia el script de configuración que se ejecutará al arranque.
COPY ./tools/wp-config.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/wp-config.sh

# Expone el puerto 9000 para la comunicación con Nginx (PHP-FPM).
EXPOSE 9000

# Punto de entrada para la configuración inicial.
ENTRYPOINT ["/usr/local/bin/wp-config.sh"]

# Comando por defecto para iniciar PHP-FPM en primer plano.
CMD ["php-fpm82", "-F"]
