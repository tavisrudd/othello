# C238 — Commercial algorithms and broader paper portfolio from repair ports, `repaircodes`, and arcs

**Lane:** `rp-next`

**Date:** 2026-07-17

**Scope:** synthesis and research/product recommendations; no production-speed or market-size claim

**Working record:** [C238 scratchpad](2026-07-17-c238-repairports-commercial-algorithms-scratchpad.md)

**Cross-domain review:**
[C239 domain translation, generalization, and missed-gap audit](2026-07-17-c239-domain-translation-audit.md)
retains the paper grade and first storage wedge, but reframes the broader program as resilience
knowledge compilation over pointed elementary capability modes.

## Executive answer

There is a commercially credible systems object in this material, but it is **not primarily a new
erasure code**. It is a compiled **repair-policy control plane**: given a linear code, topology,
failure state, and resource state, it knows all bounded recovery equations, chooses among them,
uses newly repaired fragments to unlock later repairs, prices shared-helper bottlenecks, and emits a
checkable plan.

The most useful data structure is a signed **Repair Port Capsule** containing the complete bounded
repair semantics of one code/version. The lowest-risk product wedge is an offline policy compiler
and recovery digital twin. The most differentiated product is a **proof-carrying dynamic repair
planner**: a fast untrusted optimizer proposes a schedule, while a small verifier checks its linear
equations, prerequisites, and pinned code identity before data moves.

The arcs and other paper packages yield a second broad-CS direction: **proof-carrying
symmetry-reduced enumeration**. The q=16 arcs classification already demonstrates an unusually
clean trust split in which an untrusted canonical generator emits explicit projective transports
and covering lists, and Lean checks coverage without trusting canonical labels, deduplication, or
the claimed class count. Generalized into a library and shown on a second nongeometry domain, this
may have broader CS reach than the finite-geometry theorem itself.

The direct paper answer remains:

> The best paper that can be assembled now from `repaircodes` plus selected complete-port material
> is likely **B+ overall, with a credible A-minus ceiling**. It is not presently an A/A+ paper.

That ceiling requires a short, theorem-led paper—not a repository omnibus. The strongest broader
CS papers have A-minus potential, but only after implementation/generalization and comparative
evaluation. They are not submission-ready today.

### Ranked conclusions

| Rank | Opportunity | Why it matters | State now |
|---:|---|---|---|
| 1 | Repair Port Capsule + offline policy compiler | Turns a code matrix into complete, queryable repair semantics and predeployment risk/cost answers | Implementable; unbenchmarked |
| 2 | Proof-carrying repair control plane | Dynamically chooses and certifies repair equations/schedules under failures and load | Strong architecture; needs prototype |
| 3 | Unlock-aware batch scheduler | Jointly exploits sequential repair and helper capacity rather than optimizing targets independently | New synthesis; no guarantee or benchmark |
| 4 | Recovery digital twin and hardening engine | Combines exact code-derived repairability, stopping cores, pivotality, and capacity bottlenecks | Most accessible commercial wedge |
| 5 | Proof-carrying orbit-reduced search | Exports the arcs trust architecture to classifications, code catalogs, and configuration search | One unusually strong case study exists |
| 6 | Representation-aware LSSS/MPC linter | Detects capability changes invisible at the access-structure level | Exact examples and criterion exist; narrow market |
| 7 | Algebraically guided codec fuzzing | Concentrates tests on structured hard-syndrome loci missed by uniform random tests | Research hypothesis; needs bug study |
| 8 | Extension-complex migration planner | Preserves alternate legal upgrades under deletions/configuration changes | Mathematically suggestive; commercially speculative |

## 1. The paper material and likely grade

### 1.1 Best paper assembleable now

Recommended working title:

> **Complete bounded repair ports of linear codes: exact concatenation, realization, reliability,
> and geometric families**

Its thesis should be that the correct local object is not a chosen recovery group or an ordinary
locality number, but the **complete pointed family of all bounded dual circuits through a target**,
together with the coefficient and probability structure carried by that family.

The optimal theorem spine is:

1. define complete pointed repair ports;
2. prove the exact weighted-functional obstruction and sharp concatenation transfer criterion;
3. give the strict natural example where this criterion succeeds beyond ordinary
   support-distance gating;
4. prove prescribed-port realization in asymptotically good fixed-alphabet code families;
5. develop exact reliability, radius-truncated EXIT, and the pointed-Tutte identification; and
6. use the twisted-cubic and quartic-nucleus families as contrasting infinite flagships.

The local sources are the existing
[`coding-repair-hypergraphs`](../papers/coding-repair-hypergraphs/README.md) manuscript and
[C215](2026-07-16-c215-functional-cost-api.md),
[C216](2026-07-16-c216-prescribed-port-realization.md),
[C218](2026-07-16-c218-quartic-nucleus-repair.md),
[C219](2026-07-16-c219-repair-reliability.md),
[C226](2026-07-16-c226-repair-port-exit-transforms.md), and
[C227](2026-07-16-c227-pointed-tutte-repair-polynomial.md). C220 can contribute one compact
blocker theorem if it improves the flagship story rather than opening another subject.

Material to exclude from this paper:

- sequential multi-round closure and separator composition (C229--C234);
- a general service-region development (C235);
- the full coefficient-holonomy/MPC story (C217, C228, C237);
- large q=9 tables or more orbit catalogues; and
- every available application merely because it is proved.

Those exclusions are important. The present strength is an exact conceptual chain. A mega-paper
would read as several good papers obscuring one another.

### 1.2 Grade calibration

| Dimension | Likely assembled grade | Reason |
|---|---|---|
| Significance | B+ | A richer invariant than locality is developed and globally realizable, but the operational payoff is not yet measured |
| Novelty | B+ | The exact pointed/weighted synthesis appears strong; several ingredients touch classical quotient weights, coset leaders, Tutte/reliability, and matroid circuits |
| Surprise | B to B+ | The strict transfer example and prescribed-port realization are the best surprises; more examples will not raise this much |
| Audience | B+ to A− | Coding theory is direct; storage/reliability reach depends on an implementation |
| Readiness | A− | The theorem/certificate base is unusually mature, but prose integration and a specialist novelty audit remain |
| Rigor | A− | Exact artifacts and kernel-checked pieces are a real advantage; not every general algorithm is formalized or executable |

**Expected overall: B+. Credible ceiling: A−.** The A− route is ruthless synthesis, a careful
prior-art audit, and one unmistakable narrative. Adding C229--C237 to the same manuscript lowers,
not raises, its likely grade.

### 1.3 The natural paper split

The rest should become separate papers:

| Package | Core material | Current assessment |
|---|---|---|
| Complete repair ports | C215--C220, C226--C227, selected C235 | Best immediate follow-up; B+/A− ceiling |
| Sequential repair composition | C229--C234, with C236 applications | Strongest stand-alone new theory core; B+ now, A− after broader positioning |
| Holonomy and MPC | C217, C228, C237 | High-concept specialist paper/note; B/B+ pending novelty/minimality audit |
| PortPlan systems | Capsule, dynamic scheduling, certificates, HDFS/Ceph prototype | No paper yet; A−-level potential only if evaluation is strong |
| Proof-carrying symmetry search | q=16 step books plus generic library and second domain | B/B+ case study now; A− potential after generalization/comparison |

## 2. The common computational idea

Across the repair and arcs projects, the recurring pattern is **compile expensive finite semantics
once, then answer many operational questions with small certificates**:

```text
matrix / finite object / symmetry action
                  |
        offline semantic compiler
                  |
   +--------------+------------------+
   |              |                  |
Repair Port   Syndrome Atlas   Orbit Step Books
Capsule       / Extension      + transports
              Complex
   |              |                  |
schedule,     fuzz, extend,      classify/search
risk, ETA,    harden             with small verifier
capacity
```

This is more than a metaphor. The same architectural choices recur:

- antichains of minimal witnesses and blockers;
- reverse incidence for event-driven updates;
- quotienting by symmetry or gauge;
- finite boundary summaries for repeated modules;
- expression DAGs when exact numerical behavior has an infinite value range; and
- an untrusted high-performance generator paired with a small trusted verifier.

