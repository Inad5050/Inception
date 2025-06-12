# Usa la misma imagen base que la oficial para consistencia.
FROM debian:bookworm-slim

LABEL maintainer="dangonz3 <dangonz3@student.42urduliz.com>"

# Combina la instalación, configuración de logs y limpieza en una única capa RUN.
	# set -x es una instrucción del shell que activa el modo de depuración "xtrace". 
	# Cuando está activado, el shell imprime cada comando y sus argumentos en la salida de error estándar (stderr) justo antes de que el comando sea ejecutado.
RUN set -x \
    && apt-get update \
    # Instala solo el paquete NGINX desde el repositorio estándar de Debian.
    # Esto elimina la necesidad de gestionar GPG keys y repositorios externos.
    && apt-get install --no-install-recommends --no-install-suggests -y nginx \
    # Limpia la caché de APT para reducir el tamaño de la imagen.
    && rm -rf /var/lib/apt/lists/* \
    # Redirige los logs de NGINX a la salida estándar de Docker.
    # Esto es una práctica estándar para la gestión de logs en contenedores.
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

# Expone el puerto estándar HTTP.
EXPOSE 80

# Define la señal de parada correcta para que NGINX se cierre de forma limpia.
STOPSIGNAL SIGQUIT

# El comando por defecto para iniciar NGINX.
# La directiva "-g 'daemon off;'" es crucial para que NGINX se ejecute en primer plano,
# manteniendo el contenedor activo.
CMD ["nginx", "-g", "daemon off;"]