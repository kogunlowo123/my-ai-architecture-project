# CLAUDE.md — Project instructions for Claude Code

## What this repo is
Enterprise Unified Platform for governed agentic workflows across two regulated domains:
healthcare payer operations (HIPAA/PHI) and transaction transaction tax compliance.
Owner: repository maintainer.

## Non-negotiable rules
1. **Never** log, print, or fixture real PHI or taxpayer data. Synthetic fixtures live in
   `tests/fixtures/` and are clearly fake.
2. Every agent action path must emit an audit event via `unified_platform/core/audit`. If you add a
   capability, you add its audit event in the same PR.
3. Autonomy tier changes (T1→T2→T3) require an eval report in `unified_platform/evals/reports/`
   referenced in the PR description. No exceptions.
4. Terraform: never `apply` from a laptop. Plans run in CI (`terraform-plan.yml`);
   applies happen only from the `main` branch pipeline with environment protection.
5. All MCP tool schemas are signed and pinned (`unified_platform/mcp_servers/*/schema.lock.json`).
   Regenerating a lock file is a reviewed change.

## Architecture quick reference
- Orchestrator: `unified_platform/core/orchestrator/` — routes tasks, enforces tier gates.
- Identity: `unified_platform/core/identity/` — per-agent workload identity, OAuth 2.1 token
  exchange, short-lived audience-bound tokens.
- Audit: `unified_platform/core/audit/` — hash-chained, KMS-signed event log.
- Domain agents: `unified_platform/agents/{healthcare,tax}/`.
- MCP servers: `unified_platform/mcp_servers/` — the only path from agents to systems of record.

## Conventions
- Python 3.12, ruff + mypy strict, pytest. `make test` must pass before any commit.
- Terraform ≥ 1.9, module-per-concern, environments consume modules only (no raw
  resources in `environments/`).
- Commit style: `feat(scope): …`, `fix(scope): …`, `infra(scope): …`, `docs(scope): …`.

## Useful commands
- `make bootstrap` — venv + dev deps
- `make test` — unit + eval smoke
- `make plan ENV=dev|staging|prod` — terraform plan
- `/deploy-check` — pre-deploy gate checklist (Claude command)
- `/new-agent` — scaffold a new domain agent with tier T1 defaults
- `/audit-review` — sample and verify audit-chain integrity
