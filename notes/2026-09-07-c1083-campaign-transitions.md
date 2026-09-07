# C1083 — portable campaign transition model

**Lane**: `ergodis`
**Date**: 2026-09-07
**Status**: COMPLETE. Core commit `6269cd1`; all native/Python/WASM regression gates passed.

## Implemented scope

Core `src/campaign.rs` connects proposal revisions, independent finite checking and existing
solver execution in a bounded, synchronous state machine. It is available without the native
control-plane feature. The public contract is `docs/campaign-semantics.md`; the earlier proposed
campaign section in `docs/language-semantics.md` now points to this implemented boundary.

The initial campaign specification binds one authoritative reduction problem, an initial
candidate, immutable mode and immutable limits. The commands are Propose, Check, Execute,
Cancel and Resume. A candidate revision and a command sequence are different counters.
Accepted Propose always advances the former and invalidates active evidence/result, even when
the proposal repeats the same candidate. Reports are snapshots, not serialized capabilities.

Check invokes the existing independent GF(2) checker and stores its opaque Admission, or records
refutation/incompleteness. Proof-generating Execute requires admission; heuristic Execute can
run unchecked with restricted-only coverage, or admitted with complete finite-problem coverage.
A later successful Check does not retrospectively upgrade a prior unchecked result. Proposer
origin, theorem/parameter lineage, run mode and evidence remain independent.

Cancel gates subsequent work and preserves completed evidence/results. Resume unpauses without
resetting any budget; neither interrupts an already-running atomic checker or solver. Inputs are
validated before logging even while cancelled. The source limits event logs to 128 commands,
checkpoint JSON to 4 MiB, checker reservations to fixed-width totals and execution slots to 128.
Checks reserve the submitted allowance without refunds, including incomplete or early-refuted
checks; aggregate exhaustion reserves nothing. Events still count for unsuccessful outcomes.

## Replay and artifacts

Checkpoint JSON holds the immutable initial specification and command/transition log, with a
SHA-256 checksum over typed decoded data. Restore constructs a fresh campaign and reruns the
actual checks and solver calls, requiring structural equality of every observed transition.
Changing a saved receipt/status and recomputing the public checksum cannot create admission.
Checksums are corruption detection, not authenticity, and arbitrary JSON whitespace is not bound.

This is conservative implementation replay, including checker-source identity and concrete
witnesses; it is not cross-version semantic equivalence. Replay reconstructs original logical
expenditure while physically repeating computation; host-wide replay-resource accounting remains
separate. There is no receipt-to-Admission deserializer.

Execute currently compiles and queries through the existing solver in one transition. No distinct
Compile command, retained kernel handle or persistent physical artifact cache was added. Stored
artifacts are replay requests and observed reports. General compiled artifacts, daemon/Unix-socket
transport, a JavaScript campaign export, asynchronous dispatch and autonomous scheduling are
successor layers. This task does not claim the complete autonomous system is implemented.

The schema-1 reduction constructor was factored into one crate-private cold `prepare_problem`
helper, shared by the existing one-shot interpreter and campaign construction. Existing matrix
limits, canonical minimum costs, solver hot loops and native 64-bit layouts remain unchanged.

## Reference and adversarial validation

`python/campaign_semantics.py` independently models the transition relation and obtains finite
validity/cost facts from `python/admission_semantics.py`. Its 10 command sequences cover proposal
invalidation, checked and unchecked solving, refutation, incomplete checks retaining earlier
admission, cancellation gates, old result coverage, and non-resetting aggregate budgets.
`tests/campaign_semantics.rs` drives the real campaign and compares each projected state, then
restores each complete command history. It does not use saved reports as oracle authority.

Seven adversarial integration tests cover candidate invalidation, canceled/resumed work,
prior-result coverage, incomplete/budget-exhausted checking, event/byte/execution limits,
malformed proposals while paused, and forged receipts/results with recomputed checksums.
The existing reduction document corpus also passes after the shared construction refactor.

