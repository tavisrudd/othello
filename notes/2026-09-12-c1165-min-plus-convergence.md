# C1165 — bounded min-plus convergence

**Lane**: `ergodis`
**Date**: 2026-09-12
**Status**: IN PROGRESS.

The existing runtime enforces a scalar N-round bound. Its Lean companion proves
leastness of accepted finite certificates but has no universal theorem that
every bounded nonnegative min-plus program reaches a fixed point within N rounds.
This task closes that proof gap in the existing contract, without changing its
runtime, certificate format, toolchain or validation authority.

Target: for every `P : WeightedRules.Program WeightedRules.Cost n`, prove
`step boundedMinPlus P (iterate boundedMinPlus P n) = iterate boundedMinPlus P n`,
and connect the theorem to leastness and certificate existence. Include the
empty scalar type, cycles, nonlinear repeated factors and saturation.

Proof route: finite derivations; pruning a repeated coordinate along a branch
cannot increase a nonnegative cost, leaving branch length at most the scalar
count. Validate with guarded Lean builds, an axiom audit and concrete controls.
If proof engineering exposes a different useful route, retain the same statement.

Owned paths: new convergence modules under `lean/WeightedRules/`, this report,
the rule-contract programme map, selected handoff and exact task lifecycle rows.
Join/benchmark allocation remains gated on the concrete external workload.
