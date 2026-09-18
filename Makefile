.DEFAULT_GOAL := all

SHELL := /bin/sh

COMPOSE_FILE := srcs/docker-compose.yml
ENV_FILE := srcs/.env
COMPOSE := docker compose --env-file $(ENV_FILE) -f $(COMPOSE_FILE)
SECRETS := \
	secrets/mariadb_database.txt \
	secrets/mariadb_user.txt \
	secrets/mariadb_password.txt \
	secrets/mariadb_root_password.txt \
	secrets/wordpress_admin_password.txt \
	secrets/wordpress_user_password.txt

-include $(ENV_FILE)

.PHONY: all up build down restart logs ps clean re check check-env check-secrets storage

all: up

up: check storage build
	$(COMPOSE) up -d

build: check
	$(COMPOSE) build --progress=plain

down:
	$(COMPOSE) down

restart: down up

logs:
	$(COMPOSE) logs -f

ps:
	$(COMPOSE) ps

clean:
	$(COMPOSE) down --volumes --rmi local

re: down up

check: check-env check-secrets
	@command -v docker >/dev/null || { echo "Docker is not installed" >&2; exit 1; }
	@docker compose version >/dev/null || { echo "Docker Compose plugin is not available" >&2; exit 1; }

check-env:
	@test -f "$(ENV_FILE)" || { echo "Missing $(ENV_FILE); copy srcs/.env.template first" >&2; exit 1; }
	@test -n "$(MARIADB_DATA_PATH)" || { echo "MARIADB_DATA_PATH must be set in $(ENV_FILE)" >&2; exit 1; }
	@test -n "$(WORDPRESS_DATA_PATH)" || { echo "WORDPRESS_DATA_PATH must be set in $(ENV_FILE)" >&2; exit 1; }

check-secrets:
	@for secret_file in $(SECRETS); do \
		test -s "$$secret_file" || { echo "Missing or empty secret: $$secret_file" >&2; exit 1; }; \
	done

storage: check-env
	@mkdir -p "$(MARIADB_DATA_PATH)" "$(WORDPRESS_DATA_PATH)"
