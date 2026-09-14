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

## 2026-09-12 — Macready's tensor-logic external syntax over a categorical IR (C1150/C1151 adjacent)

**Provenance**: Tavis's correspondence with William Macready, 2026-09-12, after Tavis forwarded the
Abbott–Zardini material. **Was I looking for this?**: no.
**Observation**: Macready is marrying Abbott's neural-circuit compilation to tensor logic
(https://tensor-logic.org, Domingos; einsum-syntax Datalog, a subset of RelationalAI's Datalog work)
as an external syntax, over a categorical foundation broader than Abbott's that represents
symmetries, generalized tensors, predicate logic and tensor networks.
**Why it may matter**: tensor logic programs are semiring Datalog, so they evaluate under the same
semiring-polymorphic machinery C1151 ranks (rows 2, 4, 7) and the chase/e-graph equivalence already
logged; his symmetry representation is adjacent to the C1153 group quotient. A tensor-logic front
end compiled to an Ergodis plan with exact semiring evaluation and a certificate would be a concrete
shared object. **Evidence level**: correspondence only; no source read. No C-ID allocated.

## 2026-09-12 — The order-2092 restart budget is sampler-bound, not search-bound (C1153 incidental)

**Provenance**: measured during the C1153 orbit-dedup A/B,
`notes/2026-09-12-c1153-group-quotient-spike.md` (campaign-default and short-epoch rounds,
`ergodis-private` commits `a9376d3`/`088bb27`). **Was I looking for this?**: no — the A/B was for
orbit dedup cost, and this fell out of running it at two epoch lengths.
**Observation**: cutting `order6 margin-tabu --epoch-steps` from 4,000 to 200 cut total tabu steps
by 95% and left the restart count essentially unchanged, about 78 restarts per twenty seconds on
four workers in both configurations. Each epoch therefore costs roughly 0.3 CPU-seconds almost
independently of how many tabu steps it runs.
**Why it may matter**: the cold outer-profile draw
(`sample_rotating_stratified_q29_outer_profile_seed`) rather than the full-neighbourhood step
dominates a short-epoch restart budget, so any campaign that wants many restarts is paying for the
sampler, and any per-restart filter is free by comparison. It also means an epoch-length sweep is
not the tuning knob it looks like below a few thousand steps.
**Evidence level**: two five-round interleaved A/B configurations at matched CPU budget, plus one
twelve-worker probe; the attribution to the sampler is by elimination, not by a profile. No C-ID
allocated.

## 2026-09-13 — Checked symmetries can quotient the certificate replay (C1176 incidental)

**Provenance**: fell out of C1176 decision D3, `notes/2026-09-13-c1176-contract-semantics.md`,
core `421aa78`. **Was I looking for this?**: no — the task was to spend the declarations as a
consistency check on the claim, not to accelerate anything.
**Observation**: once `verify` checks `values[i] == values[pi[i]]` for every declared
automorphism, the from-zero replay only has to establish the least solution on one coordinate
per orbit; the rest follows by invariance. The checker could replay the quotient system (orbits
as coordinates, products pushed forward) and extend, dividing replay cost by the mean orbit size.
**Why it may matter**: this is the first use of the symmetry payload beyond identity binding, and
it is the certificate-size lever C1148 will want; the Lean `WeightedRules.Contract` invariance
statement already covers the extension step.
**Evidence level**: argument only; no quotient replay exists and no measurement was taken. No
C-ID allocated.

## 2026-09-13 — count-axis parallelism loses to its own merge copy (C1177)

**Provenance**: C1177 count-axis measurement, `notes/2026-09-13-c1177-private-kernels.md`, private
`051f734`. **Was I looking for this?**: no — the task was to decide whether to enable count-axis
parallelism, not to explain the core parallel kernel's cost structure.
**Observation**: on every multi-tile count/resource table (9,207–69,673 cells) four workers lose to
serial by 5–19 per cent, and the loss grows with tile count. A count layer's transition work is bounded
by surviving jobs, so the owner's per-layer merge copy of every `u64` cell dominates. The budget layout
wins because its `u16` tiles are three times smaller and its work per layer is a full second axis.
**Why it may matter**: if count-axis parallelism is ever wanted, the lever is not a cell threshold but a
merge-free kernel where workers write disjoint tiles straight into the next layer (double-buffered
layers), removing the serial copy; that is a core `allocation_surface` change, not a private gate.
**Evidence level**: measured loss (paired, six shapes, seven rounds); the merge-free remedy is
argument only. No C-ID allocated.

## 2026-09-13 — runtime-length tuple copy is a `memmove` call inside the demand derivation loop (C1185)

**Provenance**: C1185 certificate generation profile, `notes/2026-09-13-c1185-certificate-size-exploration.md`,
private `a3c64f6`. **Was I looking for this?**: no — the task profiled certificate generation; this
is the evaluator's own cost.
**Observation**: `Demand::read`/`Demand::emit` copy a tuple with `copy_from_slice` over a runtime
arity, which lowers to a `memmove` call per tuple. On closure dense 1024 that call is about a fifth
of the process while certificate generation is under one per cent; a DWARF-unwound profile puts the
caller at `evaluate_into`.
**Why it may matter**: arity monomorphization or a bounded fixed-width element loop would remove
the call from the hot loop — a lever on evaluation itself, larger than any remaining checker lever.
**Evidence level**: one profile, one row; unmeasured remedy. No C-ID allocated.

## 2026-09-14 — cold-start workspace faults are kernel time invisible to the instruction metric; huge pages and source-sized reservation untested (C1170)

**Provenance**: C1170 `prepare-touch` stage, `notes/2026-09-14-c1170-prepare-touch-scan-attribution.md`,
private `c526b3f` … `9f1e57e`. **Was I looking for this?**: partly — the stage was the deliverable;
the size of the reservation relative to use, and the huge-page lever, were not.
**Observation**: a fresh workspace under `Limits::default` reserves 21 MB and would fault 5,123
pages at about 734 ns each (≈3.8 ms) before scanning a byte, while a 43 KB source fills 157 pages.
Per-fault cost is roughly half zeroing and half kernel entry/page-table work; transparent huge pages
are `madvise`-only on this host, so the pools do not get them.
**Why it may matter**: sizing reservations from the source length (or lazy touching) is a
product-shaped design choice; `madvise(MADV_HUGEPAGE)` on the pools is a cheap A/B that could halve
cold start. Neither is visible to the lane's instruction-count metric, which counts user events only.
**Evidence level**: one measured stage on one host; remedies unmeasured. No C-ID allocated.

## 2026-09-14 — the admission `scopes` pool is dead: reserved, touched, cleared, never written (C1170)

**Provenance**: C1170 traversal-cursor task, `notes/2026-09-14-c1170-traversal-cursor.md`, private
`5578357` … `11fc4d0`. **Was I looking for this?**: no — found while moving the traversal stack out
of the workspace.
**Observation**: `Workspace::scopes` is reserved to `Limits::depth`, filled by `touch`, counted in
`retained_bytes` and cleared three times per admission, and no code pushes to it; the scope mark
lives in `Visit::mark`. Removing it is one `try_reserve_exact` fewer in `prepare`, 2 KiB of
reservation under the bench limits and three clears; it changes `retained_bytes`, which the
allocation regression compares before and after rather than to a constant.
**Why it may matter**: small, but it is a pool-shape change with its own `prepare` A/B, so it is
not folded into a kernel candidate's measurement.
**Evidence level**: read from the source; unmeasured. No C-ID allocated; listed as the first
remaining step in the task report.
