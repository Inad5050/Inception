DOCKER_COMPOSE_FILE=srcs/docker-compose.yml
VOLUME_DIR=/home/dangonz3/data

all:
	@mkdir -p ${VOLUME_DIR}/wordpress
	@mkdir -p ${VOLUME_DIR}/mariadb2
	@docker compose -f $(DOCKER_COMPOSE_FILE) up --build

clean:
	@docker compose -f $(DOCKER_COMPOSE_FILE) down -v

fclean: clean
	@docker image prune -a -f
	@docker volume prune -f
	@docker system prune -a -f
	@rm -rf ${VOLUME_DIR}/wordpress
	@rm -rf ${VOLUME_DIR}/mariadb2
	@rm -rf ${VOLUME_DIR}

re: fclean all

.PHONY: all clean fclean re
