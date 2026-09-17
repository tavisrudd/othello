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

## 2026-09-15 — admission's symbol probe is quadratic when one spelling is declared many times (C1190)

**Provenance**: C1190 milestone (a), `notes/2026-09-15-c1190-milestone-a.md`, private `41553c9`;
profile `~/.cache/ergodis/perf-c1190/lower-datalog-41553c9.data`. **Was I looking for this?**: no —
it surfaced as the largest symbol in a profile taken to attribute the lowering stage's cost.
**Observation**: on the new `datalog` cohort, where 512 definitions all spell their relation `edge`,
`admit::declare` is 50.58 per cent of the whole parse-admit-lower stage. `admit::insert` walks the
open-addressed symbol index from the spelling's home slot to the first empty slot, and every one of
the 512 identical spellings shares that home slot, so the walk is 512 entries long at the last
insert and the declaring phase is quadratic in the number of clauses of one relation. Admission on
that cohort costs 273 instructions per source byte against 40.68 on the ASCII cohort, whose
spellings are all distinct.
**Why it may matter**: several `def` clauses of one relation is idiomatic Rel — it is how a fragment
writes its extensional data — so a realistic input is exactly the shape that triggers this. The
existing measurement cohorts never exposed it because each of their definitions has a fresh
spelling. A fix is a chained bucket or a second hash probe rather than linear probing, and it is a
kernel candidate with its own A/B.
**Evidence level**: one profile and one stage difference on one cohort, both at `41553c9`; the
mechanism is read from `admit::insert`'s source and is not in doubt, the remedy is unmeasured. No
C-ID allocated.

## 2026-09-15 — relation resolution in the lowering is a linear scan, and it is quadratic in the relation count (C1190)

**Provenance**: C1190 milestone (a), `notes/2026-09-15-c1190-milestone-a.md`, private `41553c9`;
receipt `analysis/rel-frontend/performance-v1-lower-41553c9.json`. **Was I looking for this?**:
partly — the stage cost was the deliverable, but the comment-string cohort's 284.66 instructions per
source byte was not expected and its cause was not.
**Observation**: `lower::build` resolves a relation by a linear scan of the relation pool in
`find_relation`, called from `declare`, `resolve_name` and `qualified`. The comment-string cohort,
whose string-bodied definitions are fact sets under the adopted semantics, declares 896 relations
and pays about 400,000 spelling comparisons in the declaring phase alone; the ASCII and Unicode
cohorts pay 512²/2 before they reject.
**Why it may matter**: it is the difference between a stage that scales with the source and one that
scales with its square, and the fix is the open-addressed spelling index admission already has,
keyed by owner and spelling. It is a kernel candidate with a retained control and a Fermi that the
comment-string row already prices.
**Evidence level**: three measured cohort rows at `41553c9` and the source of `find_relation`;
the remedy is unmeasured. No C-ID allocated; named as the first remaining step in the task report.

## 2026-09-15 — correction to the two entries above: the ascii and unicode cost is a node-pool sweep, not the relation scan (C1190)

**Provenance**: independent verification audit of C1190 milestone (a),
`notes/2026-09-15-c1190-milestone-a-audit.md`; measurements against the retained
`~/.cache/ergodis/bin/ergodis-tools-41553c9`. **Was I looking for this?**: yes — it is a
correction to entries in this log, recorded here because the log is append-only and the two entries
above must not be read as they stand.

**What is corrected.** The entry "relation resolution in the lowering is a linear scan" says "the
ASCII and Unicode cohorts pay 512²/2 before they reject". That is wrong. Those two cohorts reject
inside `build::declare`, which refuses a bracketed head (`def score1[k] = …`) at the *second*
top-level definition, and the declare loop returns on its first error, so one relation is in the
pool when the failure fires — there is no quadratic scan. Their 79,208 and 79,977 instructions are
`build::declare_modules`, which sweeps the entire node pool for module nodes before any definition
is declared, at about 6.4 instructions per node: 12,288 nodes at 6.45 per node on ascii, 12,416 at
6.44 on unicode, and the 769-instruction gap between the cohorts over their 128-node gap is 6.0 per
extra node. The stage difference scales linearly with the definition count (11,450 / 21,122 /
40,478 / 79,204 at 64 / 128 / 256 / 512), where a quadratic would rise fourfold per doubling.

