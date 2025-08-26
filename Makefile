DOCKER_COMPOSE_FILE = srcs/docker-compose.yml
VOLUME_DIR = /home/dangonz3/data
MARIADB_VOLUME = mariadb_data
WORDPRESS_VOLUME = wordpress_data
SECRETS_DIR = ./secrets
ENV_FILE = ./srcs/.env
COLOR_GREEN = \033[0;32m
COLOR_RESET = \033[0m

all: volumes secrets env
	@docker compose -f $(DOCKER_COMPOSE_FILE) up -d --build
	@echo "$(COLOR_GREEN)------------ Contenedores iniciados ------------$(COLOR_RESET)"
	@docker ps

volumes:
	@echo "$(COLOR_GREEN)volumes$(COLOR_RESET)"
	@mkdir -p ${VOLUME_DIR}/${MARIADB_VOLUME}
	@mkdir -p ${VOLUME_DIR}/${WORDPRESS_VOLUME}

secrets:
	@echo "$(COLOR_GREEN)secrets$(COLOR_RESET)"
	@mkdir -p ${SECRETS_DIR}
	@echo "user_password" > ${SECRETS_DIR}/db_password.txt
	@echo "root_password" > ${SECRETS_DIR}/db_root_password.txt
	@echo "wp_admin_password" > ${SECRETS_DIR}/wp_admin_password.txt
	@echo "wp_user_password" > ${SECRETS_DIR}/wp_user_password.txt

env:
	@echo "$(COLOR_GREEN)env$(COLOR_RESET)"
	@echo -e \
	"DATA_PATH=/home/dangonz3/data\n\
	DOMAIN_NAME=dangonz3.42.fr\n\
	MYSQL_DATABASE=MYSQL_db\n\
	MYSQL_USER=MYSQL_user\n\
	WP_TITLE=inception\n\
	WP_ADMIN_USER=wp_admin\n\
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
fclean:
	@docker system prune --all --volumes --force
	@sudo rm -rf $(VOLUME_DIR)
	@sudo rm -rf ${SECRETS_DIR}
	@sudo rm $(ENV_FILE)
	@echo "$(COLOR_GREEN)------------ Limpieza completa finalizada ------------$(COLOR_RESET)"

re: fclean all

.PHONY: all clean fclean re volumes secrets env

push:
	git add .
	git commit -m "generic_push"
	git push

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
	