The broad product thesis is therefore a **compiler and intermediate representation for redundant
recovery**, not a monolithic decoder.

## 3. New data structures

### 3.1 Repair Port Capsule — the primary data structure

```text
RepairPortCapsule {
  schema_version, code_hash, field, target_set,
  minimal_supports + normalized coefficients,
  support_antichain_index,
  blocker_antichain_index,
  helper_to_support_reverse_incidence,
  functional_cost_tables,
  reliability_decision_diagram,
  Horn_rules + reverse_rule_incidence,
  boundary_control_tables,
  timing_profile_DAGs,
  coefficient_holonomy_fingerprint,
  Schur_square_rank_profiles,
  certificate_hashes and signatures
}
```

Use packed support lists when the port is small; a ZDD-like representation for large sparse
support/blocker antichains; a BDD for a repeatedly queried Boolean repair event; and a lazy
circuit/pricing oracle for highly symmetric ports such as Reed--Solomon, where listing all
`k`-subsets would be perverse. The capsule is immutable and pinned to a codec matrix hash, so plans
cannot silently mix coefficient conventions or versions.

This object is not claimed to have a polynomial worst-case representation. Minimal circuit and
blocker families can be exponentially large, exact reliability can blow up, and distance/coset
leader subproblems are hard. Its practical regime is fixed small repair radius, fixed inner codes,
high symmetry, or offline compilation amortized across many objects and failures.

### 3.2 Proof-carrying Repair Plan

```text
RepairPlanCertificate {
  capsule_hash,
  selected recovery equations,
  normalized recombination coefficients,
  dependency order or round labels,
  live-source witnesses,
  optional resource allocation and dual bound
}
```

A verifier checks the equations against the code matrix, verifies that each prerequisite is live
or produced earlier, and checks the declared allocation. It need not prove that the optimizer found
the fastest plan; it proves that the proposed plan is algebraically valid and internally feasible.
This separates correctness from optimization quality.

### 3.3 Boundary Behavior Key

For systems composed through small interfaces, hash the canonical structural control table,
active/core weight map, and hash-consed timing-expression DAG. Within the proved 2-sum-tree model,
equal keys support contextual replacement and cached recomputation. This is a semantic cache key,
not merely a topology hash.

### 3.4 Syndrome Atlas

```text
SyndromeAtlasEntry {
  normalized projective syndrome ray,
  minimum coset-leader weight,
  number and supports of minimum leaders,
  low-degree algebraic-locus tags,
  legal extension neighbors and maximal compatible sets
}
```

The q=11 arcs artifact already realizes this idea in a small exact case: ray normalization,
coset-leader distance/multiplicity, a deep-hole locus, and an extension complex. Its immediate use
is exhaustive codec validation and hard-case generation, not general large-code decoding.

### 3.5 Extension Complex

Vertices are legal code/design/configuration augmentations; faces are sets that can be applied
simultaneously. Attach deletion transversals, alternate extensions, symmetry orbits, and costs.
This supports robust migration planning: select an upgrade path that remains extendable if an
element or orbit later becomes unavailable.

### 3.6 Orbit Step Book

Each augmentation record contains a parent, child, explicit group-action transport, pointwise
scalar/gauge witnesses where needed, and a local coverage certificate. A chain of books proves that
every legal input reaches some leaf. Crucially, it need not certify that the generator's canonical
label is correct or that all leaves are pairwise inequivalent.

### 3.7 Coefficient-aware identity

A support canonical form alone loses representation data. Pair it with a fundamental-cycle
holonomy vector and Schur-square rank profile:

```text
RepresentationID =
  (support canonical form, cycle holonomies, square-rank/deletion profile).
```

This can detect coefficient drift and distinguish access-structure-identical secret-sharing
matrices with different multiplicative capability. It is a linter/checksum, not yet a complete
classification invariant in all representations.

## 4. Algorithms derived from the repair work

### 4.1 Complete bounded-port compiler

Given a generator or parity-check matrix and radius `r`:

1. enumerate dependencies/circuits through each target of size at most `r+1`, or query a lazy
   circuit oracle;
2. solve and normalize the associated linear recovery equations;
3. remove nonminimal supports;
4. build target/helper/cost/failure-domain indexes; and
5. optionally dualize the support clutter to minimum blockers.

For fixed `r`, naive subset enumeration is polynomial in block length with exponent depending on
`r`; it is not a scalable arbitrary-radius solution. Meet-in-the-middle syndrome tables, geometry,
and symmetry should be pluggable back ends.

Commercial effect: a controller can choose from every legal low-read equation rather than a single
configured local group. The equation can be selected by cross-rack bytes, live helper load, trust
domain, energy, or downstream usefulness.

### 4.2 Functional-cost compiler for concatenated codes

[C215](2026-07-16-c215-functional-cost-api.md) gives an unusually clean compilation boundary.
Scan the `|F|^k` inner ambient blocks once; key by the represented outer-symbol functional; and
store the ordinary and target-nonzero minimum realization costs. Then evaluate outer functional
tuples from the cache.

This replaces a naive scan over all inner representatives in all outer blocks by one inner scan
plus a scan over functional tuples. It certifies the first nonembedded low-weight witness and
whether a complete bounded port survives concatenation. The current evaluator is kernel-checked,
but it has no extracted production executable or runtime comparison.

Commercial effect: an offline code-policy compiler can reject outer/inner combinations that
silently introduce cheaper cross-block repairs or prove that a desired local port survives scale
out.

### 4.3 Event-driven bounded sequential closure

[C229](2026-07-16-c229-cooperative-horn-closure.md) turns each small circuit `C` into rules
`(C - {e}) -> e`. Store an unsatisfied-body counter per rule and reverse incidence from each helper
to the rules that contain it. Queue live/repaired fragments, decrement each affected counter, and
fire a rule when its body is available.

With explicit rules, the forward pass is linear in total rule-literal incidence. It computes the
order-independent terminal closure and exact stopping core. Bucketed rounds or a priority queue add
earliest arrival times.

Commercial effect: correlated erasures that defeat one-round local groups may still be repaired by
using reconstructed shards as later helpers. Every step carries an explicit equation.

### 4.4 Proof-carrying dynamic planner

Use any optimizer—greedy, min-cost flow, LP/MILP, learned heuristic, or RDAG scheduler—to choose a
repair plan, but require the Repair Plan certificate above. Verification is proportional to the
plan/certificate size and small field-linear-algebra checks; it does not replay global search.

This directly imports the strongest systems lesson of the arcs formalization: do not try to verify
the complicated canonical/optimization engine when one can verify the semantic witnesses it
emits. Likely benefits are reproducible incident diagnosis, safer codec upgrades, and protection
against stale/wrong coefficient tables.

### 4.5 Unlock-aware capacitated batch scheduling

[C235](2026-07-16-c235-capacitated-batch-repair.md) expresses concurrent repair as a
recovery-set packing LP. Explicitly, assign demand to recovery sets while limiting the total load
on each helper. The primal is a schedule and the dual prices helpers by scarcity. Use column
generation when a weighted minimum-recovery-set oracle is available; pricing is hard in general,
but bounded precompiled ports make it practical.

The new synthesis is to combine this LP with sequential closure. A repaired fragment has option
value because it may unlock several later rules. A receding-horizon score can combine:

```text
downstream demand unlocked
+ reduction in stopping/blocker risk
- helper shadow-price cost
- latency / cross-domain cost.
```

The exact reference can be a time-indexed MILP over hyperedge firings; the production planner can
be heuristic and certified after the fact. No approximation guarantee is currently known. The
decisive benchmark is against per-target greedy scheduling, max-flow selection, and static RDAG
scheduling under node/rack failures.

### 4.6 Exact reliability and joint hardening

[C219](2026-07-16-c219-repair-reliability.md) supplies deletion--contraction, blocker asymptotics,
and exact pivotal derivatives for the complete repair Boolean function. A memoized decision diagram
can answer:

