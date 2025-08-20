#!/bin/sh
set -xe

echo "--- INICIANDO SCRIPT DE NGINX (DEBUG) ---"
echo "DEBUG: Verificando permisos en /var/www/html desde la perspectiva de Nginx..."
echo "DEBUG: UID/GID actual: $(id)"
ls -la /var/www/html

echo "DEBUG: Mostrando contenido de la configuración de Nginx:"
cat /etc/nginx/conf.d/default.conf
echo "------------------------------------------"

echo "--- FINALIZANDO SCRIPT DE NGINX. Pasando control a Nginx ---"
exec "$@"