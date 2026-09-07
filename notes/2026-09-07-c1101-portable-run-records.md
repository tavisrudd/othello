# C1101 — Portable run identity and immutable history

**Lane:** `ergodis`. **Date:** 2026-09-07. **Status:** complete.

Core `e4e7424` (design docs `b950d69`); private `dd3f19d`.

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

Implementation, source audit and final full native gates pass, including the
follow-up for loading an expected content ID from an external index. WASM
release compilation passes with UUID support and exact identifier layout
assertions. The runtime has six record tests. Python parity passes eight exact cost/witness/work
cases. Eight private tests pass, including the new record interoperation case
and seven C1100 domain-bound transition regressions. The runtime corpus covers
identity separation, UUIDv7 validation and the RFC example, explicit fork
linkage, immutable parents, source/event byte binding, canonical roundtrip,
byte mutations, malformed records and wrong ancestry. Reference/spec digest
vectors were computed independently with Python hashlib/struct and pinned in
the tests. Domain-separated hash encoding and bounded binary layout are
documented in core `docs/run-records.md`.

The private LRC fixture creates source states with equal min-plus summaries but
different content identities. It stores references to an actual prover snapshot
and delta, decodes and links the records, checks source/event/evidence bytes,
then explicitly invokes C1100 domain-bound verification. Finally it creates a
fresh-ID fork without copying evidence into the child. This is not a new domain
serialization standard: the fixture encodes fields explicitly for the test.

Terra implemented the runtime module and independently reviewed the combined
boundary; Luna supplied initial runtime tests. Parent reviewed and corrected
the implementation, added source/event interoperation and additional rejection
and compatibility tests, and owns all builds and commits. Source review found
no remaining correctness blocker. Artifact bytes are hashed by borrowed slice,
without copying them or applying the record-size cap to large artifacts;
untrusted hosts must bound or stream reads before calling this API.

Replay (use `run-quiet`, one build owner):

```sh
# ~/src/ergodis
nix shell nixpkgs#cargo nixpkgs#rustc nixpkgs#clippy nixpkgs#rustfmt --command bash -c 'cargo fmt --check && cargo clippy --all-targets --all-features -- -D warnings && cargo test --all-features'
nix shell nixpkgs#python3 --command python3 wasm/scripts/check-python-parity.py
nix shell nixpkgs#cargo nixpkgs#rustc --command cargo check --manifest-path wasm/Cargo.toml --target wasm32-unknown-unknown --release
# ~/src/ergodis-private
nix shell nixpkgs#cargo nixpkgs#rustc nixpkgs#clippy --command cargo clippy -p ergodis-private --test run_record_identity -- -D warnings
nix shell nixpkgs#cargo nixpkgs#rustc --command cargo test -p ergodis-private --test run_record_identity --test domain_bound_transitions
nix shell nixpkgs#rustfmt --command rustfmt --check --edition 2021 tests/run_record_identity.rs
```

Capture prefixes under `/tmp/claude-run-quiet/`: final native `20260907-125243`,
Python `20260907-125047`, private `20260907-125142`, WASM `20260907-125405`,
cache dry run `20260907-125406`. No speed claim; full-tool
clippy is not part of this slice and its previously recorded unrelated finding
is untouched. No export/push. Cache cleanup remains dry-run only.

## Follow-through

Next integration should package a concrete source, snapshots, events and scoped
certificates with these records; open it without a live process, resolve content
and ancestry, run the appropriate checker, and fork without transferring old
authority to a changed query. Repository atomic publication and resource budget
admission remain explicit gates rather than properties inferred from hashes.

Discovery-track review: no incidental mathematical discovery. The source/summary
alias distinction and identity split were intended task outcomes.
