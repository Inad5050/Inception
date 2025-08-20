# Makefile simplificado para gestionar el ciclo de vida del proyecto

# --- Variables ---
DOCKER_COMPOSE_FILE = ./srcs/docker-compose.yml
VOLUME_DIR = /home/dangonz3/data
DB_DATA_DIR = $(VOLUME_DIR)/db_data
WP_DATA_DIR = $(VOLUME_DIR)/wp_data
COLOR_GREEN = \033[0;32m
COLOR_RESET = \033[0m

# --- Reglas Principales ---

# Target por defecto: crea los directorios necesarios y levanta los contenedores.
all: create_dirs
	@docker-compose -f $(DOCKER_COMPOSE_FILE) up -d --build
	@echo "$(COLOR_GREEN)------------ Contenedores iniciados ------------$(COLOR_RESET)"
	@docker ps

# Detiene y elimina los contenedores y redes creados por Compose.
clean:
	@docker-compose -f $(DOCKER_COMPOSE_FILE) down
	@echo "$(COLOR_GREEN)------------ Servicios detenidos ------------$(COLOR_RESET)"

# Limpieza completa: elimina contenedores, redes, volúmenes e imágenes no utilizadas.
# También borra los directorios de datos del host.
fclean: clean
	@docker system prune --all --volumes --force
	@sudo rm -rf $(VOLUME_DIR)
	@echo "$(COLOR_GREEN)------------ Limpieza completa finalizada ------------$(COLOR_RESET)"

# Reconstruye y reinicia todo el entorno.
re: fclean all

# Target para crear los directorios de volúmenes en el host.
create_dirs:
	@mkdir -p $(DB_DATA_DIR)
	@mkdir -p $(WP_DATA_DIR)

# Declara los targets que no son archivos para evitar conflictos.
.PHONY: all clean fclean re create_dirs
