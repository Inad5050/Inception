DOCKER_COMPOSE_FILE = srcs/docker-compose.yml
VOLUME_DIR = /home/dangonz3/data
MARIADB_VOLUME = mariadb_data
WORDPRESS_VOLUME = wordpress_data
SECRETS_DIR = ./secrets
COLOR_GREEN = \033[0;32m
COLOR_RESET = \033[0m

all: create_volumes create_secrets create_env
	@docker compose -f $(DOCKER_COMPOSE_FILE) up -d --build
	@echo "$(COLOR_GREEN)------------ Contenedores iniciados ------------$(COLOR_RESET)"
	@docker ps

create_volumes:
	@mkdir -p ${VOLUME_DIR}/${MARIADB_VOLUME}
	@mkdir -p ${VOLUME_DIR}/${WORDPRESS_VOLUME}

create_secrets:
	@mkdir -p ${SECRETS_DIR}
	@echo "user_password" > ${SECRETS_DIR}/db_password.txt
	@echo "root_password" > ${SECRETS_DIR}/db_root_password.txt
	@echo "wp_admin_password" > ${SECRETS_DIR}/wp_admin_password.txt
	@echo "wp_user_password" > ${SECRETS_DIR}/wp_user_password.txt

create_env:
	@echo \
	"DATA_PATH=/home/dangonz3/data\n\
	DOMAIN_NAME=dangonz3.42.fr\n\
	MYSQL_DATABASE=MYSQL_db\n\
	MYSQL_USER=MYSQL_user\n\
	WP_TITLE=inception\n\
	WP_ADMIN_USER=wp_admin\n\
	WP_ADMIN_EMAIL=dangonz3@student.42urduliz.com\n\
	WP_USERNAME=wp_user\n\
	WP_USER_EMAIL=dangonz3@student.42urduliz.com" \
	> .env

clean:
	@docker compose -f $(DOCKER_COMPOSE_FILE) down
	@echo "$(COLOR_GREEN)------------ Servicios detenidos ------------$(COLOR_RESET)"

# Por defecto prune solo elimina recursos "colgantes".
# --all lo altera para que elimine todos los recursos no usados: contenedores, redes e imagenes.
# --volumes hace que tambíen elimine volumenes.
fclean: clean
	@docker system prune --all --volumes --force
	@sudo rm -rf $(VOLUME_DIR)
	@sudo rm -rf ${SECRETS_DIR}
	@sudo rm -rf .env
	@echo "$(COLOR_GREEN)------------ Limpieza completa finalizada ------------$(COLOR_RESET)"

re: fclean all

.PHONY: all clean fclean re create_volumes

check:
	@git pull && \
	$(MAKE) fclean && \
	sudo $(MAKE) all && \
	echo "$(COLOR_GREEN)✅ Despliegue completado. Mostrando logs...$(COLOR_RESET)" ; \
	docker logs mariadb ; \
	docker logs wordpress ; \
	docker logs nginx && \
	echo "$(COLOR_GREEN)✅ Comprobando web $(COLOR_RESET)" ; \
	curl -k https://dangonz3.42.fr
	