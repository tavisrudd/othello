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

## 2026-07-17 checkpoint — comparison with the applications riff

The 7,000-line
[`riffing-on-applications`](2026-07-12-riffing-on-applications.md) archive already covers most
vertical destinations: shared-dependency resilience, proof-carrying search, supply chains,
configuration/product lines, security architecture, OR solution portfolios, SDN, protocol
symmetry, gossip provenance, causal inference, statistics, and ML. C239 should **not** add another
hundred destination ideas. Its additional value is to:

1. identify a smaller number of established abstractions that subsume many riffs;
2. locate missing cross-domain theorem families rather than application nouns;
3. predict sibling phenomena from structural causes;
4. import algorithms from the destination fields back into repair-port compilation; and
5. expose where an attractive riff is already standard under different terminology.

The riff's strongest OR idea—transversally robust solution portfolios—is retained, but the new
audit sharpens it: compare against diverse planning, interdiction, column generation, and solution
reconfiguration, then target **minimum common failure-domain coverage**, not decision-vector
distance. The riff's configuration-completion ideas are part of the established solution-graph
reconfiguration world; the possible addition is option value/certification over a complete
extension complex, not the existence of reconfiguration paths.

## 2026-07-17 checkpoint — primary-literature collisions and promotions

### Knowledge compilation is the correct umbrella discipline

