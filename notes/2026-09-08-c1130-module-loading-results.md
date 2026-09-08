# C1130 — Module loading spike results

**PRIVATE — do not ship or publish.**
**Lane**: `ergodis`. Date: 2026-09-08.
**Status**: loading/conformance slice implemented; performance and distribution
acceptance still in progress. No stable ABI or full WASM parity claim.

## Demonstrated

- Public generic host and coarse ABI: core `0af66d9`, crate `ergodis-modules`;
  native trusted-library loading and browser `module-host.js`/`module-worker.js`.
  No core dependency on private source, family types or fixtures.
- Private providers: `3aafb81`, library packages `lrc-provider` and `qec-provider`.
  They compile the existing private source modules directly through one thin
  adapter. No copied solver, private-host dependency, or new executable target.
  Test-only allocation tracking was extracted from the existing inline module
  into one shared private source file; original kernel bodies were not changed.
- Native recipient runs in bubblewrap with only Nix runtime, the generic test
  executable and packaged input/payload data. Neither source checkout is visible.
  LRC's 23-operation and QEC's 20-operation direct-native transcripts pass.
- A separate offline bubblewrap build exposes only public core source, standard
  dependency cache and the shared target directory. The generic recipient builds
  successfully without a private source mount. First attempt lacked the Nix C
  linker; adding `nixpkgs#gcc` to the tool environment fixed it.
- Actual Chromium Worker execution passes the same two transcripts, including
  repeated readouts, failed preparation, stale/wrong-kind handles, release order,
  output capacity and unsupported readouts. Five incompatible package mutations
  reject. Destroy/reload does not revive old handles. Browser fetch count is one
  for the existing canonical core WASM artifact; extensions are separate payloads.
- QEC input is a generated Stim rotated memory-Z surface-code circuit, distance 5,
  five rounds, noise 0.001 at the four declared circuit noise sites. All detector
  coordinates/graph data belong to that full model, not the console projection.
  The corpus has 256 sampled shots plus an intentional replacement of the last
  shot by the dense syndrome, preserving explicit fallback/class-availability
  outcomes. LRC uses the existing HostileInstances benchmark generator, seed 2026,
  and 256 admitted budget queries with count, threshold and mode/load readouts.

These checks establish transport parity against existing APIs. They do not turn
provider results into independent mathematical certificates. Existing bounded QEC
semantic/oracle tests also pass. Public host activation is distinct from manifest
inspection; native library loading is trusted code execution, not sandboxing.

## Validation and limits

Core fmt, all-target/all-feature Clippy, all-feature tests, module-specific Clippy,
79 Python algorithm tests and 8 exact cost/witness/work WASM parity cases passed.
Core test log includes 650 unit tests plus integration/doc tests.
Both private provider contract tests pass with zero tracked allocations across
1,000 repeated executions; the existing Tiger decode-loop allocation test passes
after the test-helper extraction. Two existing QEC semantic tests pass.

Provider all-target/all-feature Clippy passes after preserving the original
private library's kernel style allowances on imported modules. Whole operator-tool
Clippy remains blocked by the pre-existing `needless_range_loop` in
`tasks/tools/src/leakage_dual_tower.rs:116`; no waiver or foreign edit applied.

Allocation tests currently instrument the linked provider implementation. The
benchmark host's allocator does not see allocations in a separately loaded
library. Do not claim loaded-library allocation coverage from a host-only count.
No performance acceptance has been issued yet. The benchmark's direct arm is the
typed **adapter**, not a claim to match an unwrapped native kernel cost.

Explicit experimental capacities: 64 live objects per provider instance, 65,536
queries per workspace; QEC caller-supplied node/edge budgets bounded by 4,096/
65,536 and one logical observable. These are spike admission bounds, not the
intended feature-complete WASM contract. Removing/generalizing remaining family
limits remains C1130 work. No stable checkpoint or in-flight continuation claim.

## Retained evidence and replay

Pre-change native baseline:
`~/.cache/ergodis/bin/ergodis-tools-6ab0681`, SHA-256
`663fd90d4cf6e7309960c2cb156d536f8a36211b7f0229a11153e61e9dd82b46`.
The three-arm counter experiment uses separately retained test executables and
the exact hashed provider libraries; its results will be added before adoption.

Private scripts live under `ergodis-private/analysis/module-loading/`:

1. `build.sh` under Nix cargo/rustc/rustfmt builds native providers and transcripts
   driver, tests the adapters, and builds the domain-neutral recipient.
2. Build WASM from the private root with Nix cargo/rustc/lld:
   `RUSTFLAGS=-Clinker=wasm-ld cargo build --release --target wasm32-unknown-unknown -p ergodis-lrc-provider -p ergodis-qec-provider`.
3. `build-recipient-isolated.sh` under Nix cargo/rustc/gcc builds with private source
   unavailable. `uv run --with stim python analysis/module-loading/package.py`
   produces the real fixtures, expected transcripts and recipient manifests.
4. `bash analysis/module-loading/recipient.sh` runs native recipients in isolation.
   Under Nix nodejs/chromium, `node analysis/module-loading/browser.mjs` runs the
   actual browser Worker against allowlisted core assets and package data only.
5. `validate.sh` contains full gates and records the known whole-tools Clippy block.
   Run the remaining scoped QEC/provider tests separately after that block.

Wrap noisy commands in run-quiet. Build outputs remain in configured shared target
directories; evidence is under `~/.cache/ergodis/module-loading/`: `artifacts.json`,
`browser.json`, recipient build JSONL, hashed module files and input transcripts.
These cache records need a compact committed measurement/fixture manifest at the
completed spike gate. No bulk module payload belongs in the private context docs.

## Remaining spike gates

Retained interleaved native counters in single/parallel modes; distinguish direct
adapter, static C ABI and loaded C ABI costs from the original direct kernel;
provider-side allocation evidence; WASM transfer/startup/warm cost accounting;
compatible revised payload under unchanged host bytes; stripped/obfuscated
recipient artifact inspection; bounded component comparison; committed compact
evidence and adoption/revision verdict. Keep production native entry points
unchanged until the performance and ownership decision is supported.

Implementation issues caught so far: browser test initially evaluated before page
navigation completed (fixed by awaiting the page-load event); imported kernels
needed their existing crate-level test helper/style context when compiled as
providers (reused, without kernel rewrites). These are integration findings, not
evidence that the ABI is ready to freeze.
