# C985 ADR: persistent adaptive theorem-search control

**Status:** accepted for staged experimental implementation

**Date:** 2026-08-30

**Scope:** optional Ergodis campaign layer; ordering and diagnostic roles only

## Decision summary

Ergodis will treat live theorem-policy selection as a cost-aware contextual
search-control problem. Candidate theorem shapes remain exact compiled programs,
but their targeting and ordering effects are learned empirically by root stratum.

The controller will combine five mechanisms:

1. counterexample-guided candidate refinement;
2. root-scoped generation and O(1) contextual dispatch;
3. bounded shadow probes analogous to strong branching;
4. reliability/pseudo-cost estimates and paired racing;
5. two-tier durable knowledge, separating semantic facts from performance priors.

The search core remains exact. Learned evidence may select ordering and diagnostic
work but may not prune or admit a branch without an independently validated theorem
role.

### Deployment ownership

The campaign daemon owns candidate generation, evolution, exact frozen-batch
evaluation, durable statistics, and validated plan activation.  `ergodisctl` is
the human/agent steering client and temporary v0 host for the unattended evolve
loop; it is not the final evolution owner.

The solver process owns two cold-path adapters.  An event-driven watcher receives
epoch notifications and installs already validated immutable plans.  One
low-priority shadow sampler consumes fixed-size `RootSnapshot`s from a preallocated
SPSC ring and runs bounded probes in an isolated presized workspace.  It emits
compact scorecards to the watcher for batched submission to the daemon.  Search
workers neither evolve candidates nor perform socket I/O, serialization, plan
compilation, or shadow expansion.

Implementation status as of this ADR refresh: the daemon, protocol, watcher,
frozen-batch evaluator, ledger, external `ergodisctl evolve`, and runner-neutral
`theorem_search` kernel exist.  Daemon-owned evolution, live scorecard ingestion,
and the isolated shadow sampler remain staged work.  Offline theorem-search
replays validate the kernel but do not constitute that integration.

## Context

The first live C880 ordering plan exposed two distinct costs. Recomputing child
summaries created repeated work; compute-once frame ordering repaired part of it.
Even after that repair, applying the theorem score globally cost 220.9 billion
instructions and 18.76 seconds on the deterministic budget-12 diagnostic. Rejecting
the plan outside its root scope cost 91.7 billion instructions and 8.00 seconds,
essentially the no-plan path. A genuinely visited orbit-11 scope took 10.40 seconds
versus 18.69 seconds unscoped while preserving the exact answer.

The system therefore needs to learn both whether a theorem shape is useful and where
its value exceeds its evaluation cost. Aggregate predicate accuracy is not a suitable
fitness for an ordering policy. Conversely, a short noisy runtime window is not a
soundness oracle for a theorem.

## Decision

### 1. Separate proposal, semantic evaluation, and operational evaluation

The controller uses three gates:

- **semantic gate:** exact frozen-row evaluation, obstruction extraction, output-class
  hashing, and hostile replay;
- **operational gate:** paired root-stratum probes measuring descendant work and
  evaluation cost;
- **promotion gate:** held-out live probation followed by exact replay of the final
  solve.

No scalar fitness collapses these gates. Correctness and theorem role are
lexicographic constraints. Within the ordering role, candidates are ranked by states
and instructions avoided per theorem instruction, with wall time as a secondary noisy
measurement.

### 2. Make observational scope part of the candidate genome

A candidate is `(program, scope)`. Scope is a categorical bitmask over a bounded
field such as `root_orbit` or `root_candidate`. It participates in the executable hash
and is tested before VM evaluation and before optional theorem-feature construction.

Generation begins with values observed in the frozen batch and in optional live root
pulses. It proposes singleton masks and a label-aligned frozen union; an already
scoped parent mutates one observed bit at a time. Later generation operators may add
scope conjunctions only after a measured need exceeds the cost of a second dispatch
coordinate.

Accepted policies compile into a direct `root -> plan` table. Search workers perform
no plan scan. In parallel search, each worker owns one cacheline-isolated root slot and
the watcher OR-reduces active/completed masks.

### 3. Pre-sample value and cost in a shadow thread

