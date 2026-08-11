Scaffold a new domain agent named $ARGUMENTS.

1. Ask which domain (healthcare | tax) and one-sentence purpose if not given.
2. Create `unified_platform/agents/<domain>/<name>/` with `agent.py` (T1 default, capabilities
   declared, audit events wired), `policy.py`, and a table-driven test.
3. Register it in `unified_platform/core/registry/manifest.yaml` with tier: T1,
   owner, and allowed MCP tools (least privilege — start empty, add explicitly).
4. Add an eval spec stub in `unified_platform/evals/specs/<name>.yaml`.
5. Show the diff summary and remind that T2 promotion needs an eval report.
