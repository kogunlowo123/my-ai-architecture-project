.PHONY: bootstrap lint test eval scan up down

bootstrap:
	python3 -m venv .venv && .venv/bin/pip install -q -U pip uv && .venv/bin/uv pip install -q pyyaml pytest ruff mypy pydantic-settings

lint:
	.venv/bin/ruff check services platform tools projects

test:
	cd projects/cigna-ceretax-unified-platform && ../../.venv/bin/pytest -q

eval:
	.venv/bin/python evals/runners/cli.py --suite regression --env local

scan:
	trivy fs --scanners vuln,secret . || true

up:
	docker compose up -d

down:
	docker compose down -v
