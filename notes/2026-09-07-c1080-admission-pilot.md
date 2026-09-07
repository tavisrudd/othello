# C1080 — portable candidate/parameter/admission pilot

**Lane**: `ergodis`
**Date**: 2026-09-07
**Status**: COMPLETE. Core commits `5247f6d` (browser recovery/layout guards) and `95d16b9` (admission pilot).

## Implemented scope

Following Tavis’s approval of the C1079 first implementation step, core now has
`src/admission.rs`, a bounded, portable discovery → independent finite check → existing solver
consumer. It is library functionality available without `control-plane`; it does not add a daemon
operation, general theorem language, plugin loader, private package, or production autonomous
campaign. Public contract documentation is `docs/admission.md`; `DESIGN.md` records the precise
implemented boundary.

The authoritative problem is a canonical GF(2) CostTable, outer blocks and target. The first
candidate family states that a coordinate of every local label in every feasible tuple equals a
binary parameter. The existing `evolve_ranked_streaming` driver searches that bounded grammar;
`discover_coordinate_reduction` retains counterexamples and produces a checked best candidate.

The checker enumerates the complete declared Cartesian product by direct XOR/AND arithmetic,
independently of CompositionTable’s optimizer. A counterexample contains a feasible tuple and
its wrongly rejected block. An admitted restriction preserves all feasible tuples for this exact
problem, hence preserves the optimum and valid witnesses. The consumer compiles only the retained
CostTable entries and calls the existing sequential or parallel CompositionTable backend.
No solver hot-loop implementation or record layout was changed for admission.

## Contracts and evidence boundaries

- Theorem origin and parameter origin are separate declared records with parent/operator/source
  and generating-context identities; origin is not a validation status or attestation.
- Candidate identity binds parameters and both origins. Problem identity binds canonical labels,
  costs, outer matrices and the target. Altering any bound input prevents token reuse.
- Admission is an opaque, private-field Rust type with no Deserialize implementation. A portable
  receipt is untrusted: replay reruns the checker and compares all fields. The checker identity
  hashes its rule version and module source, not the whole toolchain/dependency graph.
- Proof-generating consumption requires a valid admission. Unvalidated heuristic consumption
  reports restricted-only coverage; a miss does not exclude the original domain. A heuristic run
  may also use an admitted theorem and then report complete finite coverage. Mode and evidence
  remain independent.
- Hard caps: GF(2), 1–8 blocks, 64 canonical local labels, 64 cells per local label/target,
  65,536 complete tuples. Budget rejection cannot produce partial admission. The aggregate
  discovery budget covers all candidate checks; conservative cell accounting includes scratch
  initialization, stores, clearing and comparison. Metadata work is separately bounded by input
  and ancestry caps; this is not an instruction or wall-time budget.

This is one finite generation and one fixed theorem family. It is not a claim of unbounded
proof synthesis, cross-instance theorem transfer, lifecycle persistence, or end-to-end speedup.
Complete finite checking can cost more than the solve work saved; this task makes no performance
claim. Full theorem/parameter registries, richer IR, dynamic modules and campaign integration are
successor work from C1079.

## Validation

Native validation using the Nix Rust toolchain and at most 12 Rayon threads passed:

- 11 focused admission integration tests: solver cost/witness preservation, counterexamples,
  forged receipts, changed problems/parameters/origins, mode/coverage, unsatisfiable/vacuous case,
  budget/shape limits, existing proposer and public discovery entry, aggregate budget,
  independent tiny exhaustive oracle, multi-column row-major arithmetic, and parallel parity.
- Default core check, all-target/all-feature clippy, and full all-feature tests.
- `python/generate_fixtures.py --check`, covering the existing bounded independent fixture corpus.

