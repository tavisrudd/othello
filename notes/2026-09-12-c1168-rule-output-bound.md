# C1168 — rule-output-sensitive convergence

**Lane**: `ergodis`
**Date**: 2026-09-12
**Status**: COMPLETE. Proof and usage documentation `0fcf576af`.

Prove fixedness within `min N (M + 1)` for the existing bounded min-plus program,
where N counts scalar coordinates and M counts distinct rule outputs. The first
round loads facts; every later improvement must occur at a rule output. Preserve
the universal sharp N theorem, certificate schema and existing runtime behavior.

Add the tighter semantic certificate and a conversion of a checked incremental
result using that bound. Validate zero coordinates, no-rule programs, the sharp
chain family and the existing relational distance programs. Rebuild affected
owned Lean gates and audit the new terminals. Earlier paired measurements remain
pinned to their recorded source revision; no new timing claim is inferred.

## Results

`lean/WeightedRules/OutputConvergence.lean` defines `ruleOutputs` as a finite
set, so repeated rules count once, and `ruleOutputBound` as the capped bound.
`boundedMinPlus_rule_output_fixed` proves universal fixedness and
`boundedMinPlus_rule_output_least` proves leastness. The original sharp
scalar-count theorem remains available with the same public statement.

The proof exposes the improving-factor witness already used by scalar
convergence, now retaining membership of the improved coordinate in the rule
outputs. An improvement after round k+1 requires k+1 distinct output
coordinates. More such coordinates than the output set contains is impossible.
The scalar theorem supplies the cap; no acyclicity or cost-size hypothesis is
added, and saturation and repeated factors retain their existing semantics.

`OutputConvergenceReflection.lean` proves equality with the scalar-count
iterate. `ruleOutputCheckedSolution` constructs an existing-format certificate,
and `CheckedSolution.withRuleOutputBound` preserves a checked valuation while
changing its logical round bound by proof. An incremental result exposes this
conversion through `CheckedImprovement.toRuleOutputSolution`.
`iterateFrom_rule_output_bound` and
`improved_iterateFrom_rule_output_bound` additionally prove that the same
structural bound suffices for replay from a safe seed or an old least solution
after an admitted fact improvement. They reuse the existing sandwich proof.

The four-vertex distance programmes have bounds 5 instead of 21, and the
six-vertex chain has bound 7 instead of 43. These are structural upper bounds,
not the first fixed rounds: the old chain witness stops after six from-zero
rounds, and the improved four-vertex witness uses three incremental steps.
Its optional converted certificate has round count five and identical values.
No checker admission, provider implementation or runtime policy changes.

## Validation

The generic bound and reflective conversion pass guarded single-file checks.
Affected aggregate `run-20260913-044758-8bff0465` passes all four targets:
`WeightedRules.OutputConvergenceAxiomAudit`,
`WeightedRules.ConvergenceAxiomAudit`, `WeightedRules.OracleAxiomAudit` and
`WeightedRules.IncrementalAxiomAudit`. This rebuilds the actual native oracle
examples and their rejection controls against the changed convergence proof.

Final strengthened sharpness/safe-seed gate:
`run-20260913-045504-2ea04217`, targets
`WeightedRules.OutputConvergenceAxiomAudit` and
`WeightedRules.ConvergenceAxiomAudit`. Exact eighteen-terminal audit coverage
was checked against the retained stdout. Every terminal uses only subsets of
propext, Classical.choice and Quot.sound; the two exposed improvement helpers
use only propext and Quot.sound. There is no sorry, native-decision or external
process axiom. Every new module and both touched proof modules were reviewed;
the staged diff passes whitespace checks.
The required Ergodis cache-GC dry run passes (89 entries scanned); no cache
entry is deleted, and the retained paired evidence remains available.

The new controls cover empty and no-rule programs, symbolic sharpness of the
capped bound for every positive scalar count, concrete distance bounds and
value-preserving conversion of a live external witness. A post-gate control
has one immutable zero fact and one rule output: it changes between rounds one
and two, proving that counting only outputs can omit a necessary loading round.
`OutputConvergenceSharpness.lean` strengthens this control to every natural M:
`outputChain_output_count` proves exactly M outputs, `outputChain_bound` gives
bound M+1, and `outputChain_requires_extra_round` proves a change between rounds
M and M+1. Its symbolic iterate formula has no enumerated size cutoff.

## Mystery ledger — ej + tt

- Settled: immutable input coordinates need not inflate the output count.
  The proof tracks outputs after the first round, rather than counting every
  coordinate as in the original argument.
- Settled: the extra round cannot simply be removed. Beyond the one-output
  control, the new symbolic family requires M+1 rounds for every M, including
  M=0. The existing chain family separately proves sharpness of the scalar cap
  for all positive sizes. The post-gate pass promoted this general statement
  instead of relying only on a finite control.
- Settled: safe-seed replay inherits the structural bound by sandwiching it
  between from-zero iteration and the new least solution. An arbitrary
  unsupported fixed seed still has no such guarantee.
- Boundary: a structural upper bound need not be the minimal stopping round
  of an individual program. Replacing an already early certificate's count
  can increase it; incremental work counts remain separate.
- Boundary: the C1167 paired checking measurement remains pinned to monorepo
  `7798d342d` and private evidence `57a4eb9`. This proof refactor changes a
  hashed input; no timings for the current revision are inferred or substituted.
- No unresolved mathematical mystery remains in this statement. These were
  task-directed questions, so no incidental discovery-track entry is added.
  The next programme gate remains a concrete external IR obligation/workload.
