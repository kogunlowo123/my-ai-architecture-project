"""Agent orchestrator: routing, tier gates, approvals, kill switch.

The orchestrator is the 'manager' every agent reports to. No agent executes a
capability except through `execute`, which enforces the autonomy tier recorded
in the registry manifest — not whatever the agent claims about itself.
"""
from __future__ import annotations

import enum
import uuid
from dataclasses import dataclass, field
from datetime import datetime, timezone
from typing import Any, Callable

from unified_platform.core.audit.chain import AuditChain
from unified_platform.core.identity.workload import TokenExchanger
from unified_platform.core.registry.registry import AgentRegistry


class Tier(enum.IntEnum):
    T1_RECOMMEND = 1
    T2_APPROVAL_GATED = 2
    T3_HARD_LIMITED = 3


class ApprovalRequired(Exception):
    """Raised when a T2 action reaches execution without an approval token."""


class HardLimitTripped(Exception):
    """Raised when a T3 action exceeds a machine-enforced boundary."""


@dataclass
class Task:
    task_id: str
    agent_name: str
    capability: str
    payload: dict[str, Any]
    approval_token: str | None = None
    created_at: datetime = field(default_factory=lambda: datetime.now(timezone.utc))


class Orchestrator:
    def __init__(
        self,
        registry: AgentRegistry,
        audit: AuditChain,
        tokens: TokenExchanger,
        approval_verifier: Callable[[str, Task], bool],
    ) -> None:
        self._registry = registry
        self._audit = audit
        self._tokens = tokens
        self._verify_approval = approval_verifier
        self._killed: set[str] = set()

    def kill(self, agent_name: str) -> None:
        """Kill switch: immediately halt an agent platform-wide."""
        self._killed.add(agent_name)
        self._audit.emit(actor="orchestrator", capability="kill_switch",
                         payload={"agent": agent_name})

    def submit(self, agent_name: str, capability: str, payload: dict[str, Any]) -> Task:
        return Task(task_id=str(uuid.uuid4()), agent_name=agent_name,
                    capability=capability, payload=payload)

    def execute(self, task: Task) -> dict[str, Any]:
        if task.agent_name in self._killed:
            raise PermissionError(f"{task.agent_name} is halted by kill switch")

        spec = self._registry.get(task.agent_name)
        if task.capability not in spec.capabilities:
            raise PermissionError(
                f"{task.agent_name} has no capability '{task.capability}' in manifest"
            )

        tier = Tier(spec.tier)
        self._audit.emit(actor=task.agent_name, capability=task.capability,
                         payload={"task_id": task.task_id, "tier": tier.name,
                                  "phase": "requested"})

        if tier is Tier.T1_RECOMMEND:
            # Recommendation only: produce evidence bundle, never side effects.
            result = self._run(spec, task, scopes=spec.read_scopes)
            self._audit.emit(actor=task.agent_name, capability=task.capability,
                             payload={"task_id": task.task_id, "phase": "recommended"})
            return {"mode": "recommendation", "result": result}

        if tier is Tier.T2_APPROVAL_GATED:
            if not task.approval_token or not self._verify_approval(task.approval_token, task):
                raise ApprovalRequired(f"Task {task.task_id} needs a human approval token")
            result = self._run(spec, task, scopes=spec.write_scopes)
            self._audit.emit(actor=task.agent_name, capability=task.capability,
                             payload={"task_id": task.task_id, "phase": "executed",
                                      "approved_by": "verified-principal"})
            return {"mode": "approved-execution", "result": result}

        # T3: autonomous inside hard limits.
        breach = spec.hard_limits.check(task.payload)
        if breach:
            self._audit.emit(actor=task.agent_name, capability=task.capability,
                             payload={"task_id": task.task_id, "phase": "limit_tripped",
                                      "limit": breach})
            self.kill(task.agent_name)  # demote-and-halt policy on limit trips
            raise HardLimitTripped(breach)
        result = self._run(spec, task, scopes=spec.write_scopes)
        self._audit.emit(actor=task.agent_name, capability=task.capability,
                         payload={"task_id": task.task_id, "phase": "auto_executed"})
        return {"mode": "hard-limited-execution", "result": result}

    def _run(self, spec: Any, task: Task, scopes: list[str]) -> dict[str, Any]:
        token = self._tokens.exchange(agent=task.agent_name, scopes=scopes,
                                      audience=spec.mcp_audience, ttl_seconds=900)
        handler = spec.resolve_handler(task.capability)
        return handler(task.payload, token=token)
