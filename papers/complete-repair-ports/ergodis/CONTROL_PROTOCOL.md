# Ergodis local control protocol

The optional `control-plane` feature exposes a bounded local protocol for long
campaigns.  Rust, Python, and Lean clients use this protocol as their common
semantic boundary.  A binding is only a transport convenience; it cannot
promote a candidate to a proved theorem.

The current experimental schema is `ergodis-control-experimental-v0`.  A
client reads `manifest.json` from a caller-selected private run directory.  It
uses the manifest's exact socket path, run ID, and nonce on every request.
Simultaneous campaigns therefore have separate endpoints and handshakes.

## Wire format

Each connection carries one request and one response:

```text
4-byte unsigned little-endian payload length
UTF-8 JSON payload of exactly that length
```

Frames are at most 65,536 bytes.  Unknown request fields are rejected.  The
client must verify the response schema, request ID, and run ID.  The daemon
accepts connections through a blocking Unix-domain listener; it does not poll.

The request object contains `schema`, `request_id`, `run_id`, `nonce`,
`max_bytes`, `op`, and an `args` object.  The response contains `schema`,
`request_id`, `run_id`, `epoch`, `ok`, and a `result` object.  `capabilities`
returns the daemon's framing, frame bound, operation names, large-result
policy, and proof-authority status.

`tests/fixtures/control_protocol_v0.json` is the language-neutral wire fixture.
New clients should parse and reproduce those compact payloads before speaking
to a live daemon.  In Lean, the stable starting point is a small client that
uses `read` until four bytes and then the declared payload length have arrived,
decodes the prefix explicitly as little-endian, and parses `Lean.Json`.  No
Rust/Lean object crosses the process boundary.

## Large evidence

Responses remain summaries.  Large traces and evidence are written to
create-only, run-relative files and returned as path/hash/byte-count metadata.
A client resolves paths beneath the manifested run directory and streams them
with a caller-selected record bound.  It must not read an entire evidence file
merely to iterate its records.

The reference Python client is `python/ergodis_client.py`.  It has no external
dependencies, uses monotone request IDs, enforces the frame bound, and provides
bounded line and JSONL iterators.  A future in-process Python or Lean FFI must
remain byte-for-byte conformant with this socket path.

## Search-path isolation

Socket I/O, JSON, evidence serialization, and plan compilation happen outside
worker hot loops.  Uncontrolled solves compile without the control-plane
feature.  Controlled workers retain only the existing coarse safe-point flag;
adding a language binding does not add another search-path check.
