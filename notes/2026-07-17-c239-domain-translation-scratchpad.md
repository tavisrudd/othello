# C239 — Domain-translation audit scratchpad

**Lane:** `rp-next`

**Date:** 2026-07-17

**Status:** rolling working record; hypotheses below are not novelty claims

**Parent synthesis:**
[C238 commercial algorithms report](2026-07-17-c238-repairports-commercial-algorithms.md)

## Question

What does the repair-port, sequential-closure, separator-transfer, holonomy, arcs, and
proof-carrying enumeration material become when read from other disciplines rather than from
coding theory or finite geometry? In particular:

1. “This is actually an ___”: identify the established abstraction that best explains each result.
2. Determine what that field already solves and where the local theorem base supplies a missing
   capability.
3. Separate renaming from a real transplant: a valid transplant must add either a theorem, an
   algorithm, a certificate architecture, or a measurable systems capability.
4. Rank genuine gaps by commercial usefulness, generality, proof distance, and evaluation cost.

## Initial master reframing

The common object is not an erasure code. It is a **compiled capability-restoration semantics**:

```text
declarative system + local witnesses + composition boundaries
                         |
             offline semantic compilation
                         |
    minimal enablers / minimal blockers / causal unlock rules
          + resource weights + certificates + symmetries
                         |
      repeated restoration, diagnosis, planning, and audit
```

A repair port is therefore plausibly a special case of a broader **Capability Port**. For a
capability `c` and current state `x`, it stores all inclusion-minimal certified witness sets that
can establish `c`, the dual minimal blockers, coefficient/compatibility data that distinguish
superficially identical witnesses, and optional causal, capacity, reliability, and timing
valuations.

The strongest generalization candidate is:

> Compile a declarative redundant system into a signed, proof-carrying capability capsule that
> supports fast repeated “can it work?”, “why not?”, “what should I do next?”, “how long?”, and
> “which intervention preserves the most future options?” queries.

This is broader than the C238 repair-control-plane framing and may be the missing umbrella.

## “This is actually an ___” translation ledger

| Local object/result | Other-domain identity | What is genuinely extra here | First gap to test |
|---|---|---|---|
| complete repair port | minimal witness lineage / prime implicants / abductive explanations | witnesses are algebraically certified and coefficient-sensitive, not merely Boolean | provenance systems that cannot distinguish support-identical but semantically different realizations |
| blocker antichain | minimal cut sets / diagnoses / counterfactual causes / hypergraph transversals | exact dual view paired with executable recovery witnesses | unified explanation engine that returns both restoration plans and minimal impossibility causes |
| sequential small-circuit closure | monotone rule system / AND-OR hypergraph / bootstrap process / delete-free planning | rules are compiled from algebra and expose strict parallel/sequential/full-span layers | incremental planners that ignore newly enabled alternatives or algebraic feasibility |
| stopping core | deadlock kernel / unfounded set / residual diagnosis | exact terminal obstruction for bounded restoration | remediation tools that suggest steps but cannot certify that no bounded continuation remains |
| causal min-max arrival valuation | precedence-constrained AND-OR scheduling / tropical dataflow | exact earliest-arrival semantics derived from all recovery rules | workflow recovery with alternative recipes, shared resources, and checkable ETA |
| boundary-control table | tree-automaton state / Myhill–Nerode contextual summary / module contract | exact compositional interface for recovery behavior | compositional resilience analysis that avoids flattening a large system |
| finite control + infinite timing carrier | weighted/register automaton / algebraic dynamic program | finite recursive syntax represents unbounded exact delays | small reusable summaries for systems whose quantitative outcomes are unbounded |
| functional-cost transfer | abstract interpretation / assume-guarantee contract / quotient seminorm | sharp criterion for when local summaries remain exact under composition | contract systems whose coarse support summaries silently lose feasibility or cost |
| repair service region | fractional packing / production polytope / capacity region | ports are derived automatically and sequential unlock can change the feasible region | online scheduling over dynamically revealed recipes rather than a fixed job graph |
| pointed repair polynomial / EXIT | semiring provenance / reliability polynomial / partition function | one compiled family supports reliability and conditional failure transforms | cross-query knowledge compilation instead of one BDD/model per metric |
| coefficient holonomy | gain graph / gauge cocycle / sheaf obstruction / semantic type refinement | same support structure can have different multiplicative/security capability | audits that collapse representation-level semantics to a combinatorial policy graph |
| Syndrome Atlas | stratified memoization / quotient decision diagram / behavioral type table | exact algebraic strata concentrate hard cases and expose ambiguity | test generation that samples by behavioral strata rather than input frequency |
| Extension Complex | reconfiguration graph / solution complex / option-preserving planning | alternates and exchange paths make future optionality explicit | configuration repair that finds one valid state but destroys resilience to the next change |
| Orbit StepBook | proof-carrying quotient transition system / certified partial-order reduction | generator may be untrusted; verifier checks explicit transports and coverage | symmetry reducers that assume or trust canonicalization without replayable quotient evidence |
| factorized obstruction masks | factorized database / BDD/ZDD / tensor-network constraint store | geometry supplies a natural two-level factorization and exact carrier map | explanation/search engines that materialize a huge flat incidence relation |
| resource-aware proof build | precedence/resource scheduling with proof provenance | exact proof identity, generator lineage, and resource envelope travel together | formal CI that treats proof artifacts as ordinary build outputs |

