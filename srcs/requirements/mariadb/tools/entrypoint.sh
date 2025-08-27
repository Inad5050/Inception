#!/bin/bash

MYSQL_PASSWORD=$(cat "${MYSQL_PASSWORD_FILE}")

service mariadb start

sleep 5

mariadb -uroot <<EOF
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
FLUSH PRIVILEGES;
EOF

mysqladmin -uroot shutdown

#exec "$@"
exec mariadbd --bind-address=0.0.0.0
