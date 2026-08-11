-- append-only: issuance, delegation, tool calls, revocations
CREATE TABLE IF NOT EXISTS session_ledger (
  id BIGSERIAL PRIMARY KEY,
  ts TIMESTAMPTZ NOT NULL DEFAULT now(),
  principal TEXT NOT NULL,
  event_type TEXT NOT NULL CHECK (event_type IN ('issuance','delegation','tool_call','revocation')),
  payload_hash TEXT NOT NULL,
  prev_hash TEXT NOT NULL,
  event_hash TEXT NOT NULL
);
