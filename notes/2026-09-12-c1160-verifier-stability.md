# C1160 — scalar stability and semi-naive summary verification

**Lane**: `ergodis`
**Date**: 2026-09-12
**Status**: COMPLETE; native, Python-oracle and WASM compilation gates pass.
**Core implementation**: `6284ca7` in `~/src/ergodis`.

## Delivered contract

`crates/verify/src/weight.rs` introduces the sealed `TransitionWeight` interface:
canonical encoding width and fallible encoding/decoding, semiring operations,
comparison minus, stability class, has-minus/idempotence/commutativity properties,
and carrier exactness. Bounded nonnegative min-plus and Boolean reachability
instantiate it. Both scalar carriers are uniformly 0-stable. Sealing makes the
admitted laws an implementation responsibility rather than untrusted proof input.

`composition_graph.rs` checks least summaries of the supplied finite equations
`x[i] = input[i] ⊕ Σ (x[left] ⊗ x[right])`. Ordered binary product rules can
describe a DAG or cycles without a topology-specific checker. Matrices can lower
to scalar coordinate equations. Replay starts at zero and compares every claimed
coordinate. It cannot accept a self-supporting fixed point merely because the
claimed vector satisfies the equations.

The semi-naive contribution is
`Δleft ⊗ old_right ⊕ (old_left ⊕ Δleft) ⊗ Δright`, followed by comparison minus
against the held output. This includes the nonlinear cross term. All loop storage
is allocated before iteration; caller limits bound variables, rules and rounds.
A round scans the rules, and the final no-change scan counts toward the limit.
Budget exhaustion refuses the claim. There is no partial verified answer.

`VerifiedGraph::replace_input` binds a replacement to the retained old input and
sequence. An improvement reuses the retained least solution; a retraction restarts
from zero. Graph shape and rules remain owned and immutable. Claim, stale-state,
shape and budget failures leave all retained state unchanged.

The existing authenticated tree reader now propagates pointwise improvement
deltas into authenticated old parents. Arbitrary increases and mixed changes
retain full affected-path recomposition. Sibling authentication, root and sequence
checks, admitted-leaf binding, schema-one bytes, matrix layout and deferred commit
remain intact. Even a no-op still authenticates its entire path.

## Corrections to the motivating reading

The C1152 report correctly found a concrete matrix verifier, not an already
implemented generic interface. C1160 supplies the scalar interface and generic
graph checker; it does not merely add metadata to a pre-existing trait.

Two shortcuts in `2026-09-12-relationalai-datalog-reading.md` §§3.1–3.2 do not
survive implementation literally:

1. Scalar min-plus is 0-stable because `min(0,u)=0`; its 4×4 matrix algebra is
   not 0-stable. The identity plus a finite off-diagonal edge differs from the
   identity. Any N-step bound must count scalar variables, including matrix
   coordinates, rather than blindly counting matrix-valued nodes.
2. Arbitrary leaf replacement is broader than comparison-minus propagation.
   Cost increases, deletions and mixed matrix changes must not disappear as
   empty deltas. In a cyclic graph, retractions can leave unsupported values
   self-sustaining, so replay from zero is the conservative implemented boundary.

These are task-owned corrections, not incidental discovery-track entries.

## Validation

Scoped Nix gates pass: `cargo fmt --all --check`, `cargo test -p ergodis-verify`,
and `cargo clippy -p ergodis-verify --all-targets --all-features -- -D warnings`.
The test result is four unit tests, five integration tests and four doctests.
The integration suite includes:

- Law and codec checks for both algebras, including near-saturation values and
  noncanonical Boolean rejection.
- All 256 two-variable Boolean rule subsets, all four input assignments, and
  both possible single-input flips: 1,024 snapshots and 2,048 replacements,
  compared with independent full polynomial iteration.
- 160 deterministic min-plus DAG/cyclic graphs and eight replacements each:
  1,280 successful updates plus 1,280 rejected forged outputs. The committed
  Python oracle uses synchronous full iteration and unbounded integer addition
  followed by explicit saturation; it shares no Rust delta implementation.
