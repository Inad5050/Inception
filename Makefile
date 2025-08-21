SRC_DIR = srcs
DOCKER_COMPOSE_FILE = $(SRC_DIR)/docker_compose.yml

VOLUME_DIR = /home/dangonz3/data
DATABASE_DIR = $(VOLUME_DIR)/db_data
WEBFILE_DIR = $(VOLUME_DIR)/wp_data

COLOR_GREEN = \033[0;32m
COLOR_RESET = \033[0m

# --build: Es una opción para el comando up. Fuerza la reconstrucción de las imágenes Docker de los servicios \
antes de levantar los contenedores. Esto asegura que cualquier cambio en los Dockerfiles o en el código \
fuente se aplique.
# docker ps: provides a list of the Docker containers on your machine.
# docker volume ls: Lists all the volumes that are currently available on the host machine.
# docker network ls: Lists all the networks the Engine daemon knows about.
all: $(VOLUME_DIR) $(DATABASE_DIR) $(WEBFILE_DIR)
	${SETUP_HOST_SCRIPT}
	docker-compose -f $(DOCKER_COMPOSE_FILE) up -d --build
	@echo "$(COLOR_GREEN)------------ MESSAGE: DOCKER CONTAINERS UP ------------ $(COLOR_RESET)"	
	${WAIT_FOR_WP_SCRIPT}
	sudo find ${WEBFILE_DIR} -type d -exec chmod 755 {} \;
	sudo find ${WEBFILE_DIR} -type f -exec chmod 644 {} \;
	docker ps
	docker volume ls
	docker network ls

$(VOLUME_DIR):
	mkdir -p $(VOLUME_DIR)
$(DATABASE_DIR):
	mkdir -p $(DATABASE_DIR)
$(WEBFILE_DIR):
	mkdir -p $(WEBFILE_DIR)

# docker-compose down: Detiene los contenedores de los servicios definidos y elimina los contenedores y \
las redes que creó docker-compose up.
# volumen anónimo: en el contexto de Docker Compose, es un volumen de datos que Docker crea y gestiona, \
pero al que no se le asigna un nombre específico y predecible por el usuario en el fichero docker-compose.yml.
clean:
	docker-compose -f $(DOCKER_COMPOSE_FILE) down
	@echo "$(COLOR_GREEN)------------ MESSAGE: DOCKER SERVICES DOWN ------------ $(COLOR_RESET)"

# docker system prune: Es el comando base para eliminar datos no utilizados de Docker, como contenedores \
detenidos, redes sin uso y cachés de construcción.
# --all (o -a): Extiende la acción de prune para que no solo elimine los recursos "colgantes" (dangling), \
sino todos los recursos que no estén siendo utilizados por al menos un contenedor. Esto incluye la eliminación \
de todas las imágenes que no estén asociadas a un contenedor existente, incluso si no están "colgantes". 
# --volumes: Incluye en la limpieza todos los volúmenes no utilizados. Por defecto, docker system prune \
no elimina volúmenes para prevenir la pérdida accidental de datos. Esta bandera anula esa protección y \
elimina cualquier volumen que no esté conectado a un contenedor en ejecución o detenido. 
# --force (o -f): Ejecuta el comando sin solicitar confirmación. Normalmente, Docker le pediría que confirme \
una acción tan destructiva. Esta bandera omite esa pregunta y procede directamente con la eliminación.
fclean: clean
	docker system prune --all --volumes --force
	docker builder prune --force
	sudo rm -fr $(VOLUME_DIR)
	@echo "$(COLOR_GREEN)------------ MESSAGE: FCLEANING COMPLETED ------------ $(COLOR_RESET)"

re: fclean all

.PHONY:	all, clean, fclean, re, commit

# Editamos etc/hosts para que la maquina virtual reconozca dangonz3.42.fr como localhost.
define SETUP_HOST_SCRIPT
	@HOST_IP="127.0.0.1"; \
	DOMAIN="dangonz3.42.fr"; \
	HOSTS_ENTRY="$${HOST_IP} $${DOMAIN}"; \
	if ! grep -q "$${HOSTS_ENTRY}" /etc/hosts; then \
		echo "Añadiendo '$${HOSTS_ENTRY}' a /etc/hosts..."; \
		echo "$${HOSTS_ENTRY}" | sudo tee -a /etc/hosts > /dev/null; \
	else \
		echo "La entrada '$${HOSTS_ENTRY}' ya existe en /etc/hosts."; \
	fi
endef

# Esperamos a que wordpress rellene su volumen para darle permiso a su contenido.
define WAIT_FOR_WP_SCRIPT
	@timeout=30; \
	while [ ! -f $(WEBFILE_DIR)/wp-config.php ] && [ $$timeout -gt 0 ]; do \
		echo "Waiting"; \
		sleep 1; \
		timeout=$$((timeout-1)); \
	done; \
	if [ ! -f $(WEBFILE_DIR)/wp-config.php ]; then \
		echo "Error: WordPress setup timed out."; \
		exit 1; \
	fi
endef

push:
	git add .
	git commit -m "fastCommit"
	git push