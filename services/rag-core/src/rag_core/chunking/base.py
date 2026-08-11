"""Chunk dataclass: text, span, doc_id, acl, metadata."""
from dataclasses import dataclass, field

@dataclass
class Chunk:
    text: str
    span: tuple[int, int]
    doc_id: str
    acl: list[str] = field(default_factory=list)
    metadata: dict = field(default_factory=dict)
