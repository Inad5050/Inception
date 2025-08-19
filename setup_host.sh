#!/bin/sh

# La dirección IP y el dominio que necesitas configurar
HOST_IP="127.0.0.1"
DOMAIN="dangonz3.42.fr"
HOSTS_ENTRY="${HOST_IP} ${DOMAIN}"

# Usamos grep -q para buscar la entrada de forma silenciosa.
# Si la entrada no existe, el comando fallará y se ejecutará el bloque 'if'.
if ! grep -q "${HOSTS_ENTRY}" /etc/hosts; then
    echo "Añadiendo '${HOSTS_ENTRY}' a /etc/hosts..."
    # Usamos 'tee -a' con sudo para añadir la línea al final del archivo con los permisos correctos.
    echo "${HOSTS_ENTRY}" | sudo tee -a /etc/hosts > /dev/null
else
    echo "La entrada '${HOSTS_ENTRY}' ya existe en /etc/hosts."
fi
