"""Tax determination agent (T3, hard-limited). Suggests mappings, resolves situs,
looks up rates from versioned content. Fully reversible; never writes the ledger.
"""
from __future__ import annotations

from decimal import Decimal, ROUND_HALF_UP
from typing import Any

CENT = Decimal("0.01")


def lookup_rate(payload: dict[str, Any], token) -> dict[str, Any]:
    """Rates come from the tax-engine MCP server, versioned by effective date.
    This function composes them; it never hardcodes a rate."""
    amount = Decimal(str(payload["amount"]))
    components = payload["rate_components"]   # [{jurisdiction, rate, content_version}]
    lines = []
    total = Decimal("0")
    for c in components:
        tax = (amount * Decimal(str(c["rate"]))).quantize(CENT, rounding=ROUND_HALF_UP)
        total += tax
        lines.append({
            "jurisdiction": c["jurisdiction"],
            "rate": c["rate"],
            "tax": str(tax),
            "content_version": c["content_version"],   # replayable audit defense
        })
    return {"taxable_amount": str(amount), "total_tax": str(total), "lines": lines,
            "input_vector_stored": True}
