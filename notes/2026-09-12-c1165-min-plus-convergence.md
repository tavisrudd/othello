# C1165 — bounded min-plus convergence

**Lane**: `ergodis`
**Date**: 2026-09-12
**Status**: COMPLETE. Proof commit `e6ddc6e57`.

The existing runtime enforces a scalar N-round bound. Its Lean companion proves
leastness of accepted finite certificates but has no universal theorem that
every bounded nonnegative min-plus program reaches a fixed point within N rounds.
This task closes that proof gap in the existing contract, without changing its
runtime, certificate format, toolchain or validation authority.

Target: for every `P : WeightedRules.Program WeightedRules.Cost n`, prove
`step boundedMinPlus P (iterate boundedMinPlus P n) = iterate boundedMinPlus P n`,
and connect the theorem to leastness and certificate existence. Include the
empty scalar type, cycles, nonlinear repeated factors and saturation.

## Result and proof

`lean/WeightedRules/Convergence.lean` proves
`WeightedRules.boundedMinPlus_iterate_fixed` for every scalar count and supplied
program. `WeightedRules.boundedMinPlus_iterate_least` supplies leastness and
`WeightedRules.boundedMinPlus_iterate_add` proves stability at every later round.
`WeightedRules.boundedMinPlusCertificate` constructs the semantic certificate.

The proof avoids explicit derivation trees. A strict improvement in round k+1
comes from a product factor that improved in round k and has no greater cost.
Induction collects k coordinates whose costs are at most that factor's cost.
The new output cannot be among them: its previous cost is strictly greater.
Thus an improvement in round k requires k distinct coordinates. This is exposed
as `WeightedRules.boundedMinPlus_improvement_round_le`; applying the cardinality
bound excludes improvement after round N. Saturated nonnegative addition is
monotone and no smaller than either factor, which is all this counting step uses.

`lean/WeightedRules/ConvergenceReflection.lean` proves
`WeightedRules.checkCertificate_complete`: the exact list of all coordinates at
round N passes the existing checker, including length, replay and fixedness.
`WeightedRules.iteratedCheckedSolution` constructs that checked result, and
`WeightedRules.CheckedSolution.eq_iterate` identifies every accepted certificate
with the N-round result, including certificates accepted at earlier rounds.

`lean/WeightedRules/ConvergenceSharpness.lean` defines a zero-cost predecessor
chain using the actual binary-rule syntax, with repeated factors.
`WeightedRules.zeroChain_iterate` characterizes every iterate, and
`WeightedRules.zeroChain_requires_scalar_rounds` proves that every positive N
admits a program changing between rounds N−1 and N. The bound is sharp uniformly.

## Validation and trust

Guarded single-file elaboration and queue builds pass. Final aggregate audit:
`run-20260913-031828-87150a8d`, `WeightedRules.ConvergenceAxiomAudit`; dependencies
built in `run-20260913-031643-b1e3c576`. Individual module builds take about
1.8–2.4 seconds and under 900 MiB peak in these runs; these are build observations,
not a solver performance comparison.

The exact twelve-terminal axiom audit reports only `propext`, `Classical.choice`
and `Quot.sound`. Empty-certificate, repeated-factor and saturation controls use
only `propext` and `Quot.sound`. No admitted, native-decision or foreign-process
axiom appears. `lean/WeightedRules/ConvergenceChecks.lean` uses kernel reduction
to check empty input, an unsupported cyclic zero fixed point that replay rejects,
full-round chain propagation, and overflow saturation versus rejected wrapping.
The five new modules were reviewed in full for statement/prose agreement and
scholarly-public docstrings. No runtime or external provider is changed.

## Mystery ledger — ej + tt

The post-gate pass checked whether the convergence statement hides a stronger
claim than the proof, whether the round count can be reduced uniformly, and
whether replay still distinguishes unsupported fixed points.

- Settled: N is sharp for every positive N, not just a few finite controls.
- Settled: the theorem includes zero coordinates, repeated factors, zero cycles
  and saturation. It does not require strictly positive costs or distinct factors.
- Settled: semantic certificate existence and uniqueness follow without changing
  the existing checker or trusting the external producer.
- Boundary: this does not prove Rust correctness, subprocess termination,
  source-to-formal-program correspondence or unbounded-integer optimality.
- No genuine mathematical mystery remains in the allocated statement. Tighter
  per-program structural bounds are outside it; they are not needed to justify N.
- No incidental discovery-track entry: these conclusions were sought within the
  proof task. The external workload gate remains unchanged.

Owned paths: new convergence modules under `lean/WeightedRules/`, this report,
the rule-contract programme map, selected handoff and exact task lifecycle rows.
Join/benchmark allocation remains gated on the concrete external workload.