## Candidate umbrella abstractions

### A. Capability Capsule

Generalization of `RepairPortCapsule`:

```text
CapabilityCapsule {
  system_identity, capability_identity, assumption_schema,
  minimal_enablers + local certificates,
  minimal_blockers + impossibility certificates,
  compatibility_or_coefficient_labels,
  causal_unlock_rules + residual_core,
  reverse_incidence_indexes,
  resource_and_time_expression_DAGs,
  reliability/provenance valuations,
  interface summaries and composition contracts,
  symmetry transports,
  verifier and signature metadata
}
```

This is not new merely because it is named. The research question is whether one compact IR can
support explanation, restoration, timing, capacity, reliability, and compositional reuse while
preserving certificates.

### B. Certified Alternative-Recovery IR

Compiler viewpoint: the source is a matrix, ruleset, workflow, quorum policy, build graph, or
configuration theory. The IR is a minimal-witness hypergraph enriched with coefficients,
prerequisites, capacities, and proof objects. Back ends answer different queries or emit executable
plans. This resembles compiler IR design more than a storage appliance.

Potential missed contribution: establish **semantic preservation passes**—minimalization,
symmetry quotienting, separator summarization, blocker dualization, and valuation lifting—with a
small certificate checker for each pass.

### C. Recovery provenance

Database provenance normally explains why an answer exists or is absent. Here provenance is
operational: it can prescribe a sequence that makes the answer/capability exist, account for
shared capacity and time, and certify algebraic compatibility. Call this **restorative
provenance** or **executable provenance** only if the literature gap survives review.

### D. Resilience knowledge compilation

Knowledge compilation turns expensive logical reasoning into tractable repeated queries. The
local portfolio does the same for redundant recovery, but with antichains, coefficient labels,
causal closure, weighted expression DAGs, and exact module interfaces. This may be the cleanest
theory bridge: determine which target query classes become tractable after compilation and which
representations remain succinct under bounded port radius/tree-like composition/symmetry.

## Domain lenses to audit

### Programming languages and compilers

- `CapabilityCapsule` as a typed IR for alternative realizations.
- coefficient holonomy as representation-sensitive typing: equal dependency supports do not imply
  substitutability.
- separator summaries as fully abstract module interfaces/contextual equivalence.
- StepBooks as translation-validation certificates for symmetry and canonicalization passes.
- Gap hypothesis: resilience transformations lack proof-carrying, semantics-preserving compilation
  from declarative redundancy to executable recovery plans.

