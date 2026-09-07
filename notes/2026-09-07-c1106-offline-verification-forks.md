# C1106 — Explicit offline verification and fresh-ID forks

Date: 2026-09-07. Lane: `ergodis`. Status: complete. Core commit `feab0c6`.

## Result and authority boundary

The offline browser page now provides separate verification and fork actions.
The portable runtime owns closed checker dispatch and immutable child creation;
WASM exposes bounded adapters, and the browser host owns file selection,
UUIDv7 generation and download. No solver/update hot loops or native64 layouts
changed. No private source adapter or arbitrary code loader was added.

Verification selects an evidence/snapshot reference attached to one included
record. The only supported declared format is
`min-plus-matrix.snapshot.v1.sha256`, dispatched to the existing independent
`ergodis-verify::min_plus_transition::verify_snapshot` with a 4096-leaf cap.
Its success covers composition of supplied four-by-four min-plus leaf summaries
and their SHA-256 snapshot root under bounded arithmetic. It does not cover
source lowering, domain optimality, binding to the record's source/sequence,
run history or publisher authentication. The test snapshot intentionally has
sequence seven while its enclosing start record has sequence zero; no implicit
cross-format binding is claimed.

Unknown formats remain inspectable with unsupported verification. Missing
selected payloads require including those bytes. Content-corrupt bundles reject
inspection; content-valid but internally corrupt snapshots remain inspectable
and fail the explicit checker. A selected record cannot verify an unrelated
blob merely by naming its ID. A display report is not an admitted capability;
selection changes clear it, and no stored report is replayed as authority.

A fork obtains a host-issued UUIDv7 from the browser clock and crypto RNG. The
portable operation rejects collision with every included run ID. The host also
tracks up to 4096 IDs issued by the page, then requires reload. Repository-wide
identity collision and ownership remain C1107's concern. The child names the
exact parent run, immutable record and sequence, uses the selected included
specification plus chosen mode, and begins at sequence zero. Changing mode
changes the specification identity. Every original bundle entry is preserved.
The child carries the parent source reference, no snapshot and no evidence.
Source/spec compatibility, executable resumption and proof reuse are not implied.

Missing source/package dependencies stay visible; missing chosen specifications
prevent forking. Execution is unavailable in this page. A future execution
adapter must resolve its required dependencies first. The downloaded output is
new data, and the original file and current parent view remain unchanged.

## Bounds and verification

File, item and entry bounds remain 16 MiB, 4 MiB and 512. Actions use single-flight,
single-use Workers with a 30-second deadline. The page retains one selected
immutable Blob. Verification returns only a narrow metadata report. Forking
adds a bounded Rust output frame and wasm-bindgen output copy (at most 32 MiB
combined) to the existing 32 MiB input-copy bound, excluding Blob backing,
module and bounded metadata. The output ArrayBuffer transfers without a message
copy; download URLs are revoked. Oversized child bundles reject atomically.

All gates pass:

- Four new portable workflow tests and seven existing bundle tests; standalone
  WASM adapter tests. They cover supported/unknown/missing/unattached evidence,
  recomputed-content-hash corrupt snapshots, immutable parent preservation,
  changed and unchanged specs, dropped evidence, existing-run collisions and
  missing-spec/corrupt-frame rejection.
- Full native fmt, all-target/all-feature clippy and all-feature tests;
  standalone WASM fmt/clippy/tests and release wasm-pack build.
- Python parity: eight exact cost/witness/work cases. JS syntax and five
  existing session-client fault tests.
- Real Chromium: existing composition/reduction/runtime/campaign workflows;
  all prior inspection cases; explicit supported checking; unknown/missing
  controls; corrupt evidence rejection; two distinct UUIDv7 child downloads;
  selected parent preservation; child reinspection with exact lineage,
  changed-spec mode and no child evidence; missing-spec fork disablement.

The deterministic snapshot wire fixture is
`crates/runtime/tests/support/snapshot.rs`; the browser generator is
`wasm/examples/bundle-fixtures.rs`, producing committed `wasm/tests/fixtures/bundles.json`.
The former encodes a one-leaf zero matrix independently of the verifier; the
existing verifier checks it. Core docs contain the exact coverage and copy limits.

Replay from `~/src/ergodis`, using `run-quiet` for noisy commands:

```sh
nix shell nixpkgs#cargo nixpkgs#rustc nixpkgs#clippy nixpkgs#rustfmt --command bash -c 'cargo fmt --check && cargo clippy --all-targets --all-features -- -D warnings && RAYON_NUM_THREADS=12 cargo test --all-features && cargo fmt --manifest-path wasm/Cargo.toml --check && cargo clippy --manifest-path wasm/Cargo.toml --all-targets -- -D warnings && cargo test --manifest-path wasm/Cargo.toml'
nix shell nixpkgs#cargo nixpkgs#rustc --command cargo run --quiet --manifest-path wasm/Cargo.toml --example bundle-fixtures > wasm/tests/fixtures/bundles.json
nix shell nixpkgs#cargo nixpkgs#rustc nixpkgs#wasm-pack nixpkgs#lld --command env RUSTFLAGS='-C linker=wasm-ld' wasm-pack build wasm --target web --release --out-dir www/pkg
nix shell nixpkgs#python3 --command python3 wasm/scripts/check-python-parity.py
nix shell nixpkgs#nodejs --command node --test wasm/scripts/session-client.test.mjs
nix shell nixpkgs#nodejs nixpkgs#chromium --command node wasm/scripts/browser-smoke.mjs
```

Run-quiet capture prefixes under `/tmp/claude-run-quiet/`: targeted/native adapter
`20260907-135832`, full native/WASM `20260907-140001`, Python `20260907-140041`,
JS/client `20260907-140107`, Chromium `20260907-140123`.
Fixture SHA-256: `ebb56ee7267b87a24ce44bacb112882be58fb6f11281d3b41374b9339092591c`.
Built WASM SHA-256: `64402e15be7bfb3379fbced5e07a8bd7277d56464a62292a746fe5ae3d502c46`.
Packaged WASM remains ignored generated output. No export/push or performance claim.
Cache audit passed in dry-run mode at `20260907-140341`; nothing deleted.

## Closeout

No incidental mathematical finding or new mystery. Closeout review confirms
that format support, integrity, summary verification, source interpretation and
execution readiness remain distinct. C1107 is next: portable repository
publication/fencing, attempt identity and recovery accounting before storage
adapters or execution recovery. Broader checker dispatch and private domain
verification remain separately admitted work.
