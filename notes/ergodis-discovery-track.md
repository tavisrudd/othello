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
