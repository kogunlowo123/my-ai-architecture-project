# Enterprise Unified Platform — Agentic Workflows for Regulated Industries

**Reference engagements:** Healthcare payer · Tax compliance SaaS

A production-grade reference platform for deploying **governed AI agents** in two regulated
domains that share the same hard problem: a probabilistic model being handed deterministic,
audited capabilities.

- **Healthcare (payer operations):** prior authorization triage, claims adjudication support,
  member-services copilots — all touching PHI under HIPAA.
- **Tax compliance:** transaction tax determination, exemption certificate
  handling, filing-readiness checks — where a wrong answer is a financial and regulatory event.

## Why one platform for two industries

Both domains need the same platform primitives, and neither can ship without them:

| Primitive | Healthcare need | Tax need |
|---|---|---|
| Non-human identity | Agent acting on PHI must carry scoped, short-lived credentials | Agent writing to a tax ledger must be attributable |
| Autonomy tiers (T1–T3) | Prior-auth recommendation vs. auto-approval | Suggested tax code vs. auto-applied rate |
| Hash-chained audit | HIPAA §164.312(b) audit controls | SOX / audit-defense trail per determination |
| Eval gates | Clinical-policy accuracy before promotion | Rate/jurisdiction accuracy before promotion |
| Human approval gates | Adverse determinations always human-signed | Filings always human-signed |

## Repository layout

```
agentic-unified-platform/
├── .claude/                     # Claude Code project config (agents, commands, settings)
├── .github/workflows/           # CI + Terraform plan/apply pipelines
├── docs/                        # Architecture, governance model, ADRs, industry briefs
├── unified_platform/
│   ├── core/                    # Orchestrator, agent registry, identity, audit chain
│   ├── agents/
│   │   ├── healthcare/          # prior_auth, claims_navigator, member_services
│   │   └── tax/                 # determination, exemption, filing_readiness
│   ├── mcp_servers/             # FHIR gateway + tax-engine MCP servers (typed, signed schemas)
│   ├── evals/                   # Promotion gates per agent per tier
│   └── shared/                  # Config, telemetry, common schemas
├── services/api_gateway/        # Ingress, authn/z, rate limiting
├── infrastructure/terraform/    # environments/{dev,staging,prod} + reusable modules
├── ops/runbooks/                # Incident response, rollback, key rotation
├── tests/
└── web/index.html               # Deployable GitHub Pages architecture brief
```

## Quick start

```bash
make bootstrap        # venv + deps
make test             # unit tests + eval smoke suite
make plan ENV=dev     # terraform plan for dev
```

Open this repo in **Claude Code** — `.claude/` ships with domain sub-agents
(`claims-navigator`, `tax-determination`, `compliance-auditor`) and commands
(`/deploy-check`, `/new-agent`, `/audit-review`).

## Governance model (short version)

Agents are classified into autonomy tiers. **T1** recommends, a human executes.
**T2** executes behind explicit approval gates. **T3** executes autonomously inside
hard limits (spend, blast radius, jurisdiction scope). Promotion between tiers is
earned with eval evidence, never granted by default. Full model: `docs/governance.md`.

## Compliance mapping

Controls map to HIPAA Security Rule, SOC 2 (CC6/CC7), ISO 27001 A.8.15, and ISO/IEC 42001.
See `docs/architecture.md` §6 for the line-by-line mapping.

## License

MIT — see LICENSE.
