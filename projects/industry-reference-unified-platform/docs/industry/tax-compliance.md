# Industry brief — Tax compliance platform

## Workflows on-platform

1. **Determination assist (T3, hard-limited).** Product/service mapping suggestions and
   situs resolution against versioned content; fully reversible, rate-capped.
2. **Exemption certificate handling (T2).** Extraction + validation of certificates;
   staging into the customer profile behind approval.
3. **Filing readiness (T2, human-signed).** Reconciliation checks, anomaly flags,
   liability summaries; a human signs every filing, always.

## Domain rules encoded

- Rates and boundaries are versioned by effective date; agents may never cache a rate
  across effective-date boundaries.
- Communications tax stacking (federal USF, state/local E911, regulatory fees) is a
  separate composable pipeline from sales/use tax.
- Every determination stores its full input vector + content version → replayable
  audit defense.

## KPIs

Determination accuracy vs. golden set, exemption-processing cycle time, audit-defense
retrieval time (target: minutes, not days), filing exception rate.
