Run the pre-deploy gate for $ARGUMENTS (default: staging).

1. `make test` — all green required.
2. `terraform validate` + `terraform plan` for the target env; summarize resource deltas.
3. Verify eval reports exist and pass thresholds for every agent at T2+.
4. Run the compliance-auditor sub-agent checklist.
5. Produce a go/no-go summary with any blocking findings as file:line references.
