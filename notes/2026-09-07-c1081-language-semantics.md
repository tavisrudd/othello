# C1081 — language inventory and executable reduction semantics

**Lane**: `ergodis`
**Date**: 2026-09-07
**Status**: COMPLETE. Core implementation/specification/corpus commit `55c5d8c`.

## Decision and implemented boundary

Tavis approved executable semantics before wider IR/campaign integration. This slice inventories
the existing language layers and gives C1080's finite coordinate-restriction family a versioned
logical document, an independent executable denotation and cross-host conformance tests. It does
not claim machine-checked proofs or a unified semantics for all existing languages.

Core `docs/language-semantics.md` is the public contract. It distinguishes text/expression input,
scalar PlanSpec, FeatureDag, compiled physical plans, fixed reduction documents, opaque admission
and kernel/control interfaces. It specifies the chosen finite relation, optimum/witness semantics,
error phases, independent origin/mode/validation facts and proposed future campaign transitions.
The public/private extension section separates mathematical contracts from implementations and
packaging, preserving C1079's IP boundaries without claiming a loader exists.

`src/reduction_language.rs` supplies schema 1 through a bounded JSON parser and cold typed
interpreter. The problem explicitly names rectangular dimensions, GF(2) row-major matrix data,
local labels and costs. Labels canonicalize lexicographically with minimum duplicate cost. A
conservative maximum-canonical-cost times block-count bound avoids intermediate u32 overflow.
The source document has no receipt/status input capable of manufacturing admission.

`Check` independently checks the whole finite problem. Refutation returns an excluded feasible
tuple without compiling; admission calls the existing restricted composition solver. `Skip` is
allowed only in heuristic mode and always reports restricted-only coverage, including when the
candidate happens to be mathematically valid. The serialized output is a report, not an authority
token. Opaque admission/replay retain the C1080 rules.

The WASM adapter exposes `executeReductionJson` through the same core interpreter, with Worker
operation `reduction`. The original composition interface remains available. This is a check-and-
solve surface, not a discovery API, receipt-restoration API, module loader or persistent campaign.

## Independent semantics and review

`python/admission_semantics.py` computes the mathematical Cartesian product directly, without
importing Ergodis. It generates `tests/fixtures/admission_semantics.json`: 12 cases spanning valid
and refuted restrictions, cancellation, vacuous/empty-retained unsatisfiability, rectangular and
multi-column labels, ties, duplicate-label minimum costs, high costs, and mode/validation mixtures.
The reference models valid-domain mathematical results; it is not a complete parser/metadata/
budget-error oracle. Rust has separate boundary-negative tests.

The native test compares the interpreter to this independent corpus and replays returned witnesses.
The browser harness executes the same documents inside a WASM Worker and checks costs, label
membership, coordinate restrictions, canonical counterexample indices and GF(2) equations.
Neither test demands one particular tied optimum or first counterexample. It separately rejects
unsupported schema, proof-generating Skip, and insufficient checking budget through the Worker.

Terra inventoried the source languages, wrote the initial contract and independently reviewed the
interpreter. Luna supplied the Python reference and ran native/cross-host gates. Terra recovered
and extended the browser adapter/harness. Parent review corrected a rectangular-block shape bug
in the initial reference, strengthened duplicate-cost canonicalization, and corrected a browser
harness assumption that mathematical validity implied checked coverage. These defects were in the
new reference/harness and were corrected before final conformance acceptance.

## Validation

Native fmt, all-target/all-feature clippy and full all-feature tests passed. Native conformance
passed again after strengthening the duplicate fixture. Both Python fixture gates, nested adapter
native tests/clippy, wasm32 release check and wasm-pack packaging passed. Chromium Worker
conformance passed all 12 reduction cases and three rejection cases alongside the original
composition smoke. Packaging required an explicit `wasm-ld` linker from Nix `lld`; the replay
command includes it. Generated `wasm/www/pkg` remains ignored. Cache GC passed in dry-run mode,
without deleting shared artifacts.

Representative local run logs:
- Native suite: `/tmp/claude-run-quiet/20260907-075519-RAYON_NUM_THREADS12-nix-shell-nixpkgscargo-nixpkgsrustc-command-cargo-test-all-fe`.
- Final browser corpus/rejections: `/tmp/claude-run-quiet/20260907-080010-nix-shell-nixpkgsnodejs-nixpkgschromium-command-node-browser-smoke.mjs`.

The committed reference, corpus, tests and replay commands are the durable evidence; local logs
are supporting diagnostics only.

Replay from `~/src/ergodis`, using the run-quiet wrapper and shared out-of-tree Cargo targets:

```sh
nix shell nixpkgs#cargo nixpkgs#rustc --command cargo fmt --all -- --check
nix shell nixpkgs#cargo nixpkgs#rustc nixpkgs#clippy --command cargo clippy --all-targets --all-features -- -D warnings
nix shell nixpkgs#cargo nixpkgs#rustc --command env RAYON_NUM_THREADS=12 cargo test --all-features
nix shell nixpkgs#python3 --command python3 python/generate_fixtures.py --check
nix shell nixpkgs#python3 --command python3 python/admission_semantics.py --check
nix shell nixpkgs#cargo nixpkgs#rustc --command cargo test --manifest-path wasm/Cargo.toml
nix shell nixpkgs#cargo nixpkgs#rustc nixpkgs#clippy --command cargo clippy --manifest-path wasm/Cargo.toml --all-targets -- -D warnings
nix shell nixpkgs#cargo nixpkgs#rustc --command cargo check --manifest-path wasm/Cargo.toml --target wasm32-unknown-unknown --release
nix shell nixpkgs#cargo nixpkgs#rustc nixpkgs#wasm-pack nixpkgs#lld --command env RUSTFLAGS="-C linker=wasm-ld" wasm-pack build wasm --target web --release --out-dir www/pkg
nix shell nixpkgs#nodejs nixpkgs#chromium --command node wasm/scripts/browser-smoke.mjs
```

No existing solver hot loop, field layout or native 64-bit size/alignment assertion changed.
No performance claim or A/B benchmark is made. The additional interpretation and verification
remain cold and do not constrain native specialization.

## Next semantics gate

Specify the complete scalar PlanSpec integer/error semantics and FeatureDag-to-plan preservation
before campaign unification. That is the highest-value next bounded slice: the current interpreter
has many more scalar operations than FeatureDag can express, and private recipe strings and
caller-declared verification flags cannot simply become admitted core semantics. Machine-checked
proofs should target small stable admission/lowering contracts; source/package/toolchain identities
and dynamic kernels need their own versioned obligations before portable artifact reuse.

## Closeout review and mystery ledger

The explicit ej+tt pass distinguished necessary-condition restriction from a genuine quotient.
The pilot preserves every feasible tuple; representative/orbit quotients need fibre coverage,
objective transfer and witness-lifting obligations instead. The public contract now states the
separate future quotient relation, including why a mere lower bound is not an exact answer.
This was a cheap documentation improvement within the language-contract review; no generic
quotient implementation or new mathematical discovery is claimed.

No unexplained mathematical result remains in this finite slice. Open engineering gates are
explicit: full scalar/DAG semantics, executable campaign transitions, quotient instructions and
machine-checked lowering/admission proofs. These require successor tasks; tests over the current
finite corpus do not settle them. No incidental discovery-track entry is warranted.