Key saved logs from the run-quiet runner:
`/tmp/claude-run-quiet/20260907-073535-RAYON_NUM_THREADS12-nix-shell-nixpkgscargo-nixpkgsrustc-command-cargo-test-all-fe`,
`/tmp/claude-run-quiet/20260907-073548-RAYON_NUM_THREADS12-nix-shell-nixpkgscargo-nixpkgsrustc-nixpkgsclippy-command-car`,
`/tmp/claude-run-quiet/20260907-073552-RAYON_NUM_THREADS12-nix-shell-nixpkgscargo-nixpkgsrustc-command-cargo-test-all-fe`,
and `/tmp/claude-run-quiet/20260907-073640-nix-shell-nixpkgspython3-command-python3-generate_fixtures.py-check`.
The committed source/tests and replay commands below are the durable evidence, not these local logs.

```sh
nix shell nixpkgs#cargo nixpkgs#rustc --command cargo fmt --all -- --check
nix shell nixpkgs#cargo nixpkgs#rustc nixpkgs#clippy --command cargo clippy --all-targets --all-features -- -D warnings
nix shell nixpkgs#cargo nixpkgs#rustc --command env RAYON_NUM_THREADS=12 cargo test --all-features
nix shell nixpkgs#python3 --command python3 python/generate_fixtures.py --check
```

Run these from `~/src/ergodis` through the repository’s run-quiet wrapper. The existing out-of-tree
target directory remains in use. No performance or heavy research benchmark was run.

## Review and closeout

Terra’s independent source review found no concrete authority, coverage or optimum-preservation
bug. It found missing output-clearing work in the initial checker budget; this was corrected in
the shared bound used by direct admission and discovery before final focused/native validation.
Luna added the public-entry, aggregate-budget, cancellation, witness, parameter-origin and
multi-column checks and ran native validation.

The C1032 recovery adds the historical bounded browser adapter under current core `wasm/`.
Native adapter tests, adapter clippy and eight-case Python parity passed, followed by wasm32
release checking, wasm-pack packaging and a Chromium Worker smoke test (exact cost 1 and witness
label count). The Python corpus runs through the native adapter; the browser smoke is one case,
not a claim that all eight corpus cases were exercised in Chromium. C1032 remains open for its
own full original acceptance review; this task closes the current-core recovery baseline.

The first WASM attempt exposed hard-coded 64-bit layout assertions. All existing 64-bit size and
alignment expectations remain exact, with strict 32-bit expectations added. No field, representation,
solver algorithm or hot loop changed. In particular, `Zdd<DirectMemo>` is asserted at 416 bytes /
alignment 8 on 64-bit and 216 bytes / alignment 8 on wasm32. These are drift guards, not permissive
upper bounds. No throughput parity claim is inferred from layout assertions alone.

Browser replay from `~/src/ergodis`:

```sh
nix shell nixpkgs#cargo nixpkgs#rustc --command cargo test --manifest-path wasm/Cargo.toml
nix shell nixpkgs#python3 --command python3 wasm/scripts/check-python-parity.py
nix shell nixpkgs#cargo nixpkgs#rustc --command cargo check --manifest-path wasm/Cargo.toml --target wasm32-unknown-unknown --release
nix shell nixpkgs#cargo nixpkgs#rustc nixpkgs#wasm-pack nixpkgs#lld --command wasm-pack build wasm --target web --release --out-dir www/pkg
nix shell nixpkgs#nodejs nixpkgs#chromium --command node wasm/scripts/browser-smoke.mjs
```

The package needs `lld` in the build environment. The committed lockfile pins the adapter's
resolved dependencies; generated `www/pkg` stays ignored. Cache GC completed in dry-run mode;
no shared cache artifacts were deleted.

## Next gate

Connect the portable admission contract to a persistent autonomous campaign and a richer portable
IR, then expose the checked workflow through native and browser hosts. Native specialized kernels
and private packages remain later stages under C1079's IP boundaries. The browser baseline does
not yet load extensions or expose admission. The next implementation slice needs a fresh allocated
C ID; none is inferred here.
No incidental mathematical discovery arose; no discovery-track entry is warranted.
