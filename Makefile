DOCKER_COMPOSE_FILE=srcs/docker-compose.yml
VOLUME_DIR=/home/dangonz3/data

all:
	@mkdir -p ${VOLUME_DIR}/wordpress
	@mkdir -p ${VOLUME_DIR}/mariadb2
	@docker compose -f $(DOCKER_COMPOSE_FILE) up --build

clean:
	@docker compose -f $(DOCKER_COMPOSE_FILE) down -v

# Por defecto prune solo elimina recursos "colgantes".
# --all lo altera para que elimine todos los recursos no usados: contenedores, redes e imagenes.
# --volumes hace que tambíen elimine volumenes.
fclean: clean
	@docker image prune -a -f
	@docker volume prune -f
	@docker system prune -a -f
	@rm -rf ${VOLUME_DIR}/wordpress
	@rm -rf ${VOLUME_DIR}/mariadb2
	@rm -rf ${VOLUME_DIR}

re: fclean all

.PHONY: all clean fclean re

push:
	git add .
	git commit -m "generic_push"
	git push
