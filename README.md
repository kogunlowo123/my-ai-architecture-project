# My AI Architecture Project

**Kehinde Ogunlowo** — AI Platform Architect & Forward Deployed Engineer

> **Status: reference architecture blueprint.** The tree, contracts, and design are complete;
> ~90% of leaf files are intentional stubs marking where implementation goes. The
> `projects/industry-reference-unified-platform/` sub-project is a real, unit-tested reference
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
2. **`projects/industry-reference-unified-platform/`** — a working, tested reference implementation of
   governed agentic workflows for a healthcare payer (HIPAA) and a transaction-tax
   compliance platform: tier-enforcing orchestrator, hash-chained audit log (unit-tested),
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
| Working governed-agents reference | `projects/industry-reference-unified-platform/` |

## The complete tree — one view

Seven operating planes, one repository. Every directory below is an ordinary,
gated part of the tree — identity and zero-trust controls are not a separate annex.

| Plane | Charter | Primary directories |
|---|---|---|
| **APPOPS** | Agent applications & runtime | `services/` (rag-core, agent-runtime, api, workers), `sdk/` |
| **NETOPS** | Zero-trust network & device trust | `network/` (mesh, microseg, ztna, egress), `endpoint/` |
| **SECOPS** | AppSec, DLP, SOC, defensive RAG, IR | `security/`, `evals/red-team`, `evals/security` |
| **DEVOPS** | IaC, CI/CD, GitOps, observability | `infra/`, `.github/`, `deploy/`, `observability/`, `tools/` |
| **DATAOPS** | Ingestion, contracts, lineage, warehouse | `data/`, `training/datasets` |
| **LLMOPS** | Gateway, registry, evals, train/serve | `platform/`, `evals/`, `training/`, `serving/` |
| **IDENTITY** | Agentic + workforce identity, NHI | `identity/` (spiffe, federation, delegation, workforce) |

> This is the **target architecture** — the layout `agentctl scaffold` generates, fully
> expanded. Most leaf files ship as stubs today; see
> [`PRODUCTION-READINESS.md`](PRODUCTION-READINESS.md) for what is real vs. scaffolded.

