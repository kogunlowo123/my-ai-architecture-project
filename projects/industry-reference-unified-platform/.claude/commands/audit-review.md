Verify audit-chain integrity for $ARGUMENTS (default: last 24h of dev).

1. Run `python -m unified_platform.core.audit.verify --window "$ARGUMENTS"`.
2. Report: total events, chain-verification result, any gaps or hash mismatches.
3. Sample 5 events and confirm each maps to a registered capability in the manifest.
4. If any mismatch: open a findings note in ops/runbooks/audit-incident-<date>.md.
