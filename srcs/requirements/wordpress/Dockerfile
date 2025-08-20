FROM php:8.2-fpm-bullseye

# Instala las dependencias necesarias.
RUN apt-get update && \
    apt-get install -y mariadb-client wget sudo netcat && \
    rm -rf /var/lib/apt/lists/*

# Descarga, da permisos y mueve wp-cli a una ubicación accesible.
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# Establece el directorio de trabajo.
WORKDIR /var/www/html

# Copia y da permisos al script de entrada.
COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["php-fpm"]