Terra wrote the contract and independently reviewed authority, budget and replay semantics;
a second Terra supplied adversarial tests. Luna supplied the independent model. Review corrected
the model's initial charge-by-actual-work assumption and hard-coded work threshold, and moved
proposal validation before paused logging to keep command payloads bounded. Parent corrected
the fixture consumer's result projection and added execution/checkpoint limit tests before
acceptance. No hot-path code change or performance claim is made.

## Replay commands

Run from `~/src/ergodis` through run-quiet, with the shared Cargo target directory and at most
12 Rayon workers. Formatting, all-target/all-feature clippy, the full all-feature tests, default
core check, all four Python fixture checks, wasm32 release checking, wasm-pack packaging and
Chromium smoke passed. The browser regression includes the original composition example, all
12 reduction cases and three rejection cases. Generated browser packages remain ignored.
Cache GC completed in dry-run mode; no shared artifacts were deleted.

Representative local logs:
- Full native suite: `/tmp/claude-run-quiet/20260907-082846-RAYON_NUM_THREADS12-nix-shell-nixpkgscargo-nixpkgsrustc-command-cargo-test-all-fe`.
- Browser regression: `/tmp/claude-run-quiet/20260907-083105-nix-shell-nixpkgsnodejs-nixpkgschromium-command-node-browser-smoke.mjs`.

Committed source/reference/tests and replay commands are the durable evidence; local logs are
supporting diagnostics.

```sh
nix shell nixpkgs#cargo nixpkgs#rustc --command cargo fmt --all -- --check
nix shell nixpkgs#cargo nixpkgs#rustc nixpkgs#clippy --command cargo clippy --all-targets --all-features -- -D warnings
nix shell nixpkgs#cargo nixpkgs#rustc --command env RAYON_NUM_THREADS=12 cargo test --all-features
nix shell nixpkgs#cargo nixpkgs#rustc --command cargo check
nix shell nixpkgs#python3 --command python3 python/generate_fixtures.py --check
nix shell nixpkgs#python3 --command python3 python/admission_semantics.py --check
nix shell nixpkgs#python3 --command python3 python/plan_semantics.py --check
nix shell nixpkgs#python3 --command python3 python/campaign_semantics.py --check
nix shell nixpkgs#cargo nixpkgs#rustc --command cargo check --manifest-path wasm/Cargo.toml --target wasm32-unknown-unknown --release
nix shell nixpkgs#cargo nixpkgs#rustc nixpkgs#wasm-pack nixpkgs#lld --command env RUSTFLAGS="-C linker=wasm-ld" wasm-pack build wasm --target web --release --out-dir www/pkg
nix shell nixpkgs#nodejs nixpkgs#chromium --command node wasm/scripts/browser-smoke.mjs
```

The browser gate checks existing composition and reduction interfaces; campaign code compiles
for wasm32 but no campaign export or browser execution claim is made.

## Next gate

Connect a bounded autonomous proposer to this transition model, retaining counterexamples and
replayable state across steps. Expose the same workflow through native and browser hosts with
command/result parity, explicit resource ownership and eventual socket steering. General quotient
instructions, persistent compiled artifacts and private kernel/package loading remain later
C1079 stages. Do not substitute scalar diagnostic plan acceptance for reduction admission.

## Closeout review and mystery ledger

After acceptance, the explicit ej+tt pass clarified three separate observations for future hosts:
latest command outcome, current candidate evidence, and earlier run coverage. An incomplete
recheck need not revoke earlier admission, and new admission cannot retrospectively upgrade an
unchecked run. The public specification now explicitly prevents collapsing these into one status.

No unexplained mathematical result remains. The open engineering gates are explicit: autonomous
proposal scheduling, cross-host command transport, persistent compiled artifacts, genuine quotient
instructions and private module loading. These require successors; the current finite command
model and replay tests do not settle them. No incidental discovery-track entry is warranted.
