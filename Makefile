# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: dangonz3 <dangonz3@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/11/12 16:11:59 by dangonz3          #+#    #+#              #
#    Updated: 2025/06/12 18:22:10 by dangonz3         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

COLOR_GREEN = \033[0;32m
COLOR_RESET = \033[0m

SRC_DIR = srcs
DOCKER_COMPOSE_FILE = $(SRC_DIR)/docker_compose.yml
VOLUME_DIR = ./volumes
DATABASE_DIR = $(VOLUME_DIR)/database
WEBFILE_DIR = $(VOLUME_DIR)/webfiles

all: $(VOLUME_DIR) $(DATABASE_DIR) $(WEBFILE_DIR)
	docker-compose -f $(DOCKER_COMPOSE_FILE) config
	docker-compose -f $(DOCKER_COMPOSE_FILE) up --build
	@echo "$(COLOR_GREEN)------------ MESSAGE: DOCKER CONTAINERS UP ------------ $(COLOR_RESET)"	
	docker ps
	docker volume ls
	docker network ls

$(VOLUME_DIR):
	mkdir -p $(VOLUME_DIR)

$(DATABASE_DIR):
	mkdir -p $(DATABASE_DIR)

$(WEBFILE_DIR):
	mkdir -p $(WEBFILE_DIR)
	
clean:
	docker-compose -f $(DOCKER_COMPOSE_FILE) down --volumes
	@echo "$(COLOR_GREEN)------------ MESSAGE: DOCKER SERVICES DOWN ------------ $(COLOR_RESET)"
	
fclean: clean
	docker system prune --all --volumes --force
	rm -fr $(VOLUME_DIR)
	@echo "$(COLOR_GREEN)------------ MESSAGE: FCLEANING COMPLETED ------------ $(COLOR_RESET)"

re: fclean all

.PHONY:	all, clean, fclean, re, commit
