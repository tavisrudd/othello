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
