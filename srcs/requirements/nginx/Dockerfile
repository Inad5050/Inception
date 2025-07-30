# Utiliza la imagen base oficial de Debian Bookworm en su versión "slim" para reducir el tamaño.
FROM debian:bookworm-slim

# Actualiza la lista de paquetes disponibles en los repositorios de Debian.RUN 
apt-get update \                 

# Instala NGINX, omitiendo paquetes recomendados y sugeridos para una instalación mínima.    
&& apt-get install --no-install-recommends --no-install-suggests -y nginx \ 

# Crea un enlace simbólico para redirigir el log de acceso de NGINX a la salida estándar (stdout) del contenedor.
&& ln -sf /dev/stdout /var/log/nginx/access.log \ 

# Crea un enlace simbólico para redirigir el log de errores de NGINX a la salida de error estándar (stderr) del contenedor.
&& ln -sf /dev/stderr /var/log/nginx/error.log
	
# Configura la señal SIGQUIT para que Docker detenga NGINX de forma limpia.
STOPSIGNAL SIGQUIT

# COPY : Instrucción de Dockerfile que copia archivos o directorios de la máquina local (donde se construye la imagen) al sistema de archivos del contenedor.
# El primer argumento es el archivo a copiar, el segundo (/etc/nginx/conf.d) es la ruta de destino. 
# El directorio /etc/nginx/conf.d/ está diseñado para albergar archivos de configuración suplementarios,
# cuando NGINX se instala a través de los gestores de paquetes (como apt en Debian). El archivo nginx.conf principal de NGINX 
# (que ya está presente en la imagen base) contiene una directiva include /etc/nginx/conf.d/*.conf;. 
# Esta directiva hace que NGINX cargue automáticamente todos los archivos con extensión .conf de ese directorio cuando inicia.

# "/etc/nginx/nginx.conf" : se asegura de que NGINX carge el archivo de configuración pasado como argumento aunque haya otros archivos de configuración presentes. 
# NGINX, por defecto, carga la configuración de /etc/nginx/nginx.conf, y este archivo principal a menudo contiene directivas como include /etc/nginx/conf.d/*.conf; 
# o include /etc/nginx/sites-enabled/*;. Estas directivas le dicen a NGINX que busque y cargue archivos de configuración adicionales de esos directorios.
COPY ./conf/default.conf /etc/nginx/conf.d

# "daemon off;" : Define el comando por defecto para ejecutar NGINX en primer plano dentro del contenedor.
# Cuando inicias nginx sin argumentos, su proceso principal se lanza, crea procesos de trabajo en segundo plano
# (los que realmente gestionan las peticiones) y luego el proceso principal termina inmediatamente. 
# Consecuencia en Docker: Si el proceso principal que Docker inició termina, Docker considera que la tarea del contenedor ha finalizado y 
# detiene el contenedor por completo. Por lo tanto, si NGINX se ejecuta como demonio, el contenedor se iniciará y se detendrá casi instantáneamente. 
# Solución (-g 'daemon off;'): Esta directiva global instruye al proceso principal de NGINX para que no se separe y se ejecute en segundo plano. 
# En su lugar, permanece activo en primer plano, convirtiéndose en el proceso principal del contenedor. Mientras NGINX esté funcionando, 
# el contenedor permanecerá activo. Es el método estándar para ejecutar servicios de tipo demonio dentro de contenedores.
CMD ["nginx", "-g", "daemon off;"]