### Databases, provenance, and incremental computation

- minimal ports as why-provenance; blockers as why-not provenance.
- sequential repair as incremental maintenance where recovered facts enable new derivations.
- factorized obstruction masks as factorized provenance.
- Gap hypothesis: current lineage explains outputs but usually does not optimize and certify
  interventions that restore unavailable outputs under resource constraints.
- Commercial transplant: recovery of materialized views, replicated shards, lakehouse tables, or
  feature pipelines after partial corruption/version skew.

### AI planning, workflow orchestration, and agent systems

- Horn closure is delete-free planning with alternative recipes.
- proof-carrying plans are directly applicable to agents that propose actions but should not be
  trusted to assert prerequisites or effects.
- stopping cores are compact “bounded plan impossible” explanations.
- Gap hypothesis: planners produce a plan or unsat core, but do not precompile all minimal
  restoration alternatives plus exact reusable boundary contracts.
- Commercial transplant: incident runbooks, cloud remediation, disaster recovery, and safe agentic
  operations.

### Operations research and supply networks

- repair sets are alternative bills of materials/recipes; sequential unlock is intermediate
  production; service regions are production/capacity polytopes.
- blockers are minimal sets of unavailable suppliers/resources that stop production.
- Extension Complex optimizes option value under future disruptions.
- Gap hypothesis: robust optimization handles scenarios but rarely compiles exact minimal recipes,
  causal unlocks, and replayable feasibility certificates from an algebraic/declarative source.
- Risk: this may reduce to standard hypergraph scheduling or process-network synthesis unless the
  compositional/certificate result adds something formal.

### Reliability, diagnosis, and cyber-physical recovery

- ports/blockers unify success paths, minimal cut sets, and repair actions.
- dynamic closure goes beyond static fault trees because a successful recovery changes what can be
  recovered next.
- Gap hypothesis: dynamic fault trees and Markov models may already cover much of this; test
  whether exact minimal-witness compilation and separator transfer improve scalability or audit.
- Commercial transplant: industrial control restoration, telecom recovery, and power-system
  black-start planning, but only with domain-valid physical constraints.

### Security, IAM, secret sharing, and trust management

- support ports are authorization/quorum witnesses; blockers are denial coalitions.
- holonomy warns that an access structure is not a complete semantic security specification.
- Gap hypothesis: policy analysis misses representation-sensitive cryptographic capability,
  especially multiplicative MPC after adversary deletion.
- Commercial transplant: linting threshold/MPC deployments and migration across share schemes.

### Distributed systems, quorum systems, and network protocols

- a protocol capsule compiles all admissible quorums, blockers, transition rules, latency
  expressions, and transport certificates.
- separator transfer suggests compositional analysis of hierarchical/federated protocols.
- StepBooks suggest proof-producing symmetry reduction.
- New missed angle: **reconfiguration safety is an extension/exchange problem**, not just quorum
  selection. Rank migrations by how many alternate safe continuations they preserve.

### Networking and SDN/NFV

- repair plans resemble a control plane compiling a declarative protection policy into verified
  failover actions.
- ports can represent all bounded path/function-chain realizations; coefficients matter for coded
  flows and network coding.
- Gap hypothesis: fast reroute precomputes backups, but does not jointly expose all minimal coded
  recovery recipes, dynamic unlock, and proof-carrying resource feasibility.
- Risk: for ordinary routing, mature path/cut machinery dominates; restrict the claim to coded or
  multi-stage capability restoration.

### Software supply chains, builds, and package ecosystems

- alternative builders/artifacts/dependencies form recovery ports; signatures and provenance are
  native requirements.
- stopping cores explain why no trusted rebuild path remains.
- separator summaries fit modular builds; resource-aware proof CI is one instance.
- Commercial transplant: reconstruct a trusted artifact from caches, builders, source mirrors, and
  attestations after compromise.

### Cloud data/AI serving and coded computation

