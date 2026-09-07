# C1095 — Additional observable admission on finite quotients

**Lane:** ergodis. **Date:** 2026-09-07. **Status:** complete. Core commit `8fe20fa`.

## Motivation and implementation

One model may support many questions, while a particular compilation retains only some
of their distinctions. Core `observable_admission` now makes that boundary explicit for the
existing finite typed deterministic presentation. This is a deliberately narrow reusable
mechanism, not a new universal problem schema or quotient compiler.

`ValidatedQuotient::new` checks the supplied source/compiled pair through the existing core
`verify_compilation`, including representative membership and induced generator transitions.
Its cost follows the certificate policy and can include recompilation. Several new total
state-indexed u32 readouts can then be admitted without repeating that validation.
Admission checks class constancy and returns either owned class outputs with borrowed existing
transitions or a concrete same-class pair distinguished by the requested readout. No allocation
of class outputs occurs on rejection. Successful admission scans the concrete states and stores
one symbol per class. Existing hot records, loops and native64 specialization are unchanged.

This permits question specialization without claiming a new minimal representation: an existing
quotient can retain extra classes for a coarser question. A rejected finer question needs refinement
or another compilation; a planner may not silently replace it by an easier question. This is a
future Evolve search signal, not autonomous question/design exploration implemented here.

## Authority and limits

The source binding is live in-memory validation, not a durable identity or standalone verifier
receipt. Class constancy plus transition congruence preserves this state readout along every
well-typed sequence of the supplied generators. It says nothing about correctness of domain
lowering, probability interpretation, history-dependent policies, witness lifting, or changed
models/contexts. Implicit models need not materialize their carriers to use other admission paths.
No shared-library manifest, serialized schema, control-plane dependency, or new crate is added.

Terra reviewed existing verifier representative and generator checks and found no concrete safety
defect; Luna owns independent concrete-trajectory tests. Parent owns build gates and commits.

## Validation

The new three-test corpus checks 508 concrete trajectories (every two-generator word through
length six from four states), compatible/coarser readouts, snapshot semantics after caller table
mutation, a concrete distinguishing pair, malformed table length and a mismatched source.
Python composition parity passes all eight exact cost/witness/work fixtures. Full core formatting, all-target/all-feature clippy, all-feature tests and WASM release
compilation pass. Cache GC ran in dry-run mode; nothing was removed.
No new performance claim; no existing hot algorithm/layout changed.

## Next boundary

Domain-checked leaf transitions and summary-transition evidence remain next. Reuse the existing
OpenProblem/LRC/certificate corpus; do not promote source-correctness claims from table hashes.
Independent verification extraction follows explicit evidence scope. Query/representation/design
tradeoff exploration can consume admission failures without conflating weaker questions with
better answers.

## Review and maintenance

The cheap extension is admission of several observables through one validated handle; both a
coarser readout and a relabelled readout are tested. No coarsest-new-quotient claim is needed to
make reuse useful. Keep cold admission in its own compilation unit; avoid adding metadata or
control concerns to the existing large observational engine. No incidental discovery requiring
a discovery-track entry arose. The open evidence boundary is explicit domain/event correctness,
not an unexplained failure of this finite factorization check.

Replay from core:

```sh
nix shell nixpkgs#cargo nixpkgs#rustc nixpkgs#clippy nixpkgs#rustfmt --command bash -c 'cargo fmt --check && cargo clippy --all-targets --all-features -- -D warnings && cargo test --all-features'
nix shell nixpkgs#python3 --command python3 wasm/scripts/check-python-parity.py
nix shell nixpkgs#cargo nixpkgs#rustc --command cargo check --manifest-path wasm/Cargo.toml --target wasm32-unknown-unknown --release
```

Captured logs under `/tmp/claude-run-quiet/`: native gate prefix `20260907-113316`,
Python `20260907-113259`, WASM `20260907-113502`, cache dry run `20260907-113432`.
The tracked integration tests are the replay authority; temporary logs are supplementary.
