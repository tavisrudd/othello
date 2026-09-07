# C1094 — Bounded composition construction in core

**Lane:** ergodis. **Date:** 2026-09-07. **Status:** complete structural admission slice.

Extract the smallest demonstrated cold boundary, rather than moving an experimental hierarchy
wholesale. Core `CompositionShape` validates padded binary-heap geometry and caller node/inline-byte
budgets with checked arithmetic, without allocating. Private `RetainedTree::try_new` uses it to
reject malformed/oversized shapes before invoking adapter code, then fallibly reserves the inline
summary vector. Original constructors, record layouts and update/composition loops are unchanged.

This is structural admission only. It does not validate associativity, summary-domain membership,
query preservation, witness semantics or proof authority. Inline bytes exclude memory owned by
summaries, the compiled problem and other workspaces; adapters still own those budgets. Arbitrary
adapter allocation/panic behavior is not converted into a construction error.

The portable shape uses u32 node IDs and u64 storage arithmetic. Private construction additionally
caps inline allocation at the host isize addressable limit. This opt-in path does not narrow the
existing native constructor's input domain or change native64 hot record layouts. The core module
adds no crate/dependency or serialization format. Public documentation distinguishes observable,
objective, observation protocol, query admission and structural shape validity.

Owned core: `src/composition_shape.rs`, `tests/composition_shape.rs`, one `src/lib.rs` export,
`docs/composition-admission.md`, `docs/glossary.md`.
Owned private: additive cold constructors/types in `src/open_problem.rs`,
`tests/composition_construction.rs`.

Acceptance: small independently calculated geometry; zero/extreme counts; node/storage overflow and
budget errors; private rejection before adapter evaluation; admitted matrix tree parity with the
existing constructor and update path. Core required gates plus native/private integration and
portable package checks. No benchmark claim or hot-path rewrite is part of this slice.

Next semantic boundary remains distinct: validated adapter laws and query contracts, followed by
summary-transition evidence with a separate domain leaf-transition obligation. Shape admission is
necessary construction hygiene, not completion of the whole semantic architecture.

Review: Luna found no material arithmetic, range or constructor-order issue. Its documentation
finding was adopted: the tree's own update path does not allocate, but arbitrary adapter methods
or callbacks can violate their allocation contract. Existing comments now qualify this precisely;
no method body in an existing construction/update path was changed.

The independent Python composition fixture passed eight exact cost/witness/work cases. Full core
gates and private bridge tests remain the authority for the implementation results, not this note's
planned acceptance list.

## Validation record

Core commit `b74a369`. Passed `cargo fmt --check`, `cargo clippy --all-targets --all-features -- -D warnings`
and `cargo test --all-features`, including five new shape tests and existing runtime/verifier suites.
Core log: `/tmp/claude-run-quiet/20260907-111939-nix-shell-nixpkgscargo-nixpkgsrustc-nixpkgsclippy-nixpkgsrustfmt-command-bash-c-c`.
Python parity log: `/tmp/claude-run-quiet/20260907-112053-nix-shell-nixpkgspython3-command-python3-check-python-parity.py`.

Private integration adds two tests: parity with the original matrix tree through five updates, and
rejection of zero/overflow/node-budget/byte-budget inputs before any adapter method is invoked.
The latter uses an adapter that panics if called, so rejection order is executable rather than
merely asserted by the error type. No new universal capability-discovery mechanism is claimed;
existing optional traits continue to control which operations an adapter supplies.

Private commit `4add0bc`. Its scoped clippy and both construction tests passed; log:
`/tmp/claude-run-quiet/20260907-112149-nix-shell-nixpkgscargo-nixpkgsrustc-nixpkgsclippy-command-bash-c-cargo-clippy-p-e`.
This closes the structural constructor gate only. The next extraction should address semantic
adapter admission and distinguish summary-transition receipts from independently checked leaf
transitions, using the existing private capability implementations rather than another tree.
No incidental discovery-track entry: all findings were sought within this admission task.

WASM release check passed for `ergodis`, runtime and browser binding (`cargo check --manifest-path wasm/Cargo.toml --target wasm32-unknown-unknown --release`). Log: `/tmp/claude-run-quiet/20260907-112254-nix-shell-nixpkgscargo-nixpkgsrustc-command-cargo-check-manifest-path-Cargo.toml-`. No browser bundle or serialization format changed. Cache GC was dry-run only.
