# C238 scratchpad — repair-port algorithms, products, and broader papers

**Lane:** `rp-next`
**Date:** 2026-07-17
**Status:** WORKING NOTES. Evidence and architecture are being accumulated here before the final
report at `2026-07-17-c238-repairports-commercial-algorithms.md`. Claims marked *candidate* require
implementation, benchmarking, or a broader prior-art audit.

## Seed: paper-material assessment from the preceding review

The completed work is too large and too heterogeneous for one mega-paper. The defensible portfolio
is:

| Package | Material | Current verdict |
|---|---|---|
| Existing complete-repair-hypergraphs paper | `repaircodes`, exact concatenation transfer, weighted obstruction, twisted-cubic flagships and asymptotic lifts | Keep focused; assembled strong specialist paper |
| Complete repair ports | C215--C220 and C226--C227, with selected C235 examples | Full follow-up paper |
| Sequential repair composition | C229--C234, with C236 as flagship applications | Strongest new stand-alone theory core |
| Holonomy and MPC | C217, C228, C237 | Potential short high-concept paper/note; specialist novelty audit still needed |

The best combined `repaircodes`/complete-ports paper is likely **B+ overall with a credible A-minus
ceiling**, not A/A+. Its optimal spine is:

1. complete pointed repair ports;
2. the exact weighted-functional obstruction and sharp concatenation transfer;
3. the natural strict example beating the ordinary support-distance gate;
4. C216 prescribed-port realization in asymptotically good fixed-alphabet families;
5. reliability/radius-truncated EXIT and the pointed-Tutte identification; and
6. twisted-cubic and quartic-nucleus ports as contrasting infinite flagships.

Likely post-assembly grades: significance B+, novelty B+, surprise B/B+, audience B+/A-minus,
readiness A-minus, rigor A-minus. The route to the ceiling is ruthless synthesis and a specialist
novelty audit, not adding every result. C229--C234 should remain a second paper; merging it would
hurt coherence.

## Commercial thesis

The strongest commercial object is not yet another erasure code. It is a **repair control plane**
that knows *all* bounded recovery equations and can answer four questions existing systems usually
treat separately:

1. Which recovery equation should be used under the current topology, failures, and load?
2. In what order should multiple missing fragments be reconstructed when repaired fragments can
   become helpers?
3. Which helpers are true capacity/reliability bottlenecks across concurrent jobs?
4. Which exact local recovery behavior survives when an inner code is composed with a scalable
   outer code?

The mathematical work supplies exact semantics and certificates for those questions. It does **not**
yet supply a production implementation or measured speedup. Every product claim therefore needs a
benchmark gate.

## Candidate core data structure: the Repair Port Capsule

Compile each code/version/target into an immutable, signed metadata capsule:

```text
PortCapsule {
  code_id, field, target,
  minimal recovery supports + normalized coefficients,
  support antichain index,
  blocker antichain index,
  helper-to-support reverse incidence,
  functional-cost and pointed-cost tables,
  optional reliability decision diagram,
  bounded Horn rules and reverse rule incidence,
  boundary transfer control/profile DAGs,
  coefficient-holonomy cycle fingerprint,
  Schur-square ranks and MPC audit results,
  proof/certificate hashes
}
```

Representation choices:

- explicit packed support lists for small ports;
- ZDD-like antichain storage for large sparse support families;
- a BDD for exact Boolean reliability and reverse-mode influences;
- lazy circuit/pricing oracles when explicit recovery-set enumeration is too large;
- hash-consed `min` / budgeted-`max` / delay expression DAGs for synchronous timing;
- canonical finite boundary-control tables for repeated components of bounded interface width.

Worst-case exponential size is unavoidable: circuit enumeration, minimal blockers, reliability,
and minimum-distance/coset-leader problems are hard in general. The practical regime is fixed small
repair radius, fixed inner codes, repeated deployment, and offline compilation amortized over many
objects and failures.

## Algorithms available now or one implementation step away

### A1. Functional-cost compiler

From C215 / `repaircodes`:

- Scan the `|F|^k` inner ambient blocks once.
- Key a table by the represented outer-symbol functional.
- Store two minima per key: ordinary fiber cost and cost constrained nonzero at the target.
- Evaluate zero-functional, singleton-functional, and multisupport outer obstruction strata from
  the cache.
- Certify the exact first nonembedded witness threshold and whether complete bounded repair ports
  survive concatenation.

This replaces exhaustive `|F|^(b k)` block-family search by one inner scan plus an outer functional
tuple scan (at most `|V*|^b`). The evaluator is kernel-checked but has no extracted executable or
wall-clock benchmark yet.

Commercial use: an offline code-policy compiler that rejects an outer code/profile which silently
introduces cheaper cross-block repairs, or certifies that a chosen local recovery policy will remain
exact after scaling.

### A2. Complete recovery-set extractor and antichain index

Input a generator/parity-check matrix and locality radius `r`:

1. Enumerate dependencies/circuits through each target up to size `r+1`, or call a lazy circuit
   oracle.
2. Solve and normalize each linear repair equation.
3. Delete nonminimal supports to form the clutter.
4. Index supports by target, helper, cost, rack/failure domain, and coefficient fingerprint.

For fixed `r`, naive subset enumeration is polynomial in `n` with exponent depending on `r`; it is
not a scalable arbitrary-radius algorithm. Meet-in-the-middle, syndrome tables, and code-specific
geometry can accelerate the offline phase.

Commercial use: expose every legal low-read repair, not merely one configured repair group. Query
by live helper set, bytes, cross-rack count, energy price, trust domain, or current load.

### A3. Event-driven sequential repair engine

C229 turns every circuit `C` of size at most `r+1` into implications `(C-{e}) -> e`.
Precompile each rule with:

- an unsatisfied-body counter;
- reverse incidence from helper to rules;
- target and recombination coefficients.

