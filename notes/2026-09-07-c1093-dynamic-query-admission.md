# C1093 — Admission for existing dynamic query capabilities

**Lane:** ergodis. **Date:** 2026-09-07. **Status:** complete bounded admission slice.

This slice follows C1092 by adding a real cold private adapter around `parametric_lrc::LrcTransfer`.
It binds one immutable `RepairModel` to a `RepairPlan`, admits representable budget top-ups, and
returns a borrowed `BudgetQuery`. Count, threshold and witness readouts share that admitted question.
No caller can substitute an unrelated capacity vector during witness reconstruction. Overflow is an
admission error rather than a silently saturated change in query meaning.

The model is the existing fixed Azure LRC(12,2,2) counted-repair interpretation, not arbitrary code
recovery. Its demand is u32 to give the same admitted range on native64 and wasm32. The adapter is
cold orchestration-free library code; original kernels, transfers and hot layouts remain unchanged.
It carries no independent optimality certificate and is not yet a public universal schema.

Owned private code: `src/parametric_lrc_contract.rs`, one export line in `src/lib.rs`,
`tests/semantic_contract_lrc.rs`, `tests/semantic_contract_updates.rs`. The update test exercises
existing classification, not a new event engine. It also executes C1092's saturation counterexample
so unrestricted DeltaRun folding cannot silently become a core assumption.

## Existing abstraction and certificate audit

Terra reviewed `open_problem.rs` and `generic_certificate.rs`. The reusable composition core is
context-bearing `OpenProblem` with optional normalization, tensor and reconstruction capabilities.
Its `RetainedTree` is flat and iterative. Four existing adapters cover matrix, function, monoid index
and semiring-window summaries. Extraction should retain their specialized paths and law suites.

Admission must precede exposure: tree constructors use assertions, mutation has debug-only index
checks, table constructors trust sizes/states, and summary fields can bypass domain validation.
Associativity, canonical codec semantics and complete artifact interpretation are trait obligations,
not consequences of implementing a trait. These APIs are experimental building blocks, not yet
validated untrusted-input boundaries.

Generic delta evidence establishes summary transition and recomposition. Domain-event → leaf-summary
correctness is separate. Table build checking rehashes supplied cells; it proves commitment identity,
not that those cells implement the source model. A future source-derived table checker must bind
model/query/contract and reconstruct or verify the semantic lowering. Keep these obligations
separate when moving verification out of the private experimental module.

## Next extraction gate

Use the new admitted budget queries plus the earlier domain examples to introduce a narrow shared
cold identity/admission vocabulary. Adapt existing OpenProblem implementations through validated,
fallible constructors with checked size limits. Only then promote the generic composition boundary.
The generic receipt needs a separate leaf-transition checking seam before it can support source-level
claims. Avoid serializing unchecked internal state or putting runtime/session concepts in these traits.

## Executable checks

The LRC test compares 64 generated models × 16 budgets (1,024 admitted queries) with the existing
counted kernel, including counts, mode witnesses and resource loads. Threshold readouts are checked
at the attained count and one above. Separate cases exercise both parity-domain overflow paths and
immutable old/new design plans. This is finite differential evidence, not a universal proof.

The retained-update test checks demand update versus fresh recomposition, rebase/out-of-range
nonmutation, and the actual i32-saturation counterexample. The previous six QEC/causal/privacy
contract tests remain in the same validation run. All 11 passed. The saturation test documents a
known limitation; it is not a repair or permission to admit arbitrary batches.

Also corrected comments in `generic_certificate::TableCommitment` and `verify_build` to state
commitment identity accurately. Implementation and wire format are unchanged.

Commands (private workspace, via run-quiet):

```sh
nix shell nixpkgs#cargo nixpkgs#rustc --command cargo test -p ergodis-private \
  --test semantic_contract_lrc --test semantic_contract_updates \
  --test semantic_contract_privacy --test semantic_contract_causal --test semantic_contract_qec
nix shell nixpkgs#cargo nixpkgs#rustc nixpkgs#clippy --command cargo clippy -p ergodis-private \
  --test semantic_contract_lrc --test semantic_contract_updates \
  --test semantic_contract_privacy --test semantic_contract_causal --test semantic_contract_qec -- -D warnings
```

Test log: `/tmp/claude-run-quiet/20260907-111233-nix-shell-nixpkgscargo-nixpkgsrustc-command-cargo-test-p-ergodis-private-test-sem`.
Scoped rustfmt and whitespace checks pass. No production kernel changed, so no performance claim
or hot-path A/B is made. The private crate still requires its existing native dependency closure;
this adapter has a wasm32-compatible input range but no new WASM binding/build is claimed.

Scoped clippy passed; Luna found no material issue in the cold admission adapter and LRC tests.
Private implementation commit: `c66e4a6`. Clippy log:
`/tmp/claude-run-quiet/20260907-111345-nix-shell-nixpkgscargo-nixpkgsrustc-nixpkgsclippy-command-cargo-clippy-p-ergodis-`.
Cache GC was dry-run only. No incidental discovery-track item: the admission/evidence findings were
part of the requested audit. Remaining limitations are the explicit promotion gates above.
