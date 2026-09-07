# C1100 — Domain-bound authenticated summary transitions

**Lane:** `ergodis`. **Date:** 2026-09-07. **Status:** complete.

Core commit `174999c`; private commit `cc56b87`. Terra implemented the private
adapter and independently audited the final combined boundary; parent implemented
the core accessors, adversarial corpus, validation and integration.

## Motivation and decision

C1096 admitted an LRC event and its resulting leaf summary. C1097 authenticated
min-plus summary transitions independently, and C1098 contained legacy replay
paths which could not authenticate sibling summaries. Neither admission alone
connected the declared event to the authenticated replacement. This slice joins
those boundaries for one existing domain without changing solver kernels.

The core verifier owns wire parsing. The private adapter supplies meaning. This
avoids copying certificate offsets into domain code and keeps the dependency
direction from private interpretation toward reusable verification machinery.

## Implementation

Core `VerifiedSnapshot::leaf_costs` exposes authenticated costs for real leaves,
excluding padding. `TransitionVerifier::verify_delta_for_leaf` requires the
caller-admitted leaf and new costs as well as all existing old-leaf, sibling,
artifact, root and sequence checks. Every check precedes mutation; the original
summary-only entry point remains available. Fixed wire schema and arithmetic
are unchanged. The verifier implementation identity changes with its source.

Private `LrcTransitionVerifier` authenticates a bounded snapshot, validates the
supplied fleet schema and parameters, and compares every real leaf with the
existing `pod_summary` evaluator. It retains the supplied source parameters.
For an event it derives the permitted replacement through shared C1096 admission
logic, evaluates its new summary, invokes the core leaf-bound verifier, and
finally assigns the prepared parameters. No fallible operation follows the
composition commit. Initial per-leaf binding plus authenticated transitions
maintain agreement with the retained source by induction.

Structural events require a rebase. Invalid indices, unavailable-domain bits,
budget multiplication overflow and capacity top-up saturation are rejected.
No-op and summary-preserving events are admitted and increment the sequence;
source changes must still be retained because a later event can observe them.

## Evidence scope and limitations

The independent checker establishes summary composition and authentication.
Domain admission establishes consistency with the existing LRC evaluator. It
does **not** independently prove that evaluator's domain optimality.

A summary is a many-to-one observation. Its commitment does not uniquely name
the source model, schema or event, and loading a snapshot does not authenticate
a publisher. Two source interpretations with identical summaries can both
admit the same snapshot. Durable source identity and event provenance need their
own record binding above the solver; this API deliberately does not claim them.

The private wrapper retains a source vector plus the verifier's O(N) summary/
digest state. Snapshot construction currently clones checked tree storage once.
Updates perform one fixed-domain evaluation and O(log N) authenticated path
work; no per-event whole-tree clone or durable/control-plane state is added.
Existing solver/emitter loops, arithmetic, and hot layouts remain unchanged.
The new expected-replacement comparison is outside the verifier's path loop.
No performance improvement is claimed and no native/WASM ABI is expanded for
the private adapter. Existing core summary size/alignment assertions remain.

## Validation

Core full formatting, all-target/all-feature clippy and all-feature tests pass.
Python parity passes all eight exact cost/witness/work fixtures. WASM release
compilation passes. Private changed-file formatting, library/integration clippy
and 16 regression tests pass: seven new domain-bound tests, six prior event
admission tests, two independent transition tests and the sibling-forgery test.
Core regression directly tests admitted leaf/cost
mismatch rejection without any node, digest, root or sequence mutation. Private
integration tests cover real prover interoperation on one, padded and power-of-two
trees; source mismatch and arithmetic gates; valid proofs for the wrong event or
leaf; every one-byte delta mutation and every truncated prefix; replay rejection;
and latent source changes whose summaries are unchanged until later events.
An explicit alias test accepts two different supplied models for one summary
snapshot, documenting rather than concealing the source-identity limitation.
An unavailable global parity domain with stored maximum capacity is admitted;
reviving it is rejected when the declared top-up would overflow, even if a valid
no-op certificate is supplied. The same certificate then accepts a real no-op.

Replay with Nix toolchains, sequentially (the parent owns the build window):

```sh
# ~/src/ergodis
nix shell nixpkgs#cargo nixpkgs#rustc nixpkgs#clippy nixpkgs#rustfmt --command bash -c 'cargo fmt --check && cargo clippy --all-targets --all-features -- -D warnings && cargo test --all-features'
nix shell nixpkgs#python3 --command python3 wasm/scripts/check-python-parity.py
nix shell nixpkgs#cargo nixpkgs#rustc --command cargo check --manifest-path wasm/Cargo.toml --target wasm32-unknown-unknown --release
# ~/src/ergodis-private
nix shell nixpkgs#cargo nixpkgs#rustc nixpkgs#clippy --command cargo clippy -p ergodis-private --lib --test domain_bound_transitions -- -D warnings
nix shell nixpkgs#cargo nixpkgs#rustc --command cargo test -p ergodis-private --test domain_bound_transitions --test leaf_update_admission --test independent_summary_transition --test summary_transition_forgery
nix shell nixpkgs#rustfmt --command rustfmt --check --edition 2021 --config skip_children=true src/lib.rs src/lrc_update_admission.rs src/lrc_transition_verification.rs tests/domain_bound_transitions.rs
```

Captured through `run-quiet`: core gate prefix `20260907-123034`, private gate
`20260907-123229`, Python `20260907-123230`, WASM `20260907-123347`, under
`/tmp/claude-run-quiet/`. Full-tool lint was not rerun: C1098's unrelated
`leakage_dual_tower.rs:116` finding remains outside this slice. No public export
or push. Cache cleanup is a dry run only.

## Next

Carry model identity, admitted query/representation semantics, event provenance
and checker coverage in durable run records above this boundary. A demonstrator
can then load an old run, verify it independently, and fork a new event stream
without confusing equal summaries with equal source histories. Broader domain
optimality evidence, other algebra/backends, and compact sibling proofs remain
separate work with their own admission and performance gates.

Discovery-track review: no incidental research discovery; summary aliasing is a
planned semantic boundary and is recorded here with an executable regression.
