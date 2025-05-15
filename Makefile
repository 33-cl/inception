all: up

up:
	@mkdir -p /home/$(shell whoami)/data/wordpress
	@mkdir -p /home/$(shell whoami)/data/mariadb
	@docker compose -f srcs/docker-compose.yml up -d --build

down:
	@docker compose -f srcs/docker-compose.yml down

restart:
	@docker compose -f srcs/docker-compose.yml restart

clean: down
	@docker system prune -af
	@docker volume rm -f $$(docker volume ls -q)
	@sudo rm -rf /home/$(shell whoami)/data/wordpress
	@sudo rm -rf /home/$(shell whoami)/data/mariadb

fclean: clean
	@docker system prune -af --volumes

re: fclean all

.PHONY: all up down restart clean fclean re 