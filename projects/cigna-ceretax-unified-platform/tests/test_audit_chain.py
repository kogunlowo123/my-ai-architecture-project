from unified_platform.core.audit.chain import AuditChain


class _MemSink:
    def __init__(self): self.rows = []
    def append(self, record): self.rows.append(record)


class _NullSigner:
    def sign(self, digest: bytes) -> bytes: return b"\x00" * 64


def test_chain_verifies_and_detects_tamper():
    chain = AuditChain(_MemSink(), _NullSigner())
    sink = chain._sink
    for i in range(5):
        chain.emit(actor="agent:test", capability="cap", payload={"i": i})
    assert AuditChain.verify(sink.rows) is True
    sink.rows[2]["capability"] = "tampered"
    assert AuditChain.verify(sink.rows) is False
