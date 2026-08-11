# Governance — Autonomy Tiers

## Tiers

- **T1 Recommend.** Agent produces a recommendation + evidence bundle. A human executes.
  Default for every new agent, permanent for adverse healthcare determinations.
- **T2 Execute with approval.** Agent prepares and stages the action; a named human
  approves per action (or per batch with sampling rules). Tax ledger writes, member
  communications, filing preparation live here.
- **T3 Execute within hard limits.** Autonomous execution inside explicit, machine-enforced
  boundaries: rate caps, jurisdiction/product scope, spend ceilings, reversibility
  requirement. Tax rate lookups and claims-status enrichment live here.

## Promotion

Promotion is earned with evidence, like a probation period:

1. Eval spec exists (`unified_platform/evals/specs/<agent>.yaml`) with thresholds agreed by the
   domain owner and the platform owner.
2. ≥ 30 days of T(n) telemetry with override rate below threshold.
3. Eval report committed to `unified_platform/evals/reports/` and linked in the promotion PR.
4. Compliance-auditor checklist passes.

## Demotion (automatic)

Any of: eval regression on version change, override rate breach, audit-chain
incident, or a hard-limit trip → orchestrator drops the agent one tier and pages the owner.

## The question that matters

Not "autonomous agents: yes or no?" but "what has THIS agent proven, and what blast
radius are we prepared to accept?"
