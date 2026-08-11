# Industry brief — Healthcare payer

## Workflows on-platform

1. **Prior authorization triage (T2).** Intake ServiceRequest → gather Coverage +
   clinical policy evidence via FHIR gateway → recommendation with citations →
   licensed reviewer decides. Denials remain T1 by policy (and consistent with the
   direction of CMS-0057 interoperability/prior-auth rules).
2. **Claims navigator (T2/T3 mix).** Status enrichment and member-friendly explanations
   are T3; any adjustment staging is T2.
3. **Member services copilot (T1).** Agent-assist for CSRs: surfaces benefits, accumulators,
   and next-best-action; the human owns the conversation.

## Data boundaries

- PHI never leaves the FHIR gateway boundary un-tokenized; agents see the minimum
  necessary fields per capability scope.
- Model calls route through a no-retention endpoint; prompts are PHI-minimized
  by the gateway (structured field passing, not free-text dumps).

## KPIs to instrument from day one

Prior-auth turnaround time, reviewer override rate, appeal reversal rate on
agent-recommended decisions, CSR handle-time delta, audit-verification pass rate.