```
ai-agent-platform/
├── README.md                      entry point, 10-minute local bootstrap
├── CODEOWNERS                     path-based review routing; identity/ and security/ need two owners
├── SECURITY.md  CONTRIBUTING.md  CHANGELOG.md  VERSION  LICENSE
├── Makefile                       bootstrap, lint, test, eval, scan, up, down
├── docker-compose.yml             local stack: postgres+pgvector, opensearch, redis, langfuse, gateway, api
├── .env.example  .pre-commit-config.yaml  .editorconfig  .gitignore  .dockerignore
│
├── .github/                       DEVOPS — CI/CD
│   ├── dependabot.yml  pull_request_template.md  ISSUE_TEMPLATE/
│   ├── actions/                   composite: setup-python, setup-terraform, docker-build-push, eval-gate, gpu-runner
│   └── workflows/                 ci, terraform, evals, train, serve-bench, security, release, nightly, pages
│
├── infra/                         DEVOPS — Terraform, cloud-agnostic by contract
│   ├── contracts/                 interfaces only, zero providers (network, kubernetes, gpu-pool,
│   │                              vector-store, relational-db, object-store, model-endpoint, kms,
│   │                              messaging, observability)
│   ├── aws/  azure/  gcp/         each implements the contracts with its own providers
│   ├── envs/                      the only place providers exist: {aws,azure,gcp}/{dev,staging,prod}
│   │   └── _posture/              cloud-neutral per-env identity + security posture tfvars
│   ├── bootstrap/                 state-backends, ci-oidc, org-baseline (applied once per cloud)
│   ├── policies/                  OPA/conftest: deny-public-buckets, require-kms, tag-enforcement, cost-guardrails
│   └── tests/                     terratest + golden plans (drift fails CI)
│
├── platform/                      LLMOPS — shared services every agent consumes
│   ├── gateway/                   the single LLM front door: routing, fallback, cache, budgets, profiles
│   ├── model-registry/            approved catalog; gateway refuses anything not listed; promoted checkpoints
│   ├── accuracy-surface/          the customer-facing finding-accuracy number, read-only from evals
│   ├── authn/  feature-flags/  tenancy/
│
├── services/                      APPOPS
│   ├── rag-core/                  the shared retrieval spine (ingestion, parsing, chunking, enrichment,
│   │                              embeddings, stores, hybrid retrieval + rerank + CRAG, prompts, guardrails)
│   ├── agent-runtime/             registry (T0–T3 agents), orchestrator, tools, guardrails, memory,
│   │                              sessions, self-improvement loop
│   ├── api/                       FastAPI: chat (SSE/WS), agents, corpora, feedback, admin, health
│   └── workers/                   KEDA-scaled: ingestion, reembed, eval, ttl, dlq
│
├── sdk/                           APPOPS — typescript, python, ui-components (react/web-component), examples
│
├── data/                          DATAOPS — Dagster pipelines, data contracts, quality gates, lineage,
│                                  retention/RTBF, dbt warehouse
│
├── training/                      LLMOPS — datasets (curation/synthetic/registry), sft, preference (dpo/grpo),
│                                  distributed (fsdp/deepspeed), experiments, evals-gate → checkpoints
│
├── serving/                       LLMOPS/DATAOPS — vllm engine configs, quantization budgets, routing/byok,
│                                  benchmarks, warmup probes
│
├── evals/                         SECOPS/LLMOPS — golden + adversarial datasets, retrieval/generation/agent
│                                  scoring, red-team (injection/exfil/pii), security (owasp, exploit-chains,
│                                  finding-accuracy), regression thresholds, runners (cli + ci_gate)
│
├── security/                      SECOPS
│   ├── policies/                  kyverno + gatekeeper admission control
│   ├── detections/                detection-as-code, MITRE-mapped (sigma, kql, cloudwatch)
│   ├── secrets/ supply-chain/ threat-models/ compliance/
│   ├── appsec/  data-protection/  soc/                application security, DLP/encryption, SIEM/UEBA/SOAR
│   ├── defensive-rag/             retrieval as the security control plane (signed corpora, grounding,
│   │                              correlation, remediation, self-healing, verification)
│   └── incident-response/
│
├── identity/                      IDENTITY — every agent is a first-class principal
│   ├── registry/ spiffe/ federation/ issuance/ delegation/ authorization/ nhi/
│   ├── workforce/                 human identity plane: providers, authn, sso, mfa, adaptive, rbac,
│   │                              lifecycle (scim), iga, pam, uam
│   ├── session/                   append-only ledger + revocation
│   └── detections/ tests/
│
├── network/                       NETOPS — mesh (istio mTLS), ingress, default-deny policies, egress
│                                  allowlist, dns, microseg (by identity set), ztna (SDP for admin planes)
│
├── endpoint/                      NETOPS — device trust: baselines, av, edr, mdm, compliance posture signal,
│                                  patch, encryption, ephemeral runners
│
├── deploy/                        DEVOPS — helm charts, cloud/env overlays, argocd (app-of-apps, sync-waves),
│                                  rollouts (canary + eval-canary + model-canary), scripts (break-glass,
│                                  promote-index, rollback-model, promote-checkpoint, drain-gpu-pool)
│
├── observability/                 DEVOPS — otel (+pii-scrub), langfuse tracing, grafana dashboards,
│                                  prometheus alerts, SLOs, synthetics
│
├── docs/                          adr, architecture (c4), runbooks, failure-modes, onboarding, api
│
├── tests/                         cross-cutting: integration, e2e, load (k6), chaos
│
├── tools/                         DEVOPS — agentctl (scaffold/validate/deploy), corpusctl, costctl
│
├── web/                           static architecture brief (GitHub Pages)
│
└── projects/
    └── industry-reference-unified-platform/   working, unit-tested governed-agents reference
                                          (healthcare payer HIPAA + tax compliance)
```

### Cloud parity — what each contract binds to

| Contract | AWS | Azure | GCP |
|---|---|---|---|
| kubernetes | EKS + Karpenter, IRSA | AKS + Workload Identity | GKE + Workload Identity |
| relational-db | Aurora PostgreSQL 16 + pgvector | PostgreSQL Flexible + pgvector | Cloud SQL PostgreSQL + pgvector |
| vector / lexical | pgvector HNSW + OpenSearch | pgvector + Azure AI Search | pgvector + Vertex Vector Search |
| model-endpoint | Bedrock via PrivateLink | Azure OpenAI / Foundry (PE) | Vertex Gemini via PSC |
| object-store | S3 (SSE-KMS, versioned) | Blob (CMK, versioned) | GCS (CMEK, versioned) |
| messaging | SQS + EventBridge | Service Bus + Event Grid | Pub/Sub |
| kms / secrets | KMS + Secrets Manager (ESO) | Key Vault + Managed HSM (ESO) | Cloud KMS + Secret Manager (ESO) |
| agent identity | IRSA + IAM Roles Anywhere, STS | Entra Workload ID | Workload Identity Federation |
| edge / WAF | CloudFront + WAF + Shield | Front Door + Azure WAF | Cloud CDN + Cloud Armor |
| observability | CloudWatch + AMP + X-Ray | Azure Monitor + Grafana | Cloud Ops + Managed Prometheus |
| tf state | S3 + DynamoDB lock | azurerm blob backend | GCS backend |
| CI auth | GitHub OIDC → IAM role | GitHub OIDC → federated cred | GitHub OIDC → WIF |

Anything not on this table is cloud-neutral (Kubernetes, Postgres, Redis, OTel) and identical across all three.

License: MIT.
