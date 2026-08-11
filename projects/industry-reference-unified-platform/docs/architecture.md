# Architecture — Enterprise Unified Platform for Agentic Workflows

## 1. Thesis

The blocker for enterprise agents is not model quality — it's accountability. This platform
treats an agent like a new hire: scoped credentials, least privilege, logged actions, and a
manager (the orchestrator + human approval gates). One control plane serves two regulated
domains because the governance primitives are identical; only the domain agents and the
systems of record differ.

## 2. Layered view

```
┌────────────────────────────────────────────────────────────────┐
│  Experience layer     Payer ops console · Tax ops console       │
├────────────────────────────────────────────────────────────────┤
│  API gateway          AuthN/Z (OIDC) · rate limits · WAF        │
├────────────────────────────────────────────────────────────────┤
│  Agent control plane                                            │
│    Orchestrator ── tier gates (T1/T2/T3) ── approval queue      │
│    Agent registry (manifest, capabilities, owners)              │
│    Workload identity (OAuth 2.1 token exchange, per-agent)      │
│    Audit chain (hash-linked, KMS-signed)                        │
│    Eval harness (promotion gates)                               │
├────────────────────────────────────────────────────────────────┤
│  Tool layer (MCP)     FHIR gateway server · Tax engine server   │
│                       — signed, pinned schemas; sandboxed exec  │
├────────────────────────────────────────────────────────────────┤
│  Systems of record    Claims core · Eligibility · Tax content   │
│                       DBs · Rate/boundary data · Filing rails   │
└────────────────────────────────────────────────────────────────┘
```

## 3. Request lifecycle (prior-auth example)

1. Intake: ServiceRequest arrives via API gateway; orchestrator assigns to
   `prior_auth` agent (tier from manifest: T2).
2. Identity: orchestrator performs token exchange → short-lived, audience-bound token
   scoped to `fhir_gateway:read:coverage,servicerequest`.
3. Reasoning: agent gathers evidence via MCP tools only; every tool call emits an
   audit event (actor, capability, input hash, output hash, prev-hash link).
4. Gate: recommendation → approval queue. A licensed reviewer approves/overrides.
   Adverse determinations are never auto-executed (T1 by policy).
5. Outcome + human decision are appended to the chain; eval telemetry updates the
   agent's promotion evidence.

Tax determination follows the same shape: rate lookup and situs resolution are T3
(hard-limited, reversible), ledger writes are T2, filings are human-signed.

## 4. Identity model

- Every agent = a workload identity (no shared service accounts).
- OAuth 2.1 token exchange kills the confused-deputy problem: the agent presents its
  own identity + the task context, receives a token usable only for the named audience
  and scope, TTL ≤ 15 minutes.
- Human approvals are separate principals — an approval is never performed with the
  agent's credential.

## 5. Failure modes designed for

| Failure | Control |
|---|---|
| Tool poisoning / schema swap | Signed + pinned MCP schemas (`schema.lock.json`), verified at session start |
| Prompt injection via retrieved data | Tool results treated as data; no tool grants outside manifest; egress allow-list |
| Runaway autonomy | Hard limits per T3 agent (rate caps, jurisdiction scope, spend ceiling) + kill switch in orchestrator |
| Silent drift | Eval gates re-run on model/prompt/tool version change; demotion path is automatic |
| Audit tampering | Hash-chained events, KMS-signed checkpoints, WORM storage (S3 Object Lock) |

## 6. Control mapping

| Platform control | HIPAA | SOC 2 | ISO 27001 | ISO/IEC 42001 |
|---|---|---|---|---|
| Hash-chained audit log | §164.312(b) | CC7.2 | A.8.15 | 8.4 |
| Per-agent workload identity | §164.312(a)(2)(i) | CC6.1 | A.5.16 | 8.2 |
| Least-privilege tool scopes | §164.308(a)(4) | CC6.3 | A.8.2 | 8.2 |
| Human approval gates | §164.308(a)(3) | CC5.1 | A.5.3 | 9.2 |
| Eval promotion gates | — | CC7.1 | A.8.29 | 8.3 / 9.1 |
| Encryption in transit/at rest | §164.312(e) | CC6.7 | A.8.24 | — |

## 7. Cost & scale notes (realistic, not idealized)

- Token spend is dominated by evidence-gathering; the orchestrator caches tool results
  per task with content-hash keys (observed 30–50% reduction in similar builds).
- Approval queues are the real throughput ceiling for T2 — plan reviewer staffing, not
  just GPU/API capacity.
- Eval suites are the largest hidden cost line; budget them like a test org, not a
  side project.
