"""Hash-chained audit log with KMS-signed checkpoints.

Each event links to the previous event's hash. Chain heads are periodically
signed (KMS asymmetric key) and checkpointed to WORM storage (S3 Object Lock),
so tampering requires rewriting history *and* forging signatures.
"""
from __future__ import annotations

import hashlib
import json
from dataclasses import dataclass, asdict
from datetime import datetime, timezone
from typing import Any, Protocol


class Signer(Protocol):
    def sign(self, digest: bytes) -> bytes: ...


class Sink(Protocol):
    def append(self, record: dict[str, Any]) -> None: ...


@dataclass(frozen=True)
class AuditEvent:
    ts: str
    actor: str
    capability: str
    payload_hash: str
    prev_hash: str
    event_hash: str


def _h(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


class AuditChain:
    GENESIS = "0" * 64

    def __init__(self, sink: Sink, signer: Signer, checkpoint_every: int = 1000) -> None:
        self._sink = sink
        self._signer = signer
        self._every = checkpoint_every
        self._prev = self.GENESIS
        self._count = 0

    def emit(self, actor: str, capability: str, payload: dict[str, Any]) -> AuditEvent:
        # Payloads are hashed, not stored raw: no PHI/taxpayer data in the chain itself.
        payload_hash = _h(json.dumps(payload, sort_keys=True).encode())
        ts = datetime.now(timezone.utc).isoformat()
        body = f"{ts}|{actor}|{capability}|{payload_hash}|{self._prev}"
        event_hash = _h(body.encode())
        event = AuditEvent(ts=ts, actor=actor, capability=capability,
                           payload_hash=payload_hash, prev_hash=self._prev,
                           event_hash=event_hash)
        self._sink.append(asdict(event))
        self._prev = event_hash
        self._count += 1
        if self._count % self._every == 0:
            self._sink.append({
                "checkpoint": True,
                "head": event_hash,
                "signature": self._signer.sign(bytes.fromhex(event_hash)).hex(),
            })
        return event

    @staticmethod
    def verify(events: list[dict[str, Any]]) -> bool:
        prev = AuditChain.GENESIS
        for e in events:
            if e.get("checkpoint"):
                continue
            body = f"{e['ts']}|{e['actor']}|{e['capability']}|{e['payload_hash']}|{prev}"
            if _h(body.encode()) != e["event_hash"]:
                return False
            prev = e["event_hash"]
        return True
