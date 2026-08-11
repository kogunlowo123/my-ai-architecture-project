"""FHIR gateway MCP server: the ONLY path from agents to member data.

- Validates the agent's audience-bound token and per-capability scopes.
- PHI minimization: returns structured minimum-necessary fields, never raw bundles.
- Serves a signed, pinned tool schema (schema.lock.json) verified at session start.
"""
# Implementation stub — wire to your FHIR R4 store (HAPI / Firely / payer core).
TOOLS = {
    "read_coverage": {"scope": "fhir:read:coverage"},
    "read_servicerequest": {"scope": "fhir:read:servicerequest"},
    "read_claim": {"scope": "fhir:read:claim"},
    "stage_priorauth_packet": {"scope": "priorauth:stage:packet"},
}
