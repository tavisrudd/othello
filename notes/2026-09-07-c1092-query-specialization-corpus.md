# C1092 — Query specialization and semantic contract examples

**Lane:** ergodis. **Date:** 2026-09-07. **Status:** complete initial slice; production extraction follows.

Motivation: one model can support different query-specific compilation, representation and evidence.
Evolve can explore questions and underlying designs as well as implementation strategies. The
accepted motivation is recorded in the final section of
[the core semantic plan](2026-09-07-c1091-core-semantic-contracts.md).

This first slice adds private integration examples using existing implementations and test-local
cold contracts. It does not freeze a public schema, add a crate or modify solve kernels. The examples
must show both supported reuse and rejection of a stronger query or changed model. Production
adapters, common core extraction and general exploration APIs remain subsequent work.

Owned private paths: `tests/semantic_contract_privacy.rs`, `tests/semantic_contract_causal.rs`,
`tests/semantic_contract_qec.rs`. Parent owns validation; Terra agents own the causal and QEC files.

## Observables, objectives and protocols

The user's quantum-observable analogy sharpens three separate terms: an observable says what can
be read out of a model; an objective says what is preferred; an observation protocol says what can
be learned, when, and used for which decision. Representations equivalent for one observable may
be distinguishable for another. This is a semantic analogy, not an assumption of a quantum algebra
for every domain. In QEC, actual logical observables retain their domain-specific meaning.

Question design is itself an Evolve search target. It can select targets, experiments, observations,
guarantee levels and scenario classes within an explicit evaluation contract. Source-design search
changes the underlying system. Neither should be conflated with choosing a faster strategy for an
unchanged question. Candidate comparisons must expose changes in meaning as well as cost.

## Implemented examples

- Privacy: one shared-mask transcript supports a dimension readout and a stronger target-functional
  readout. The scalar plan rejects the latter. All four GF(2) targets are compared against a
  physical-assignment indistinguishability oracle. A revised fresh-mask design requires a new
  model admission and changes leakage from one dimension to zero. Re-declaring a used mask as
  fresh is rejected. Borrowed model identity is intentionally test-local, not a durable ID scheme.
- Causal: one supplied four-context SCM supports an admitted quotient query, a direct false answer
  outside the declared quotient action vocabulary, and a valid conditional question with zero
  evidence mass. Unsupported, false and undefined remain distinct. A separate four-row reference
  checks the positive and false cases; zero mass uses valid values with zero-weight contexts.
- QEC: one existing repetition-code graph supports minimum-weight correction and separately
  requested logical-class costs, checked against exhaustive mechanism subsets. A planted logical
  history is not identified by a minimum-weight correction observable. A separate margin query
  checks the audit's bounded coverage rather than conferring universal certification on the decoder.

These use the existing production APIs; the only new executable code is integration tests. They
are initial contract examples, not implementations of automatic question search, general model
identity, shared-plan caching or a production admission API. Public extraction should now compare
what the examples actually need rather than promote their test-local wrappers wholesale.

## Incremental history recovered after user steering

The post-C985 C1061 thread already contains substantial implementation, not just future proposals:

- [Probe 1: composition and deltas](2026-09-03-c1061-probe1-composition-survey-and-delta-prototype.md).
- [Probe 2: real-kernel witness deltas](2026-09-03-c1061-probe2-real-kernel-witness-deltas.md).
- [Probe 3: incremental certificates](2026-09-03-c1061-probe3-incremental-certificates.md).
- [Probe 15: incremental top-k and tie-closed state](2026-09-03-c1061-probe15-incremental-topk-and-tie-closed-state.md).

Probe 3 describes authenticated snapshot/delta chains with artifact identity, prior root and sequence,
recomputation along the affected min-plus composition path, tamper/stale rejection and snapshot
replay. Its guarantee is relative to the compiled leaf semantics and composition law, not a universal
source-model correctness proof. It lives in private code; it has not yet been migrated into the
independent verifier crate introduced by C1086.

