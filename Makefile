DOCKER_COMPOSE_FILE=srcs/docker-compose.yml
VOLUME_DIR=/home/dangonz3/data
SECRETS_DIR=./secrets
ENV_FILE=./srcs/.env

all:
	@mkdir -p /home/dangonz3/data/wordpress
	@mkdir -p /home/dangonz3/data/mariadb2
	@docker compose -f $(DOCKER_COMPOSE_FILE) up --build

setup: secrets env

secrets:
	@mkdir -p ${SECRETS_DIR}
	@echo "user_password" > ${SECRETS_DIR}/db_password.txt
	@echo "root_password" > ${SECRETS_DIR}/db_root_password.txt

env:
#	@echo \
#	"DOMAIN_NAME=dangonz3.42.fr\n\
#	MYSQL_DATABASE=MYSQL_db\n\
#	MYSQL_USER=MYSQL_user\n\
#	WP_TITLE=inception\n\
#	WP_ADMIN_USER=wp_ad\n\
#	WP_ADMIN_EMAIL=dangonz3@student.42urduliz.com\n\
#	WP_USERNAME=wp_user\n\
#	WP_USER_EMAIL=dangonz3@student.42urduliz.com" \
#	> $(ENV_FILE)
	@echo \
	"DOMAIN_NAME=dangonz3.42.fr\n\
	SQL_DATABASE=mariadb\n\
	SQL_USER=dangonz3\n\
	SQL_PASSWORD=contrasena1\n\
	SQL_ROOT_PASSWORD=hola123\n\
	WP_TITLE=Inception\n\
	WP_ADMIN_USER=master\n\
	WP_ADMIN_PASSWORD=contrasena1\n\
	WP_ADMIN_EMAIL=dangonz3@student.42urduliz.com\n\
	WP_USERNAME=dangonz3\n\
	WP_USER_EMAIL=dangonz3@student.42urduliz.com\n\
	WP_USER_PASSWORD=hola123\n\
	WP_USER_ROLE=administrator"
	> $(ENV_FILE)

clean:
	@docker compose -f $(DOCKER_COMPOSE_FILE) down -v

# Por defecto prune solo elimina recursos "colgantes".
# --all lo altera para que elimine todos los recursos no usados: contenedores, redes e imagenes.
# --volumes hace que tambíen elimine volumenes.
fclean: clean
	@docker image prune -a -f
	@docker volume prune -f
	@docker system prune -a -f
	@rm -rf /home/dangonz3/data/wordpress
	@rm -rf /home/dangonz3/data/mariadb2
	@rm -rf /home/dangonz3/data
	@rm -rf ${SECRETS_DIR}
	@rm -rf $(ENV_FILE)

re: fclean all

.PHONY: all clean fclean re volumes secrets env

push:
	git add .
	git commit -m "generic_push"
	git push
	