At a root boundary the search may publish a fixed-size immutable `RootSnapshot` into
a preallocated SPSC ring. Publication is optional and contains only structural state:
selected mask, unresolved cuts, symmetry/orbit identifier, sizing tuple, and replay
seed. It performs no allocation, serialization, lock, or system call.

One low-priority sampler initially consumes snapshots. For each candidate it builds an
isolated presized workspace and runs the same bounded shadow expansion. It never
shares the live seen table or mutable theorem caches. A scorecard records:

- plan and root-stratum keys;
- probe state/instruction budgets;
- states expanded and ordering change;
- unresolved, packing, duplicate, and infeasible deltas;
- theorem calls and theorem instructions;
- completion/censoring status;
- sample count and variance state.

Candidates race on the same snapshot and budget. The sampler stops obvious losers
early and extends only survivors. One sampler and a token-bucket duty cycle are the
initial limit; extra samplers require evidence that they do not steal memory bandwidth
from the solve.

Completed analogous roots are preferred training instances. A not-yet-active root may
be probed ahead of injection when its snapshot is available. Shadow evidence is
heuristic: it cannot affect exactness except through branch ordering.

### 4. Import reliability and impact learning

The learned key is initially

```text
(plan hash, canonical root orbit, structural sizing bucket, action bucket)
```

An exact shadow probe initializes the key. Until a reliability count is reached, the
sampler may reprobe it. Afterwards the controller uses a cheap pseudo-cost estimate and
reprobes only under distribution shift, excessive uncertainty, or a held-out failure.

The primary reward is empirical search impact, not raw theorem magnitude:

```text
(descendant states avoided, instructions avoided) / theorem instructions spent
```

Rare large improvements are retained as a separate statistic rather than erased by a
mean. The first implementation stores count, sum, sum of squares, wins/losses, maximum
gain, and censored count. It does not introduce a bandit until paired racing and credit
assignment are calibrated.

### 5. Use counterexamples as active queries

`obstruction-first` is the campaign's equivalence-query analogue. Candidate generation
will retain a discrimination table of known rows/outcomes and request the smallest
program or scope split that distinguishes a collision. Exact replay either accepts the
candidate on the current corpus or returns the next permanent obstruction.

Feature-ceiling collisions request a new discriminator rather than a wider unguided
grammar. Mutation operators remain available for exploration, but later receive credit
for new observational classes and held-out wins rather than raw syntactic novelty.

### 6. Race candidates on paired canonical roots

Every race block is one canonical root snapshot. All surviving candidates receive the
same block and budget. Elimination uses rank/paired evidence so root difficulty is not
confounded with policy effect. Training and held-out orbits remain separate. Timeout
and node-budget stops are stored as censored observations, not discarded or treated as
completed runtimes.

Live probation uses state rate only when both windows retain the same root candidate
and initial structural tuple. Otherwise it uses completed-root throughput only when
both windows cross roots; an incomparable test restores the candidate.

### 7. Persist semantic knowledge and performance knowledge separately

The semantic store contains portable durable facts:

- canonical source and lowered plan hash;
- schema/presentation hash and scope;
- exact output-class hash;
- counterexamples and obstruction ancestry;
- exact replay result;
- theorem role and proof/certificate handle;
- the discrimination table.

The performance store contains conditional priors keyed by:

```text
(problem fingerprint, adapter ABI, solver/build hash, plan hash,
 root stratum, action bucket, measurement protocol, hardware class)
```

Its values are mergeable sufficient statistics, not raw node logs. A new build or CPU
may import them only as weak priors and must recalibrate. Exact falsifiers never decay;
performance estimates may be retired or placed in a new generation after detected
distribution shift.

Search threads emit only fixed-size snapshots and counters into preallocated rings.
The shadow sampler emits fixed-size scorecards to the watcher.  The watcher owns
batching and transport, while the campaign daemon owns persistence and serialization:
it appends checksummed, versioned WAL records at root completion or a coarse time
boundary, periodically compacts them into sorted immutable tables, and installs a new
manifest by atomic rename. Restart replays the WAL, restores active plan hashes/epoch,
and rebuilds the dispatch table.

The disk format is portable and versioned, not a dump of a `repr(C)` Rust structure.
The in-memory cross-thread scorecard may use `repr(C, align(64))`. Current expected
cardinality favors sorted flat records and `u64` masks; delta coding or bitmap indexes
are deferred until measured scale requires them.

