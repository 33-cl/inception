.PHONY: all clean re

all:
	cd srcs && docker compose up --build

clean:
	cd srcs && docker compose down -v

re: clean
	$(MAKE) all