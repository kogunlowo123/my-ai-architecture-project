from unified_platform.core.registry.registry import HardLimits


def test_jurisdiction_scope_enforced():
    hl = HardLimits({"jurisdiction_scope": ["US"], "reversible_only": True})
    assert hl.check({"jurisdiction_country": "US"}) is None
    assert "outside" in (hl.check({"jurisdiction_country": "CA"}) or "")
    assert "irreversible" in (hl.check({"jurisdiction_country": "US", "irreversible": True}) or "")
