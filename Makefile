COMPOSE_FILE=srcs/docker-compose.yml

all: up

up:
	@mkdir -p /home/dangonz3/data/wordpress
	@mkdir -p /home/dangonz3/data/mariadb2

	@docker compose -f $(COMPOSE_FILE) up --build

down:
	@docker compose -f $(COMPOSE_FILE) down -v

restart: down up

clean: down
	@docker image prune -a -f
	@docker volume prune -f
	@docker system prune -a -f

	@rm -rf /home/dangonz3/data/wordpress
	@rm -rf /home/dangonz3/data/mariadb2
	@rm -rf /home/dangonz3/data

re: clean up
