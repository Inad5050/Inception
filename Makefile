DOCKER_COMPOSE_FILE = srcs/docker-compose.yml
VOLUME_DIR = /home/dangonz3/data
MARIADB_VOLUME = mariadb_data
WORDPRESS_VOLUME = wordpress_data
SECRETS_DIR = ./secrets
ENV_FILE = ./srcs/.env
COLOR_GREEN = \033[0;32m
COLOR_RESET = \033[0m

all:
	@docker compose -f $(DOCKER_COMPOSE_FILE) up -d --build
	@echo "$(COLOR_GREEN)------------ Contenedores iniciados ------------$(COLOR_RESET)"
	@docker ps

setup: volumes secrets env

volumes:
	@echo "$(COLOR_GREEN)volumes$(COLOR_RESET)"
	@mkdir -p ${VOLUME_DIR}/${MARIADB_VOLUME}
	@mkdir -p ${VOLUME_DIR}/${WORDPRESS_VOLUME}

secrets:
	@echo "$(COLOR_GREEN)secrets$(COLOR_RESET)"
	@mkdir -p ${SECRETS_DIR}
	@echo "user_password" > ${SECRETS_DIR}/db_password.txt
	@echo "root_password" > ${SECRETS_DIR}/db_root_password.txt

env:
	@echo "$(COLOR_GREEN)env$(COLOR_RESET)"
	@echo \
	"DOMAIN_NAME=dangonz3.42.fr\n\
	MYSQL_DATABASE=MYSQL_db\n\
	MYSQL_USER=MYSQL_user\n\
	WP_TITLE=inception\n\
	WP_ADMIN_USER=wp_ad\n\
	WP_ADMIN_EMAIL=dangonz3@student.42urduliz.com\n\
	WP_USERNAME=wp_user\n\
	WP_USER_EMAIL=dangonz3@student.42urduliz.com" \
	> $(ENV_FILE)

clean:
	@docker compose -f $(DOCKER_COMPOSE_FILE) down
	@echo "$(COLOR_GREEN)------------ Servicios detenidos ------------$(COLOR_RESET)"

# Por defecto prune solo elimina recursos "colgantes".
# --all lo altera para que elimine todos los recursos no usados: contenedores, redes e imagenes.
# --volumes hace que tambíen elimine volumenes.
fclean: clean
	@docker system prune --all --force --volumes
	@rm -rf ${VOLUME_DIR}/${MARIADB_VOLUME}
	@rm -rf ${VOLUME_DIR}/${WORDPRESS_VOLUME}
	@rm -rf $(VOLUME_DIR)
	@rm -rf ${SECRETS_DIR}
	@rm -rf $(ENV_FILE)
	@echo "$(COLOR_GREEN)------------ Limpieza completa finalizada ------------$(COLOR_RESET)"

re: fclean all

.PHONY: all clean fclean re volumes secrets env

push:
	git add .
	git commit -m "generic_push"
	git push
	