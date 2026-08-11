.PHONY: bootstrap test lint plan

ENV ?= dev

bootstrap:
	python3 -m venv .venv && .venv/bin/pip install -q pyyaml pytest ruff mypy

test:
	.venv/bin/pytest -q tests/

lint:
	.venv/bin/ruff check unified_platform/ services/ tests/

plan:
	cd infrastructure/terraform/environments/$(ENV) && terraform init -backend=false && terraform validate && terraform plan