Given surviving fragments, queue the initial facts, decrement affected counters once, and fire a
rule when its body becomes available. This computes the order-independent bounded sequential
closure and exact stopping core. With explicit rules, the straightforward forward pass is linear in
total rule-literal incidence. Bucketed levels or a priority queue additionally compute earliest
synchronous arrival times.

Commercial use: recover correlated erasures that a one-round/local-group controller declares
unrepairable, while returning an explicit dependency schedule and proof for every step.

### A4. Port reliability and hardening engine

C219 supplies exact deletion--contraction, blockers, and pivotal derivatives. Implement with a
memoized decision diagram:

- exact repair probability under independent heterogeneous helper survival;
- exact evaluation under an empirical correlated failure distribution;
- minimum blockers and high-survival failure asymptotics;
- every helper's pivotal/Birnbaum influence;
- cheapest available repair-radius distribution from C226.

Commercial use: risk-rank nodes/racks, choose where to add redundancy, prioritize scrub/health
checks, and quantify the availability effect of maintenance before taking a node offline.

Novelty warning: BDD fault-tree evaluation and Birnbaum importance are established reliability
engineering. The new engineering value is automatic extraction of the *correct recovery Boolean
function from a code matrix*, including every repair alternative and sequential stopping core.

### A5. Capacitated multi-target scheduler

C235's service region is a recovery-set packing LP. For targets `t`, recovery sets `A`, helper
capacities `c_u`, and rates/jobs `x_(t,A)`:

```text
sum_A x_(t,A) = demand_t,
sum_(t,A: u in A) x_(t,A) <= c_u.
```

The primal schedule assigns repair work; dual helper prices identify bottlenecks. Avoid explicit
columns through column generation when a weighted minimum-repair-set oracle exists. General
pricing is hard; bounded radius or precompiled ports make it practical.

Commercial use: schedule a rack/node failure across many stripes without overloading a shared
helper. Feed dual prices into source selection, throttling, and placement redesign.

Creative derived control score (candidate, not yet a theorem):

```text
upgrade_value(u)
 = availability_value * pivotal_influence(u)
 + congestion_value * helper_shadow_price(u)
 - hardware/network/energy cost(u).
```

This combines stochastic criticality with capacity scarcity, which are normally optimized
separately.

### A6. Boundary-summary cache for modular codes

C231--C234 support a compositional cache for layouts assembled along small interfaces:

- one-round/terminal behavior passes truncated certificate costs;
- terminal closure has a finite monotone boundary-control table for fixed radius/interface width;
- active/core counts are passive integer weights evaluated at the boundary fixed point;
- exact timing uses budget-indexed arrival profiles over an infinite carrier but finite expression
  syntax;
- alternatives use `min`, simultaneous prerequisites use `max` with helper-budget convolution,
  and a Horn round adds one delay.

Store each repeated component once, canonicalize its structural control table, and reuse it across
a tree decomposition. Store timing as a hash-consed expression DAG rather than expanding every
delay value.

Commercial use: fast what-if analysis for repeated rack/pod/code modules, incremental recomputation
after a local failure, and exact recovery ETA without flattening the whole global dependency graph.

No FPT/runtime claim is currently justified: realizable-control construction, decomposition input,
and circuit-list production still need algorithms and benchmarks.

### A7. Representation-aware LSSS/MPC linter

From C217/C228/C237:

1. compute a cycle-basis holonomy fingerprint of circuit coefficients modulo circuit and coordinate
   gauge;
2. compute the quadratic Veronese/Schur-square representation;
3. for each dealer and declared adversary deletion, test whether the dealer square lies in the span
   of surviving participant squares;
4. output recombination vectors on success and a rank/covector counterexample on failure.

Commercial use: preflight custom monotone-span-program/linear-secret-sharing deployments. An access
structure alone does not determine strong multiplicativity: C237's two `U(3,8)` realizations have
the same `3-of-7` access structure but different MPC capability.

This is an auditing tool, not a cryptographic security proof. Existing MPC frameworks such as
MP-SPDZ expose optimized Shamir and replicated protocols; the opportunity is an external linter for
custom/general-access-structure matrices rather than a claim that existing threshold protocols are
wrong.

## Highest-value commercial products, ranked

### P1. Port-aware repair control plane — highest confidence

An offline compiler plus online scheduler for HDFS/Ceph-compatible erasure-coded stores:

- compile complete bounded recovery sets and coefficients;
- choose a Pareto-optimal equation under live topology/load;
- execute sequential recovery when repaired shards can unlock others;
- solve/approximate the multi-target capacity LP;
- produce a recombination certificate and recovery ETA;
- update blocker risk and helper prices continuously.

Why plausible: HDFS's documented EC worker reads the minimum number of input blocks and decodes all
missing blocks together; its scheduling weight is based on max(read streams, write streams).
Ceph exposes recovery priorities/QoS and has documented layered LRC decoding that walks configured
steps. These are real integration surfaces. The proposal adds algebraic option discovery and
target/helper-level optimization beneath existing admission/QoS controls.

### P2. Erasure-code policy compiler and deployment preflight — high confidence

Given code matrices, topology, failure domains, workload, and SLO:

- certify locality/availability/complete-port transfer;
- compute blockers, expected read amplification, and bottleneck helpers;
- compare profiles before a pool is created;
- synthesize a signed Port Capsule shipped with the codec.

This is attractive for storage appliances, archival/backup vendors, and managed Ceph because EC
profiles and placements are expensive to change after deployment. It can begin as an offline tool,
avoiding a risky production data-path integration.

### P3. Recovery digital twin for SRE/capacity planning — medium-high confidence

Import code matrices and placement, then answer correlated-failure and maintenance questions:

- What remains locally/sequentially recoverable after losing these hosts/racks?
- Which stopping core remains?
- Which helper becomes mandatory or saturated?
- What is the expected recovery makespan and client-I/O impact?
- Which hardware/network upgrade buys the most availability?