The report's collapsed-run operation preserves the final node digest and optimum while the certificate
sequence counts batches rather than original events. The omitted individual events are not recoverable
from the collapsed chain. This is a direct existing example of **query-specific evidence retention**:
final-result preservation does not establish every intermediate decision or trace observation.

Probe 15 replaces repeated tree aggregation with a fixed-profile incremental top-k policy in its
admitted fleet family. It also corrects probe 12's benchmark conclusion after removing update-dependent
setup cost from the harness. Carry that correction forward; do not reuse the older headline. No
historical timing measurement was rerun for C1092.

Consequence for core design: distinguish query-parameter changes, admitted model-state transitions,
source-family edits and observation-contract changes. An event needs a typed interpretation, affected
dependencies, validity conditions and an evidence-update rule. Mathematical event sequencing and
session request IDs are different concepts; neither should leak into solve records. Reuse these
existing implementations behind adapters before designing a generic event engine from scratch.

### Source audit and promotion gates

Terra recovered `src/lrc_delta_binding.rs`: `FleetSchema::affected` classifies capacity,
availability and demand changes as leaf-local `Parametric`, budget-grain/pod-count edits as
`RebaseRequired`, and bad coordinates as `OutOfRange`. `FleetTree::apply_event` applies only
admitted changes; snapshot rebinding merges ancestor frontiers. Its `LeafClassKey` relies on
capacity–demand multiplicity symmetry, not arbitrary sorting of capacities. This is the first
update adapter to exercise after the static query examples.

The generic `delta_composition::DeltaRun` is not ready for unrestricted external admission.
`absorb` enforces same-leaf ownership only with `debug_assert_eq!`; `act` clamps the aggregate
bump before saturating addition. Stepwise saturation is not equivalent to unrestricted additive
folding: starting at i32::MAX, bumps +1 then -1 end at MAX-1, whereas folding to zero ends at MAX.
The existing bounded event corpus does not establish that unrestricted law. This source-level
counterexample was not executed or patched here. Promotion requires a checked numeric/update
contract or a separately validated fix under the hot-path performance gates. Do not advertise
arbitrary event-run equivalence from the historical prose.

## Validation and disposition

Complete as the initial executable corpus and historical update-contract audit. Private commit
`4841e23`; no production code or Cargo dependencies changed. Six integration tests passed:

```sh
nix shell nixpkgs#cargo nixpkgs#rustc --command cargo test -p ergodis-private \
  --test semantic_contract_privacy --test semantic_contract_causal --test semantic_contract_qec
nix shell nixpkgs#cargo nixpkgs#rustc nixpkgs#clippy --command cargo clippy -p ergodis-private \
  --test semantic_contract_privacy --test semantic_contract_causal --test semantic_contract_qec -- -D warnings
nix shell nixpkgs#rustfmt --command rustfmt --edition 2021 --check \
  tests/semantic_contract_privacy.rs tests/semantic_contract_causal.rs tests/semantic_contract_qec.rs
```

All passed. Test log: `/tmp/claude-run-quiet/20260907-110405-nix-shell-nixpkgscargo-nixpkgsrustc-command-cargo-test-p-ergodis-private-test-sem`;
clippy log: `/tmp/claude-run-quiet/20260907-110518-nix-shell-nixpkgscargo-nixpkgsrustc-nixpkgsclippy-command-cargo-clippy-p-ergodis-`.
An initial run-quiet invocation failed argument parsing before launching cargo; corrected to its
single-command-string interface. Luna reviewed the three examples for material semantic gaps;
no additional material issue found. No benchmark or full private regression suite was rerun:
this slice changes only independent integration test targets. Native64 hot layouts remain untouched.