- repair probability under heterogeneous independent survival;
- exact expectation under an empirical correlated failure distribution;
- minimum blockers/cut sets;
- each helper's pivotal influence; and
- the cheapest available repair-radius distribution from C226.

BDD fault-tree evaluation and Birnbaum-style importance are established reliability methods. The
new value is automatic extraction of the **correct code-derived Boolean function**, with shared
helpers and a declared one-round/sequential/full-span semantics.

Combine stochastic pivotality with the LP helper price. One identifies whether a helper determines
*existence* of repair; the other identifies whether it throttles *throughput*. Their joint frontier
can rank rack moves, bandwidth upgrades, maintenance deferrals, or code changes. This joint
decision rule is a promising derived algorithm, not yet a proved optimum.

### 4.7 Compositional recovery and ETA cache

C231--C234 show what a small interface must transmit:

- truncated certificate budgets for one-round/terminal behavior;
- a finite structural boundary-control table for fixed radius and interface width;
- passive integer weights for active/core counts; and
- budget-indexed arrival profiles for exact timing, represented by finite `min`, budgeted-`max`,
  and delay expression syntax over an infinite value carrier.

Hash-cons repeated component summaries and evaluate the boundary fixed point rather than flattening
the whole system. This can support incremental recovery ETA and fast what-if analysis on repeated
rack/pod modules.

The exact theorem currently covers 2-sum trees. There is no justified general FPT or arbitrary
production-topology claim; decomposition, circuit-list construction, and realizable-control
enumeration still need algorithms.

### 4.8 Representation-aware LSSS/MPC linter

From C217, C228, and [C237](2026-07-16-c237-u38-holonomy-mpc.md):

1. compute circuit-coefficient holonomies modulo circuit and coordinate gauge;
2. compute the quadratic Veronese/Schur-square representation;
3. test dealer-square span after each declared adversary deletion; and
4. emit recombination vectors on success or a rank/covector witness on failure.

C237 gives two `U(3,8)` representations with the same `3-of-7` access structure but different
strong-multiplicativity behavior. An access structure alone is therefore insufficient deployment
metadata.

