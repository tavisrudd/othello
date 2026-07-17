# C239 — Domain translation, generalization, and missed-gap audit

**Lane:** `rp-next`

**Date:** 2026-07-17

**Status:** integrated draft; evidence and claim boundaries audited

**Working record:**
[C239 domain-translation scratchpad](2026-07-17-c239-domain-translation-scratchpad.md)

**Parent report:**
[C238 commercial algorithms report](2026-07-17-c238-repairports-commercial-algorithms.md)

## Executive thesis

The shared object underneath the coding and geometry vocabulary is a **compiled
capability-restoration semantics**. It represents all minimal certified ways to establish a
capability, all minimal ways to block it, the causal rules by which partial restoration unlocks
more options, and quantitative valuations such as capacity, reliability, and earliest arrival.

The leading general-purpose data structure is therefore not merely a Repair Port Capsule but a
candidate **Capability Capsule**. The leading research question is whether one proof-carrying IR
can support restoration, explanation, diagnosis, timing, capacity, and compositional reuse more
faithfully than the separate abstractions used in adjacent fields.

This report will test that thesis through programming languages, databases and provenance,
knowledge compilation, AI planning, operations research, reliability, configuration repair,
security, distributed protocols, networking, software supply chains, coded computation, and
verification. A vocabulary transplant will not count as a contribution: each retained direction
must expose a real gap and identify a theorem, algorithm, certificate, or benchmark that closes it.

The audit changes the C238 framing in one important way. The broad research object should not be
named only by the storage operation it performs. It is a **resilience knowledge compiler** whose
core linear objects are **pointed elementary capability modes**. A repair port is one finite-field
instance. Elementary flux modes in metabolic networks are a real-cone instance. Equivalent
expression families in e-graphs, derivations in provenance, and plans in monotone workflows are
nearby but not identical instances.

The audit also makes the novelty boundary stricter:

- compile-once/query-many is established knowledge compilation;
- semiring valuation of a packed derivation family is established provenance/parsing;
- monotone causal closure is established Datalog, metabolic network expansion, and planning;
- minimal blockers are established cut sets, diagnoses, transversals, and Petri-net siphons;
- finite control with tropical weights is established weighted-automata territory;
- fully abstract component interfaces and quantitative contracts are established;
- proof-producing e-graph extraction and proof-carrying computation exist; and
- holonomy/local-to-global consistency is established in gain graphs and sheaves.

What may be new is the **semantics-preserving combination**: compile elementary linear witnesses
and their blockers; preserve coefficient identity; support causal enabling and shared-resource
multi-target extraction; derive exact contextual component summaries; and emit replayable evidence
for compilation and execution.

### Bottom-line revisions to C238

1. The focused repair-port paper remains **B+ expected, A− ceiling**. This review does not justify a
   higher grade; it improves positioning and imports stronger baselines.
2. The storage Repair Port Capsule remains the best first implementation because the source
   semantics and theorem base already exist.
3. The deepest new theory program is **pointed elementary capability modes** across fields, cones,
   and linear dataflow.
4. The sharpest broader-CS implementation gap is **failure-aware, capacity-aware multi-extraction**
   for packed alternative-expression systems such as e-graphs.
5. The closest paper to theorems already in hand is **fully abstract bounded-restoration
   interfaces** from C231--C234.
6. The fastest empirical cross-domain paper is **transversally robust diverse planning**: plan
   diversity measured by minimum common failure domains, not syntactic distance.
7. “Operational/restorative provenance” is a useful interface name but not, by itself, a novelty
   claim; reverse data management and why-not/repair provenance already occupy much of that space.

## Structural prediction method

For each phenomenon proved locally, the audit also asks where related phenomena should recur and
why. The intended form is:

> We found **P** here. We predict **P′** in **X, Y, and Z** because each contains structural
> ingredients **S**. This predicts observable **O** and is falsified if the strongest baseline
> already captures O or if S is lost in the encoding.

This method is now also documented in the repository's
[discovery-track conventions](discovery-track-conventions.md) for incidental cross-domain leads.

## Claim boundary

The final report will distinguish:

