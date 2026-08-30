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
Accepted streams have the read/write deadline reported by `capabilities`, so a
client that abandons a partial frame cannot hold the serial controller forever.

The request object contains `schema`, `request_id`, `run_id`, `nonce`,
`max_bytes`, `op`, and an `args` object.  The response contains `schema`,
`request_id`, `run_id`, `epoch`, `ok`, and a `result` object.  `capabilities`
returns the daemon's framing, frame bound, operation names, large-result
policy, and proof-authority status.

Numbers follow the Rust wire types rather than a binding language's coercion
rules: request IDs and epochs are unsigned 64-bit integers, Boolean values are
not integers, and byte limits are positive bounded integers.  Non-finite
floating-point spellings are not JSON and are rejected.  Reference clients
fail closed if any envelope field has a different type.

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

The daemon likewise does not retain a serialized evidence payload.  It first
streams compact JSON through a hash/count sink to enforce the configured bound
and derive the content address, then serializes directly through a buffered
create-only file writer.  This trades one cheap serialization pass for bounded
memory independent of the trace limit.

The reference Python client is `python/ergodis_client.py`.  It has no external
dependencies, uses monotone request IDs, enforces the frame bound, and provides
bounded line and JSONL iterators.  Capability negotiation also pins the socket
deadline, create-only large-result policy, proof-authority status, and minimum
operation inventory.  A future in-process Python or Lean FFI must remain
byte-for-byte conformant with this socket path.

## Search-path isolation

Socket I/O, JSON, evidence serialization, and plan compilation happen outside
worker hot loops.  Uncontrolled solves compile without the control-plane
feature.  Controlled workers retain only the existing coarse safe-point flag;
adding a language binding does not add another search-path check.
