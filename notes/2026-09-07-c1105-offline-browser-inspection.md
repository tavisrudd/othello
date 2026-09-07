# C1105 — Offline browser bundle inspection

Date: 2026-09-07. Lane: `ergodis`. Status: complete. Core commit `d5e5504`.

## Implementation

The browser prototype now has `bundle.html`, a separate offline inspection page.
It displays manifest counts, run/record/specification identities, exact sequence
strings, start/update/fork lineage, declared search mode and missing dependencies.
A missing specification leaves the mode unknown. Absent parents are unresolved
ancestry; corrupt included parents reject the file. Included checksums grant no
publisher authentication or mathematical authority.

The WASM adapter calls the existing runtime `Bundle::parse` and builds display
metadata. JavaScript does not duplicate the wire parser. Inspection constructs
no Campaign and invokes no solver, source adapter or mathematical checker.
Existing campaign and composition pages retain their separate workflows.

The browser client checks the 16 MiB file limit before starting a Worker. The
Worker checks it again before reading an immutable Blob handle. One ArrayBuffer
and one wasm-bindgen slice copy bound input copies to 32 MiB, excluding original
Blob storage, module and bounded metadata. Rust borrows payloads from its slice;
only display metadata returns to the page. The existing 4 MiB item/512 entry and
record/specification bounds remain enforced. A single-flight client rejects
overlap; its disposable Worker terminates on success, failure or a 30-second
deadline. Prior views and buffers are not retained across file selections.

All file-derived content is rendered with `textContent`. Sequence numbers remain
decimal strings rather than potentially rounded JavaScript numbers. The page
supports keyboard file selection and recovers after rejected input.

## Validation

Deterministic fixture generator: core `wasm/examples/bundle-fixtures.rs`.
Committed corpus: `wasm/tests/fixtures/bundles.json`. The generator uses the
canonical encoder. Its adversarial included-parent fixture combines two valid
partial frames with a structurally valid but skipped child sequence, so parent
consistency rejects it independently of checksum checks.

Native WASM adapter tests and Python parity (eight exact cost/witness/work cases)
pass. JavaScript syntax and the five existing session-client fault tests pass.
Full native fmt, all-target/all-feature clippy and all-feature tests pass, as do
standalone WASM fmt/clippy/tests and the release wasm-pack build.

Real Chromium tests pass: complete manifest and fork lineage; partial material
with absent parent/specification; unknown mode when the spec is missing;
corrupt bytes; structurally valid but inconsistent included parent; oversize
rejection before Worker creation/read and through actual file selection;
single-flight rejection preserving the first inspection; reopening after errors;
and keyboard focus. Existing composition, reduction/runtime corpora and live
campaign UI/Worker checkpoint workflows also pass.

Replay from `~/src/ergodis`, wrapping noisy commands with `run-quiet`:

```sh
nix shell nixpkgs#cargo nixpkgs#rustc nixpkgs#clippy nixpkgs#rustfmt --command bash -c 'cargo fmt --check && cargo clippy --all-targets --all-features -- -D warnings && RAYON_NUM_THREADS=12 cargo test --all-features && cargo fmt --manifest-path wasm/Cargo.toml --check && cargo clippy --manifest-path wasm/Cargo.toml --all-targets -- -D warnings && cargo test --manifest-path wasm/Cargo.toml'
nix shell nixpkgs#cargo nixpkgs#rustc --command cargo run --quiet --manifest-path wasm/Cargo.toml --example bundle-fixtures > wasm/tests/fixtures/bundles.json
nix shell nixpkgs#cargo nixpkgs#rustc nixpkgs#wasm-pack nixpkgs#lld --command env RUSTFLAGS='-C linker=wasm-ld' wasm-pack build wasm --target web --release --out-dir www/pkg
nix shell nixpkgs#python3 --command python3 wasm/scripts/check-python-parity.py
nix shell nixpkgs#nodejs --command node --test wasm/scripts/session-client.test.mjs
nix shell nixpkgs#nodejs nixpkgs#chromium --command node wasm/scripts/browser-smoke.mjs
```

Run-quiet capture prefixes under `/tmp/claude-run-quiet/`: adapter `20260907-134501`,
full native/WASM `20260907-134546`, Python `20260907-134619`, JS/client `20260907-134659`,
Chromium `20260907-134809`. An initial compile caught that `ContentId` has no
Display implementation; explicit bounded hex rendering fixed it before acceptance.

Fixture SHA-256: `38bbef9e739d99a4c695fa3da8f64fecd700d5d6ccf22bf3be465147634c789c`.
Built WASM SHA-256: `8b94e28610bf877372f0d6d7ffa61ef4663080c8968f40e7ffb5f85d4db7471e`.
The generated browser package remains ignored build output; its sources and
fixture generator/corpus are committed. No export or push.
Cache audit passed in dry-run mode at `20260907-134934`; nothing deleted.

## Scope and closeout

Solver/update hot loops and native64 layouts are untouched; no performance
improvement is claimed. The browser workflow is inspection only. C1106 owns
explicit verification and fresh-ID forks; C1107 owns repository publication,
fencing and recovery accounting. No private adapter or platform storage was added.

Discovery-track discriminator: no incidental mathematical finding. The
missing-parent/corrupt-parent distinction and input-copy bounds are planned
deliverables. Closeout review identified the cheap sequence-string and
post-rejection recovery checks, included above; no new research mystery remains.
