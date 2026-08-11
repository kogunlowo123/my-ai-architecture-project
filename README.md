# My AI Architecture Project

**Kehinde Ogunlowo** — AI Platform Architect & Forward Deployed Engineer

> **Status: reference architecture blueprint.** The tree, contracts, and design are complete;
> ~90% of leaf files are intentional stubs marking where implementation goes. The
> `projects/cigna-ceretax-unified-platform/` sub-project is a real, unit-tested reference
> implementation. See [`PRODUCTION-READINESS.md`](PRODUCTION-READINESS.md) for a measured,
> per-subsystem status. Publish as a portfolio/architecture artifact — not as deployable
> production infrastructure.

One repository, two layers:

1. **`ai-agent-platform` scaffold (repo root)** — the complete enterprise AI agent platform tree
   across seven planes (APPOPS, NETOPS, SECOPS, DEVOPS, DATAOPS, LLMOPS, IDENTITY): cloud-agnostic
   Terraform contracts with AWS/Azure/GCP implementations, an LLM gateway + model registry, a single
   RAG spine, a tiered agent runtime (T0–T3), agentic identity (SPIFFE, delegation chains, token
   TTL by tier), workforce identity, defensive RAG, training/serving planes, evals with red-team
   and security scoring, and GitOps deploy with eval-gated canaries.
2. **`projects/cigna-ceretax-unified-platform/`** — a working, tested reference implementation of
   governed agentic workflows for a healthcare payer (Cigna-scale, HIPAA) and a tax-compliance
   platform (CereTax-style): tier-enforcing orchestrator, hash-chained audit log (unit-tested),
   per-agent workload identity, and its own env-per-folder Terraform. Ships as a Claude Code
   project (`.claude/` sub-agents and commands).

**Live site:** `web/index.html`, published via GitHub Pages (`.github/workflows/pages.yml`).

## Quick start

```bash
make bootstrap && make test     # runs the tested sub-project suite
make up                          # local stack: postgres+pgvector, opensearch, redis, langfuse
```

## Map of the tree

| Plane | Where |
|---|---|
| Infra contracts + 3-cloud impl | `infra/` (contracts/, aws/, azure/, gcp/, envs/, policies/) |
| LLM gateway, registry, tenancy | `platform/` |
| RAG spine, agent runtime, API | `services/` |
| Data pipelines, contracts, dbt | `data/` |
| Model plane (train/serve) | `training/`, `serving/` |
| Evals, red-team, security scoring | `evals/` |
| Security planes (appsec, DLP, SOC, defensive RAG) | `security/` |
| Agent + workforce identity | `identity/` |
| Network zero trust, microseg, ZTNA | `network/` |
| Device trust | `endpoint/` |
| Helm, ArgoCD, canaries | `deploy/` |
| OTel, dashboards, SLOs | `observability/` |
| CLIs (agentctl, corpusctl, costctl) | `tools/` |
| Working governed-agents reference | `projects/cigna-ceretax-unified-platform/` |

License: MIT.
