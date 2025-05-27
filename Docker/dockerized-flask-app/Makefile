# Makefile for Dockerized Flask App with check .env-file

ENV_FILE=.env
COMPOSE=docker-compose --env-file $(ENV_FILE)
REQUIRED_ENV_VARS=POSTGRES_DB POSTGRES_USER POSTGRES_PASSWORD
PROJECT_NAME=dockerized-flask-app

.PHONY: up down build logs restart shell prune ps health check-env

check-env:
	@echo "Check $(ENV_FILE)..."
	@if [ ! -f $(ENV_FILE) ]; then \
		echo "file $(ENV_FILE) not found!"; \
		exit 1; \
	fi; \
	MISSING=""; \
	for VAR in $(REQUIRED_ENV_VARS); do \
		if ! grep -q "^$$VAR=" $(ENV_FILE); then \
			echo " Variable $$VAR not found in $(ENV_FILE)"; \
			MISSING="yes"; \
		fi; \
	done; \
	if [ "$$MISSING" = "yes" ]; then \
		echo " Errors in file $(ENV_FILE). Add variables"; \
		exit 1; \
	else \
		echo "Your env-file is ok!"; \
	fi

up: check-env
	$(COMPOSE) up -d

down:
	$(COMPOSE) down

build: check-env
	$(COMPOSE) build

logs:
	$(COMPOSE) logs -f

restart: down up

shell:
	$(COMPOSE) exec web sh

prune:
	docker system prune -f

ps:
	$(COMPOSE) ps

health:
	curl -f http://localhost || echo "⚠️ App may not be healthy"
