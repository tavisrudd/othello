# C1101 — Portable run identity and immutable history

**Lane:** `ergodis`. **Date:** 2026-09-07. **Status:** implementation in progress.

## Motivation

C1100 joins domain-event admission with authenticated summary transitions, but
two different sources or events may have identical summaries. Durable history
must therefore identify the source and event separately from the mathematical
summary. The user also explicitly requested SQUUIDs or similar for run IDs.

Decision: use standard UUIDv7 for `RunId`, and SHA-256 content identities for
immutable specifications, records and typed payload references. Equal inputs do
not mean one run. A restart keeps the run ID; a fork creates a fresh run ID and
links the exact parent boundary. Explicit sequences and parent links, rather
than timestamps, determine history. Existing ephemeral service IDs are unchanged.

The [UUIDv7 specification](https://www.rfc-editor.org/rfc/rfc9562.html#section-5.7)
defines the timestamp/random UUID layout. Use the `uuid` crate for representation,
validation and formatting; do not invent a UUID parser or random generator.
Native/browser hosts supply IDs. This portable slice owns no clock, RNG, OS
handle or live worker. UUID layout validation cannot prove global uniqueness or
chronological truth; repository admission must later reject duplicate run IDs.

## Bounded implementation

The portable runtime owns immutable specifications and committed history record
data, not solver/kernel records. Domain-specific bytes remain typed content
references. The initial record API covers creation, update, explicit fork,
bounded encoding/decoding and parent-link checks. Source, event, snapshot and
evidence references identify exact bytes under a declared kind and format.
The codec must reject unsupported versions, malformed lengths, invalid enum
tags, excess resources and trailing bytes before producing a valid record.

Decoding, resolving lineage, checking referenced content, admitting domain
meaning and verifying mathematical evidence are separate operations. A decoded
record is not a current verified result. A hash is neither a publisher signature
nor a proof of the claim referenced by the record. Historical checker reports
must remain viewable without acquiring current authority.

This is the small executable foundation for C1084's run repository design.
It does not implement disk publication, exported bundles, host activation,
ownership fencing, catalog indexing, attempt recovery, budget accounting or
mid-solve continuation. Those require further explicit operations. User notes,
system/build metadata and theorem/parameter provenance belong in versioned
referenced records, not hot solver objects or an unqualified verified flag.

## Performance and portability

All record encoding, hashing and allocation are cold orchestration work. Native
solver layouts, compile-time alignment assertions and solve/update loops remain
unchanged. A browser and native host use the same portable record layer. New
wire u64 counters remain binary here; a future JS DTO must encode values beyond
the safe integer range explicitly, never through an imprecise Number.

## Validation

Pending implementation and validation. Tests will cover identity separation,
UUIDv7 validation, explicit fork linkage, immutable parents, source/event byte
binding, canonical roundtrip and malformed records, and missing/wrong ancestry.

## Follow-through

Next integration should package a concrete source, snapshots, events and scoped
certificates with these records; open it without a live process, resolve content
and ancestry, run the appropriate checker, and fork without transferring old
authority to a changed query. Repository atomic publication and resource budget
admission remain explicit gates rather than properties inferred from hashes.