The commercial target is a preflight linter for custom monotone span programs and linear secret
sharing, not a replacement for mature MPC systems. [MP-SPDZ](https://github.com/data61/MP-SPDZ)
is an important practical baseline; the opportunity is most plausible for custom/general access
structures, since ordinary threshold deployments already have well-understood choices.

## 5. Algorithms exported from arcs and the other papers

### 5.1 Proof-carrying symmetry-reduced enumeration

The q=16 arcs classification in
[`arcs_complete_outside_conic`](../papers/arcs_complete_outside_conic/README.md) uses an untrusted
C++ generator, normalized augmentation, explicit invertible `3 x 3` transports with scalar
witnesses, and four checked covering-list layers of sizes `4 -> 61 -> 454 -> 2633`. Lean proves
that every legal extension is represented and composes the layers. It does not trust pairwise
inequivalence, canonical labels, deduplication, or the external class count.

The general algorithmic pattern is:

1. let a fast domain engine perform canonical/symmetry-reduced search;
2. retain a covering list rather than insisting the verifier reconstruct canonical labels;
3. emit an explicit group action transporting each omitted child to a retained child;
4. check local legality and transport semantics in a small trusted kernel; and
5. compose step-book coverage to prove global exhaustiveness.

Canonical construction paths are already established by
[McKay's isomorph-free generation](https://users.cecs.anu.edu.au/~bdm/papers/orderly.pdf), and the
[nauty/Traces](https://pallini.di.uniroma1.it/) ecosystem is the obvious performance baseline.
Certified untrusted-solver/trusted-checker separation is also established: LRAT adds hints that
make SAT proofs amenable to efficient verified checking
([Cruz-Filipe et al.](https://arxiv.org/abs/1612.02353)). Proof-verified finite-geometry
enumeration is not empty territory either; Dallaire--Bright combine SAT, symbolic symmetry
reduction, and certificates for projective planes of order nine
([paper](https://cs.uwaterloo.ca/~cbright/reports/sc2-pp9-preprint.pdf)).

The plausible novelty is narrower: native group-action transport certificates that prove orbit
coverage while deliberately declining to certify canonical labels or quotient counts. A broader
paper must compare certificate size, generation/check time, and trusted code base with
canonical-generation and SAT/LRAT alternatives.

Likely applications: code/design catalogs, graph/configuration generation, symmetry-heavy protocol
state exploration, and hardware test-vector classes. A second nongeometry benchmark is mandatory.

### 5.2 Algebraically guided hard-syndrome detection and fuzzing

The arcs evaluation obstruction forms a feature-evaluation matrix on the ordinary-uncovered locus.
Its kernel gives exact low-degree algebraic models containing that locus; full rank certifies that
no nonzero model in the selected feature space does so.

Turn this into a testing loop:

1. enumerate/sample projective syndrome rays and measure decoder cost or failure;
2. fit exact finite-field low-degree kernels to the hard set;
3. generate new tests on and immediately off the detected algebraic locus;
4. minimize failures by coset-leader support and extension adjacency; and
5. emit a reproducible syndrome/leader certificate.

This could find structured blind spots that random sampling rarely hits. It must be compared with
uniform, weight-stratified, and hand-built decoder tests on injected and real defects. Existing
square-code distinguishers and classical syndrome decoding are adjacent; novelty would lie in the
joint audit/fuzz workflow and demonstrated bug-finding gain.

### 5.3 Collision-aware pair-coverage search

The prescribed-hole defect identity separates useful new pair coverage, duplicate collisions, and
exceptional-locus capacity exactly. Use the residual defect as a branch-and-bound bound when
searching for saturating sets or short covering codes: reward newly covered directions, charge
collisions exactly, and prune when remaining pair capacity cannot cover the target complement.

This is immediately credible as a finite-geometry/code-search heuristic. Mappings to pairwise test
design or two-resource coverage are possible but need new semantics and benchmarks.

### 5.4 Robust completion and alternate-extension planning

Completion distance becomes a transversal/hitting-set problem; equivariant extension results count
alternate legal orbit additions after deletions. Store these in the Extension Complex and optimize
not only the next augmentation, but the number/cost/diversity of future augmentations preserved by
that choice.

Potential use: precompute alternate parity columns or configuration upgrades before a device,
field orbit, or feature is retired. The current finite-geometry theorems are demonstrations, not
evidence that a production code family has a valuable extension complex.

### 5.5 Continuation-graph fingerprints

The [`continuation-graph-rigidity`](../papers/continuation-graph-rigidity/README.md) package proves,
in its regime, that legal-extension compatibility reconstructs the semilinear geometry and the
original cap. Derived algorithmic ideas are:

- canonical fingerprints based on compatibility rather than coordinates;
- equivalence/deduplication without exposing a chosen gauge;
- integrity checks when a mutated compatibility graph no longer reconstructs the expected object;
  and
- black-box reconstruction from a legal-extension oracle.

The current theorems are exact. A useful commercial fingerprint needs an explicit reconstruction
algorithm and stability under noise or incomplete observations.

### 5.6 Equivariant compilation of complete repair semantics

The full `repaircodes` Discovery Track adds an important algorithmic improvement. D-PC10/D-PC11
show that a monomial automorphism of the generator-column configuration transports the complete
bounded repair hypergraph exactly, not merely the code parameters. The same verified action
transports equations, blockers, the repair Boolean function, and Horn rules.

Upgrade the primary data structure to an **Equivariant Repair Port Capsule**:

```text
EquivariantPortCapsule {
  group generators and action certificates,
  coordinate and repair-edge orbit representatives,
  stabilizers / transporter data,
  representative equations, blockers, BDD nodes, and Horn rules,
  lazy expansion and query cache
}
```

Compile one target and repair representative per orbit, then transport answers on demand. For
highly symmetric cyclic, RS-like, and geometric codes, this could reduce compilation time and
metadata by orbit-size factors. For an asymmetric code it degenerates to the ordinary capsule.
Symmetry reduction itself is standard; the useful delta is certified equivariance of the entire
complete repair semantics.

The C115 cross-lane audit reinforces the principle: completion transversals, code-repair rows, and
determinant hypergraphs are sometimes literally the same functorial object under different names.
This makes orbit reduction a core compiler optimization, not decorative geometric framing.

### 5.7 Multiobjective pointed syndrome compilation

The `repairports` discovery log observes that C215's cache is an ordinary syndrome/coset-leader
table augmented with a target-forced nonzero minimum for every coordinate. Instead of building one
table per target, compute a vector-valued table in one traversal:

```text
PointedCost[beta] =
  (ordinary_min, forced_nonzero_min[x] for all inner coordinates x).
```

Each ambient representative updates its ordinary fiber minimum and every pointed entry on which it
is nonzero. Combine this with coordinate orbits, trellis/state-space methods, or incremental
dynamic programming. One traversal is an immediate engineering improvement; the research question
is which code classes permit runtime polynomial in the number of syndromes and coordinate orbits,
rather than the full ambient `|F|^k` scan.

### 5.8 Orbit-exchange configuration repair

The `alt-orbit-repair` lane supplies a stronger theorem base than the initial extension-complex
discussion recognized. It repairs the **configuration** rather than only the erased data: delete a
selected nonfixed Frobenius orbit and add a different legal orbit while retaining the arc/code
constraint.

The checked phase condition

```text
floor((k-1)^2/4) + r + 1 <= s(s-1)/2
```

guarantees at least `r` alternate repairs in the proved family. For invariant ten-arcs and `s>=7`,
at least 318 alternate orbits remain after every selected-orbit deletion. Over `PG(2,25)`, every
profile has an alternate pair; the exceptional profile's exact computed spectrum is 32--47, with
the universal 32 bridge still being completed in C151.

Derived data structure:

```text
OrbitExchangeCapsule {
  configuration and group action,
  orbit-valued deletion units,
  remainder -> restoration and alternate additions,
  carrier-indexed candidates and obstruction masks,
  exchange-graph adjacency oracle,
  robustness envelope and certificates
}
```

This is a serious foundation for resilient configuration migration. It is not yet a production
algorithm: no deployed code/profile has been shown to expose the same useful exchange structure,
and high local degree does not prove that the exchange graph is connected or rapidly mixing.

### 5.9 Factorized obstruction-mask search

C151's formal certificate work hides a reusable search data structure. Direct legality witnesses
were too expensive. The successful design factors 46,056 payload decisions through 651 canonical
dual-line masks, 310 candidate carriers arranged ten per fixed line, constant freshness/incidence
layers, a varying old-secant mask, and residual symmetry transports.

```text
FactorizedConstraintStore {
  canonical predicate masks,
  tuple -> mask IDs,
  constant and variable obstruction bitsets,
  symmetry transporter IDs,
  bounded conclusion certificates
}
```

The relconic mechanism notebooks independently found the same pattern: a nine-factor determinant
test became a pair-indexed 1,302-bit forbidden-third lookup. This can substantially accelerate
symmetry-heavy algebraic CSPs and shrink their proof artifacts. Bitset propagation is established;
the publishable contribution would be proof-carrying factorization, certificate-size reduction,
and a generic compiler.

Those notebooks also establish a useful negative search rule: run cheap coverage/capacity gates
before expensive low-degree rank tests. Several attractive q=64 symmetry families fail by hundreds
of uncovered points, long before rank is relevant.

### 5.10 Decoder-ambiguity and continuation fingerprints

The full theorem registry adds a creative inverse problem. For the Clebsch code, one quadratic
syndrome test is a complete distance oracle, and nearest-word ambiguity reconstructs Brianchon
geometry and an intrinsic support bipartition. Separately, the continuation complex reconstructs
the geometry/configuration in its proved regime.

```text
BehaviorFingerprint {
  hard-syndrome locus,
  nearest-leader multiplicity/support complex,
  legal-extension conflict complex,
  inferred symmetry and coefficient identity
}
```

Possible uses are black-box codec identification, drift/tamper detection, and structure-aware test
generation. A broader paper—*Behavioral reconstruction of linear codes from decoding and extension
oracles*—would need multiple families and a noise-tolerant reconstruction theorem. At present this
is a high-upside research hypothesis, not a product claim.

### 5.11 Symmetry-first game and protocol preprocessing

The Nofil and dihedral theorem packages suggest a generic prepass:

1. find a fixed-point-free automorphism preserving the legal structure and emit a mirror-strategy
   certificate;
2. otherwise quotient the residual position into Schreier orbit templates;
3. xor only template nimbers with odd multiplicity; and
4. cache templates under a group-action/Burnside signature.

This can bypass game-tree search on structured boards and is a good nongeometry benchmark for the
proof-carrying symmetry library. Commercial reach is limited to puzzle/game solvers and verification
testbeds, so it should not displace the storage or protocol work.

### 5.12 Resource-aware generated-proof build scheduling

The alt-orbit certificate logs measured individual Lean targets at roughly 6--11 GB peak memory and
exposed misleading timestamp/progress behavior across long resumable builds. The surviving
engineering pattern is a content-traced, resource-constrained build DAG:

```text
ProofBuildManifest {
  content-addressed source and trace keys,
  dependency DAG,
  measured/predicted RSS and time by target family,
  maximum-safe concurrency constraints,
  snapshots and restart provenance,
  aggregate trust/staleness checks
}
```

Schedule shared high-memory checkers first, then bounded independent leaves; factor recurring
incidence data; validate freshness from content traces rather than filenames or progress counters.
This supports the registered `lean-proof-engineering-at-scale` methods paper and a practical CI tool
for formal-verification teams. Novelty requires comparison with Lake and content-addressed systems
such as Nix/Bazel; the repository currently supplies an unusually rich case study, not that audit.

## 6. What existing systems can be improved

The table states a candidate delta and a falsification gate, not a measured improvement.

| Existing system/method | Documented or published baseline | Proposed improvement | Required proof |
|---|---|---|---|
| HDFS ECWorker | Reads a minimum set of inputs in parallel and reconstructs missing internal blocks; supports custom codecs and recovery weights ([official docs](https://hadoop.apache.org/docs/current/hadoop-project-dist/hadoop-hdfs/HDFSErasureCoding.html)) | Complete-port helper oracle; sequential reuse; LP shadow prices; certified dependency DAG | Better makespan/tail/cross-rack bytes on node/rack failures without harming client I/O |
| Ceph EC | Profiles select code/plugin/failure domain; recovery/backfill exposes priorities/QoS ([EC docs](https://docs.ceph.com/en/latest/rados/operations/erasure-code/), [recovery controls](https://docs.ceph.com/en/latest/rados/operations/placement-groups/)) | Compile all small circuits, dynamically choose sequence/helper sets, report stopping cores, leave mClock to arbitrate recovery versus client I/O | Adapter overhead and improved recovery on realistic CRUSH placements |
| MinIO / MDS stores | Erasure sets and healing from surviving data/parity shards ([docs](https://min.io/docs/minio/linux/operations/concepts/erasure-coding.html)) | Lazy `choose-any-k` source oracle plus topology/load-aware batch selection | Scheduling gain only; no false claim of new MDS repair algebra |
| ECPipe | Slice pipelining and path/helper scheduling for repair ([paper](https://arxiv.org/abs/1908.01527)) | Choose the recovery equation first, then pipeline its certified DAG | Combined controller beats either stage alone |
| RepairBoost | Represents a single-chunk repair solution as an RDAG and balances tasks ([paper](https://www.usenix.org/system/files/atc21-lin.pdf)) | Supply a Pareto family of certified RDAGs and select jointly across stripes | Multi-stripe/node-failure gain versus its scheduler |
| SelectiveEC | Max-flow balancing for source/replacement selection in single-failure recovery ([paper](https://www.usenix.org/system/files/hotstorage20_paper_xu.pdf)) | Replace fixed source choices by recovery-set hyperedges; add correlated targets and sequential reuse | Improved heterogeneous multi-failure results without controller blowup |
| LESS | Optimizes code/sub-stripe layout for efficient single repair ([FAST '26 page](https://www.usenix.org/conference/fast26/presentation/cheng)) | Compile and schedule every equation provided by the resulting layout | Complementary gain after controlling for its physical layout advantage |
| Fault-tree/BDD tools | Exact Boolean reliability and importance are established | Automatically derive one-round/sequential/full-span code recovery functions; retain shared helpers; combine pivotality with service prices | Better intervention decisions than manual fault models or either score alone |
| Datalog/dataflow | High-performance recursive and incremental Horn evaluation already exists ([Souffle](https://souffle-lang.github.io/pdf/cav16.pdf), [differential Datalog](https://arxiv.org/abs/2308.04214)) | Specialize bounded symmetric circuit rules and cache verified small-interface summaries | Beat general engines on repeated recovery modules; no general-superiority claim |
| MPC frameworks | Optimized threshold/replicated protocols already exist | External linter for custom matrices, coefficient identity, and strong multiplicativity after adversary deletions | Real custom-MSP corpus and useful caught misconfigurations |
| nauty/canonical augmentation and SAT proof logs | Mature symmetry reduction and certified SAT checking exist | Native orbit-transport step books that certify coverage but not canonical labels/counts | Smaller trusted base or better certificate/checking tradeoff on at least two domains |

The most promising substantial improvements are therefore:

1. **model fidelity:** extract all actual algebraic recovery options rather than hand-configured
   groups;
2. **multi-failure feasibility:** exploit repaired fragments as new helpers;
3. **joint scheduling:** optimize recovery equations across targets and shared capacities;
4. **auditability:** verify selected equations and dependencies independently of the optimizer; and
5. **incrementality:** reuse exact boundary summaries for repeated modules.

### 6.1 Where a substantial SOTA improvement is plausible

The right standard is not “the mathematics has an application.” A promoted area needs a plausible
order-of-magnitude, new-capability, or assurance delta over a strong baseline.

| Area | Current SOTA strength | Missing capability supplied here | Potential substantial delta | Decisive falsifier |
|---|---|---|---|---|
| Erasure-coded repair control | Strong pipelining, RDAG/flow scheduling, and optimized layouts | Complete equation family + sequential reuse + joint capacity + checked plans | Repair cases fixed policies miss; materially lower node/rack recovery time; smaller trusted controller | No significant feasible-set or makespan gain on realistic codes/failures |
| Protocol model checking | Mature symmetry reduction, often with a trusted canonicalizer or assumed symmetry | Explicit process-permutation transports and coverage certificates in native semantics | Keep exponential state reduction while removing the symmetry reducer from the TCB | Certificates dominate time/space or offer no assurance advantage over SAT/SMT proofs |
| Formal proof CI | Mature general build/cache tools, weak handling of giant generated proof leaves and memory envelopes | Content-traced, RSS-aware DAG scheduling plus semantic certificate factorization | Avoid repeated OOM/rebuild cycles; make multi-hour proof farms resumable and auditable | Lake/Nix/Bazel configuration matches it without domain-specific machinery |
| Consensus quorum operations | Flexible/adaptive/weighted quorums and classical load/availability theory | One verified phase-aware safety/availability/ETA/capacity/reconfiguration capsule | Safer online adaptation and a better joint Pareto frontier in heterogeneous deployments | AWARE/WPaxos/fixed policies match the frontier and catch the same config faults |
| Coded gossip/data availability | RLNC, algebraic gossip, IDNC, and erasure-coded verifiable dispersal | Complete structured recovery semantics, unlock/stopping-core diagnostics, and checked plans | Less redundant traffic and higher recovery under correlated loss for structured codes | RLNC/ordinary coding matches delivery with much lower control overhead |
| Symmetric code compilation | Automorphism tools and code-specific lazy algorithms are established | Certified equivariant compilation of the *full repair semantics* | Orbit-factor reductions in compile time, capsule size, and validation | Useful deployed families have too little symmetry or standard lazy oracles already suffice |
| Codec validation | Random, weight-stratified, and code-specific exhaustive testing | Algebraic hard-locus discovery plus ambiguity/behavior reconstruction | Find structured bugs with orders fewer tests; identify codec drift from behavior | Low-degree/hard loci do not correlate with bugs or decoder cost |
| Configuration migration | Safe reconfiguration protocols and ordinary hitting-set robustness | Extension complex with alternate-future option value and checked paths | Avoid changes that are safe now but create a future dead end | No production family has useful nontrivial extension structure |

The first three have the clearest step-function thesis. The consensus and coded-gossip rows are
credible but enter crowded fields and need especially strong baselines.

Areas that do **not** presently support a substantial-SOTA claim are generic routing/cut
reliability, generic Horn/Datalog evaluation, generic fault-tree BDDs, ordinary threshold consensus
or MPC, unconstrained workflow engines, and ordinary canonical augmentation without the
proof-carrying trust improvement.

### 6.2 Consensus and quorum protocols: the exact bridge

For a family `Q` of acceptable quorums, four repair-port constructions become familiar quorum
objects:

```text
availability = exists Q in Q, every member of Q is live
blocker      = a set intersecting every Q
capacity     = fractional packing of Q under member capacities
ETA          = min_(Q in Q) max_(u in Q) arrival_time(u).
```

This is exact, but not new. Naor--Wool already developed quorum load, capacity, and availability
([primary source](https://www.wisdom.weizmann.ac.il/~naor/PAPERS/quor_abs.html));
[Flexible Paxos](https://drops.dagstuhl.de/entities/document/10.4230/LIPIcs.OPODIS.2016.25)
uses the weaker cross-phase intersections actually required by Paxos; and
[WPaxos](https://arxiv.org/abs/1703.08905) and
[AWARE](https://arxiv.org/abs/2011.01671) already adapt WAN quorum/weight choices for latency.

The derived systems object is therefore a **Protocol Capsule**, not a claim to have invented quorum
optimization:

```text
ProtocolCapsule {
  protocol, epoch, and configuration hash,
  minimal phase/round quorum families or lazy oracles,
  cross-phase intersection certificates,
  blockers and declared fault domains,
  heterogeneous availability BDD,
  quorum ETA/profile DAG,
  capacity columns and shadow prices,
  safe-reconfiguration extension complex,
  symmetry generators/transports,
  optional erasure-code Repair Port Capsule,
  signed proof manifest
}
```

Safety, availability/liveness, and performance remain separate layers. None of the repair results
proves Paxos, Raft, or BFT agreement or models Byzantine equivocation by itself.

#### Certified adaptive quorum planner

Offline, compile every allowed phase-specific quorum, certify the required cross-phase/round/epoch
intersections, build availability/blocker and ETA/capacity views, and precompute safe membership
changes. Online, select a quorum by predicted completion time, load price, and failure risk, then
emit an epoch-pinned policy certificate.

A normal quorum certificate proves that votes were obtained. The added certificate proves that the
chosen *policy, quorum family, and reconfiguration* belong to the verified configuration.

The possible substantial improvement over AWARE/WPaxos is joint optimization over the complete
safe quorum family with exact correlated-failure and future-reconfiguration information, while a
small checker guards adaptation. The likely first win is assurance and safer configuration, not an
assumed latency win. Benchmark against majority Raft/Paxos, Flexible Paxos/WPaxos, and AWARE on WAN
traces and injected policy/epoch bugs.

#### Exact quorum-certificate ETA and bottleneck explanations

A phase completes when all messages in any acceptable quorum arrive, exactly the `min` over
quorums of the `max` member arrival. C234's delay-expression DAG and budgeted bottleneck
convolution can compile this for general/hierarchical quorum families; Horn triggers compose later
phases. This gives incremental ETA, counterfactual leader/weight selection, and explanations of
which replica is both pivotal and capacity-scarce.

For a threshold quorum this collapses to an order statistic and offers little. The plausible SOTA
delta is for heterogeneous flexible quorum systems whose full family is too complex for a single
threshold model. Dynamic quorum-latency optimization already exists, so this direction survives
only if it improves tail prediction or decisions on real traces.

#### Safe reconfiguration as an extension/exchange complex

[Raft](https://www.usenix.org/node/184041.) uses overlapping majorities for membership changes;
[Vertical Paxos](https://lamport.azurewebsites.net/pubs/vertical-paxos.pdf) separates configuration
management; other reconfigurable protocols likewise have explicit transition rules. Represent
candidate membership/weight changes as vertices, simultaneously safe changes as faces, and attach
blockers plus alternate future paths.

The improvement target is not another one-step reconfiguration protocol. It is a planner that
maximizes **future option value**—multiple safe continuations after further failure—and certifies an
entire transition path. The alt-orbit phase theorem proves that such option-rich exchange can be
quantified in a nontrivial family, but a general quorum-extension theorem and real configuration
corpus are still missing.

### 6.3 Gossip, coded dissemination, and data availability

[GossipSub v1.1](https://github.com/libp2p/specs/blob/master/pubsub/gossipsub/gossipsub-v1.1.md)
already maintains a sparse mesh, peer scores, thresholds, and outbound quotas. Random linear
network coding and [algebraic gossip](https://www.mit.edu/people/medard/papers/ITRevised.pdf) already
mix packets during dissemination, while joint scheduling with instantly decodable network coding
is established
([primary paper](https://openresearch-repository.anu.edu.au/server/api/core/bitstreams/f654031c-5240-4c1a-a891-d1eeda383df3/content)).
[Narwhal/Tusk](https://arxiv.org/abs/2105.11827) explicitly separates reliable transaction
dissemination from ordering, and asynchronous verifiable information dispersal already combines
erasure coding with Byzantine robustness
([primary paper](https://people.csail.mit.edu/tessaro/papers/dds.pdf)).

The derived layer must therefore be narrower and code-aware:

```text
CodedGossipCapsule {
  object/code/commitment hash,
  authenticated peer shard/span state,
  minimal target recovery equations,
  innovative functional/circuit candidates,
  reverse unlock incidence,
  peer/link capacity and trust domains,
  stopping cores and certified transmission DAGs
}
```

An unlock-aware scheduler sends the authenticated coded packet or shard with the highest downstream
decoding value per scarce link. Repaired shards become transmitters; global encoding vectors or
repair equations certify algebraic validity. GossipSub remains the peer mesh and attack-resistance
layer.

The substantial-improvement target is fewer redundant shard transmissions, a higher recovery rate
under correlated peer loss, and exact stopping-core diagnostics for structured erasure-coded
objects. Compare with uncoded GossipSub, RLNC/algebraic gossip, IDNC scheduling, and the target
protocol's standard coded broadcast. If RLNC's cheap random innovation matches delivery while
capsule state/certificates add material overhead, this direction fails.

Byzantine boundary: every shard/equation needs a Merkle, polynomial-commitment, signature, or other
verifiable-coding layer. Linear recombination validity alone prevents neither poisoning nor
equivocation.

### 6.4 Proof-producing symmetry reduction for distributed protocols

This is the strongest protocol-facing SOTA thesis. Distributed protocols are dominated by
interchangeable processes. FDR/CSP symmetry reduction can deliver enormous state-space reductions
([paper](https://link.springer.com/article/10.1007/s10009-019-00516-4)); PRISM supports symmetry for
probabilistic protocol models but its documentation says that the tool assumes rather than checks
the model's symmetry ([documentation](https://www.prismmodelchecker.org/symm/)). Protocol synthesis
already exploits symmetry as well
([Alur et al.](https://arxiv.org/abs/1505.04409)).

Apply the arcs StepBook architecture:

1. an untrusted engine canonicalizes protocol states under process permutations;
2. every omitted state/transition carries an explicit permutation to a retained representative;
3. local certificates check transition preservation and safety-property invariance;
4. covering step books prove every reachable successor is represented; and
5. a small kernel checks exhaustiveness without trusting the canonicalizer.

The potential step-function delta is **assurance per unit state reduction**: retain mature symmetry
speedups while removing canonicalization and the symmetry assumption from the trusted computing
base. This also provides the second, nongeometry case required by the proof-carrying search paper.

Benchmark finite Paxos/Raft, randomized consensus, cache-coherence, or GossipSub models against
plain exploration, FDR/PRISM symmetry reduction, and SAT/SMT certificates. Measure reduction,
generation time, certificate bytes, checker time/memory, trusted code, and detection of injected
symmetry/transition bugs. The initial claim should cover finite-state safety/exhaustiveness;
liveness and fairness require separate certificates.

### 6.5 Network protocols that should be demoted

Ordinary path failover, routing reliability, and multicommodity traffic engineering already reduce
to mature cuts, flows, BDDs, and fast-reroute systems. The present work adds no credible generic
SOTA improvement there. A network-coding coefficient/holonomy linter is worth a bounded scout, but
global encoding vectors and rank checks are established; it matters only if cycle fingerprints
detect equivalence or coefficient drift materially more cheaply than full transfer-matrix checks.

## 7. Commercial product ranking

### 7.1 Offline Port Compiler and deployment preflight — build first

Input: matrix/codec, target repair radius, placement, failure domains, helper capacities, and SLO.
Output: a signed capsule, complete/lazy repair queries, blockers, expected reads, capacity prices,
and policy warnings.

Why first: it avoids changing the data path, can compare profiles before deployment, and provides
the artifact required by every later product. Likely users include storage appliance vendors,
managed Ceph operators, archival/backup products, and codec developers.

Stop if standard RS/LRC policies already produce indistinguishable decisions on representative
traces or if capsules cannot be kept compact/lazy at useful radii.

### 7.2 Proof-carrying repair controller — strongest differentiation

Add live topology/load, sequential closure, capacity scheduling, and plan certificates. Integrate
first through an HDFS custom codec/controller boundary; use a Ceph adapter after semantics are
stable.

The defensible claim is not “globally optimal repair.” It is “uses a richer certified feasible-set
model, can exploit sequential unlocks, and separates a fast planner from a small correctness
checker.”

Stop if verification/capsule management consumes a meaningful fraction of recovery latency without
catching plausible failures, or if complete-port selection adds no material feasible plans.

### 7.3 Recovery digital twin and maintenance advisor — easiest standalone UI

Answer counterfactuals:

- What remains one-round or sequentially recoverable after these node/rack losses?
- Which stopping core remains?
- Which helper is pivotal, mandatory, or saturated?
- What is the repair ETA and client-I/O effect?
- Which shard move or bandwidth upgrade improves the joint reliability/capacity frontier?

This can ship before a runtime controller. Its differentiation from generic SRE/fault-tree tools is
automatic algebraic extraction and exact recovery semantics.

### 7.4 Proof-carrying search toolkit — research-led developer product

Provide a generic group-action augmentation API, step-book schema, certificate compactor, and Lean
checker generator. Users are computational mathematicians, code/design enumerators, verification
researchers, and potentially hardware/protocol-state teams.

This has the strongest methodological moat but the smallest obvious initial market. It is best
developed as an open research tool first.

### 7.5 LSSS/MPC linter — narrow, high-consequence tool

A CLI that hashes a representation, checks declared access/adversary structures, computes square
profiles, and emits positive or negative multiplicativity certificates. It may be valuable to
auditors and advanced threshold/secret-sharing implementers even if the user count is small.

### 7.6 Algebraic codec fuzzer — experimental developer tool

Start with short codes and injected decoder bugs. Its success criterion is simple: find failures or
pathological decoder cost with fewer tests than random/weight-stratified baselines. Without such a
result, keep it as a mathematical analysis feature of the Syndrome Atlas.

### 7.7 Protocol Capsule / QuorumLens — strong adjacent product

An offline linter and digital twin for phase-specific quorum policies: certify intersection and
epoch rules, calculate blockers and correlated availability, replay latency traces through the
exact quorum ETA expression, expose member shadow prices, and validate reconfiguration paths.

The initial product should not modify consensus. It should ingest a declarative configuration and
traces, find unsafe/stale policies and poor joint availability/latency choices, and emit a signed
capsule. Runtime adaptive selection comes only after the linter catches real bugs or makes better
counterfactual decisions than AWARE/WPaxos-style baselines.

### 7.8 Certified protocol symmetry reducer — highest broader-CS leverage

Package the StepBook generator/checker around finite distributed-protocol state spaces. A protocol
team gets symmetry reduction plus a replayable certificate that all successors and safety checks
were covered. This is likely a developer/research tool before a commercial product, but the value
proposition—smaller verification TCB without giving up symmetry performance—is unusually crisp.

### 7.9 Generated-proof build coordinator — practical formal-CI wedge

Profile Lean target families, schedule the dependency graph under a hard memory envelope, verify
content-trace freshness, snapshot reusable artifacts, and expose why a target rebuilt. The alt-orbit
case provides realistic stress data. Unlike the theorem products, this can be tested entirely on
existing formal repositories, but it requires a dedicated build-system prior-art audit.

### 7.10 Orbit-exchange lifecycle planner — longer horizon

Maintain safe alternative augmentation/replacement paths for a symmetric code or configuration.
Its theorem base is now substantial, but commercial priority remains low until a real codec,
protocol membership, or hardware configuration exhibits nontrivial orbit-valued exchange.

### Updated commercial ordering after the full scan

1. Equivariant Port Capsule + storage/recovery digital twin.
2. Proof-carrying storage repair controller.
3. Certified protocol symmetry reducer / generic StepBook toolkit.
4. Protocol Capsule / quorum configuration linter.
5. Resource-aware formal-proof CI coordinator.
6. LSSS/MPC linter and algebraic codec fuzzer.
7. Coded-gossip optimizer, contingent on beating RLNC/IDNC.
8. Orbit-exchange lifecycle planner.

The first two have the clearest operational buyer and direct theorem-to-system path. The third has
the strongest general-CS novelty. The fourth and fifth are credible adjacent tools. The remainder
need a sharper user corpus or a decisive benchmark before product work.

## 8. Broader paper portfolio

### Paper A — Complete bounded repair ports

The immediate B+/A− paper described in Section 1. Assemble this first because almost all theorem
work exists.

### Paper B — Sequential repair composition

Core: small-circuit Horn closure, exact stopping cores, scalar 2-sum messages, the fixed-width
finite-alphabet obstruction, finite structural terminal controls with integer weights, and the
infinite-carrier bottleneck-delay algebra with finite expression syntax.

Best broader positioning: compositional semantics for bounded-resource cyclic AND/OR recovery
systems. Required gate: a theorem beyond matroid 2-sums and a serious comparison with Datalog,
semiring provenance, weighted automata, dataflow, and abstract interpretation. Likely current grade
B+; A− ceiling if the abstraction genuinely generalizes.

### Paper C — PortPlan: a complete-recovery control plane

Contributions:

- matrix-to-capsule compiler;
- dynamic recovery-equation selection;
- sequential multi-erasure recovery;
- capacitated batch scheduling;
- proof-carrying plans; and
- a real HDFS or Ceph integration.

Evaluate RS, Azure-style LRC, layered/nonuniform LRC, and geometric/nonuniform examples across
single-shard, node, rack, and correlated failures. Compare conventional reconstruction, greedy
choice, ECPipe, RepairBoost-style RDAGs, SelectiveEC-style flow, and an offline MILP oracle. Measure
makespan, total/cross-rack bytes, helper imbalance, client tail latency, locally/sequentially
repaired fraction, controller time, capsule size, and verification time.

This has A− systems potential only if the combined planner produces large, robust gains. Today it
is an architecture, not a paper.

### Paper D — Proof-carrying symmetry-reduced search

Core: generic orbit step books with explicit transports, covering-list semantics, compositional
kernel verification, certificate compression, and the deliberate non-trust of canonical labels and
class counts.

Use q=16 arcs as the flagship and add a nongeometry benchmark such as graph/design generation,
small code catalogs, or symmetry-heavy protocol-state exploration. Compare with nauty-style
canonical generation and SAT/LRAT proof logging. This could be an A− formal-methods/constraint-
programming paper; the current single-domain artifact is more plausibly B/B+.

### Paper E — Algebraically extracted recovery fault models

Matrix/placement to BDD/ZDD, blockers, pivotality, stopping cores, cheapest radius, and capacity
prices. The paper must show that the extracted model changes real maintenance/placement decisions;
deletion--contraction or importance measures alone are not novel. B+/A− potential with a strong
SRE study.

### Paper F — Representation-aware LSSS audit

Access/support structure, coefficient holonomy, Schur square, deletion profiles, and explicit
positive/negative certificates. C237 is the clean motivating separation. A minimality theorem,
novelty audit, and custom-MSP corpus are the gates. Likely B/B+ specialist paper.

### Paper G — Algebraic hard-syndrome auditing and fuzzing

Unify the uncovered-locus evaluation detector, Syndrome Atlas, blocker structure, and square-rank
fingerprints. The headline must be an empirical audit win, not a repackaging of classical syndrome
decoding or square-code distinguishers. B/B+ potential if it reliably finds structured decoder or
design failures.

### Paper H — Resilient configuration synthesis by extension complexes

Unify repair alternatives, completion transversals, compatible extension faces, and alternate
symmetry-orbit upgrades. This is creative and mathematically coherent, but it needs a production-
relevant configuration family before it becomes more than a speculative algorithms paper.

The alt-orbit results materially improve this paper's foundation: it can now include a quantified
orbit-valued exchange phase diagram, a uniform 318-alternative theorem, the Q25 two-repair theorem,
and the factorized obstruction/collision anatomy. The missing ingredient is no longer mathematical
evidence that option-rich exchange exists; it is a nongeometry or deployed-code instantiation.

### Paper I — Certified symmetry reduction for distributed protocols

Use protocol-state exploration as the second StepBook domain. The paper contribution is an
untrusted high-performance symmetry reducer that emits explicit process-permutation transports and
successor-cover certificates checked by a small kernel. Evaluate safety properties for finite
Paxos/Raft, randomized consensus, cache coherence, or gossip models.

This may be stronger than a generic two-domain enumeration paper because the SOTA comparison and
assurance need are concrete. A− formal-methods potential if it retains useful state reduction with
moderate certificate overhead and catches mutations that existing symmetry assumptions miss.

### Paper J — QuorumCaps: verified adaptive quorum configuration

Unify phase-specific safety intersection, exact availability/blockers, min--max ETA, capacity
prices, and safe reconfiguration in one compiled artifact. The novelty cannot be any individual
quorum measure. It must be the proof-carrying joint compiler plus a demonstrated operational win
over Flexible Paxos/WPaxos/AWARE configurations. Currently a research architecture; B+/A− systems
potential if the evaluation is decisive.

### Paper K — Proof-certificate engineering at scale

Turn the existing registered methods idea into a tool paper: semantic mask factoring, bounded
generated shards, measured-memory DAG scheduling, content-trace freshness, restartable snapshots,
and trust-manifest aggregation. Compare with ordinary Lake builds and general content-addressed
build/cache systems on this repository and at least one external large Lean project. Likely B
practitioner/methods paper as a case study; higher ceiling requires a reusable tool and external
validation.

### Paper L — Behavioral reconstruction of codes

Combine Clebsch decoder-ambiguity reconstruction, hard-syndrome algebraic loci, continuation-complex
reconstruction, and coefficient identities. The desired theorem says when a code/representation is
recoverable from a decoder or legal-extension oracle and how stable the fingerprint is under noise.
Conceptually high upside and well beyond narrow geometry, but presently the most speculative paper
in the portfolio.

## 9. Prototype and falsification program

### Milestone 1 — capsule CLI

- parse small linear code matrices over prime and extension fields;
- enumerate/normalize circuits through targets up to radius three or four;
- output supports, coefficients, blockers, Horn rules, and hashes;
- independently verify every emitted equation; and
- use lazy schemas for uniform/MDS ports.

Correctness corpus: RS, Azure-style LRC, Ceph layered examples, all current q=9/q=16 artifacts,
random small matrices, and deliberately mutated coefficients.

### Milestone 2 — simulator and planner

- event-driven one-round/sequential closure;
- exact stopping core and earliest rounds;
- explicit recovery-set LP and dual prices;
- time-indexed MILP oracle on small instances;
- greedy and unlock-aware heuristics; and
- proof-carrying plan verifier.

The first decisive experiment is not a large cluster. Replay heterogeneous helper capacities and
correlated erasures on small realistic code layouts. Measure whether complete-port choice and
sequential reuse improve feasible repair fraction or oracle gap enough to warrant integration.

### Milestone 3 — reliability/digital twin

- BDD/ZDD back end and empirical correlated scenarios;
- blocker and pivotality reports;
- joint pivotality/shadow-price intervention ranking; and
- incremental module cache on repeated layouts.

Compare recommended interventions with availability-only, load-only, and manual configured-group
models.

### Milestone 4 — storage integration

Implement one controller path, preferably HDFS's custom-codec surface first. Keep physical slice
pipelining modular so an ECPipe-like executor can consume the selected plan. Only after trace and
testbed wins should a Ceph adapter be attempted.

### Independent track — generic StepBook library

Factor the q=16 certificate schema into a domain-independent group-action interface. Re-run the arcs
case unchanged, then add one nongeometry augmentation search. Measure:

- generated objects and search time;
- certificate bytes per retained child;
- verifier time and peak memory;
- trusted lines/components;
- mutation-detection coverage; and
- comparison with a CNF plus LRAT certificate when a reasonable encoding exists.

### Protocol benchmark track

Build two deliberately small prototypes before attempting consensus integration:

1. **Protocol-state StepBooks:** finite Raft/Paxos safety model with interchangeable replicas,
   explicit permutation transports, a deliberately buggy symmetry declaration, and an independent
   checker. Compare state count, certificate overhead, and caught mutations with plain and existing
   symmetry-reduced exploration.
2. **Quorum Capsule replay:** ingest phase-specific quorum rules and WAN latency/failure traces;
   verify intersections; compute exact ETA, blockers, and load; then compare its selected policies
   with majority, Flexible Paxos/WPaxos, and an AWARE-like weighted search.

These tests cheaply distinguish a real SOTA contribution from a restatement of classical quorum
theory.

### Coded-gossip falsification track

Simulate erasure-coded batches over a changing peer mesh with authenticated shards, correlated
peer loss, and heterogeneous links. Compare uncoded GossipSub-style spreading, RLNC/algebraic
gossip, IDNC, fixed erasure shards, and complete-port unlock-aware scheduling. Measure useful rank
per byte, time to reconstruct, fraction of peers reconstructing, controller/certificate bytes, and
stopping-core diagnostic accuracy. Stop if RLNC matches results at materially lower state cost.

### Formal-CI benchmark track

Replay the C143/C151 target families under fixed memory limits with default Lake scheduling,
manually capped workers, and an RSS-aware content-traced scheduler. Report wall time, peak aggregate
RSS, OOM/restart count, redundant target work, cache-hit validity, and recovery after interruption.
Then repeat on an external generated-certificate Lean repository before claiming generality.

## 10. Claim boundary

### Already proved or exactly certified

- weighted-functional transfer semantics and finite evaluators;
- prescribed finite ports in asymptotically good families;
- complete-port reliability identities and pointed-Tutte specialization;
- bounded sequential repair as small-circuit Horn closure;
- exact 2-sum composition and the finite structural/infinite timing boundary;
- capacitated service-region LPs and explicit examples;
- coefficient holonomy and representation-dependent MPC separation;
- the q=16 orbit-covering classification architecture;
- exact monomial transport of complete repair hypergraphs; and
- the alt-orbit robust-exchange phase theorem, uniform 318-alternative bound, and Q25 alternate
  repair theorem.

### Implementable derivations, not measured contributions

- the Port Capsule compiler;
- event-driven runtime closure;
- BDD/ZDD recovery models;
- proof-carrying repair plans;
- unlock-aware LP/MILP scheduling;
- boundary-summary caches;
- the MPC linter;
- the Syndrome Atlas/fuzzer;
- equivariant capsule compression and vector-valued pointed syndrome tables;
- factorized obstruction-mask search and resource-aware formal CI;
- Protocol/Quorum Capsules and proof-producing protocol symmetry reduction; and
- code-aware gossip planning with authenticated coding vectors.

### Speculative until tested or generalized

- superiority over HDFS/Ceph/ECPipe/RepairBoost/SelectiveEC/LESS;
- a useful approximation guarantee for unlock-aware scheduling;
- a general non-matroid workflow algebra;
- noisy continuation-graph reconstruction;
- commercially useful extension-complex migration;
- a generic proof-carrying orbit-search advantage over SAT/LRAT or mature canonical generators;
- an operational advantage over adaptive quorum systems such as AWARE/WPaxos;
- a coded-gossip advantage over RLNC/IDNC;
- general consensus reconfiguration from the special alt-orbit exchange theorem; and
- noisy behavioral reconstruction of codes from decoder/extension oracles.

## 11. Full-portfolio audit disposition

This report was checked against:

- every current paper abstract/README and every theorem/result row in
  [`papers-index.md`](../papers/papers-index.md);
- the legacy `repaircodes` and arcs Discovery Track registers;
- the standalone `repairports` and `rp-next` discovery logs;
- the C115 twisted-cubic cross-lane log and its Fable/Opus review;
- the `alt-orbit-repair` handoff/archive and C142/C143/C148/C149/C150 reports; and
- the relconic C201/C210 mechanism notebooks, including negative searches.

The audit promoted five things that the first repair-only pass understated:

1. equivariant compilation should be part of the core Port Capsule;
2. pointed syndrome tables are a multiobjective compilation problem, not one table per target;
3. alt-orbit exchange supplies a serious theorem base for configuration lifecycle repair;
4. factorized obstruction masks and resource-aware proof builds are reusable systems machinery; and
5. decoder ambiguity plus continuation structure suggests behavioral reconstruction of codes.

It also demoted several tempting directions. The five-weight cubic-axis code is a strong certified
family but modest algorithmic leverage; generic completion/transversal APIs are classical; ordinary
mirror strategies, bitset CSP indexes, fault-tree BDDs, quorum load/availability, network coding,
and symmetry reduction are established; and the q=64 construction notebooks currently supply
search guidance rather than a product path.

None of the added sources changes the immediate publication grade. The best paper assembleable now
from `repaircodes` plus complete-port material remains B+ with an A− ceiling. The widened audit does
raise the ceiling of two *future* broad-CS projects: certified protocol symmetry reduction and a
proof-carrying complete-recovery control plane.

## Final recommendation

Proceed on four deliberately different horizons:

1. **Publication now:** assemble the focused complete-repair-ports paper at the B+/A− level. Keep
   sequential composition and holonomy/MPC separate.
2. **Commercial validation next:** build the matrix-to-Capsule CLI, closure simulator, LP/MILP
   benchmark, and plan verifier before attempting a storage data-path integration.
3. **Broad-CS research:** extract the arcs StepBook architecture into a generic proof-carrying
   orbit-search library, using finite distributed-protocol model checking as the preferred second
   domain.
4. **Adjacent systems scout:** build an offline Quorum Capsule trace replay before modifying any
   consensus or gossip implementation.

If only one implementation is funded, choose the **Port Capsule CLI plus digital twin**: it is the
smallest artifact that can falsify the commercial thesis and is reusable by the runtime controller,
systems paper, reliability paper, MPC audit, and code-policy synthesis. If only one high-upside
methodology paper is pursued, choose **proof-carrying symmetry-reduced search**: it is the clearest
idea in the wider portfolio whose significance is not confined to coding theory or finite geometry.
For that methodology paper, protocol-state symmetry is now the best second benchmark because it
tests both practical state reduction and a concrete trusted-computing-base improvement.
