.PHONY: all clean re

all:
	cd srcs && docker compose up -d

clean:
	cd srcs && docker compose down -v

re: clean
	$(MAKE) all