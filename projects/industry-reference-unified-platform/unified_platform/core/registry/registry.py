"""Loads and serves the agent manifest. The orchestrator trusts this, not agents."""
from __future__ import annotations

from dataclasses import dataclass, field
from pathlib import Path
from typing import Any, Callable

import yaml


@dataclass
class HardLimits:
    raw: dict[str, Any] = field(default_factory=dict)

    def check(self, payload: dict[str, Any]) -> str | None:
        """Return breach description or None. Real impl also tracks rate windows."""
        scope = self.raw.get("jurisdiction_scope")
        if scope and payload.get("jurisdiction_country") not in scope:
            return f"jurisdiction {payload.get('jurisdiction_country')} outside {scope}"
        if self.raw.get("reversible_only") and payload.get("irreversible"):
            return "irreversible action attempted by reversible-only agent"
        return None


@dataclass
class AgentSpec:
    name: str
    domain: str
    tier: int
    capabilities: list[str]
    mcp_audience: str
    read_scopes: list[str]
    write_scopes: list[str]
    hard_limits: HardLimits
    _handlers: dict[str, Callable] = field(default_factory=dict)

    def resolve_handler(self, capability: str) -> Callable:
        return self._handlers[capability]


class AgentRegistry:
    def __init__(self, manifest_path: Path) -> None:
        data = yaml.safe_load(manifest_path.read_text())
        self._agents = {
            name: AgentSpec(
                name=name,
                domain=spec["domain"],
                tier=spec["tier"],
                capabilities=spec["capabilities"],
                mcp_audience=spec["mcp_audience"],
                read_scopes=spec.get("read_scopes", []),
                write_scopes=spec.get("write_scopes", []),
                hard_limits=HardLimits(spec.get("hard_limits", {})),
            )
            for name, spec in data["agents"].items()
        }

    def get(self, name: str) -> AgentSpec:
        return self._agents[name]