- local results already proved or exactly certified;
- cross-domain identifications supported by established theory;
- new algorithms or data structures derived from the combination; and
- predictions and commercial hypotheses requiring prototypes or new theorems.

## 1. What the first report missed

The [C238 report](2026-07-17-c238-repairports-commercial-algorithms.md) correctly identified a
compiled repair control plane, proof-carrying symmetry reduction, protocol capsules, and several
commercial wedges. Its main omission was not another application. It did not identify the nearest
general disciplines strongly enough.

| Missed viewpoint | “This is actually an …” | Effect on the claims |
|---|---|---|
| knowledge compilation | target language chosen for succinctness and supported tractable queries | promotes a query/representation map; demotes generic compile-once language |
| metabolic pathway analysis | elementary modes, network expansion, and minimal cut sets | reveals the deepest linear generalization and imports mature enumeration algorithms |
| provenance/reverse data management | semiring derivations, why/why-not explanations, and input interventions | narrows “restorative provenance” to operational sequencing, resources, coefficients, and evidence |
| e-graphs/equality saturation | packed alternatives followed by cost extraction | predicts failure-aware multi-target extraction; demotes proof-carrying extraction alone |
| Petri nets and dynamic fault trees | siphons, deadlocks, sequential gates, and minimal cut sequences | demotes generic stopping-core/sequential-failure novelty |
| interface and contract theory | contextual substitutability, quotient, and resource-aware composition | reframes C231--C234 as an exact specialized interface theory |
| weighted automata and semiring parsing | finite control/derivation syntax valued in an infinite carrier | narrows C234 to its exact recovery-specific finiteness and obstruction theorems |
| gain graphs and cellular sheaves | coefficient labels with cycle-level local-to-global obstruction | reframes holonomy as a compact capability fingerprint, not a new general phenomenon |
| solution reconfiguration and viability | paths/connectivity through a solution space | narrows extension-complex novelty to continuation robustness and certified option value |
| diverse planning and OR | alternative solution pools, interdiction, and resource robustness | sharpens the objective to common failure-domain transversals |

This audit used the earlier
[`riffing-on-applications`](2026-07-12-riffing-on-applications.md) archive as a destination map. That
archive already contains hundreds of plausible verticals. The useful new move is compression:
many of those riffs are manifestations of the same six-layer semantics below.

## 2. The common object: an elementary capability system

### 2.1 Algebraic core

Let `E` be resources and `c` a distinguished capability. A source system determines a family of
labelled feasible vectors or derivations `W_c`. Depending on the domain, `W_c` may be:

- a subspace/kernel over a finite field;
- a sign-constrained real cone or polyhedron;
- a semimodule of derivations;
- an equality class of expressions; or
- a monotone action theory.

An **elementary capability mode** is an indecomposable feasible member establishing `c`. In the
finite-field repair case it is a minimal-support dual dependency through the target. In metabolic
analysis it is an elementary flux vector/mode carrying target production. In a monotone workflow it
is a minimal derivation or plan, though the linear labels may disappear.

The support shadow and its dual blockers are

```text
H_c = { support(m) : m is an elementary capability mode for c }
B_c = minimal { B subset E : B intersects every member of H_c }.
```

The support shadow alone is insufficient whenever coefficients, signs, gains, trust labels, or
side conditions affect composition. C217/C237 already give an exact warning: identical support
matroids can have different Schur-square ranks and strong-multiplicativity behavior.