The first implemented semantic-store slice is deliberately narrower than the full
campaign store. `SoundTheoremArchive` can snapshot and restore its diagnostic Pareto
frontier only when the presentation, feature DAG, and output-class content hashes match
exactly. Restore rechecks bitmap bounds, candidate ordering and identity, soundness on
the stored corpus, and pairwise non-dominance under a hard 4,096-point cap. The portable
schema carries `proof_authority: false`, and any attempt to set it is rejected. Thus a
restart can retain useful diagnostic candidates without turning a corpus observation
into a proof or pruning fact; promotion still requires its separately bound verifier or
certificate artifact. Callers must bound serialized bytes before decoding untrusted
storage.

## Consequences

### Positive

- Expensive theorem lookahead is paid only while it supplies information.
- Root-specific wins are not erased by global averages.
- Frozen semantic evidence, live performance evidence, and exactness stay distinct.
- Campaign learning survives restart and can transfer conservatively across runs.
- Candidate generation becomes counterexample- and value-of-information-driven.
- The ordinary seconds-scale solver remains free of the campaign layer.

### Costs and risks

- Shadow search consumes CPU and memory bandwidth; duty-cycle control is mandatory.
- Root-local probes approximate the live transposition environment unless the full seen
  state is reproduced, so their evidence remains heuristic.
- Reliability buckets can fragment or overfit; canonical orbits and held-out roots are
  required.
- A persistent performance prior can become stale after implementation changes; build,
  protocol, and hardware fingerprints are part of the key.
- The controller needs crash-consistent checkpointing and explicit schema migration.

## Alternatives rejected for this stage

- **One global learned score:** confounds root heterogeneity and theorem cost.
- **Generic genetic programming first:** spends budget on syntax before exploiting exact
  counterexamples and known categorical structure.
- **Neural policy first:** adds approximation and training complexity before the exact
  small-instance oracle and classical cheap estimators are exhausted.
- **Share the live workspace with a sampler:** risks contention and contaminates exact
  state.
- **Persist every event:** unnecessary volume; sufficient statistics plus armed traces
  preserve the useful evidence.
- **Trust wall time alone:** sensitive to scheduling and censoring; paired states and
  instructions are primary.

## Staged implementation

1. Persist probation outcomes and the first reliability table beside the campaign
   ledger; restore them as priors.
2. Add fixed-size root snapshots and one isolated shadow sampler with a hard node and
   duty-cycle budget.
3. Move the deterministic evolve loop from `ergodisctl` into one low-priority daemon
   worker and add batched live scorecard ingestion.
4. Add paired successive racing and held-out promotion.
5. Compile a multi-policy root dispatch table and worker-slot mask aggregation.
6. Replace mutation-only refinement with a discrimination table.
7. Add a sliding/restarted operator-selection bandit only after reward and shift tests
   are measured.

## Literature audit

This is an import/architecture memo, not a novelty or priority verdict. It makes no
claim that the combination above lacks predecessors, and no forward-citation negative
was attempted. **0 of 7 named sources were read at full text.** Five were read at the
partial depths stated below; two were abstract/metadata only.

### Sources and read depth

1. Tobias Achterberg, Thorsten Koch, Alexander Martin, *Branching Rules Revisited*.
   DOI `10.1016/j.orl.2004.04.002`.
   **Read depth: partial.** Read the accessible ZIB-report excerpt in full: abstract,
   Sections 1, 2, 2.1, 2.2, and the beginning of 2.3 (five PDF pages). This supports
   only the strong-branching/pseudo-cost setup; the reliability rule and experiments
   were characterised from the publisher abstract and are not verified against the
   missing remainder. Cached key `10.1016/j.orl.2004.04.002`, SHA-256
   `0332ea70f162cde24bad336389c39f80e79f9c6deebe6c182f30e1215752149d`, ZIB-report
   version dated 2004.

2. Philippe Refalo, *Impact-Based Search Strategies for Constraint Programming*.
   DOI `10.1007/978-3-540-30201-8_41`.
   **Read depth: abstract/metadata only.** Springer/ResearchGate abstract and DBLP
   metadata were retrieved. The statement that impact measures observed search-space
   reduction comes from that abstract; detailed algorithms and experiments were not
   read.

