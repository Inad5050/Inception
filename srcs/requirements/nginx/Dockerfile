# FROM Utiliza la imagen base oficial de Debian.
# RUN (1) actualiza los repositorios e instala NGINX.
#	Actualiza la lista de paquetes disponibles en los repositorios (servidores remotos que contiene software) de Debian.
#	Instala NGINX. 
#	Instala OpenSSL y crea un directorio para los certificados.
# RUN (2) Generar el certificado SSL y la clave privada.
# STOPSIGNAL define qué señal específica envía el demonio de Docker al contenedor para solicitar su detención
#	cuando se ejecuta el comando docker stop.
#	Si no se especifica Docker envía la señal SIGTERM.
#	SIGTERM: Provoca un apagado rápido. Las peticiones que están siendo procesadas en ese instante pueden interrumpirse.
#	SIGQUIT: Provoca un apagado elegante. NGINX no acepta nuevas conexiones, pero finaliza las existentes de forma limpia.
# COPY Copia archivos o directorios de la máquina local al sistema de archivos del contenedor.
# 	El primer argumento es el archivo a copiar, el segundo es la ruta de destino. 
# 	El directorio /etc/nginx/conf.d/ está diseñado para albergar archivos de configuración suplementarios,
#	El archivo nginx.conf principal de NGINX (en la imagen base) contiene una directiva include /etc/nginx/conf.d/*.conf;.

# FROM debian:11
# RUN apt update \                 
# && apt install -y nginx \ 
# && apt install -y openssl \ 
# && mkdir -p /etc/nginx/ssl
# RUN openssl req -x509 -nodes \ 
# -out /etc/nginx/ssl/inception.crt \ 
# -keyout /etc/nginx/ssl/inception.key \ 
# -subj "/C=ES/ST=E/L=BIL/O=42/OU=42/CN=dangonz3.42.com/UID=dangonz3"
# STOPSIGNAL SIGQUIT
# COPY ./conf/default.conf /etc/nginx/conf.d/wp-conf.conf
# RUN chown -R www-data:www-data /var/www/html
# EXPOSE 443
# CMD ["nginx", "-g", "daemon off;"]

FROM debian:11

RUN apt-get update && apt-get install -y \
    nginx \
    openssl

RUN mkdir -p /etc/nginx/ssl

RUN openssl req -x509 -nodes -out /etc/nginx/ssl/inception.crt -keyout /etc/nginx/ssl/inception.key \
    -subj "/C=ES/ST=E/L=BIL/O=42/OU=42/CN=dangonz3.42.com/UID=dangonz3"

COPY conf/nginx.conf /etc/nginx/conf.d/wp-conf.conf

RUN chown -R www-data:www-data /var/www/html

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]

# CMD define el proceso principal que el contenedor debe ejecutar al arrancar.
#	El ejecutable nginx está diseñado para daemonizarse. Al ejecutar nginx, el proceso principal 
#	lanza los procesos de trabajo (los que gestionan las peticiones) y luego termina.
#	Si el proceso principal que Docker inició termina, Docker considera que la tarea del contenedor ha finalizado y 
#	detiene el contenedor por completo. Por lo tanto, si NGINX se ejecuta como demonio, el contenedor se iniciará y 
#	se detendrá casi instantáneamente.
#	-g permite pasar directivas de configuración globales directamente desde la línea de comandos.
#	Estas directivas anulan o complementan las que están definidas en el archivo de configuración (nginx.conf).
#	-g 'daemon off: instruye al proceso principal de NGINX para que no se separe y permanezca 
#	activo en primer plano, convirtiéndose en el proceso principal del contenedor. Mientras NGINX esté funcionando, 
#	el contenedor permanecerá activo. Es el método estándar para ejecutar servicios de tipo demonio dentro de contenedores.

# --- NOTAS ---

# Sintaxis de CMD
# Forma exec (recomendada): CMD ["ejecutable", "param1", "param2"]	
# 	Ejecuta el comando directamente sin invocar un intérprete de comandos (shell). 
# 	Si ejecutamos una shell, la shell y no NGINX pasa a ser el proceso principal del contenedor (PID1)
#	La shell no siempre reenvía las señales a su proceso hijo (nginx), por lo que nginx podría no recibir nunca 
#	la orden de apagado, forzando a Docker a enviar una señal SIGKILL (apagado forzoso) tras un tiempo de espera.
# Forma shell: CMD comando param1 param2
# 	Ejecuta el comando dentro de una shell, por defecto /bin/sh -c. 
# 	Es útil si necesitas funcionalidades de la shell, como las redirecciónes o las variables de entorno.

# Contexto de construcción
# 	El Dockerfile solo puede ver y acceder a los archivos que están dentro de su contexto de
# 	construcción, (en este caso el directorio /mariadb). No tiene acceso a, por ejemplo, 
# 	.env en /requirement. De forma que cada Dockerfile necesita su .conf o su .env de requerirlos.
