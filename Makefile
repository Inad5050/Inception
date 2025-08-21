# Makefile final y robusto para gestionar el ciclo de vida del proyecto

# --- Variables ---
DOCKER_COMPOSE_FILE = srcs/docker-compose.yml
DOMAIN_NAME = dangonz3.42.fr
VOLUME_DIR = /home/dangonz3/data
DB_DATA_DIR = $(VOLUME_DIR)/db_data
WP_DATA_DIR = $(VOLUME_DIR)/wp_data
COLOR_GREEN = \033[0;32m
COLOR_RESET = \033[0m

# --- Lógica de Scripts ---
define SETUP_HOSTS
	@if ! grep -q "127.0.0.1 ${DOMAIN_NAME}" /etc/hosts; then \
		echo "Añadiendo ${DOMAIN_NAME} a /etc/hosts..."; \
		echo "127.0.0.1 ${DOMAIN_NAME}" | sudo tee -a /etc/hosts > /dev/null; \
	else \
		echo "${DOMAIN_NAME} ya está configurado en /etc/hosts."; \
	fi
endef

# --- Reglas Principales ---

all: create_dirs
	@$(SETUP_HOSTS)
	@docker-compose -f $(DOCKER_COMPOSE_FILE) up -d --build
	@echo "$(COLOR_GREEN)------------ Contenedores iniciados ------------$(COLOR_RESET)"
	@docker ps

clean:
	@docker-compose -f $(DOCKER_COMPOSE_FILE) down
	@echo "$(COLOR_GREEN)------------ Servicios detenidos ------------$(COLOR_RESET)"

fclean: clean
	@docker system prune --all --volumes --force
	@sudo rm -rf $(VOLUME_DIR)
	@echo "$(COLOR_GREEN)------------ Limpieza completa finalizada ------------$(COLOR_RESET)"

re: fclean all

create_dirs:
	@mkdir -p $(DB_DATA_DIR)
	@mkdir -p $(WP_DATA_DIR)

.PHONY: all clean fclean re create_dirs

push:
	git add .
	git commit -m "fastCommit"
	git push

check:
	@git pull && \
	$(MAKE) fclean && \
	sudo $(MAKE) all && \
	echo "$(COLOR_GREEN)✅ Despliegue completado. Mostrando logs...$(COLOR_RESET)" && \
	docker logs mariadb && \
	docker logs wordpress && \
	docker logs nginx