- alternative shard/expert/cache/worker sets establish an inference or training capability.
- sequential recovery can model intermediate recomputation; capacity regions model stragglers and
  accelerators.
- Gap hypothesis: coded-computation schedulers optimize a chosen code but do not compile all
  coefficient-correct alternatives or reuse them across failure/load states.
- Candidate evaluation: erasure-coded KV cache, checkpoint reconstruction, distributed inference,
  or coded matrix computation.

### Test generation and verification

- Syndrome Atlas is behavioral stratification; continuation fingerprints are state abstractions.
- hard-syndrome strata resemble coverage-guided fuzzing with algebraically derived feature maps.
- StepBook certificates can validate quotient exploration.
- Gap hypothesis: fuzzers discover empirical rarity but lack exact partitions tied to decoder
  ambiguity and algebraic failure mechanisms.

## Highest-value gap hypotheses before literature audit

1. **Restorative provenance:** move from “why is this result present/absent?” to “what minimal,
   certified action sequence restores it under capacities?”
2. **Proof-carrying knowledge compilation:** every minimization, quotient, and composition pass
   emits evidence checkable independently of the optimizer/compiler.
3. **Fully abstract resilience interfaces:** boundary summaries identify modules exactly up to all
   bounded restoration contexts, with quantitative values carried separately.
4. **Option-preserving configuration repair:** optimize the extension complex, not merely distance
   to one valid configuration.
5. **Representation-sensitive policy analysis:** enrich access/quorum/dependency structures with
   coefficient or cocycle data when support-level identity loses capability.
6. **Certified dynamic cut/path duality:** pair executable causal recovery plans with residual
   stopping-core certificates in one IR.
7. **Algebraic behavioral coverage:** compile exact hard-case strata for fuzzing and regression
   selection.
8. **Proof-producing symmetry compilation:** quotient huge state spaces without trusting the
   canonicalizer or orbit count.

## Structural prediction ledger: found here, predicted in X/Y/Z

This is a separate discovery mode from application listing. Each row starts from a mechanism found
locally, predicts related phenomena in other domains because the same structural ingredients are
present, and names the observation that would make the prediction nontrivial.

| Found here | Predicted analogs | Why the mechanism should transfer | Discriminating prediction |
|---|---|---|---|
| support-identical representations have different functional costs or MPC capability | authorization policies backed by different cryptographic schemes; coded-computation plans with identical worker sets; network-coded routes with identical topology | the Boolean support hypergraph forgets scalar maps, composition phases, or implementation labels | construct two deployments with the same minimal authorized/available sets but different composability, cost, or adversary robustness |
| parallel, sequential, and full-span recovery separate strictly | incident runbooks; multi-stage manufacturing; package/build recovery | completing one action creates an intermediate that unlocks rules unavailable initially, while global feasibility may still require an unbounded/forbidden action | find the smallest workflow where independent fallback checks fail, bounded causal remediation succeeds, and unconstrained feasibility is strictly stronger |
| bounded local behavior needs a finite control state but unbounded quantitative carrier | streaming cost monitors; modular workflow ETA; hierarchical quorum latency; supply-chain lead time | contextual choices are finite while accumulated counts/delays remain unbounded | prove no finite value alphabet is exact, then give a finite syntax/control algebra over an infinite semiring carrier |
| support distance is insufficient; functional quotient cost is sharp | API substitutability; data-layout migration; approximate service replacement | two components can expose the same reachable interfaces while differing in the cost of realizing the required function | exhibit a composition accepted by reachability/type matching but rejected exactly by a functional-cost contract |
| availability and throughput separate on the same recovery hypergraph | quorum systems; replicated database reads; coded computation; supplier networks | existence of one live witness is a Boolean property, whereas simultaneous demand is a fractional packing problem with shared bottlenecks | find a highly available design whose maximum sustainable concurrent service is provably poor, with a dual bottleneck certificate |
| local alternate completions do not imply a universal bridge preserving all profiles | rolling protocol reconfiguration; schema migration; dependency upgrades; key rotation | each state may have some escape, yet no single transition is compatible with every future context | find configurations where pairwise safe migrations exist but every universal migration destroys at least one continuation class |
| a small exceptional field/parameter changes the closure spectrum | finite-word-size protocols; SIMD/quantized kernels; small-threshold secret sharing | identities that are generic over large domains collapse when coefficients or residues coincide | predict exceptional small moduli/word widths where test coverage, rank, or adversary properties change discontinuously |
| factorized obstruction incidence collapses a huge flat search | policy analysis; configuration diagnosis; attack graphs; constraint explanations | obstructions are generated through a small family of carriers/interfaces rather than independently | recover the same answers from a two-level carrier-to-obstruction map using asymptotically or empirically less memory |
| explicit transports let a tiny checker validate untrusted orbit reduction | concurrent protocol model checking; replicated workflow exploration; compiler state-space search | symmetry reduction is sound when every quotient edge/state can be lifted by a replayable group action | demonstrate a bug or trust reduction unavailable when the canonicalizer only emits orbit representatives/counts |
| algebraic hard cases lie on exact syndrome strata | cryptographic implementation testing; coded computation; numerical kernels over finite/quantized domains | failures depend on rank/discriminant/ambiguity loci of low codimension, which uniform fuzzing rarely samples | algebraically stratified tests find distinct bugs or semantic branches at materially lower test budgets |
| exact recovery semantics can be compiled once and valued many ways | database lineage; resilience digital twins; policy analysis | reliability, blockers, ETA, capacity, and explanations are valuations of the same witness structure | one shared IR beats separate per-query models in build cost, consistency, or certificate reuse without losing exactness |

