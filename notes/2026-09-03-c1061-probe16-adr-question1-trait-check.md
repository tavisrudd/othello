# C1061 probe 16: empirical check of ADR question 1

**Lane**: `complete-ports`
**Date**: 2026-09-03
**Artifact**: ADR section 9 (ergodis-private code `041e198`, ADR `1cd8960`)
**Verdict**: **trait holds as a four-method core plus three capability traits; dedupe deferred**

Empirical check of ADR question 1 (one trait for matrix, function, monoid-index, and
semiring-window summaries). The core (`identity`, `compose_into`, `optimum`, width) instantiates
for all four, but only when composition takes the compiled problem as `&self` (a monoid index is
meaningless without its Cayley table). `quotient` splits off as `NormalizedProblem` (2 of 4; the
semiring window only at MinPlus), `tensor` as `TensorProblem` (1 of 4; automata tensor into a
product automaton so the summary type changes), `reconstruct` as `ReconstructProblem` (2 of 4; a
monoid index names the composed function, not the trace, probe 12's boundary from the other side).

At equal work the abstraction is free: the width-8 window arm (the only like-for-like) is 0.988x
instructions (CI tight); the min-plus arm's 1.129x gap is leaf-evaluation fusion, not dispatch, so
extraction needs a `set_leaf_from_parameters` hook. Defect caught in the generic tree: storing
summaries by value and cloning to recompose allocated per node per update (8,380 vs 2,895
instructions on the function arm); composing in place via `split_at_mut` removed it, and the
zero-allocation regression now covers Copy and owned summaries.

Dedupe not done: every file it touches is owned by an active probe; section 9.5 lists the exact
hooks per module, including the per-leaf summary accessor `delta_composition` still lacks.
Methodology: below about a thousand instructions per op, cycle differencing goes negative on this
box; only instructions carry a verdict there.
