# Ergodis local control protocol

The optional `control-plane` feature exposes a bounded local protocol for long
campaigns.  Rust, Python, and Lean clients use this protocol as their common
semantic boundary.  A binding is only a transport convenience; it cannot
promote a candidate to a proved theorem.

The current experimental schema is `ergodis-control-experimental-v0`.  A
client reads `manifest.json` from a caller-selected private run directory.  It
uses the manifest's exact socket path, run ID, and nonce on every request.
Simultaneous campaigns therefore have separate endpoints and handshakes.
Both reference clients bound manifest ingestion to the 65,536-byte frame
ceiling and reject a mismatched manifest schema before connecting.

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

Campaign-data headers may bind an offline feature extractor with an optional
`generator` object containing a nonempty `name`, nonempty `version`, and
64-hex-digit `digest`. The daemon copies this provenance into the manifest and
status response. A presentation hash alone does not identify how derived
features were computed.

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

`candidate-batch` accepts a bounded list of lowered plans, evaluates them
against the frozen batch, and writes each complete record directly to a
create-only JSONL file under `evidence/`. The response contains only counts and
a caller-bounded top set. The daemon stops before the first record that would
cross `max_evidence_bytes` and reports `truncated: true`; it never silently
writes beyond the configured campaign trace limit.

## Textual plan authoring

Single plans passed to `ergodisctl try` and `ergodisctl apply` may use the
bounded textual syntax instead of hand-authored JSON:

```text
plan "rigid-order" {
  role ordering;
  output score;
  scope root.kind 0x0000000000000005;
  expr select((rigid == 1) && !(debt > 3), max(score * 4, abs(slack)), -7);
}
```

The parser accepts ordinary arithmetic, comparisons, Boolean connectives, and
the bounded `abs`, `min`, `max`, and `select` forms. Quoted names allow field
names outside the identifier grammar. Text and expression-JSON decode to the
same typed AST and use the same lowering and type checker; canonical formatting
has parse/format/parse identity, and equivalent text and JSON lower to identical
serialized bytecode. Input bytes, tokens, expression nodes, and depth are all
bounded before a plan can enter the daemon. JSON and JSONL remain the protocol,
persistence, bulk-batch, and diagnostic encodings; text is the human authoring
surface only.

## Proof authority

The daemon currently advertises `proof_authority: false`. Plans may diagnose
or order work, but no control-plane plan is authorized to prune the exact
search. A fit to a frozen feature batch is evidence about that batch, not a
proof. Any future pruning role must bind its predicate to independently
verified feature semantics rather than trusting field names or presentation
metadata.

The reference Python client is `python/ergodis_client.py`.  It has no external
dependencies, uses monotone request IDs, enforces the frame bound, and provides
bounded line and JSONL iterators.  Capability negotiation also pins the socket
deadline, create-only large-result policy, proof-authority status, and minimum
operation inventory.  A future in-process Python or Lean FFI must remain
byte-for-byte conformant with this socket path.

## Search-path isolation

The component topology and implementation-status matrix are authoritative in
[DESIGN.md](DESIGN.md). In experimental v0, `ergodis-campaign` serves the serial
control protocol, durable ledger, bulk candidate evaluator, and one optional
low-priority evolution worker. `evolve-start`, `evolve-status`, and
`evolve-cancel` manage that worker; `ergodisctl evolve` remains an offline
staging path. The generic `theorem_search` engine also supports caller-owned
streaming sinks.

The daemon evolution worker shares only the immutable frozen feature batch,
streams its audit to a bounded create-only file, and publishes progress through
one isolated cache-line record. A distinct solver-side low-priority sampler consumes fixed-size root
snapshots, performs isolated bounded probes, and sends compact scorecards through
the watcher. Search workers do not run evolution, probe workspaces, or protocol
code.

`ergodisctl evolve-start` accepts an optional direct seed JSONL file and up to
eight repeated `--resume-evidence` paths.  A replay archive must match the
problem, ordered feature schema, and exact feature-generator provenance.  When
no generator provenance exists, its complete presentation hash must also
match.  The daemon recomputes every archived plan hash, ranks candidates within
each archive, interleaves archives in request order, removes structural
duplicates, and admits at most 32 direct-plus-replayed seeds.  Replayed plans
are compiled and evaluated again on the current frozen batch; archived scores
are selection evidence, never current results.  Each output header records the
current presentation and producing code commit, while replay roots record a
separate source hash and archive path rather than creating a false parent edge
in the mutation lineage.

Completed predicate evaluations also persist a bounded failure shape: the
false-positive/false-negative class, first mismatching row identity and label,
and at most eight values for fields referenced by the candidate.  The daemon
uses that counterexample to target simple ordered-comparison thresholds before
trying the generic mutation family.  The generated constant is the nearest
integer boundary that gives the requested label on that row; overflow yields
no candidate.  Evidence serialization happens immediately.  Ranked candidates
retain only the mismatch-row index, and feature probes are reconstructed only
for the bounded beam selected for expansion.

Socket I/O, JSON, evidence serialization, and plan compilation happen outside
worker hot loops.  Uncontrolled solves compile without the control-plane
feature.  Controlled workers retain only the existing coarse safe-point flag;
adding a language binding does not add another search-path check.