**What still stands.** Everything the entry says about the comment-string cohort. That cohort does
declare all 896 relations, `find_relation`'s linear scan is quadratic in the relation count, and
the 284.66 instructions per source byte are that scan: the stage difference there is 468,393 /
1,397,718 / 4,748,879 / 18,676,568 instructions at 64 / 128 / 256 / 512 definitions, ratios 2.98,
3.40 and 3.93, converging on fourfold per doubling. The open-addressed spelling index keyed by
owner and spelling remains the fix and remains the largest measured win.

**What the earlier entry on admission's probe chain gets wrong.** Only its comparison: "273
instructions per source byte there against 40.68 on the ASCII cohort" puts the `datalog` composed
stage beside the ASCII admission-only difference from the C1170 census. Like for like, both as
`admit` minus `parse` from the same receipts, it is 199.95 against 29.27. The mechanism that entry
describes is right and is now confirmed by counting rather than by a profile share: the `datalog`
admission difference is 97,626 / 279,711 / 902,976 / 3,185,977 instructions at 64 / 128 / 256 / 512
definitions, ratios 2.87, 3.23 and 3.53.

**Why it may matter**: a successor reading the uncorrected entries would price the node-pool sweep
as a quadratic and size its saving from the wrong model. Two separate candidates exist, not one: a
spelling index for the quadratic on programs with many relations, and a module index built during
admission for the linear sweep every lowering pays before its first declaration.
**Evidence level**: scaling runs on three cohorts against the retained `41553c9` binary, two-point
differenced and pinned, plus the failing span and the source of `build::declare` and
`build::declare_modules`. No C-ID allocated.

## 2026-09-17 — the derivation loop recompiles under semantically irrelevant source changes (C1200)

**Provenance**: C1200 repair pass, `notes/2026-09-17-c1200-c1198-repair-pass.md`, opcode
histograms of `Demand::evaluate_into` across `closure_ballpark-356fce6`, `c1198-stagger-probe`,
`c1198-nostagger-probe`, `closure_ballpark-6078142` and `closure_ballpark-aa04358` under
`~/.cache/ergodis/c1200/`. **Was I looking for this?**: no — the task was isolating the stagger's
credit for the 9 per cent dense-closure cycle regression; the lever it exposes is not the repair.

**Observation.** Three source changes that do not touch the derivation loop have each recompiled
it: C1170's untimed bench-driver dump path (scanner +1.7 per cent of instructions), the C1198
stagger commit in `pages.rs` (7,741 → 7,701 instructions, 0.9917 in instructions, 0.913 in cycles
on dense closure), and C1200's one `u32` field on `DemandWorkspace` (7,701 → 7,788, 1.0067–1.0085
in instructions). The two stagger-commit bodies differ by 40 instructions with no new opcode, 27 of
them `mov`, which is the signature of register allocation over a `lto = "thin"`,
`codegen-units = 1` workspace rather than a different algorithm.

**Why it may matter**: the lane spends tasks on kernel changes worth one to six per cent while an
unexamined build configuration moves the same kernel by comparable amounts in either direction. A
deliberate sweep — profile-guided optimization on the retained cohorts, `codegen-units`, inline
thresholds, an LLVM inliner-argument sweep — each measured against a retained control on the six
direct-path cohorts, would turn a confound that has now hit three reports into a measured lever,
and could recover the 9 per cent by design rather than by accident.
**Evidence level**: opcode histograms and `ab.py` receipts (`analysis/datalog-comparison/ab-2026-09-17-c1200-*.json`)
in the private workspace; the mechanism (a removed spill on a dependency chain) is a lead, not a
measurement — a kernel-scoped `perf annotate` of both stagger arms is the gap. No C-ID allocated.
