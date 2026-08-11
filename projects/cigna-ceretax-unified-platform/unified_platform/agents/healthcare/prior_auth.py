"""Prior-authorization agent (T2). Recommends; a licensed reviewer decides.

Evidence flow: ServiceRequest -> Coverage + clinical policy via FHIR gateway MCP
-> recommendation packet with citations. Denial recommendations carry mandatory
'reviewer attention' flags; auto-denial logic is intentionally absent (policy).
"""
from __future__ import annotations

from dataclasses import dataclass
from typing import Any


@dataclass(frozen=True)
class RecommendationPacket:
    service_request_id: str
    recommendation: str            # "approve" | "pend" | "reviewer_attention"
    policy_citations: list[str]
    evidence_refs: list[str]       # FHIR resource references, PHI-minimized


def draft_recommendation(payload: dict[str, Any], token) -> dict[str, Any]:
    sr_id = payload["service_request_id"]
    evidence = payload["evidence"]           # gathered by gather_evidence capability
    policy_hits = payload["policy_matches"]

    if not policy_hits:
        rec = "reviewer_attention"           # never recommend denial; flag instead
    elif all(m["criteria_met"] for m in policy_hits):
        rec = "approve"
    else:
        rec = "pend"

    packet = RecommendationPacket(
        service_request_id=sr_id,
        recommendation=rec,
        policy_citations=[m["policy_id"] for m in policy_hits],
        evidence_refs=[e["ref"] for e in evidence],
    )
    return {"packet": packet.__dict__}
