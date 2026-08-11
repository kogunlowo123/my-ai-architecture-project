# ADR-0001: One control plane, many domains

Status: Accepted · Date: 2026-08-10

## Context
Healthcare and tax agent programs were candidates for separate stacks.

## Decision
One agent control plane (identity, tiers, audit, evals); domain logic isolated in
`unified_platform/agents/<domain>` and domain MCP servers.

## Consequences
+ Governance controls are built once and audited once.
+ New domains onboard as agents + an MCP server, not a new platform.
− The control plane is a shared dependency; it gets platform-grade SLOs and
  its own on-call.