3. Dana Angluin, *Learning Regular Sets from Queries and Counterexamples*.
   DOI `10.1016/0890-5401(87)90052-6`.
   **Read depth: partial.** Read abstract, Section 1 including minimally adequate
   teachers, Section 2.1 on closed/consistent observation tables and distinguishing
   experiments, and Section 6 open problems. Cached published PDF key
   `10.1016/0890-5401(87)90052-6`, SHA-256
   `b579d6ce72ea21afcea2d52ea825c79ab43ac1fe81d8d6c190a2e4e59a10b264`.

4. Mauro Birattari, Thomas Stützle, Luís Paquete, Klaus Varrentrapp, *A Racing
   Algorithm for Configuring Metaheuristics*.
   **Read depth: partial.** Read Sections 2.2, 2.3, 3, 3.1, 3.2, and 6 of the GECCO
   2002 paper: formal configuration problem, instance classes, sequential blocking,
   F-Race, and conclusions. The paper has no DOI in DBLP; cached under the proceedings
   locator `isbn:1-55860-878-8:11-18`, SHA-256
   `8785d1988a80e5f941496e8bb7347cfbe02ec0104e6c21ad6a81a16effcfca13`.

5. Lin Xu, Frank Hutter, Holger H. Hoos, Kevin Leyton-Brown, *SATzilla:
   Portfolio-based Algorithm Selection for SAT*.
   DOI `10.1613/JAIR.2490`, cached arXiv version `arXiv:1111.2249`.
   **Read depth: partial.** Read Sections 1.1--1.3, portfolio-construction steps 2--12,
   Sections 2.2--2.3 on censored and hierarchical models, and Sections 3.1--3.2 on
   training splits and solver selection. Cached arXiv PDF SHA-256
   `850a7d9ce3477b8236db175418aa1a894cbd392f9a74e42d8b7efdbf434a30e0`; claims are
   about that arXiv version, not independently checked against the 2008 journal bytes.

6. Álvaro Fialho, Luís Da Costa, Marc Schoenauer, Michèle Sebag, *Analyzing
   Bandit-Based Adaptive Operator Selection Mechanisms*.
   DOI `10.1007/s10472-010-9213-y`.
   **Read depth: partial.** Read Sections 2, 3.1, and 7: credit assignment, probability
   matching/adaptive pursuit, UCB, Page--Hinkley restart, sliding-window motivation,
   and conclusions. Cached author manuscript SHA-256
   `101cf0364abd723240cb4b222cfbeb15425e3efb59e1ff3ac7b231d894287650`.

7. Armando Solar-Lezama, *Program Sketching*.
   DOI `10.1007/s10009-012-0249-7`.
   **Read depth: abstract/metadata only.** Read the Springer abstract and bibliographic
   page, specifically its description of alternating inductive synthesis with bounded
   validation/counterexamples. The advertised PDF URL returned HTML and was recorded
   by the cache as `not-a-pdf`; no full-text characterisation is made.

### Search trace and coverage

Searches were run on 2026-08-30 over web title/abstract/metadata indexes. Load-bearing
queries were:

- `reliability branching Achterberg Koch Martin original paper pseudo costs strong branching PDF`
- `F-Race algorithm configuration Birattari original paper PDF`
- `SATzilla portfolio-based algorithm selection original paper PDF`
- `impact based search Refalo constraint programming original paper PDF`
- `CEGIS counterexample guided inductive synthesis original paper PDF Solar-Lezama`
- `Angluin learning regular sets queries counterexamples 1987 PDF`
- `adaptive operator selection multi armed bandit Fialho original paper PDF`

The full published reliability-branching paper was blocked by publisher access/Anubis;
the cached public file ended after page 4 of the paper body. Refalo's full text returned
404/403 through the attempted public routes. The Springer Program Sketching PDF route
returned HTML. These are **not covered** beyond the read depths above. MathSciNet and
Google Scholar were not used. Because the memo makes no absence claim, OpenAlex,
Crossref, Semantic Scholar citing-set enumeration and exhaustive screened-set counts
were not required.

### Attribution boundary

The mapping from these classical mechanisms to Ergodis, the two-tier persistence
scheme, the shadow-thread protocol, the scorecard fields, and the import order are this
memo's architectural inferences. They are not attributed to the cited papers as claims
made by those authors.
