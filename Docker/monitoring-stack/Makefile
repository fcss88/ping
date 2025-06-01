# Makefile for Full-stack Monitoring Stack

ENV_FILE=.env
COMPOSE=docker-compose --env-file $(ENV_FILE)

up:
	$(COMPOSE) up -d

down:
	$(COMPOSE) down

build:
	$(COMPOSE) build

restart:
	$(COMPOSE) down
	$(COMPOSE) up -d

logs:
	$(COMPOSE) logs -f

ps:
	$(COMPOSE) ps

clean:
	$(COMPOSE) down -v --remove-orphans

grafana-dashboards:
	mkdir -p grafana/dashboards

prometheus-config-check:
	docker run --rm -v $(PWD)/prometheus:/etc/prometheus prom/prometheus:v2.52.0 --config.file=/etc/prometheus/prometheus.yml --log.level=error

help:
	@echo "avaliable options:"
	@echo "  make up              — start stack"
	@echo "  make down            — stop stack"
	@echo "  make build           — build images"
	@echo "  make restart         — restart stack"
	@echo "  make logs            — watch logs"
	@echo "  make ps              — containers list"
	@echo "  make clean           — full clean stack"
	@echo "  make grafana-dashboards — create directory for Grafana-dashboards"
	@echo "  make prometheus-config-check — check Prometheus configuration"