[Darwiche and Marquis's knowledge-compilation map](https://doi.org/10.1613/jair.989) says a
compiled representation should be judged by succinctness and by which queries and transformations
it supports in polynomial time. This supplies a much sharper program than “build a capsule”:

> Build a **resilience knowledge-compilation map** whose rows are witness antichains, blocker
> antichains, ZDD/BDD variants, Horn fixed-point systems, separator tables, weighted expression
> DAGs, and lazy symmetry oracles; whose columns are availability, minimal explanation, blocker,
> update, ETA, capacity, and plan-extraction queries.

This demotes the generic claim that compile-once/query-many is new. The potential new contribution
is a representation family combining algebraic validity, causal unlock, quantitative valuations,
module composition, and independently checked transformations. The theory paper needs succinctness
separations and tractable-query results, not a schema alone.

[Efficient Explanations for Knowledge Compilation Languages](https://arxiv.org/abs/2107.01654)
already obtains familiar explanation classes efficiently for d-DNNF and related languages.
Therefore minimal enabler/blocker explanations are not a new generic capability. The gap, if any,
is executable restoration with coefficients, state transitions, shared capacities, and proof
objects.

### Provenance is a close ancestor, not an empty field

[Green--Karvounarakis--Tannen](https://www.cs.ucdavis.edu/~green/papers/pods07.pdf) unify multiple
database semantics through provenance semirings, extend to Datalog fixed points, and represent
possibly infinite provenance by finite algebraic systems of formal power series. This is strikingly
close to C233--C234's finite control/syntax over an infinite quantitative carrier.

Consequences:

- “restorative provenance” must not claim to invent semiring valuation or finite recursive
  presentation;
- C234 should be compared explicitly with Datalog provenance and weighted automata;
- the strongest new question is whether one **operational provenance** representation supports
  action extraction, capacity-constrained multi-target selection, and small verification
  certificates;
- provenance semiring machinery may supply a cleaner algebraic formulation and implementations for
  the Capsule back ends.

Reverse data management, why-not provenance, causality, and database repair already study minimal
input interventions that change outputs. The [cell-based causality/repair work](https://www.usenix.org/conference/tapp15/workshop-program/presentation/debosschere)
even calls for provenance tailored to procedural chase repairs. Thus “tell me how to restore the
answer” is established. A defensible delta must jointly handle precompiled alternative action
sequences, resource/time valuations, algebraic compatibility, and independently verified execution.

### Complete ports are finite-field elementary modes

The most important missed domain is metabolic pathway analysis.

- [Network expansion](https://pubmed.ncbi.nlm.nih.gov/16155745/) starts from seed metabolites,
  repeatedly fires reactions whose substrates are available, and computes the resulting scope.
  This is essentially the same monotone closure pattern as C229--C230.
- [Exhaustive biosynthetic-pathway enumeration](https://www.nature.com/articles/s41598-018-28007-7)
  explicitly tracks stuck reactions and triggers them when precursors appear later—nearly the same
  reverse-incidence operational algorithm proposed for sequential repair.
- Elementary flux modes are support-minimal feasible steady-state flux vectors; metabolic minimal
  cut sets block every target-carrying mode. Their hypergraph duality and dedicated enumeration
  algorithms are mature
  ([MCS2 overview](https://pmc.ncbi.nlm.nih.gov/articles/PMC6612898/),
  [dual-network result](https://doi.org/10.1093/bioinformatics/btr674)).
- [Elementary-vector theory](https://arxiv.org/abs/1512.00267) places these modes in linear
  subspaces, subspace cones, polyhedral cones, and polyhedra using conformal decomposition.
- The metabolic literature explicitly identifies elementary modes with positive circuits of an
  oriented vector matroid
  ([Schuster--Hilgetag framework](https://pmc.ncbi.nlm.nih.gov/articles/PMC544875/)).

So a pointed repair port is best understood as a finite-field sibling of a pointed family of
elementary flux modes. The common generalization is a **Pointed Elementary Capability Mode**:

```text
linear relation / cone / semimodule + distinguished output capability
    -> inclusion-minimal feasible elementary vectors using that output
    -> coefficient/sign-labelled support family
    -> dual minimal interventions blocking all output-producing modes.
```

This is more mathematically grounded than the unconstrained `CapabilityCapsule` name. It predicts
a genuine three-way program across finite-field code repair, real-cone metabolic production, and
network-coded/linear dataflow systems.

Claim boundary: metabolic scope expansion is topological and often treats available metabolites as
reusable; flux modes enforce steady-state stoichiometry and sign constraints; code repair treats
symbols as nonconsumable information. No single encoding may preserve all three. The paper-worthy
work is to state the exact common category and the assumptions under which ports, blockers,
composition, and valuations transfer.

### Algorithms to import back from metabolism

The metabolic connection is bidirectional, not an application claim:

- use EFM enumeration, double-description, reverse search, MILP column generation, and dual-network
  minimal-cut algorithms as baselines or engines for complete-port compilation;
- use “generate only relevant modes” optimization when complete enumeration is impossible;
- compare pointed syndrome/circuit enumeration against elementary-vector algorithms on matched
  sparse matrices;
- test whether symmetry and fixed-target structure make finite-field ports easier than generic EFM
  enumeration.

Potential export in the other direction: C231--C234's exact separator composition, terminal
boundary-control algebra, and delay-expression DAGs may give modular algorithms for network
expansion or pathway ETA on tree-like reaction networks. This is a real gap hypothesis, not yet a
literature conclusion.

### Petri nets and dynamic fault trees explain two more objects

Minimal stopping cores resemble Petri-net siphons/deadlock structures; BDD computation of all
minimal siphons is established
([Chen--Liu](https://doi.org/10.1145/2406336.2406339)). Dynamic fault trees already include
sequence-enforcing, priority-AND, spare, and functional-dependency gates and minimal cut sequences
([example primary treatment](https://doi.org/10.1177/1748006X14552004)).

Therefore:

- do not claim generic stopping-core/deadlock or sequential reliability novelty;
- test an exact restricted correspondence between monotone repair closure and safe/read Petri nets;
- the plausible delta is automatically extracting these structures from algebraic recovery
  semantics and pairing them with executable witnesses, rather than inventing new fault-tree gates.

### E-graphs are the compiler-side sibling

An e-graph stores many equivalent expressions and extracts a least-cost representative. This is
close to storing all reconstruction expressions and choosing one under a cost model.
[Fast and Optimal Extraction for Sparse Equality Graphs](https://doi.org/10.1145/3689801) shows
general extraction is NP-hard/inapproximable within a constant ratio but tractable on a sparse
class. Equality-saturation systems already produce explanations, and an executable formally
verified merge/extraction checker now exists in the
[Archive of Formal Proofs](https://devel.isa-afp.org/entries/Equality_Saturation_Checker.html).

So “proof-carrying alternative-expression extraction” is not new. The predicted missing sibling is
**failure- and capacity-aware multi-extraction**:

- leaves/operators can become unavailable;
- an extracted term can materialize intermediates that unlock later extractions;
- several target terms contend for shared leaves/operators;
- coefficients or side conditions must be checked;
- the objective is a certified schedule, not one minimum-cost term.

This should be tested as an e-graph paper/benchmark. Conversely, e-graph compactness and extraction
algorithms may improve capsule representation for codes with recursively equivalent repair
expressions.

### Weighted automata constrain the transfer-algebra claim

Weighted automata over tropical semirings already attach min/plus quantitative semantics to finite
control and can require infinite weight carriers; determinization/equivalence have delicate
boundaries ([Mohri's algorithms survey](https://research.google.com/pubs/archive/35076.pdf)).
C232--C234 should be positioned as a **domain-specific weighted tree transducer/context algebra**
for Horn recovery, with an exact radius/interface finiteness theorem and an explicit failure of a
finite quantitative alphabet. The contribution cannot be “finite state plus tropical weights.”

The sharper PL theorem candidate is a Myhill--Nerode-style characterization of contextual recovery
equivalence and a minimal boundary transducer, including when determinization or finite-weight
quotienting is impossible.

### Diverse planning and reconfiguration narrow two claims

[Plan-diversity research](https://doi.org/10.1609/aaai.v29i1.9669) already studies pathologies in
syntactic plan-distance metrics. This supports rather than defeats the riff's transversally robust
portfolio: predict that two plan sets with equal pairwise diversity can have different minimum
common failure-domain hitting numbers. The publishable object is that separation plus a generation
algorithm and domain benchmark.

Solution-graph reconfiguration is a mature area, and current work studies path preservation and
kernelization even for independent sets
([STACS 2026 example](https://drops.dagstuhl.de/entities/document/10.4230/LIPIcs.STACS.2026.19)).
Thus extension complexes do not invent configuration-space topology. The possible new objective is
certified **continuation diversity**: choose a state/path maximizing the minimum future disruption
that destroys all safe continuations, rather than merely finding one reconfiguration path.

## Revised top abstractions after the first audit

1. **Resilience knowledge compilation** — broadest CS umbrella and proper evaluation discipline.
2. **Pointed elementary capability modes** — deepest mathematical generalization, joining repair
   circuits, elementary flux modes, and linear/coded dataflow.
3. **Operational/proof-carrying provenance** — useful systems interface, but heavily prior-art
   constrained.
4. **Failure-aware multi-extraction** — best compiler transplant via e-graphs.
5. **Fully abstract weighted recovery interfaces** — best PL/theory transplant from C231--C234.
6. **Transversally robust plan portfolios** — strongest OR transplant from the riff archive.
7. **Continuation-robust reconfiguration** — sharper version of option-preserving migration.

The generic Capability Capsule remains a product IR, not the research novelty claim.

## 2026-07-17 checkpoint — PL, contracts, and local-to-global semantics

### Boundary transfer is a quantitative interface theory instance

Interface automata, assume--guarantee contracts, quotient operations, and full abstraction are
established. For example, the
[algebraic theory of interface automata](https://doi.org/10.1016/j.tcs.2014.07.018) supplies
parallel composition, conjunction, disjunction, hiding, quotient, substitutive refinement, and a
full-abstraction result. Quantitative compositional pricing and resource interfaces already attach
cost/resource semantics to component contracts
([QEST 2006](https://ptolemy.berkeley.edu/projects/chess/pubs/233.html)). Dependability work also
uses behavioral interfaces and bisimulation to compose dynamic fault models.

Hence C231--C234 do not invent contracts or quantitative interfaces. Their possible distinctive
content is much narrower and more exact:

- interfaces are **compiled automatically from all bounded elementary recovery modes**;
- the structural control alphabet is finite at fixed radius/interface width;
- the exact count/time carrier is provably infinite even when structural control is finite;
- an expression grammar still gives finite recursive presentation;
- specific 2-sum and tree composition laws are exact rather than conservative.

Best theory reframe:

> a fully abstract interface theory for bounded monotone restoration, with a finite qualitative
> quotient, an unavoidable infinite quantitative carrier, and exact semiring-valued composition.

The new theorem needed is a canonical/minimal contextual quotient or a general characterization of
which valuations factor through the finite control layer. Merely importing “Myhill--Nerode” language
would not suffice.

### Semiring hypergraph evaluation is prior art

[Goodman's semiring parsing](https://aclanthology.org/J99-4004/) and subsequent hypergraph dynamic
programming show that one packed derivation forest can support many valuations. This is another
direct ancestor of the compile-once/value-many thesis. A Capability Capsule should therefore be
presented as a **domain-specific packed derivation forest with additional blocker duality,
coefficient labels, state updates, and certificates**, not as a new universal semiring engine.

This also suggests an implementation strategy: reuse generalized inside/outside or hypergraph
semiring kernels for availability, cheapest repair, count, probability, and earliest-arrival
valuations, while keeping capacity coupling and blocker enumeration as separate back ends where
simple semiring factorization fails.

### Holonomy is a sheaf/gain-graph phenomenon

Gain graphs and cellular sheaves already formalize locally labelled relationships whose cycle data
controls global consistency. Spectral sheaf theory explicitly uses local restriction maps and
global sections for distributed consistency and consensus
([Hansen--Ghrist](https://doi.org/10.1007/s41468-019-00038-7)); network-coding sheaves have been
used for global extendability, robustness, and information flow
([Ghrist--Hiraoka](https://doi.org/10.34385/proc.45.A4L-C3)).

Thus coefficient holonomy is not a generally new local-to-global obstruction. The local result's
value is as an unusually small **representation-sensitive capability separation**: the same
support matroid/access structure can yield different Schur-square rank and strong multiplicativity.

The cross-domain prediction should be stated with sheaf precision:

> Whenever a system is specified by a support hypergraph plus local linear restriction maps,
> support-level policy equivalence can fail to preserve a nonlinear/compositional capability; a
> cycle/cocycle or sheaf invariant may be the cheapest missing fingerprint.

Predicted siblings:

- network-coded flows with identical path supports but different global transfer capability;
- distributed frame/sensor synchronization with identical communication graphs but different
  cycle inconsistency;
- linear/tensor computation graphs with identical dependency DAGs but different composability;
- cryptographic access structures with identical authorized sets but different multiplication
  behavior (already witnessed locally).

The novelty test is not whether holonomy exists; it is whether a cheap cycle fingerprint predicts a
capability that currently requires a full global rank/transfer computation.

## Layered abstraction emerging from the audit

A single hypergraph is too coarse. The common system has at least six layers:

```text
L0  support layer:       which resources occur in each minimal witness?
L1  linear/label layer:  which coefficients, signs, maps, or gains make it valid?
L2  causal layer:        which completed capabilities enable later witnesses?
L3  resource layer:      how do simultaneous witnesses contend for capacities?
L4  context layer:       what boundary behavior is observable under composition?
L5  evidence layer:      how is every compilation and execution claim checked?
```

Different adjacent fields usually cover only a subset:

| Field | Strong layers | Typical omission relevant here |
|---|---|---|
| knowledge compilation/provenance | L0, some L2, valuation fragments | L1 algebraic identity, L3 joint scheduling, L5 transformation evidence |
| metabolic modes | L0--L1 and capacity cones | L4 exact modular restoration contracts, L5 proof-carrying compilation |
| e-graphs | L0/L2 expression alternatives, cost extraction | failures, multi-target L3, blocker duals, domain coefficients |
| Petri nets/workflows | L2 and richer token dynamics | automatically derived elementary linear witnesses and compact L1 identity |
| interface/contracts | L4 and sometimes resource costs | complete witness extraction from source algebra, blocker duality |
| sheaves/gain graphs | L1 local-to-global consistency | operational L2--L3 restoration planning |
| repair-port portfolio | exact L0--L4 instances | generality, implementation, and comparative evaluation |

This layered view is likely the clearest answer to “what have we missed?” The opportunity is not a
new name for any one layer; it is semantics-preserving compilation across all six.

## Revised structural predictions after the second audit

1. **Coarse-equivalence failures will recur.** Systems equal at L0 but different at L1 will have
   different nonlinear/compositional capabilities in MPC, network coding, metabolism, and tensor
   programs.
2. **Static/dynamic feasibility gaps will recur.** Systems with identical one-step witnesses can
   differ after L2 closure in build recovery, metabolic scope, incident remediation, and staged
   reconfiguration.
3. **Availability/throughput inversions will recur.** L0 abundance can conceal L3 bottlenecks in
   quorum systems, production recipes, diverse plans, and coded computation.
4. **Finite-control/infinite-value separations will recur.** Fixed boundary behavior at L4 can
   coexist with unbounded latency/count/cost carriers in workflows, protocols, parsing, and
   modular supply processes.
5. **Proof cost will reorder optimizers.** Two equal-cost plans at L3/L4 can have radically
   different L5 certificate size/check time; formal CI, agentic remediation, and regulated
   operations should expose a proof-cost Pareto frontier.