### Prediction templates to use in the final report

For every strong local result, write:

> We found **P** in repair/geometry. We predict a related **P′** in **X, Y, and Z**, because all
> four systems contain **structural ingredients S**. The prediction is stronger than analogy: it
> entails **observable O** and is falsified if **baseline B** already captures O or if S does not
> survive the domain encoding.

The most valuable predictions are not “algorithm A could be applied to X.” They are surprising
phenomenon forecasts: a missing distinction, an exceptional regime, an impossibility boundary, or
a pair of systems that coarse SOTA abstractions incorrectly identify.

## Ideas likely to be mere relabeling unless strengthened

- ordinary path/cut enumeration;
- generic hypergraph scheduling;
- static fault-tree compilation;
- plain Datalog/Horn evaluation;
- generic workflow or BOM planning;
- a new file format around existing recovery sets;
- standard BDD/ZDD compression;
- “digital twin” without a code-derived exact semantic layer;
- generic proof-carrying code without domain-specific certificates;
- standard quorum selection without safe extension/exchange semantics.

## Evaluation matrix to fill

For every transplant, record:

| Field | Existing SOTA object | Missing capability | Local theorem/algorithm supplied | Required new theorem | Prototype | Baseline | Falsifier |
|---|---|---|---|---|---|---|---|
| provenance | pending | pending | ports + blockers + closure | pending | pending | pending | pending |
| planning | pending | pending | closure + stopping core + ETA | pending | pending | pending | pending |
| configuration | pending | pending | extension/exchange complex | pending | pending | pending | pending |
| PL/compilers | pending | pending | transfer + contextual summaries | pending | pending | pending | pending |
| protocol verification | pending | pending | StepBook + transports | pending | pending | pending | pending |
| supply/build security | pending | pending | signed capsules + provenance | pending | pending | pending | pending |
| coded computation | pending | pending | complete coefficient-aware ports | pending | pending | pending | pending |

## Source discipline

- Prefer primary papers, standards, and official documentation.
- A vocabulary collision is not evidence of novelty.
- For each “gap,” seek the strongest adjacent method and write the falsifier first.
- Preserve C238's claim boundary: proved locally, derived/implementable, or speculative.
- Do not alter the current paper manuscript during this audit.
