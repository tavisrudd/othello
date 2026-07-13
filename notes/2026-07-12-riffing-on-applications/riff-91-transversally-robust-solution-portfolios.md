# Transversally robust solution and portfolio families

Status: exploratory paper agenda  
Primary source: `RIFF_91`–`RIFF_94`, `RIFF_103`, `RIFF_104`, `RIFF_181`, `RIFF_182`, `RIFF_194`,
`RIFF_195`  
Existing mathematical base: matching/transversal inequalities and completion hypergraphs

## Mathematical spine

- [`MATH_10`](math.md#math_10--robust-solution-family-iff-τ--f) — a solution family survives every
  `f`-failure set exactly when its transversal number exceeds `f`.
- [`MATH_11`](math.md#math_11--finite-double-oracle-termination-and-correctness) — finite exact
  solution/cut oracles give termination and a global certificate.

## Thesis

Syntactically diverse feasible solutions can remain vulnerable to one shared resource failure. An
optimizer should return a family of acceptable solutions whose dependency hypergraph has a large
minimum transversal, together with adaptive recourse policies. This is a different objective from
distance-based diverse-solution generation and from robustness of one fixed solution.

## Minimum publishable contribution

1. Define transversal robustness for a family of feasible or near-optimal solutions.
2. Give a double-oracle or column-generation algorithm alternating solution generation with minimum
   shared-disruption search.
3. Establish at least one approximation, termination, or finite optimality result.
4. Show on one standard OR domain that distance diversity and transversal robustness rank solution
   pools differently.

Public-market portfolios may serve as motivation or a later case study, but should not be the only
benchmark or imply an alpha result.

## Research agenda

### Phase 1 — Formal model

- Separate decision variables from causal failure domains.
- Define acceptable objective gap, solution family, and dependency projection.
- Compare `ν`, `τ`, pairwise distance, entropy, and scenario coverage.
- Define static portfolios and adaptive `exists/forall/exists` recourse packets.

### Phase 2 — Algorithms

- Master problem over selected solutions and current cuts.
- Adversarial minimum-transversal subproblem.
- Pricing oracle for a new acceptable solution avoiding the current cut.
- Bounds and stopping criteria when exact pricing is unavailable.

### Phase 3 — Benchmarks

Choose one primary domain with explicit dependencies:

- routing with shared-risk link groups;
- machine scheduling with common failure domains;
- supply allocation with upstream suppliers;
- service-chain placement.

Include synthetic controls where raw diversity can be inflated without changing `τ`.

### Phase 4 — Recourse

- Compare a robust solution pool with a primary decision plus adaptive repairs.
- Measure objective cost, minimum cut, repair cost, and family size.
- Identify when packetized recourse dominates dedicated backups.

## Paper spine

1. **Introduction:** many alternatives can share one point of failure.
2. **Model:** acceptable solutions and dependency hypergraphs.
3. **Transversal robustness and relation to diversity metrics.**
4. **Double-oracle algorithm.**
5. **Recourse packets.**
6. **Benchmark evaluation.**
7. **Sensitivity to dependency-model error.**
8. **Extensions:** portfolio construction and multistage optimization.

## Shallow literature and novelty check

Closest precedents found:

- Diverse near-optimal MIP solution generation is established, including
  [DiversiTree](https://doi.org/10.1287/ijoc.2022.0164) and earlier pairwise-distance selection
  methods.
- Recoverable robust optimization explicitly models bounded second-stage repair; see
  [Recoverable Robust Optimization with Commitment](https://arxiv.org/abs/2306.08546).
- Shared-risk resource groups are mature in survivable routing; SRLG-disjoint path models already
  encode common-cause failures, for example
  [Redundant multicast routing in multilayer networks with shared risk resource groups](https://doi.org/10.1016/j.cor.2009.12.009).

Preliminary verdict: **adjacent and crowded, but the family-level objective may be distinct**. The
paper cannot claim novelty for diverse solutions, recourse, or shared-risk modeling. It must isolate
the optimization of the transversal number of an *acceptable solution family*, show that this is not
equivalent to existing survivable/recoverable formulations, and give an algorithmic or approximation
result beyond applying a generic hitting-set loop.

Required deeper audit:

- `k`-adaptability and solution-pool robustness;
- interdiction, survivable network design, and maximum-coverage/hitting-set dual formulations;
- diversity metrics defined over shared attributes rather than decision-vector distance.

## Kill criteria

- The formulation is equivalent to a standard survivable-design model after a simple translation.
- The dependency projection is too subjective to benchmark reproducibly.
- Minimum-transversal computation dominates without a usable oracle or approximation.
- Distance-diverse baselines already achieve the same resilience on non-contrived instances.
