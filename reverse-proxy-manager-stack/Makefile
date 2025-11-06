# Makefile for managing Reverse Proxy Manager stack

include .env

up:
	docker compose --env-file .env up -d

down:
	docker compose --env-file .env down

build:
	docker compose --env-file .env build

logs:
	docker compose --env-file .env logs -f

restart:
	docker compose --env-file .env restart

ps:
	docker compose --env-file .env ps

clean:
	docker compose --env-file .env down -v --remove-orphans

# Help
help:
	@echo "Makefile commands:"
	@echo "  up       - Start all containers"
	@echo "  down     - Stop all containers"
	@echo "  build    - Build all images"
	@echo "  logs     - View logs"
	@echo "  restart  - Restart all containers"
	@echo "  ps       - Show running containers"
	@echo "  clean    - Stop and remove all containers and volumes"
