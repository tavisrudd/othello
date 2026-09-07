# C1098 — Retire legacy certificate authority

**Lane:** ergodis. **Date:** 2026-09-07. **Status:** complete first-party migration. Private commit `83ebffa`.

## Scope and result

The bounded first-party source inventory found two operational consumers: the generic and
specialized incremental certificate benchmark commands. Other references are historical/unit/
allocation tests and the explicit forgery regression. Core, runtime and WASM have no consumer of
these private legacy types. This inventory covers Rust source, not external integrations or
historical scripts; old private callers now fail compilation instead of silently retaining
verifier authority.

Rename `GenericVerifier` to `LegacyGenericReplay` and `VerifierState` to `LegacyReplayState`.
Their operation is `replay_delta`, with no compatibility aliases or `verify_delta` method.
Compile-fail doctests guard removal of the old authority-shaped type names. The algorithms and
72-byte layouts are retained only for explicit historical replay and allocation comparisons.
The old root-only algorithms remain unsound as certificate verifiers; renaming is containment,
not a mathematical repair. The new independent checker is the supported verification path.

Generic historical chain modes require `--legacy-replay` before setup and report
`proof_authority false`. The specialized benchmark requires this flag for every run because its
setup/collapse stages use legacy replay even outside its chain mode; every output reports false
authority. Emit-only generic modes no longer instantiate the legacy state. Existing table
inclusion benchmarks remain separate from summary-transition authority.

Add `matrix-verified-chain`: an actual first-party consumer of the independent min-plus checker.
It emits SHA256Digest backend-1 certificates, validates the initial snapshot, and checks every
update through `ergodis-verify`. It declares only `authenticated_summary_transition` authority
and explicitly denies domain optimality authority. Other algebras/backends do not silently fall
back to the legacy replay path as proof. The new mode releases its snapshot bytes and redundant checked snapshot before the update loop.
It is a different measured workload, not a
performance-equivalent replacement for old root-only timings.

## Performance and ownership

No solver, emitter, legacy replay algorithm, hot record, or existing per-event algorithm changes.
Method/type renaming retains the same arithmetic and memory layout; the allocation regression
still checks historical replay. Mode/authority selection happens before measured loops. The
independent verifier retains O(N) authenticated state and O(log N) path updates as established in
C1097; no new speed claim is made. No public core or WASM source changes in this slice.

Parent owns library/API migration, compilation and reports. Terra owns benchmark migration and
unit refusal/supported-mode tests; Luna audits first-party consumers. No publication/export.

## Validation

Library doctests (including removed-API guards), both certificate modules' existing unit tests,
allocation regression, independent interoperability and the masking forgery regression pass.
Changed-file formatting and library clippy pass. Whole-tool clippy is blocked by the unrelated
`needless_range_loop` diagnostic in `tasks/tools/src/leakage_dual_tower.rs:116` (that tracked file
is unchanged). No warning suppression or foreign fix was applied. CLI consumer tests and smoke
execution pass; do not describe the whole-tool lint gate as passing. Across doctests, relevant
library unit/integration tests and CLI tests, 50 tests pass. CLI integration clippy also passes.
The persistent CLI tests exercise refusal for all nine historical mode selections, supported
verification output, and explicit legacy replay with false proof authority.

## Next

Bind domain-event admission to authenticated summary transitions for a real domain adapter.
The supported checker alone does not establish source lowering or leaf-event meaning. Other
wire/backends and compact sibling proofs require explicit admission, not automatic fallback.

## Closeout judgment

The key containment is compile-time: accidental reuse of old authority-shaped API names fails.
The deliberate legacy path remains available only as clearly named replay; its benchmark consumers
also require runtime opt-in and cannot advertise proof authority. No incidental lead requires
logging. Remaining unsupported algebra/backends are explicit scope, not checked by this migration.

Replay from `ergodis-private`:

```sh
nix shell nixpkgs#cargo nixpkgs#rustc --command bash -c 'cargo test -p ergodis-private --doc && cargo test -p ergodis-private --lib generic_certificate:: && cargo test -p ergodis-private --lib incremental_certificate:: && cargo test -p ergodis-private --test incremental_certificate_allocations --test summary_transition_forgery --test independent_summary_transition && cargo test -p ergodis-tools generic_certificate_bench::tests && cargo test -p ergodis-tools incremental_certificate_bench::tests && cargo test -p ergodis-tools --test certificate_authority'
nix shell nixpkgs#cargo nixpkgs#rustc nixpkgs#clippy --command cargo clippy -p ergodis-private --lib -- -D warnings
nix shell nixpkgs#cargo nixpkgs#rustc nixpkgs#clippy --command cargo clippy -p ergodis-tools --test certificate_authority -- -D warnings
nix shell nixpkgs#cargo nixpkgs#rustc --command cargo run -p ergodis-tools -- generic-certificate-bench --mode matrix-verified-chain --events 2
```

Supplementary `/tmp/claude-run-quiet/` logs: library suite `20260907-121018`,
whole-tool lint limitation `20260907-121322`, CLI unit/smoke `20260907-121608`,
CLI integration/lint `20260907-121832`. Cache GC ran dry; nothing was removed.
Tracked tests and source are the replay authority; no timing result is claimed.
