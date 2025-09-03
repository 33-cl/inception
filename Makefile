NAME = inception

DOCKER_COMPOSE = docker-compose -f srcs/docker-compose.yml

all: up

up:
	@mkdir -p /home/maeferre/data/mariadb
	@mkdir -p /home/maeferre/data/wordpress
	$(DOCKER_COMPOSE) up -d --build

down:
	$(DOCKER_COMPOSE) down

clean: down
	docker system prune -f

fclean: clean
	$(DOCKER_COMPOSE) down -v
	docker system prune -af
	sudo rm -rf /home/maeferre/data/mariadb/*
	sudo rm -rf /home/maeferre/data/wordpress/*

re: fclean up

logs:
	$(DOCKER_COMPOSE) logs

status:
	$(DOCKER_COMPOSE) ps

.PHONY: all up down clean fclean re logs status