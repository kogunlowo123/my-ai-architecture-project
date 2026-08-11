"""Tax-engine MCP server: versioned rates/boundaries/content behind scoped tools."""
TOOLS = {
    "get_rate_components": {"scope": "tax:read:content"},
    "resolve_situs": {"scope": "tax:read:boundaries"},
    "read_customer_profile": {"scope": "tax:read:customer_profile"},
    "stage_profile_update": {"scope": "tax:stage:profile_update"},
    "stage_filing_packet": {"scope": "tax:stage:filing_packet"},
}
