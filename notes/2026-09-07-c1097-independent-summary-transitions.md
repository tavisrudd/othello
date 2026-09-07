# C1097 — Independent authenticated summary transitions

**Lane:** ergodis. **Date:** 2026-09-07. **Status:** complete checker extraction. Core `46f7d1c`; private `9c1a620`.

## Result and important correction

Added `ergodis-verify::min_plus_transition`, an independent fixed checker for existing schema-one
min-plus-matrix snapshot/delta wire with SHA256Digest backend 1. It imports no solver or private
adapter. Initial snapshot composition and SHA-256 commitments are recomputed independently;
subsequent updates must authenticate all supplied siblings against retained checked state before
changing the verifier. Domain event correctness, source lowering, witness meaning and external
optimality are separate obligations. The C1096 domain checker is not yet a serialized proof link
into this generic wire.

The extraction uncovered a real defect in the old generic root-only checker. An all-absent changed
leaf masks the other subtree under min-plus composition. A certificate can replace that upper
sibling summary with zero entries while retaining its identity subtree digest. The old root stays
unchanged; changing the leaf to identity exposes the forged summary. Recomputing only the claimed
new root makes the legacy checker accept the forged update without breaking SHA-256.

`tests/summary_transition_forgery.rs` constructs exactly this four-leaf example from the actual
private prover. It demonstrates legacy acceptance and independent-checker rejection with unchanged
state. This is a sibling-summary authentication failure, not a cryptographic collision.

Terra's bounded source audit found the same binding omission in specialized
`incremental_certificate::VerifierState` at all sibling levels. Its changed-leaf event evaluator
does not repair sibling authentication. That specialized finding is source-audit evidence, not a
second executed wire exploit. Generic and specialized legacy authority claims are corrected in
source comments. Their old implementations remain for reproduction and are not certified paths;
retirement/migration of their callers and other hash backends is still required. This removes
adversarial certificate authority; it does not by itself show that honest computed answers or
previous timing measurements were wrong.

## Design and maintenance

Retain authenticated node summaries and digests from the checked snapshot. Require each delta's
old leaf and sibling summary/digest to match that state, then check its claimed next root. Commit
only the verified path. A malformed or stale proof cannot advance root, sequence, or retained nodes.

The price is O(N) verifier memory rather than the legacy 72-byte claim. Updates remain O(log N)
compositions/hashes with bounded fixed scratch. `from_snapshot` clones its retained state. A future
compact proof would need to authenticate each sibling's summary directly, for example via its
child digests; dropping this state without changing proof obligations is unsound.

The module is a separate compilation unit in the independent crate, not a generic callback-based
verifier. Four-by-four summaries use explicit 64-byte layout/alignment assertions on native and
WASM. Costs follow existing u32 saturating min-plus with MAX as absence, not unbounded arithmetic.
Snapshot admission validates exact size, caller leaf bound, checked shape arithmetic, canonical
power-two padding and identity padded leaves before accepting a root. Deltas bind exact depth,
real leaf range, artifact, old root and sequence; checked sequence increment rejects overflow.
Only SHA256Digest backend 1 is supported here, not the default packed backend or other algebras.

The verifier source identity includes the new module. Existing admission receipts intentionally
need fresh verification under the changed identity. No control-plane or durable-run schema changed.

## Validation

Actual private prover interoperability passes for one, three and eight leaves, twelve updates
each; snapshot/delta byte mutations, malformed/trailing inputs and replay rejection preserve state.
For the three-leaf fixture all 352 snapshot bytes and 448 delta bytes are individually mutated.
The explicit masking forgery passes against the old checker and fails against the new checker.
Scoped private tests and clippy pass. Eight Python cost/witness/work parity cases pass. Full core formatting, all-target/all-feature clippy, all-feature tests and WASM release
compilation pass. Cache GC ran dry; no entries removed. Parent owns builds and commits; Terra implements checker, Luna develops
forgery regression, parent owns interoperability/mutation tests and integration.

## Next

Migrate proof consumers away from legacy root-only authority. Extend the authenticated checker
only with explicit domain/source admission and exact backend/format compatibility; do not claim
all existing generic certificate variants are independently checked. A compact authenticated
sibling format is a separate performance/format decision requiring retained before/after evidence.

## Closeout review

The unexpected and useful result is identifying why old-root replay alone is insufficient for
noninjective composition. The executed regression settles that defect for the generic matrix wire.
Specialized caller migration remains explicit engineering debt. No novelty claim or unrelated
research lead is being promoted; the defect was found while auditing the planned checker.

Replay:

```sh
# From ergodis
nix shell nixpkgs#cargo nixpkgs#rustc nixpkgs#clippy nixpkgs#rustfmt --command bash -c 'cargo fmt --check && cargo clippy --all-targets --all-features -- -D warnings && cargo test --all-features'
nix shell nixpkgs#python3 --command python3 wasm/scripts/check-python-parity.py
nix shell nixpkgs#cargo nixpkgs#rustc --command cargo check --manifest-path wasm/Cargo.toml --target wasm32-unknown-unknown --release
# From ergodis-private
nix shell nixpkgs#cargo nixpkgs#rustc nixpkgs#clippy --command bash -c 'cargo clippy -p ergodis-private --test independent_summary_transition --test summary_transition_forgery -- -D warnings && cargo test -p ergodis-private --test independent_summary_transition --test summary_transition_forgery'
```

Supplementary logs under `/tmp/claude-run-quiet/`: core final `20260907-120102`,
private lint/interop `20260907-115835`, private final replay `20260907-120319`,
Python `20260907-120003`, WASM `20260907-120403`, cache dry-run `20260907-120239`.
The tracked tests generate their own complete fixtures and are the replay authority.