- 1,152 authenticated tree replacements covering all four leaf positions,
  improvement, increase, mixed and no-op updates. Full scalar-u64 matrix
  recomputation constructs the reference snapshots. Forged sibling summaries,
  forged new roots and replayed deltas are rejected.
- Unsupported zero-cost cycles, nonlinear same-variable products, malformed
  indices and lengths, stale sequences, and transactional budget exhaustion.

Replay from the core checkout:

```sh
nix shell nixpkgs#cargo nixpkgs#rustc nixpkgs#rustfmt nixpkgs#clippy nixpkgs#python3 -c sh -c 'cargo fmt --all --check && cargo test -p ergodis-verify && cargo clippy -p ergodis-verify --all-targets --all-features -- -D warnings'
```

The broader native gate also passes on the committed implementation:
`cargo fmt --check`, `cargo clippy --all-targets --all-features -- -D warnings`,
and `cargo test --all-features -- --test-threads=4`, with eight build jobs and
four Rayon workers in the same Nix environment: 54 suites, 895 passed, zero
failed, two ignored. Existing Python fixture tests include
`checked_in_python_oracle_agrees_with_rust_metrics_and_witnesses` and
`generated_spans_match_python_costs_and_supports`; both pass, as does the new
live Python graph oracle. The full run took about two minutes; this is validation
duration, not a performance comparison.

`nix shell nixpkgs#cargo nixpkgs#rustc -c cargo check -p ergodis-verify
--target wasm32-unknown-unknown` passes. This establishes library compilation,
not a browser binding or executed browser graph certificate. Cache GC dry-run
completed successfully without deleting anything.

Both the scoped native gate and the WASM `cargo check` above passed at commit
`6284ca7`. Durable replay authority is the committed test/oracle source and the
commands above, not any ephemeral local log.
No solver hot loop, worker communication or hot solver layout changed; no timing
or speedup claim is made. The new graph API is cold, serial verification.

## ej + tt closeout / Mystery ledger

After the scoped acceptance gate, and refreshed after the full native gate, the
explicit ej+tt pass asked which assumptions
would fail first when the next task lowers a recursive program. The cheap upgrades
already incorporated are the executable matrix counterexample, cycle-retraction
rejection, nonlinear cross-term control and transactional budget-exhaustion test.

| Question | Settled? | Evidence gap or owner |
|---|---|---|
| Does scalar 0-stability extend unchanged to matrix nodes? | No; settled counterexample | Matrix coordinate count must be explicit in C1163's contract |
| Can comparison minus represent arbitrary replacements? | No; settled | Improvement propagation and retraction restart are separate tested paths |
| Is an arbitrary cyclic fixed point enough? | No; settled | Replay from zero rejects unsupported cycles |
| Can both changing factors lose their joint contribution? | Settled | Full cross term and independent generated oracles agree |
| Does the saturating carrier recover unbounded path meaning? | No; unchanged limitation | Exact total costs must stay below u32::MAX; sentinel redesign remains C1155 |
| Can a stored graph be trusted as a portable certificate? | Not implemented here | C1163 owns source/IR binding, serialization, ABI, convergence contract and first end-to-end program |
| Is this already recursive runtime execution? | No | C1161 owns runtime integration and its performance/admission gates |

No additional unexplained phenomenon emerged. Discovery discriminator reviewed;
no incidental entry was warranted. There was no Lean work or new literature claim.

## Process note

The initial full-handoff display exceeded the output bound and was truncated;
it was recovered using bounded chunks. An early filename query used a root scope
despite known narrower directories; subsequent searches used explicit subtrees.
The first compile exposed a duplicate test-module name, corrected before rerun.
These are command/implementation corrections, not unresolved validation failures.

## Next

C1163: define the IR-agnostic rule/fixpoint/certificate contract and lower one
recursive min-plus program through the existing portable boundary. Use the scalar
variable count and separate source interpretation, algebra admission, least-summary
replay and external optimality. Runtime and join-engine work retain the programme
ordering; no new ID or public export is allocated here.
