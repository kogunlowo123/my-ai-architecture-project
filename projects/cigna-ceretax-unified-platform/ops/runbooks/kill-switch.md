# Runbook — Agent kill switch
Trigger: hard-limit trip, audit-chain incident, or on-call judgment.
1. `orchestrator.kill("<agent>")` via ops console or break-glass CLI (MFA required).
2. Confirm halt: no new audit events for the agent within 60s.
3. Page agent owner; open incident doc from template.
4. Re-enable only via a demotion-review PR: agent returns one tier lower.
