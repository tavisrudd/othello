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

## 2026-09-12 — Cai–Fürer–Immerman structures as an adversarial control for learned local repair (C1150)

**Provenance**: Abramsky, Dawar and Wang, arXiv:1704.05124 §8 (partial read, recorded in
`2026-09-12-c1150-part-b-compilers-solvers-normalization.md` §2.2); met while surveying game
comonads for solver structure. **Was I looking for this?**: no — the sweep sought categorical
solver formulations, not counterexample families.
**Observation**: CFI structures defeat `k`-local consistency for every fixed `k` yet are solvable by
Gaussian elimination. Ergodis's search space is GF(2) structure, so any learned local repair or
kick rule in Evolve can look saturated on a CFI instance and be wrong.
**Why it may matter**: a ready-made negative control for Evolve's local-rule discovery. **Evidence
level**: literature statement, no Ergodis experiment. No C-ID allocated.

## 2026-09-12 — interval and polynomial interpretations of the same FeatureDag term (C1150)

**Provenance**: Elliott, *Compiling to Categories*, §7.7 and §7.8 (full text, recorded in the C1150
part B dossier §1.1). **Was I looking for this?**: no — the read was for functorial compilation.
**Observation**: a Cartesian term admits a drop-in interval interpretation (static overflow bounds)
and, on the add/mul fragment, a polynomial interpretation with exact root and extremum analysis.
The FeatureDag modulus, abs and norm nodes leave the polynomial fragment.
**Why it may matter**: checked arithmetic already needs to know whether a subterm can overflow;
interval analysis answers that statically. **Evidence level**: musing. No C-ID allocated.

## 2026-09-12 — trace structure and the chase as e-graph relatives (C1150)

**Provenance**: Tiurin et al. arXiv:2406.15882 §VII and Suciu, Wang and Zhang arXiv:2501.02413
§1/§4 (both partial, C1150 part B dossier §1.2). **Was I looking for this?**: no.
**Observation**: trace structure encodes infinite equivalence classes finitely in e-graphs;
equality saturation and the database chase are the same procedure up to encoding.
**Why it may matter**: an Ergodis representation wanting "equivalent for all n" rather than
"equivalent up to the node bound", or incremental recomputation borrowed from the chase side.
**Evidence level**: literature statement. No C-ID allocated.