The metabolism bridge is exact enough to matter but not so exact that domains can be conflated.
[Elementary flux modes](https://pmc.ncbi.nlm.nih.gov/articles/PMC544875/) are positive circuits of
an oriented vector matroid; [elementary-vector theory](https://arxiv.org/abs/1512.00267) treats
linear subspaces, subspace cones, cones, and polyhedra. Information symbols are reusable, whereas
chemical species may be consumed and fluxes obey sign and steady-state constraints. A common paper
must state the algebraic category and the preservation hypotheses, not translate by analogy.

### 2.2 Six semantic layers

One hypergraph is too coarse. The compiled object has six layers:

| Layer | Question | Local material |
|---|---|---|
| L0 support | Which resources occur in each minimal witness/blocker? | complete ports, blockers, syndrome tables |
| L1 label | Which coefficients, signs, maps, gains, or trust labels make a support valid? | functional cost, coefficient holonomy, Schur-square profiles |
| L2 causal | Which established capabilities unlock later modes? | Horn closure, stopping core, repair depth |
| L3 resource | How do simultaneous modes contend for capacity, time, or risk? | service region, shadow prices, min--max ETA |
| L4 context | What behavior can an environment observe through a module boundary? | 2-sum messages, terminal boundary controls, delay transfer |
| L5 evidence | How is compilation, quotienting, and execution independently checked? | code hashes, equations, transports, StepBooks, Lean certificates |

The neighboring fields are complementary precisely because none routinely owns all six:

| Field | Strong layers | Gap relevant here |
|---|---|---|
| knowledge compilation/provenance | L0, valuations, some recursive L2 | coefficient identity, joint L3 extraction, checked compiler passes |
| metabolism/constraint-based biology | L0--L1, cones and capacity | exact modular L4 restoration contracts and L5 evidence |
| e-graphs | packed alternatives and cost extraction | failures, causal materialization, shared multi-target capacity, blockers |
| Petri nets/workflows | rich L2 token/action semantics | elementary witnesses derived from source linear algebra |
| interface/contract theory | L4 composition and refinement | full witness extraction, blocker duality, source-algebra certificates |
| sheaves/gain graphs | L1 local-to-global consistency | L2--L3 operational restoration |
| repair-port portfolio | exact instances spanning L0--L5 | a general compiler, complexity map, and external benchmarks |

### 2.3 The product IR

`CapabilityCapsule` remains the useful engineering name:

```text
CapabilityCapsule {
  source_and_capability_hashes,
  elementary_modes + label/coefficient certificates,
  support_and_blocker_antichains,
  reverse_incidence and causal_unlock_rules,
  residual_stopping_core representation,
  resource columns and valuation expression DAGs,
  contextual boundary summaries,
  symmetry transports,
  compiler-pass and execution certificates,
  schema/version/signature metadata
}
```

This schema is not the scientific contribution. The contribution would be a representation class
with proved tractable queries, succinctness bounds, semantics-preserving transformations, and
measured advantages on at least two domains.

## 3. The strongest translations

### 3.1 Resilience knowledge compilation

[Darwiche--Marquis](https://doi.org/10.1613/jair.989) evaluates compilation languages by
succinctness and tractable queries/transformations. Apply that discipline directly:

| Representation | availability | blocker | update | plan/ETA | capacity | compose | evidence |
|---|---:|---:|---:|---:|---:|---:|---:|
| explicit mode antichain | easy | dualization-hard | incidence-local | easy | LP/MILP | poor | direct |
| BDD/ZDD | easy | sometimes symbolic | good | weighted traversal | external | variable | replay graph |
| Horn rule graph | closure-easy | residual core | excellent | causal DP | coupled | separator-dependent | rule trace |
| boundary-control table | local | local | local | weighted carrier | local | exact on decomposition | table proof |
| lazy oracle/column generation | query-dependent | hard | good | optimizer | natural | source-dependent | per-column proof |
| symmetry quotient | orbit-easy | transports | orbit-local | orbit DP | orbit LP | possible | transports |

The paper question is a **recovery knowledge-compilation map**: which queries become tractable and
which representations remain succinct under bounded radius, symmetry, and bounded interface width?
Without that map, the capsule is a format; with it, this can be a theory contribution.

### 3.2 Operational provenance

[Provenance semirings](https://www.cs.ucdavis.edu/~green/papers/pods07.pdf) already factor many
valuations through a universal derivation representation and extend to recursive Datalog through
fixed-point equations/formal power series. Why-not provenance, causality, reverse data management,
and repairs already ask how inputs must change to alter an output.

The nontrivial extension is:

```text
explanation provenance
    + executable state-changing interventions
    + algebraic/cryptographic validity labels
    + shared-resource multi-target scheduling
    + independently checkable execution evidence.
```

Call this **operational provenance**. Its first credible domain is a bounded monotone recovery
workflow—build artifacts, replicated data products, or incident runbooks—where actions create
reusable facts and every action has a verifier.

### 3.3 Elementary metabolic modes and network expansion

Metabolic analysis is the most concrete missed sibling:

- [network expansion](https://pubmed.ncbi.nlm.nih.gov/16155745/) iteratively adds reactions when
  substrates are available and computes a seed's biosynthetic scope;
- exhaustive pathway work tracks stuck reactions and awakens them when precursors appear
  ([primary paper](https://www.nature.com/articles/s41598-018-28007-7));
- elementary flux modes are minimal feasible pathways; and
- minimal cut sets block target modes and have hypergraph/dual-network algorithms
  ([MCS2](https://pmc.ncbi.nlm.nih.gov/articles/PMC6612898/)).

Import into repair ports:

1. benchmark EFM and minimal-cut-set enumerators on code-derived matrices;
2. add MILP mode generation when explicit complete ports explode;
3. use dual-network formulations for blocker compilation;
4. compare conformal elementary-vector decomposition with finite-field circuit enumeration; and
5. import pathway-relevance objectives for target-specific lazy capsules.

Export from repair ports:

1. test exact separator messages for modular network expansion;
2. compile bounded-interface reaction modules into terminal scope controls;
3. attach earliest-production expressions and shared enzyme/capacity prices; and
4. emit small pathway/cut certificates.

The export remains a hypothesis. A bioinformatics paper survives only if C231--C234 measurably
reduce repeated modular pathway analysis or prove a new decomposition theorem.

### 3.4 Failure-aware multi-extraction

E-graphs compactly store equivalent terms and extract an optimized representative. Optimal
extraction is hard in general, with strong sparse-case algorithms
([Sun--Zhang--Ni](https://doi.org/10.1145/3689801)). Proof production is established, and a verified
merge/extraction checker now exists in the
[Archive of Formal Proofs](https://devel.isa-afp.org/entries/Equality_Saturation_Checker.html).

The predicted missing problem is:

> Given several target e-classes, unavailable leaves/operators, shared execution capacities, and
> materializable intermediates, extract and certify a minimum-cost **schedule** whose earlier terms
> unlock later extractions.

This combines conditional availability, multi-root shared-subexpression choice, causal
materialization, capacity contention, stopping-core explanations, and coefficient/side-condition
checks. Applications include tensor lowering, query-plan fallback, heterogeneous compilation, and
build artifact reconstruction.

### 3.5 Fully abstract bounded-restoration interfaces

Interface automata and assume--guarantee theories already provide composition, quotient,
refinement, and full abstraction
([interface theory](https://doi.org/10.1016/j.tcs.2014.07.018)); quantitative contracts already
handle resource costs
([quantitative pricing](https://ptolemy.berkeley.edu/projects/chess/pubs/233.html)).

C231--C234 contribute a specialized exact case:

- interfaces are compiled from every bounded elementary recovery mode;
- scalar or multi-interface messages compose exactly on 2-sums;
- radius/interface width does not bound the exact quantitative response alphabet;
- terminal structural control nevertheless has a finite algebra;
- exact counts/times require an infinite carrier; and
- a finite expression syntax presents that carrier recursively.

The broad paper should prove a canonical contextual equivalence for bounded restoration modules,
identify the minimal qualitative quotient, and characterize which valuations factor through it.

### 3.6 Representation-sensitive capability

Cellular sheaves and gain graphs explain how local linear maps and cycle data control global
consistency. Spectral sheaf theory applies this to distributed agreement
([Hansen--Ghrist](https://doi.org/10.1007/s41468-019-00038-7)); network-coding sheaves address
information flow and extendability
([Ghrist--Hiraoka](https://doi.org/10.34385/proc.45.A4L-C3)).

The local result is a small exact test: the same support matroid/access structure can carry
representations with different nonlinear composition capability. The research question is whether
a gauge/cycle/cocycle fingerprint can predict that capability materially more cheaply than full
global rank or transfer analysis. Holonomy itself is not the novelty.

## 4. Structural predictions: found here, expected in X/Y/Z

These are phenomenon forecasts, not application suggestions.

| Found locally | Predicted in X/Y/Z | Structural reason | Observable/falsifier |
|---|---|---|---|
| support-identical representations have different capability | metabolic networks; network coding; tensor/linear computation | L0 forgets L1 coefficients/signs/maps | same support modes, different feasible flux/transfer/composition; falsified if support determines capability |
| parallel < sequential < unconstrained feasibility | build recovery; incident runbooks; metabolic scope | L2 actions create intermediates that unlock new modes | smallest three-way separation; falsified if the domain is one-shot or closure-complete |
| availability and throughput diverge | quorums; supplier recipes; coded computation | existential L0 witness versus L3 packing | highly available design with poor certified capacity and dual bottleneck |
| finite structural control but infinite exact value carrier | hierarchical workflows; protocol ETA; modular production | finite L4 contexts accumulate unbounded counts/delays | no finite value quotient but finite expression grammar; weighted automata may subsume it |
| local alternatives exist but no universal bridge preserves all profiles | rolling configuration; schema migration; key rotation | solution graph is locally nonempty but lacks a context-universal transition | every state has an escape, yet each migration kills a continuation class |
| support distance loses sharp composition cost | API replacement; data-layout migration; service substitution | reachability/type equality ignores functional realization cost | same exposed support, different exact composability |
| exceptional small fields change closure | modular protocols; quantized kernels; threshold cryptography | coefficient identities collapse at special characteristics/moduli | discontinuous rank/closure/security at small parameters |
| obstruction incidence factors through few carriers | IAM; metabolic modules; failure domains | blockers share a small latent incidence source | two-level store preserves answers with major memory/time reduction |
| explicit transports remove canonicalizer trust | protocol checking; hardware exploration; chemical enumeration | quotient correctness can be replayed by group actions | injected symmetry bug caught by the checker |
| hard cases occupy algebraic strata | codecs/network coding; crypto arithmetic; quantized kernels | ambiguity/rank failures lie on low-codimension loci | stratified tests find distinct bugs with fewer cases |
| continuation behavior reconstructs hidden structure | policy APIs; configuration services; code fingerprints | legal-extension oracle leaks a rigid compatibility object | bounded queries identify the hidden class; privacy defenses break rigidity |
| proof cost changes the preferred plan | agentic remediation; regulated workflows; formal builds | L5 cost is not correlated with L3 execution cost | equal-execution plans reverse order when checker cost is priced |

Three immediate prediction experiments are especially clean:

1. **E-graph three-way separation:** independent target extraction fails, sequential
   materialization succeeds, and unconstrained equality proves existence without an executable
   bounded schedule.
2. **Diverse-plan false redundancy:** equal pairwise diversity but sharply different minimum common
   failure-domain transversals.
3. **Support-identical linear systems:** matched support families in code, metabolic, or
   network-coded instances with different nonlinear/capacity behavior.

## 5. New data structures and algorithms after the transplant

### 5.1 Elementary Capability Capsule

This refines the C238 capsule by making the algebraic category and semantic layers explicit. Every
support witness carries a label type—field coefficients, signed flux, trust predicate, rewrite
proof, or plain Boolean derivation—so consumers cannot mistake support equality for semantic
substitutability.

### 5.2 Bidual witness/blocker store

Maintain witnesses and blockers as synchronized compiled views:

```text
witness antichain / lazy mode oracle
             <-> certified transversal or dual-network update
blocker antichain / residual stopping cores.
```

Use ZDD/BDD forms or factorized carrier maps when useful. Incremental source changes update both
views or content-mark one stale.

### 5.3 Failure-aware multi-extractor

Input: a packed alternative-expression graph, several targets, unavailable leaves, materialization
rules, capacities, and cost/risk models.

1. Lazily generate feasible elementary expressions/modes.
2. Close zero/low-cost materializations event-wise.
3. Solve a column-generation master problem across targets.
4. Schedule integral precedence/resource constraints.
5. Emit a dependency DAG with per-node semantic proofs.
6. Return a residual stopping core if no bounded extraction exists.

This generalizes the unlock-aware repair scheduler into a direct PL/database benchmark.

### 5.4 Multi-valuation derivation engine

Reuse semiring parsing/provenance machinery for queries that factor cleanly: existence, count,
cheapest single plan, independent reliability, earliest arrival on an acyclic derivation DAG, and
provenance explanation. Route shared-capacity packing, correlated failure, and transversal queries
to specialized solvers. The useful compiler pass decides automatically which cheap evaluator is
sound for each query.

### 5.5 Contextual recovery minimizer

Compute terminal boundary-control functions, quotient modules by contextual recovery equivalence,
minimize the finite control table, retain quantitative values as attached infinite-carrier
expressions, and generate a distinguishing context for every inequivalent pair. The distinguishing
context explains exactly which external failure/load makes two modules behave differently.

### 5.6 Transversally robust portfolio generator

Replace syntactic diversity with failure-domain coverage:

```text
repeat:
    generate the best acceptable plan avoiding selected failure domains
    update a minimum transversal of the plan family
    choose a new adversarial failure set or certify target robustness
```

This is a double-oracle/column-generation architecture. Its novelty depends on outperforming
diverse-planning and robust-optimization baselines at comparable objective cost.

### 5.7 Continuation-resilience index

For a configuration `x`, score not `|Next(x)|` but the minimum disruption hitting every safe
continuation, optionally recursively to depth `d`. Use it to choose migrations that retain causally
independent futures. Compare against viability kernels and solution-graph connectivity.

### 5.8 Certificate-cost-aware planner

Add proof bytes, checker time, trusted-code surface, and certificate freshness as resource columns.
Optimize execution and assurance cost jointly. This makes proof-carrying architecture operational
rather than decorative.

## 6. Where a substantial SOTA improvement is plausible

| Rank | Area | Strong baseline | Missing intersection | Step-function claim to test | Decisive failure |
|---:|---|---|---|---|---|
| 1 | failure-aware multi-extraction | e-graphs, query optimization, workflow scheduling | alternatives + failures + causal materialization + shared capacities + proofs | compile/recover targets fixed plans miss, with bounded overhead | standard global ILP/e-graph tooling matches it fairly |
| 2 | transversally robust plan portfolios | diverse planning, robust optimization, interdiction | family optimized against common causal failure domains | equal-cost pools survive strictly larger correlated disruptions | baselines attain the same transversal/objective frontier |
| 3 | exact bounded-restoration interfaces | interfaces, contracts, weighted automata | source-compiled modes with exact finite-control/infinite-value boundary | much smaller repeated modular analysis plus distinguishing contexts | generic tools match size, queries, and evidence |
| 4 | resilience knowledge compilation | d-DNNF/BDD/ZDD, provenance, KC maps | coefficients + causal updates + joint capacity + evidence | new succinctness or tractability frontier | merely bundles known languages with no theorem advantage |
| 5 | modular pathway analysis | expansion, EFM/MCS, FBA/MILP | exact separator transfer and reusable boundary summaries | major repeated-analysis speed/memory gain | decomposition is unnatural or existing tools dominate |
| 6 | operational provenance | why/why-not, reverse data management, planners | checked state-changing sequences with resources and cores | safer/faster build/cloud recovery | planner plus lineage supplies the same result |
| 7 | representation-sensitive linter | sheaf/gain invariants and rank tests | cheap fingerprint for support-identical differences | detect capability drift without global recomputation | fingerprint is no cheaper or less predictive |
| 8 | continuation-robust reconfiguration | solution graphs, robust control, viability | transversal diversity of future continuations | fewer rolling-change dead ends | existing connectivity/robust MPC captures it |

The first three are most concrete. Knowledge compilation is broadest but needs complexity theorems.
Metabolism is the most surprising connection and has the highest domain-validation burden.

Not promoted as generic advances: semiring evaluation, cut-set enumeration, Horn/network
expansion, Petri deadlock analysis, ordinary e-graph extraction, generic quantitative contracts,
holonomy/sheaf consistency, one safe reconfiguration path, or ordinary plan diversity.

## 7. Commercial implications

### 7.1 What remains first

The first build should still be the **Repair Port Capsule and storage recovery simulator**. It has a
real source compiler—the parity-check/generator matrix—and exact local semantics. General cloud
runbooks often lack a trustworthy declarative source, so a broad “resilience compiler” would spend
its first years solving model extraction rather than validating the core engine.

### 7.2 Best adjacent wedges

1. **Build/artifact restoration capsule.** Compile source mirrors, trusted builders, cached
   artifacts, signatures, dependency recipes, and attestations into verified reconstruction plans.
2. **Failure-aware compiler/query fallback.** Apply the multi-extractor to e-graph, tensor, query,
   or build-plan corpora with unavailable operators/devices/data sources.
3. **Resilient plan-portfolio service.** Wrap an optimizer and generate alternatives avoiding
   common causal failure domains rather than merely differing syntactically.
4. **Agentic remediation verifier.** Let an untrusted agent propose a plan; verify prerequisites,
   effects, identity, and stopping-core claims against a capsule.
5. **MPC/network-code representation linter.** Audit support-identical coefficient drift in a
   narrow, high-consequence market.
6. **Metabolic-mode compiler.** Scientifically interesting but not a first commercial product
   without a systems-biology partner and a benchmark win over EFM/FBA tools.

### 7.3 Platform later, not first

After two verticals share infrastructure, expose a typed Capability Compiler SDK:

```text
front end: field matrix | cone/polyhedron | Horn workflow | e-graph | protocol policy
middle IR: modes + blockers + labels + causal rules + resources + boundary controls
back ends: availability | plan | ETA | capacity | explanation | hardening | certificate
```

The six-layer types should prevent unsupported cross-domain assumptions. Premature unification
would erase exactly the semantic distinctions that make the work useful.

## 8. Revised paper portfolio

### Paper M — Pointed elementary capability modes

Repair circuits over finite fields and elementary flux modes over real cones become instances of a
common pointed elementary-vector construction with blockers and typed valuations.

Required: a theorem covering at least fields and subspace cones, precise preservation results, and
code/metabolic examples. Assessment: **B+/A− potential**, but only a concept today; oriented-matroid
and polyhedral theory may already contain most of it.

### Paper N — A knowledge-compilation map for redundant recovery

Classify compiled languages by succinctness, update cost, and support for availability, blocker,
planning, reliability, ETA, capacity, and composition queries.

Required: at least two nontrivial succinctness/tractability separations and one compiler.
Assessment: **A− theory potential**, currently pre-paper.

### Paper O — Failure-aware multi-extraction from packed alternatives

Treat multi-root extraction under failures, reusable materialization, shared capacity, and checked
side conditions as a distinct optimization problem.

Required: complexity classification, structured algorithm, and e-graph/tensor/query benchmark.
Assessment: strongest **PL/systems A− potential**, no paper until a prototype exists.

### Paper P — Fully abstract interfaces for bounded restoration

Bounded restoration modules have a finite qualitative contextual quotient, require an infinite
exact quantitative carrier, and admit finite recursive weighted syntax.

Theorem base: C231--C234. Required: domain-independent contexts/full abstraction, a canonical or
minimal quotient theorem, and comparison with weighted automata/contracts. Assessment: **best broad
paper closest to existing proofs; B+ now, A− if the general theorem holds**.

### Paper Q — From diverse plans to transversally robust portfolios

Show that pairwise syntactic/behavioral diversity can badly overstate contingency robustness, then
optimize the minimum common failure-domain transversal.

Required: strict separation, generation algorithm, and planning/OR benchmarks. Assessment:
**B+/A− potential** and probably the quickest broad-CS experiment.

### Paper R — Modular biosynthetic scope by certified boundary controls

Compile bounded-interface reaction modules into reusable summaries for scope, earliest production,
and target blockers.

Required: valid reaction semantics, exact composition theorem, and comparison with
network-expansion/EFM/FBA tooling. Assessment: **B+ bioinformatics potential**, highly contingent.

### Paper S — Operational provenance capsules

Enrich provenance derivations with verified actions, state-changing unlock, shared resources, and
impossibility cores.

Required: one build/database/cloud workflow language, checker, and evaluation. Assessment: **B
systems architecture today; A− only with a compelling deployment**.

### Paper T — Representation-sensitive capability shadows

Study support hypergraphs as lossy shadows of labelled linear systems and test whether compact
cocycle/sheaf fingerprints predict capabilities invisible to support.

Theorem base: C217/C237. Required: a general invariant and a second domain such as network coding.
Assessment: **B/B+ specialist**, potentially deeper if it avoids global recomputation.

### Priority order

1. Assemble the original complete repair-port paper; grade unchanged.
2. Reframe C231--C234 into Paper P and finish the interface/weighted-automata novelty audit.
3. Prototype Paper Q's transversal-diverse planning separation and generator.
4. Prototype Paper O on a small e-graph corpus.
5. Develop Paper M only after an elementary-vector/oriented-matroid specialist audit.
6. Treat Paper N as the umbrella after two concrete languages are implemented.

## 9. Falsification program

### Track A — knowledge-compilation map

Compile small code, workflow, and reaction instances into explicit antichains, BDD/ZDD, Horn rules,
and separator tables. Measure representation size, updates, and availability/blocker/plan/ETA/
capacity queries. Fail the thesis if no frontier appears beyond known KC structures.

### Track B — metabolic transfer

Compare finite-field circuit, EFM, MILP column-generation, and blocker-dual algorithms on matched
sparse systems. Test boundary-control caching on modular reaction networks. Fail if sign/consumption
semantics break exact composition or existing metabolic decomposition dominates.

### Track C — e-graph multi-extraction

Use several roots, operator/device failures, reusable intermediates, shared memory/accelerators, and
proof traces. Compare per-root greedy, global ILP, sparse extraction, and unlock-aware column
generation. Include a strict parallel/sequential/unconstrained example. Fail if a straightforward
global ILP performs adequately and leaves no assurance contribution.

### Track D — transversal plan diversity

Attach causal failure domains to diverse-planning benchmarks. Compare action/state/NCD diversity
with exact transversal robustness under correlated failures. Fail if strong baselines already
optimize the same coverage or if robustness destroys objective value.

### Track E — contextual interfaces

Generalize the triangle-relay family beyond matroid language. Minimize structural control tables,
generate distinguishing environments, and compare against generic interface/weighted-automata
encodings. Fail if this is a routine instantiation with no smaller summary or new boundary.

## 10. What should be transplanted back into repair ports

1. Adopt knowledge-compilation terminology and publish a query/representation matrix.
2. Benchmark metabolic EFM/MCS algorithms before designing another port enumerator.
3. Express clean valuations through a semiring hypergraph engine.
4. Use lazy mode/column generation when explicit capsules explode.
5. Separate L0 support identity from L1 label identity in every schema and API.
6. Keep capacity/correlated blockers in specialized solvers rather than force one semiring.
7. Expose distinguishing contexts for inequivalent module summaries.
8. Price certificate generation/checking as a resource.
9. Use e-graphs as the second-domain benchmark for sequential unlock and plan checking.

## 11. Final assessment

The review does not reveal a hidden ready-made A/A+ paper. It reveals a better research program
than an application list:

> **Compile elementary ways to establish a capability, preserve the semantic labels that make
> them valid, and support causal/resource/contextual planning with independently checkable
> evidence.**

“Elementary capability modes” gives the linear theory a home. “Resilience knowledge compilation”
gives the CS program an established evaluation discipline. The six-layer model prevents false
unification. The structural-prediction ledger turns one discovered separation into falsifiable
forecasts in neighboring fields.

The most important predicted discoveries are:

- support-identical but capability-different systems outside MPC;
- static/sequential/global three-way separations in expression and workflow systems;
- highly available but low-throughput plan/quorum/production families;
- finite contextual control with irreducibly infinite quantitative behavior; and
- locally safe reconfigurations with no continuation-robust universal bridge.

If these predictions materialize in two non-coding domains, the work becomes a general theory and
compiler architecture for redundant capability. If they do not, the focused repair-port paper and
storage controller remain worthwhile, and the broader language should be retired rather than
marketed.
