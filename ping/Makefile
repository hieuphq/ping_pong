PHONY: pg

pg:
	@echo "Postgres"
	docker compose up -d db

dev:
	docker compose up -d web

build:
	docker build -t ping:local .