Next: exercise the existing recovery pilot plus LRC event classification through cold admitted
contracts, including parameter update versus rebase, and extract the smallest shared core types.
Require release-safe batch preconditions before promoting generic incremental machinery. Extend
question/design exploration examples with explicit allowed changes and comparable evaluation
criteria; automatic search remains future implementation.

## Monoid search: September 2–7 reports

User-directed search for `monoid` in dated reports found 23 Ergodis-related notes at the search
snapshot, excluding verbatim brainstorms and append-only archives. The key additional predecessors:

- [Probe 4: sufficient statistics closed under the update monoid](2026-09-03-c1061-probe4-evolve-sufficient-statistics.md)
  connects back to the C985 adaptive-search ADR. It implements a scorer separating observed
  exactness, transition closure and exactness on reachable closure. Corpus-only success admits
  decoys; its experimental result is not proof authority. Reuse the counterexample categories.
- [Probe 7: other domains and shapes](2026-09-03-c1061-probe7-other-domains-and-shapes.md)
  distinguishes matrix/semiring summaries from automaton transition functions and transition-monoid
  indices. Event algebra differs between toggles, resets and symbol replacement.
- [Probe 8: monoidal collapse inside kernels](2026-09-03-c1061-probe8-monoidal-collapse-inside-kernels.md)
  supplies `parametric_lrc::LrcTransfer`: compile a threshold once and read out a whole budget
  family, with witness reconstruction separately costed. This is an existing example of the
  same-model/multiple-query motivation, and should be a primary adapter target.
- [Probe 16: empirical trait check](2026-09-03-c1061-probe16-adr-question1-trait-check.md)
  tests a small composition interface with separate normalization, tensor and reconstruction
  capabilities. Composition needs the compiled problem context: a monoid element ID means nothing
  without its table. Owned-summary allocation and fused-leaf evaluation were material constraints.
- [Probe 17: sparsity and routing](2026-09-03-c1061-probe17-sparsity-aware-composition-and-routing.md)
  records corrected budget-pruning admission and historical benchmark corrections. A surviving
  partial cost alone cannot establish an exact total-cost argmin. Preserve the total-cost gate.

The private predecessor `docs/adr/0001-generic-dynamic-decision-layer.md` remains labelled proposed;
its later sections 9 and 10 describe implemented `open_problem` and `generic_certificate` experiments.
Do not restart this design from an empty trait. In particular:

1. Reuse the small context-bearing composition abstraction; normalization, reconstruction and
   tensoring remain capabilities of specific instantiations. A monoid index does not retain the
   generating trace. Shape-changing products require an explicit output signature.
2. The generic certificate proves that changed summaries recompose to the new root. It does not
   establish that the domain event implies the supplied new leaf summary; that requires separate
   leaf evidence. A table inclusion proof establishes membership in the committed table, not
   semantic correctness of the table. Rehashing all cells establishes commitment consistency only.
3. The ADR also adds `CertifiableProblem` and table-transition certificates. Consolidate those
   obligations into the independent-checker plan rather than assuming only the earlier specialized
   certificate exists. Historical timing and allocation gaps require current validation before
   promotion; the broad abstraction is not automatically free in every implementation.
4. Event classification is representation-relative. The older binding requires rebase for a budget
   grain change; richer budget profiles can admit it. Space-axis QEC explores regrowth when topology
   changes without changing the boundary algebra. Use update contracts rather than a global table
   declaring every event permanently incremental or structural.

This changes the successor emphasis: **audit and adapt existing OpenProblem, parametric readouts,
update classifications and generic evidence first**, then extract common core interfaces together
with the new query contracts. The six new tests remain useful semantic discriminators; they are not
substitutes for the substantial existing implementations.

Read-shaping correction: an attempted whole-ADR display exceeded the 10,000-token output rule and
was truncated. It was replaced by a heading index and bounded reads of sections 9.1–9.2, 10.1–10.2
and 10.4. This task does not claim a fresh complete read of every ADR section or a full source audit
of every listed module.
