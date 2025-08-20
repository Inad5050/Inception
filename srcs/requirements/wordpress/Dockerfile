FROM php:8.2-fpm-bullseye

RUN apt-get update && \
    apt-get install -y mariadb-client wget sudo netcat && \
    rm -rf /var/lib/apt/lists/*

RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# --- AÑADE ESTA LÍNEA ---
# Copia nuestra configuración de memoria personalizada a la carpeta de configuración de PHP.
COPY conf/custom.ini /usr/local/etc/php/conf.d/custom.ini
# ---------------------

WORKDIR /var/www/html

COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["php-fpm"]