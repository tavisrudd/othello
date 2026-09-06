# Ergodis discovery track

Append-only companion for incidental observations and musings encountered in the `ergodis` lane
(the compiled exact-optimization engine and its benchmark, tooling, capability, and paper work).
Planned engine, benchmark, tooling, and manuscript work belongs in the task reports and lane handoff
instead — the admission test is whether the observation was actually being looked for.

Pre-split Ergodis incidental entries from before 2026-09-05 remain in the historical
[complete-ports discovery track](complete-ports-discovery-track.md) at their original dates; they
are not copied here.

## 2026-09-06 — greedy structure of the coalition-to-leakage-space map (C1070 probe 1)

**Provenance**: noticed while proving the contextual-quotient section of
`2026-09-06-c1070-probe1-mask-quotiented-associativity.md`; not sought.
**Observation**: the map from a coalition `H` to its leakage space `L_H = {uᵀA : uᵀB_H = 0}` might
carry matroid or submodularity structure. If it does, the minimization over `t`-dimensional secret
subspaces in the `t`-symbol leakage profile could go greedy instead of enumerating a
Gaussian-binomial number of subspaces (probe 5 currently enumerates).
**Why it may matter**: it is the difference between a compiled leakage profile and a per-subspace
query. **Evidence level**: musing, no computation. Probe 2 of C1070 is the natural owner if it
becomes work.

## 2026-09-06 — the coupled-but-additive proportion of subspace pairs looks pinned (C1070 probe 6)

**Provenance**: the exhaustive additivity sweep of
`2026-09-06-c1070-probe6-transcript-state.md` §6.4, run to check that zero mask coupling forces
additive leakage. **Was I looking for this?**: no — the sweep's purpose was the decoupled direction;
the coupled column was recorded only to show the alarm is one-sided.
**Observed**: among pairs of subspaces of `(S ⊕ R)*` whose mask blocks intersect nontrivially, the
fraction whose leakage is nevertheless additive is `0.53, 0.53, 0.53, 0.52` in the four larger
ambients checked (`q=2` with `k=m=2`; `q=3` with `(k,m) = (2,1)` and `(1,2)`; `q=5` with `k=m=1`)
and rises to `0.68` and `0.73` in the two smallest `F_2` ambients.
**Why it may matter / strongest question**: is there a limiting proportion, and is it a
Gaussian-binomial ratio? The quantity is the false-alarm rate of the mask-reuse test, so a closed
form would let an interface state the test's precision rather than only its soundness.
**Evidence**: CHECKED on six ambient spaces with `k+m ≤ 4`, `q ∈ {2,3,5}`; certificate
`notes/data/2026-09-06-c1070-probe6/transcript-leakage.report.json`.
**Status**: open lead. It is subspace counting, not privacy; no C-ID allocated.
