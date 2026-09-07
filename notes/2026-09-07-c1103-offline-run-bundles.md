# C1103 — Bounded offline run bundles

**Lane:** `ergodis`. **Date:** 2026-09-07. **Status:** complete.

Core commit `c8da541`; private fixture commit `fd0f03f`.

## Motivation and scope

C1101 separates UUIDv7 run identity from immutable record/content identity.
This slice packages that material for offline inspection and explicit content
resolution. Opening a bundle must not start a process, instantiate a Campaign,
load a private executable package or verify a mathematical claim implicitly.
It follows C1084's view/verify/replay/resume/fork distinction.

The runtime reader owns framing, bounded metadata, included-content integrity,
included-parent checks and missing-dependency diagnostics. Blob bytes are
borrowed from the input, avoiding another full payload copy. An omitted private
package or parent is an explicit unresolved dependency, not an excuse to refuse
all viewing or to silently assert complete ancestry.

This is not a filesystem repository, publisher authentication, transactional
head publication, attempt/budget recovery, browser UI or export-policy engine.
The bundle is a selected history view. Conflicting records with the same run
and sequence cannot silently compete inside it. Opaque payload formats may
have further dependencies that the generic reader cannot inspect.

## Implementation and validation

The portable runtime now provides `Bundle::encode/parse`, object lookup,
manifest counts and missing-dependency diagnostics. It borrows included blob
bytes, checks every included content identity, rejects duplicate IDs and
conflicting `(RunId, sequence)` records, and checks included parent boundaries.
Opaque metadata does not grant evidence authority. The encoder preserves caller
entry order; there is no canonical global bundle digest. The explicit versioned
frame and bounds are documented in core `docs/run-bundles.md`.

The limits are positive caller selections bounded by 16 MiB total input, 4 MiB
per item and 512 entries. Encoder aggregate sizes are checked before hashing
borrowed blobs; final output is reserved once. Individual record/spec codecs
retain their own stricter metadata bounds. Duplicate and parent checks also
apply before encoding, rather than emitting frames the reader would reject.

Terra implemented the portable reader/encoder; Luna supplied the initial core
tests. Parent reviewed/corrected tests, tightened resource preflight, added
adversarial framing/lineage tests, documented the format, and owns all builds.
A second Terra agent audits the read-only boundary and missing-content semantics.

Final full core fmt/clippy/all-feature tests pass. Seven bundle tests cover
content resolution, complete and partial material, included empty versus
missing packages, all truncated prefixes, all single-byte mutations of a blob
frame, explicit forks, conflicting records and wrong included parents assembled
from separately valid partial bundles. A pointer-range assertion confirms that
the exposed payload is borrowed from the input frame. Python parity passes
eight exact cost/witness/work fixtures. Private formatting, targeted clippy and
eight tests pass (the bundle interoperation and seven domain-bound regressions).
WASM release compilation passes. Independent source review found no correctness
blocker within the declared view-only scope.

The private LRC fixture now packages the actual specification, source states,
event, prover snapshot and delta in one bundle. It resolves those bytes before
explicitly invoking domain-bound verification, then creates a fresh-ID fork.
A child-only bundle remains inspectable and lists its absent parent, spec and
source. This remains a private test fixture, not a production LRC wire schema.

Replay sequentially, through `run-quiet`:

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

Capture prefixes under `/tmp/claude-run-quiet/`: final core `20260907-132719`,
Python `20260907-132800`, private `20260907-132844`, WASM `20260907-132928`.
Cache GC ran as a dry run at `20260907-132928`; nothing deleted. No export/push.
The unrelated whole-tool lint from earlier work remains outside this slice.

## Performance and next step

Metadata hashing/parsing is cold orchestration work. Solver kernels, update
loops and native/WASM layout assertions remain untouched. Total input bytes,
frame bytes and metadata entry counts are admission limits; readers must check
them before allocating from untrusted counts. Hosts also need bounded outer
file/network reads. No performance improvement is claimed.

The next product layer can display the manifest and unresolved dependencies,
then request explicit domain verification or a fresh-ID fork. Disk persistence,
publication fencing and executable continuation remain separately admitted.

Discovery-track review: no incidental mathematical discovery. Partial-history
and missing-content distinctions are planned deliverables, recorded here.
