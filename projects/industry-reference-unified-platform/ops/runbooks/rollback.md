# Runbook — Model/prompt version rollback
1. Identify last-good version from eval reports (unified_platform/evals/reports/).
2. `terraform plan` with pinned model_version var in the target env; apply via CI.
3. Orchestrator re-runs eval smoke on the rolled-back version before re-admitting T2/T3.