The differentiator from generic fault-tree products is algebraic model extraction plus exact
repair semantics. BDD/influence computation itself is prior art.

### P4. General-access-structure MPC linter — medium confidence, narrower market

Useful to MPC/threshold-signature vendors, protocol auditors, and research compilers. Start as a
certificate-generating CLI. General adversary enumeration can be exponential, but declared minimal
adversary families or bounded threshold `t` are tractable.

### P5. Redundant workflow/dependency engine — speculative but broad

Generalize repair circuits to cyclic AND/OR recovery rules:

- alternatives compete by `min`;
- simultaneous prerequisites synchronize by `max`;
- bounded resources convolve;
- cyclic dependencies use least fixed points;
- modules expose finite terminal controls and symbolic timing profiles.

Possible workloads: disaster-recovery runbooks, build/deployment fallback plans, supply-chain
substitution, service remediation, and data-pipeline recomputation. This could beat generic Datalog
or full-graph recomputation on repeated small-boundary modules, but only after a non-matroid
semantics theorem and benchmark. Do not market this yet as a proven general workflow improvement.

## Existing systems/research that could be substantially improved

### HDFS ECWorker

Current documented baseline: the NameNode selects a recovery DataNode; the worker reads the minimum
number of input blocks in parallel, decodes missing data/parity together, and uses configurable
thread/stream weights. HDFS supports self-defined codecs.

Candidate improvement:

- replace "a minimum-size input set" with a complete-port oracle choosing among all legal equations
  by rack traffic, source load, failure correlation, and expected downstream utility;
- invoke sequential Horn recovery for multi-erasure cases;
- use LP dual prices instead of only stream counts for helper contention;
- hand the selected dependency DAG to ECPipe-style slice pipelining.

### Ceph

Current official surface: EC profiles choose code/plugin/failure domain; recovery/backfill has pool
priorities, active-request caps, and mClock QoS. The documented LRC plugin uses configured layers and
reverse traversal to reconstruct missing chunks.

Candidate improvement:

- compile all small recovery circuits rather than following only configured layer order;
- choose a valid sequence dynamically under current OSD/rack availability;
- expose stopping-core diagnostics when local recovery cannot finish;
- choose helper sets using OSD shadow prices while leaving mClock to arbitrate client versus
  recovery I/O.

### MinIO and ordinary Reed--Solomon stores

MinIO documents erasure sets, quorum, and healing from available data/parity shards. For an MDS
code, the complete port can be huge and symmetric, so explicit support storage is wrong; use a lazy
"choose any `k`" oracle. Value comes from topology/load-aware source choice and batch scheduling,
not a new algebraic repair capability.

### ECPipe / RepairBoost / SelectiveEC / LESS

- ECPipe optimizes slice transmission after choosing helpers. A port oracle improves the recovery
  equation/helper choice first; the two stages compose.
- RepairBoost's RDAG represents a single-chunk repair solution and balances its tasks. Supply a
  Pareto family of certified RDAGs and select jointly across stripes.
- SelectiveEC uses max flow for balanced single-failure reconstruction. Replace fixed feasible
  source choices with recovery-set hyperedges, extend to correlated multi-target failures, and add
  sequential reuse.
- LESS improves the physical code/sub-stripe layout for I/O-efficient single repair. Complete-port
  scheduling is complementary: exploit every equation the resulting code actually provides.

No speedup is claimed until these combinations beat their published implementations.

### Fault-tree/BDD reliability products

Substantial improvement is possible in model fidelity, not in claiming a new BDD algorithm:

- generate the repair success Boolean function directly from the code;
- keep shared-helper correlations visible;
- distinguish one-round, sequential, and full-span recovery;
- generate minimum blockers/cut sets and influences automatically;
- combine probability criticality with service-capacity shadow prices.

### Datalog/differential-dataflow engines

Small-circuit Horn closure is ordinary recursive inference, and high-performance/incremental Datalog
is established. The possible improvement is specialized compilation for bounded bodies, symmetric
circuit rules, and reusable small-interface component summaries. Benchmark against Souffle and a
differential-dataflow implementation; do not claim general superiority.

## Broader-CS paper packages

### S1. Systems paper: PortPlan / Complete-Recovery Control Plane

Core contribution: a storage prototype integrating complete recovery-set compilation, dynamic
helper selection, sequential recovery, and capacitated batch scheduling.

Evaluation:

- HDFS self-defined codec first; Ceph adapter second;
- RS, Azure-style LRC, Ceph layered LRC, and several nonuniform linear codes;
- single shard, full node, rack, and correlated multi-shard failures;
- homogeneous and heterogeneous bandwidth/I/O;
- compare HDFS conventional reconstruction, greedy helper selection, ECPipe, RepairBoost-style
  RDAG scheduling, SelectiveEC-style flow, and an offline ILP oracle;
- measure recovery makespan, bytes and cross-rack bytes, read/write load imbalance, client tail
  latency, fraction repaired locally/sequentially, controller time, and capsule size.

This is the best route beyond narrow mathematics and the strongest commercial proof point.

### S2. PL/algorithms paper: Compositional Recovery Algebras

Seed with C229--C234, but state it for a class of bounded-resource cyclic AND/OR rule systems:

- exact small-separator composition;
- no finite timing alphabet;
- finite terminal structural quotient with weighted outputs;
- infinite-carrier budgeted bottleneck dioid with finite recursive syntax;
- associative least-fixed-point composition.

The hard gate is generalization beyond matroid 2-sums and positioning against Datalog,
dataflow/semiring provenance, weighted automata, and abstract interpretation.

### S3. Reliability/SRE paper: Algebraically Extracted Recovery Fault Models

