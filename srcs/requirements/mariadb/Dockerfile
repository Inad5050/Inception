# Utiliza la imagen oficial de Debian Bookworm slim como base.
FROM debian:bookworm-slim

# Metadato del mantenedor de la imagen.
LABEL maintainer="dangonz3 <dangonz3@student.42urduliz.com>"

# Instala el servidor de MariaDB y su cliente.
RUN apt-get update && \
    apt-get install -y mariadb-server mariadb-client && \
    rm -rf /var/lib/apt/lists/*

# Copia el fichero de configuración personalizado de MariaDB.
COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

# Expone el puerto estándar de MariaDB.
EXPOSE 3306

# Comando por defecto que se ejecutará después del entrypoint.
CMD ["mysqld_safe"]
