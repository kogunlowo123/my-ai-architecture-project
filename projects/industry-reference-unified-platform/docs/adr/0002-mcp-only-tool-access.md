# ADR-0002: MCP servers are the only tool path

Status: Accepted · Date: 2026-08-10

## Context
Agents could call systems of record directly (faster to build) or exclusively via
MCP servers (governable).

## Decision
All agent → system-of-record traffic goes through MCP servers with signed, pinned
schemas and per-capability scopes. Direct calls are lint-blocked.

## Consequences
+ Single choke point for identity, audit, and egress control.
+ Tool poisoning surface reduced to a reviewed lock-file diff.
− Extra hop latency (~10–30 ms observed in comparable builds) — acceptable.
