"""Per-agent workload identity via OAuth 2.1 token exchange (RFC 8693 pattern).

Kills the confused-deputy problem: an agent never borrows a platform credential.
It presents its own identity + task context and receives a token that is
short-lived (<=15 min), audience-bound (one MCP server), and scope-bound
(named capabilities only).
"""
from __future__ import annotations

from dataclasses import dataclass


@dataclass(frozen=True)
class ScopedToken:
    subject: str          # agent identity, e.g. "agent:prior-auth"
    audience: str         # e.g. "mcp:fhir-gateway"
    scopes: tuple[str, ...]
    expires_in: int       # seconds


class TokenExchanger:
    """Adapter over the IdP's token-exchange endpoint (Entra ID / Okta / Cognito)."""

    def __init__(self, idp_client) -> None:
        self._idp = idp_client

    def exchange(self, agent: str, scopes: list[str], audience: str,
                 ttl_seconds: int = 900) -> ScopedToken:
        if ttl_seconds > 900:
            raise ValueError("Agent tokens are capped at 15 minutes by policy")
        raw = self._idp.token_exchange(subject=f"agent:{agent}", audience=audience,
                                       scope=" ".join(scopes), ttl=ttl_seconds)
        return ScopedToken(subject=f"agent:{agent}", audience=audience,
                           scopes=tuple(scopes), expires_in=ttl_seconds)