Build a tool that converts code matrices and placement into BDD/ZDD recovery models, exact
influences, stopping cores, and capacity bottlenecks. The research contribution must be the
automatic algebra-to-risk pipeline and a demonstrated decision improvement, not deletion--
contraction or Birnbaum importance.

### S4. Security engineering paper: Representation-Aware LSSS Audit

Tool plus theory:

- access structure and circuit port;
- coefficient gauge/holonomy canonicalization;
- Schur-square fingerprint;
- ordinary and strong multiplicativity certificates;
- C228 rank-two negative boundary and C237 `U(3,8)` positive separation.

Benchmark on generated/custom MSPs and integrate as a preflight mode beside an MPC framework. A
specialist novelty audit and a minimality theorem would materially strengthen it.

### S5. Code-policy synthesis paper: Compile Local Recovery into Global Codes

Turn C215/C216 from existence/reference evaluation into a finite tool:

- input a desired local port and deployment constraints;
- search inner representations and outer codes;
- use functional-cost tables to prune invalid compositions;
- output a finite code, exact port certificate, rate/distance, and deployment metadata.

Commercially ambitious and mathematically central, but it needs finite-length optimization and
benchmarks; the asymptotic realization theorem alone is not a product algorithm.

## Primary baselines already checked

- [Apache HDFS erasure coding documentation](https://hadoop.apache.org/docs/current/hadoop-project-dist/hadoop-hdfs/HDFSErasureCoding.html): ECWorker reconstruction, source reads, configurable codecs and recovery weights.
- [Ceph erasure-code documentation](https://docs.ceph.com/en/latest/rados/operations/erasure-code/): profiles, code parameters, and failure domains.
- [Ceph LRC plugin documentation](https://docs.ceph.com/en/nautilus/rados/operations/erasure-code-lrc/): layered encoding and reverse-step recovery example.
- [Ceph recovery/backfill controls](https://docs.ceph.com/en/latest/rados/operations/placement-groups/): pool/PG priority controls.
- [MinIO erasure coding](https://min.io/docs/minio/linux/operations/concepts/erasure-coding.html): erasure sets, quorum, and healing.
- [Azure LRC production paper](https://www.microsoft.com/en-us/research/wp-content/uploads/2016/12/LRC12-cheng-webpage.pdf): production motivation and I/O/bandwidth reductions.
- [ECPipe](https://arxiv.org/abs/1908.01527): slice-level pipelining and heterogeneous/multi-block repair.
- [RepairBoost](https://www.usenix.org/system/files/atc21-lin.pdf): RDAG scheduling and load balancing.
- [SelectiveEC](https://www.usenix.org/system/files/hotstorage20_paper_xu.pdf): max-flow-based source/replacement balancing for single-failure recovery.
- [LESS](https://www.usenix.org/conference/fast26/presentation/cheng): current I/O-efficient code/layout baseline.
- [MP-SPDZ](https://github.com/data61/MP-SPDZ): practical fixed-protocol MPC framework baseline.
- [Souffle](https://souffle-lang.github.io/pdf/cav16.pdf) and [differential Datalog](https://arxiv.org/abs/2308.04214): recursive/incremental Horn evaluation baselines.
- [BDD fault-tree importance](https://doi.org/10.1016/S0951-8320(01)00004-7): established exact reliability/importance baseline.

## Evidence ladder and immediate next research actions

1. **Proved semantics:** functional costs, port transfer criteria, reliability identities, Horn
   closure, 2-sum composition, terminal controls, delay algebra, service LP, LSSS square criterion.
2. **Verified finite artifacts:** all task certificates already committed.
3. **Implementable but unbenchmarked:** capsule compiler, event-driven closure, BDD reliability,
   LP scheduler, LSSS linter.
4. **Research prototypes needed:** HDFS/Ceph adapter, boundary-summary engine, finite code-policy
   synthesis.
5. **Speculative generalizations:** non-matroid workflow algebra and general SRE dependency engine.

Highest-value implementation sequence:

```text
matrix -> Port Capsule CLI
       -> failure/closure/reliability simulator
       -> multi-target LP scheduler
       -> HDFS self-defined-codec/controller prototype
       -> trace/testbed comparison with ECPipe/RepairBoost/SelectiveEC baselines
```

The fastest falsification test is small: compile standard RS/LRC matrices, replay real-ish
heterogeneous helper capacities and correlated failures, and measure whether complete-port choice +
sequential reuse improves the feasible repair fraction or LP makespan over fixed/minimum-input
reconstruction enough to justify systems integration.

## Additional exportable machinery from the other paper packages

The user explicitly widened the read-only idea pool beyond repair work, beginning with
`arcs_complete_outside_conic`. These are additional candidates; they do not change the ownership of
the source paper lanes.

### A8. Proof-carrying orbit-reduced enumeration

The q=16 arcs classification uses a commercially interesting verification architecture:

1. a fast untrusted C++ generator normalizes a four-frame, performs symmetry/canonical reduction,
   and emits covering lists at successive augmentation depths;
2. every parent/child transition carries an explicit invertible projective transformation and
   pointwise scalar witnesses;
3. local certificates prove that every legal child is represented in the next covering list;
4. a small trusted Lean checker composes the layers and transports an arbitrary input to a listed
   leaf;
5. downstream properties are checked at the leaves without trusting canonical labels,
   deduplication, or the generator's class count.

This pattern is broader than arcs: **proof-carrying canonical augmentation** for finite search.
Potential uses include code/design catalogs, finite protocol-state exploration, hardware test-vector
classification, and symmetry-heavy configuration synthesis. It sits between conventional
canonical-generation tools and SAT/SMT proof logging: the certificate explains orbit coverage by
explicit transports rather than trusting the canonicalizer.

Broader-CS paper candidate: formal methods / constraint programming paper comparing certificate
size, verifier time, trusted code base, and search overhead against an uncertified canonical search
and a SAT/DRAT encoding. The q=16 `4 -> 61 -> 454 -> 2633` step books are a strong case study.

### A9. Low-degree uncovered-locus / syndrome anomaly detector

The arcs paper's evaluation obstruction is algorithmic. Given:

- a finite point/syndrome set `U` left uncovered by pair combinations; and
- a feature map `phi` (quadratic/Veronese or arbitrary finite-dimensional features),

form the evaluation matrix `phi(U)`. Its kernel is exactly the family of low-complexity algebraic
models containing the anomaly locus. Rank growth gives either a model equation or a certificate
that no nonzero model in the chosen feature class contains all anomalies while avoiding the base
configuration.

Potential uses:

- flag parity-check matrices whose hard/deep-hole syndromes collapse onto a low-degree variety;
- generate adversarial decoder test suites concentrated on structured hard syndromes;
- screen code-based cryptographic candidates for unexpectedly algebraic failure loci;
- detect whether missed cases in a finite test/configuration campaign share a low-degree feature
  explanation.

This is presently a research/audit tool, not a new generic anomaly-detection algorithm. The value is
the exact finite-field certificate and direct tie to coset-leader/deep-hole structure.

### A10. Syndrome-ray and extension-complex atlas

The q=11 arcs package normalizes every nonzero syndrome to a projective ray, records exact
coset-leader distance and multiplicity, and builds the independence complex of simultaneous legal
column extensions. Generalize this into a short-code atlas:

```text
SyndromeAtlas {
  projective ray representative,
  minimum coset-leader weight,
  number/supports of minimum leaders,
  algebraic-locus tags,
  valid code-extension neighbors/facets
}
```

Uses: exhaustive decoder validation, worst-case syndrome test generation, safe code extension, and
identifying extension choices that preserve MDS/local-repair constraints. Commercial relevance is
narrow but concrete for codec verification and code-design tooling.

### A11. Collision-aware pair-coverage optimizer

The prescribed-hole defect identity exactly decomposes pair-generated coverage into useful coverage,
duplicate collisions, and exceptional-locus capacity. This suggests a branch-and-bound/search
heuristic for saturating sets and short covering codes:

- reward newly covered syndrome/projective directions;
- charge exact collision redundancy rather than a loose union bound;
- retain a residual lower bound from the defect identity;
- prune when remaining pair capacity cannot cover the prescribed complement.

Possible adjacent applications are pairwise test-suite generation and two-resource coverage designs,
but those mappings require separate semantics and benchmarks. The immediate credible application is
faster finite-geometry/code search.

### A12. Robust completion and alternate-extension planner

The completion-core and Frobenius-pair packages provide a general design-resilience layer:

- completion distance equals a circuit/extension transversal number;
- deletion robustness asks how many existing elements must be lost before no legal completion
  remains;
- the equivariant arc result counts legal Galois-orbit additions with an exact invisible/collision
  correction;
- alternate-repair theorems certify that deleting a selected orbit leaves many replacement orbits.

Data structure: an **Extension Complex** whose vertices are legal augmentations and whose faces are
simultaneously compatible augmentations, augmented with blocker/transversal data and symmetry-orbit
labels. This is the same antichain/robustness technology as repair ports applied to design evolution.

Potential product use: resilient code/configuration migration—precompute alternate parity columns or
symmetry-compatible upgrades before retiring a device/field orbit. Practical value depends on a
finite code family used in real systems; the current Q25 result is a mathematical demonstration,
not a deployed-code proposal.

### A13. Continuation-graph fingerprinting and reconstruction

The continuation-rigidity package shows that, in its proven regime, the abstract graph/complex of
legal extensions recovers the ambient semilinear geometry and original cap. This suggests:

- canonical fingerprints for finite codes/designs derived from compatibility rather than raw
  coordinates;
- equivalence/deduplication without exposing a chosen coordinate gauge;
- tamper detection: a modified compatibility graph that no longer reconstructs the expected
  geometry is a structural integrity failure;
- black-box reverse engineering from a legal-extension oracle.

This is promising for a graph reconstruction/canonicalization paper. Commercial use is speculative
until reconstruction algorithms and noise stability are developed; the present theorems are exact,
not robust-to-noise learning results.

### A14. Symmetry-certificate preprocessing for combinatorial games

The Nofil and dihedral Node-Kayles packages contribute two reusable solver ideas:

- search for fixed-point-free involutions that certify a pairing/mirror strategy before exploring
  the game tree;
- quotient residual conflict graphs by Schreier/Cayley symmetry, then compute and independently
  certify nimbers on the small templates.

These can improve impartial-game/puzzle solvers and provide hard, symmetry-rich benchmarks for
game-graph verification. The mapping to production scheduling or independent-set optimization is
too indirect for a near-term commercial claim.

## Additional broader-CS paper candidates from the widened portfolio

### S6. Proof-Carrying Symmetry-Reduced Search

Combine the arcs step-book architecture with the repository's certificate-first finite checkers.
Headline: an untrusted high-performance canonical augmentation engine emits explicit group-action
coverage witnesses checked by a small proof assistant kernel; correctness does not trust
canonical labels or class counts.

This may have broader CS reach than any single geometry theorem. Required work: generic certificate
schema/library, second nongeometry benchmark, comparison with SAT proof logs and nauty-style
canonical generation, and measurement of search/certificate/checking overhead.

### S7. Algebraic Hard-Syndrome Auditing for Linear Codes

Combine the arcs evaluation-rank detector, syndrome atlas, repair-port blocker structure, and C237
Schur-square fingerprints. Build a tool that reports:

- low-degree varieties containing deep/hard syndromes;
- coset-leader multiplicity anomalies;
- repair bottleneck loci;
- low Schur-square dimension or representation-dependent MPC behavior.

Potential audiences: coding systems, codec validation, and code-based cryptography. The paper must
clearly separate known square-code distinguishers and classical syndrome decoding from the new
joint audit workflow.

### S8. Resilient Configuration Synthesis by Extension Complexes

Unify complete repair ports, completion transversals, and legal extension complexes into one
algorithmic object for configurations that must survive deletions and retain multiple upgrade
paths. Implement multiobjective search over availability, alternate extensions, pair-coverage
defect, and deployment cost. Initial domains: short storage codes and combinatorial test designs.

The theorem base exists in pieces; the cross-domain abstraction and practical optimizer do not.

## Cross-paper synthesis after the arcs review

### A15. Proof-carrying repair planning

The arcs step-book architecture should be imported into the repair control plane. Keep the online
optimizer untrusted and aggressively heuristic, but require every chosen plan to carry a compact
certificate:

```text
RepairPlanCertificate {
  target equations and normalized coefficients,
  dependency/topological schedule,
  live-helper witnesses,
  optional capacity allocation and dual-bound witness,
  hashes of the code matrix and Port Capsule
}
```

A small verifier checks each linear recombination against the pinned codec matrix, verifies that
every prerequisite is live or produced earlier, and checks that declared helper loads respect the
allocation. This catches stale matrices, coefficient drift, planner bugs, and invalid sequential
reuse before a data node moves bytes. It does not certify runtime/network behavior, but it sharply
shrinks the trusted control-plane code.

This is a stronger product story than a scheduler alone: the same architecture that makes the
q=16 classification trustworthy makes dynamic repair plans auditable. It is also a credible second
nongeometry case study for a proof-carrying search paper.

### A16. Unlock-aware capacitated repair scheduling

C229 and C235 can be combined rather than run in two independent stages. A repaired fragment has
an **option value** because it can unlock additional Horn rules. For each unavailable coordinate
`e`, maintain:

- its earliest feasible repair time under current resources;
- the number/weight of rules whose last missing prerequisite is `e`;
- the marginal growth in terminal closure if `e` becomes available;
- helper shadow prices for its candidate recovery equations; and
- the blocker reduction produced by recovering `e`.

A candidate greedy/receding-horizon score is

```text
unlock_value(e, A)
  = downstream_demand_unlocked(e)
  + risk_value * blocker_reduction(e)
  - sum_(u in A) shadow_price(u)
  - latency_cost(A).
```

The exact offline reference is a time-indexed MILP over hyperedge firings. The practical planner can
use column generation plus the score above, emitting a certificate for the chosen schedule. No
approximation guarantee is known; establish one only under a restricted acyclic or submodular
regime. The immediate systems question is whether future-unlock value improves node/rack recovery
makespan over per-target greedy or static RDAG scheduling.

### A17. Reliability-capacity co-design

Combine C219 pivotality with C235 LP duality. A helper can be important because it is likely to be
pivotal for *whether* repair exists, expensive because it is scarce in the *service region*, or
both. Rank interventions by a two-axis frontier rather than a single centrality number:

```text
stochastic criticality = d Pr[repair succeeds] / d survival_probability(u)
operational scarcity   = optimal LP dual price of helper u.
```

Candidate interventions include moving a shard across a rack boundary, adding bandwidth, changing
the local code, or delaying maintenance. The research contribution would be a joint intervention
optimizer and evidence that the joint score makes better placement/upgrade decisions than either
fault-tree importance or load alone. The formula is a derived decision rule, not yet a theorem.

### A18. Behavioral hashing and incremental module replacement

Use C233's finite structural boundary control and C234's hash-consed delay expressions as a
canonical cache key for repeated modules:

```text
BehaviorHash(component)
  = hash(radius, interface signature, terminal control table,
         active/core weight map, canonical timing-expression DAG).
```

Two modules with the same verified key may be substituted in a tree context without changing the
modeled recovery behavior. This could support incremental digital-twin recomputation and regression
testing after a rack/code-policy change. Exact contextual replacement is proved only in the
2-sum-tree model; arbitrary production topologies need a guarded abstraction or counterexamples.

### A19. Algebraically guided codec fuzzing

Turn A9 and A10 into a testing loop:

1. enumerate or sample syndrome rays and record decoder cost/failure;
2. fit exact finite-field low-degree feature kernels to the hard locus;
3. generate new syndromes on the detected locus and just off it;
4. minimize counterexamples by coset-leader support and extension-complex adjacency;
5. emit a reproducible syndrome/codeword certificate.

This can find structured blind spots that uniform random fuzzing undersamples. The first product is
a codec-validation plugin, not an anomaly-detection platform. Compare against uniform syndrome
sampling, weight-stratified sampling, and existing decoder test suites on injected and real bugs.

### A20. Coefficient-aware configuration identity

Support hypergraphs alone do not identify a linear representation. C217's cycle holonomies provide
a gauge-invariant checksum for the coefficient layer, and C237 shows that support-identical
representations can have different Schur-square/MPC behavior. A signed configuration identity can
therefore include:

```text
(support canonical form, fundamental-cycle holonomies, Schur-square rank profile).
```

Uses: detect unintended codec/MSP coefficient changes, deduplicate only genuinely equivalent
representations, and prevent a deployment system from treating the same access structure as the
same cryptographic capability. This is especially useful as a linter/checksum; full classification
may require foundation/Tutte-group data beyond the chosen cycle basis.

## Prior-art correction for proof-carrying enumeration

Canonical construction paths are established: McKay's isomorph-free generation generates through
canonical augmentations. Certified solver/checker separation is also established: LRAT augments
SAT proof logs with hints so simple verified checkers can validate them, including Coq and ACL2
implementations. Proof-verified finite-geometry enumeration is not empty territory either: the
projective-plane-of-order-nine work combines SAT search, symbolic symmetry removal, and certificates.

Therefore the arcs-derived novelty claim must be narrower:

- explicit group-action transport witnesses at every augmentation edge;
- a covering-list certificate that need not certify canonical labels, pairwise inequivalence, or
  the quotient class count;
- compositional kernel checking of orbit coverage directly in the native mathematical semantics;
- and a generic schema demonstrating when this is smaller/simpler than a CNF plus LRAT proof.

Primary baselines:

- [McKay, Isomorph-free exhaustive generation](https://users.cecs.anu.edu.au/~bdm/papers/orderly.pdf)
- [Cruz-Filipe et al., Efficient Certified RAT Verification](https://arxiv.org/abs/1612.02353)
- [Dallaire--Bright, Enumerating Projective Planes of Order Nine with Proof Verification](https://cs.uwaterloo.ca/~cbright/reports/sc2-pp9-preprint.pdf)
- [nauty and Traces](https://pallini.di.uniroma1.it/)

## Updated opportunity ranking

| Rank | Candidate | Product proximity | Research defensibility | Main falsifier |
|---:|---|---|---|---|
| 1 | Port Capsule + offline policy compiler | High | Medium-high | Complete-port choices add negligible value over standard LRC/RS policies |
| 2 | Proof-carrying repair control plane | Medium-high | High if verifier is tiny and overhead low | Certificates add latency/complexity without catching meaningful faults |
| 3 | Unlock-aware batch scheduler | Medium | Medium-high | Static RDAG/flow scheduling already matches it on realistic traces |
| 4 | Recovery digital twin and joint hardening | High | Medium | Generic fault-tree/load tools give the same decisions |
| 5 | Proof-carrying orbit-reduced search library | Medium | High with second domain | Certificates are larger/slower than SAT/LRAT or too domain-specific |
| 6 | General-access-structure MPC linter | Medium | Medium-high | Real users rely almost entirely on threshold structures already covered |
| 7 | Algebraically guided codec fuzzing | Medium | Medium | Low-degree loci do not correlate with implementation bugs/decoder cost |
| 8 | Extension-complex migration planner | Low | Medium-high | No production configuration family has useful compatible-extension structure |

The near-term commercial wedge is the **offline compiler/digital twin**, where integration risk is
low. The strongest differentiated architecture is **proof-carrying dynamic repair**. The broadest
research export is **proof-carrying symmetry-reduced search**.

## Full paper-index, discovery-log, and `alt-orbit-repair` audit

Sources scanned after the initial report draft:

- every current mathematical paper abstract/README and every result row in
  [`papers-index.md`](../papers/papers-index.md);
- the embedded `repaircodes` and arcs Discovery Track registers;
- the standalone `repairports` and `rp-next` discovery logs;
- the C115 twisted-cubic cross-lane discovery log and its Fable/Opus triage;
- the `alt-orbit-repair` live/archive logs and C142, C143, C148, C149, C150 findings; and
- the relconic C201/C210 mechanism notebooks, including their negative results.

The following are the material additions. Classical/standard mechanisms are retained only as
implementation guidance, not promoted as novelty.

### A21. Equivariant Repair Port Capsule

D-PC10/D-PC11 prove the exact transport principle needed to compress the primary data structure:
a monomial automorphism of a generator's column configuration relabels the complete bounded repair
hypergraph, including full-support relations. More generally, blockers, repair Boolean functions,
Horn closure, and coefficient-labelled equations are all functorial under the same verified
transport.

Store:

```text
EquivariantPortCapsule {
  group generators and action certificates,
  coordinate-orbit representatives and stabilizers,
  repair-edge orbit representatives,
  transporter map / Schreier data,
  representative coefficients, blockers, BDD nodes, and Horn rules,
  lazy expansion and query cache
}
```

Compile one target/edge representative per orbit and transport answers on demand. This can reduce
preprocessing and metadata by orbit-size factors for RS-like, cyclic, geometric, and other highly
symmetric codes. A tiny checker verifies each generator action on the pinned matrix and the
transported equation. For asymmetric codes it degenerates safely to the ordinary capsule.

This is a major addition to the product thesis. Symmetry reduction itself is standard; the specific
gain is that the entire *complete repair semantics*, rather than only code coordinates, is compiled
equivariantly and certified.

### A22. Multiobjective pointed syndrome compiler

The `repairports` discovery log observes that C215's cache is an ordinary syndrome/coset-leader
table plus a target-forced nonzero minimum for every coordinate. Compute all pointed columns in one
ambient traversal:

```text
PointedCost[beta] = {
  ordinary_min,
  forced_nonzero_min[x] for each inner coordinate x
}
```

Every visited representative updates the ordinary minimum and all coordinates on which it is
nonzero. Combine this with coordinate orbits, a code trellis, or state-space dynamic programming
instead of rebuilding a table per target. The open algorithmic question is which inner-code classes
admit runtime polynomial in the number of syndromes and coordinate orbits rather than the full
ambient `|F|^k` traversal.

Immediate improvement: one scan and one vector-valued table instead of `n` independent target
scans. Research improvement: symmetry/trellis-compressed output-sensitive compilation.

### A23. Orbit-exchange capsule and resilient configuration planner

The alternate-orbit lane supplies a second, higher-level meaning of repair: repair the
*configuration*, not merely the erased data. After deleting a selected nonfixed conjugate orbit,
the system can add a different legal orbit while retaining the arc/code constraint.

```text
OrbitExchangeCapsule {
  configuration and symmetry action,
  selected orbit units,
  deletion remainder -> restoration and alternate additions,
  carrier-indexed candidate sets,
  obstruction/collision profile,
  exchange-graph adjacency oracle,
  robustness envelope and proof certificates
}
```

The checked phase condition

```text
floor((k-1)^2/4) + r + 1 <= s(s-1)/2
```

guarantees at least `r` alternate orbit repairs in the proven family. For invariant ten-arcs and
`s>=7`, at least 318 alternatives survive every selected-orbit deletion. The Q25 result guarantees
an alternate pair in every profile. These are strong mathematical demonstrations of option-rich
configuration repair.

Commercial mapping: code/profile migration or symmetry-constrained resource replacement where
resources are retired/added in coupled orbit units. This remains speculative until a deployed code
or configuration family has the same exchange semantics. Do not imply the exchange graph is
connected or rapidly mixing; C152 has not proved that.

### A24. Factorized obstruction-mask search and certificates

C151's certificate engineering is an algorithm/data-structure result hiding inside a formal proof.
Direct legality witnesses were too expensive. The successful factorization uses:

- 651 canonical dual-line obstruction masks;
- 310 candidate carriers on 31 fixed lines, ten per line;
- constant freshness and carrier-incidence blocks;
- a varying old-secant mask;
- residual symmetry transports; and
- small row dispatch certificates referring to the factored masks.

General schema:

```text
FactorizedConstraintStore {
  canonical predicate masks,
  pair/tuple -> mask IDs,
  constant obstruction layers,
  variable obstruction bitsets,
  symmetry transport IDs,
  small conclusion certificates
}
```

This can substantially improve symmetry-heavy finite CSP/enumeration systems when expensive
algebraic predicates repeat through a small quotient. It is related to standard bitset CSP and
decision-diagram techniques; the paper contribution would be the proof-carrying factorization and
measured certificate/compiler effect, not bitsets themselves.

The relconic C201 notebook independently reinforces the pattern: a nine-factor determinant test
became a pair-indexed 1,302-bit forbidden-third lookup. It also supplies a useful negative rule for
search pipelines: run cheap coverage/capacity gates before expensive low-degree rank tests.

### A25. Resource-aware generated-proof build scheduler

The C143/C151 logs expose a commercially useful formal-CI problem:

- generated Lean leaves consumed roughly 6--11 GB each;
- changing worker counts did not invalidate correct artifacts, but scheduler order and stale
  content made progress misleading;
- filenames, timestamps, and progress denominators were inadequate freshness evidence;
- bounded certificate shards, content traces, `--no-build` validation, memory guards, and
  disk-backed snapshots made the build recoverable; and
- factoring repeated incidence masks reduced proof duplication.

Candidate tool:

```text
ProofBuildManifest {
  content-addressed source/trace keys,
  dependency DAG,
  measured/predicted peak RSS and time per target family,
  maximum-safe concurrency constraints,
  restart/snapshot provenance,
  aggregate trust and staleness checks
}
```

Schedule proof targets as a resource-constrained DAG rather than a fixed worker pool, preferentially
building shared high-memory checkers before parallel bounded leaves. The repository already has an
unnumbered `lean-proof-engineering-at-scale` paper idea. To claim novelty, compare with Lake,
Bazel/Nix-style content-addressed builds, remote caches, and large-formalization CI practice. As a
case study/tool, this may be more commercially immediate for formal-verification teams than several
mathematical products.

### A26. Decoder-ambiguity and continuation fingerprints

The Clebsch theorem registry adds a more ambitious inverse problem. For the short q11 code, a single
quadratic syndrome test is a complete distance oracle, and nearest-word ambiguity reconstructs the
Brianchon geometry and an intrinsic support bipartition. The continuation package independently
reconstructs a finite geometry/configuration from its legal-extension complex.

Generalize to an **Ambiguity/Continuation Fingerprint**:

```text
BehaviorFingerprint {
  hard-syndrome locus,
  nearest-leader multiplicity and support complex,
  legal-extension conflict complex,
  inferred automorphism group / coefficient identity
}
```

Possible uses: identify an unknown short codec from black-box decoder behavior, detect coefficient
or implementation drift, reconstruct hidden structure, and generate targeted tests. Potential paper:
*Behavioral reconstruction of linear codes from decoding and extension oracles*. The present
evidence is one exceptionally rigid code plus an exact continuation theorem; a general/noisy
reconstruction theory is open.

### A27. Symmetry-first game/puzzle preprocessing

The Nofil/dihedral theorems suggest a solver prepass:

1. search for a fixed-point-free legal-structure involution and emit a mirror-strategy certificate;
2. otherwise quotient residual positions into Schreier orbit templates;
3. xor only the template nimbers with odd orbit multiplicity; and
4. cache templates through a Burnside/group-action signature.

This can dramatically avoid game-tree search on structured boards. It is a sound algorithmic export
and good benchmark domain for proof-carrying symmetry tooling, but its commercial reach is mainly
puzzle/game solvers and verification testbeds.

## Promotions and demotions after the full scan

Promote:

1. **Equivariant capsule compilation** into the core storage architecture.
2. **Multiobjective pointed syndrome compilation** into the algorithms research agenda.
3. **Orbit-exchange configuration repair** into the extension-complex paper/product, with a much
   sharper theorem base than the first draft recognized.
4. **Factorized obstruction masks** and **resource-aware proof CI** into the proof-carrying search
   and methods-paper programs.
5. **Behavioral code reconstruction** as a creative, longer-horizon paper.

Keep but do not promote as novelty:

- pair-indexed forbidden-third bitsets and coverage-before-rank staging (standard search/CSP
  engineering, though directly useful here);
- mirror/involution preprocessing (standard pairing-strategy idea with strong exact instances);
- BDD reliability, Horn forward chaining, LP scheduling, clutter dualization, and canonical
  augmentation individually;
- the five-weight cubic-axis family as a commercial algorithm (good certified code family, modest
  algorithmic leverage); and
- Q64 layered-parabola construction signals (interesting finite geometry, no current product path).

The updated strongest architecture is:

```text
equivariant offline compiler
  -> signed Port / Exchange / Syndrome capsules
  -> untrusted dynamic planners and finite search engines
  -> small proof-carrying plan / coverage verifiers
  -> content-traced, resource-aware certificate build pipeline
```
