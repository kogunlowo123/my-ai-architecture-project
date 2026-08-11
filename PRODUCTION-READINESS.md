# Production Readiness — Honest Status

**Short answer: this repository is a _reference architecture blueprint_, not a running
production system.** The directory tree, the contracts, and the design are complete and
coherent. The vast majority of the leaf files are intentionally empty or short stubs that
mark where implementation goes. One sub-project (`projects/cigna-ceretax-unified-platform/`)
is a real, unit-tested reference implementation.

Publish it as a portfolio / architecture artifact. Do **not** point it at a cloud account
and expect it to deploy.

## The numbers (measured, not estimated)

Counted across the committed tree (excludes `.git`, `__pycache__`, `.pytest_cache`):

| Metric | Count | Share |
|---|---:|---:|
| Files total | 1033 | 100% |
| Empty (0 bytes) | 221 | 21% |
| Stub (< 200 bytes) | 706 | 68% |
| Substantive (> 200 bytes) | 106 | 10% |

~90% of files are skeleton. That is expected for a scaffold generated from a tree spec — it
is the shape of a platform, waiting to be filled.

## Where the real content is, by subsystem

`> 200B` = files with substantive content.

| Subsystem | Files | Empty | > 200B | State |
|---|---:|---:|---:|---|
| `projects/` (cigna-ceretax) | 97 | 17 | 67 | **Working + tested** — the one real implementation |
| `.github/` | 20 | 0 | 10 | Workflows present; only `ci` + `security` run on push |
| `infra/` | 192 | 34 | 7 | Contract structure only; `.tf` files are comment stubs |
| `services/` | 176 | 3 | 7 | Package layout + a few configs; no runnable service |
| `platform/` | 28 | 0 | 2 | Config skeletons (gateway, model-registry) |
| `identity/` | 86 | 30 | 1 | Structure only |
| `security/` | 111 | 40 | 1 | Structure only |
| `web/` | 1 | 0 | 1 | Static architecture page (`index.html`) |
| `data/` | 28 | 0 | 0 | Structure only |
| `deploy/` | 60 | 34 | 0 | Structure only |
| `docs/` | 25 | 2 | 0 | Mostly stub docs |
| `endpoint/` | 25 | 7 | 0 | Structure only |
| `evals/` | 32 | 9 | 0 | Structure only |
| `network/` | 34 | 18 | 0 | Structure only |
| `observability/` | 27 | 2 | 0 | Structure only |
| `sdk/` | 17 | 1 | 0 | Structure only |
| `serving/` | 11 | 5 | 0 | Structure only |
| `tests/` | 11 | 6 | 0 | Structure only |
| `tools/` | 14 | 2 | 0 | Structure only |
| `training/` | 22 | 11 | 0 | Structure only |

**Ten planes have zero substantive files**: `data`, `deploy`, `docs`, `endpoint`, `evals`,
`network`, `observability`, `sdk`, `serving`, `tests`, `tools`, `training`. They are
directory contracts, not implementations.

## What actually works today

- `projects/cigna-ceretax-unified-platform/` — tier-enforcing orchestrator, hash-chained
  audit log, per-agent workload identity, MCP server skeletons. **2 unit tests pass**
  (`pytest -q` from that directory; CI runs them on every push).
- `web/index.html` — self-contained static architecture brief.
- CI (`ci`, `security`) is green on push. `pages`, `terraform`, `train`, `serve-bench`,
  `nightly`, `evals`, `release` are manual / event-scoped and do **not** block.

## What "production ready" would require (not done here)

1. Fill the ~90% stub/empty files with real code, policy, and config.
2. Real Terraform in `infra/aws|azure|gcp/*` and `infra/envs/*` — the `.tf` files are comments.
3. Runnable services under `services/` (rag-core, agent-runtime, api, workers) with tests.
4. Populated eval suites so `evals.yml` becomes an enforcing gate, not `|| true`.
5. Real secrets wiring (ESO / cloud vaults), image signing, SBOM — currently declared, not built.
6. Load, chaos, and red-team suites executed against a staging environment.

## Bottom line

Green light to **publish as an architecture reference / portfolio piece**.
Red light to treat as **deployable production infrastructure**. The scaffold is the deliverable.
