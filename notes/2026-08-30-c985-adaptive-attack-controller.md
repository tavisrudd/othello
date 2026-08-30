# C985 adaptive attack controller

**Lane:** `complete-ports`

**Date:** 2026-08-30

## Decision

The C80 workflow itself should become an Ergodis feature.  The reusable object
is not an automatic theorem prover and not a source-code generator.  It is a
runtime **attack-plan compiler and experiment controller** that searches a
typed space of exact predicates, bounds, quotient levels, branch policies, and
objectives against one already compiled problem presentation.

The controller may generate and race speculative attacks without recompiling
Rust.  It may promote an attack into a solver rule only after the plan's
soundness role and replay obligation pass.  Sampled success remains a lead;
exact counterexamples are durable negatives; only a proved or independently
replayed rule becomes admissible mathematics.

## Why C80 exposes the need

The manual C80 loop has repeatedly followed the same higher-order transition:

```text
propose response state / exchange law
-> run bounded hostile strata
-> extract the first exact obstruction
-> identify the omitted observable or wrong quantifier
-> weaken or enrich the predicate
-> rerun on positive and held-out controls
-> either promote a conditional theorem or kill the route
```

The latest instance is particularly diagnostic.

1. A universal consumed-label exchange law looked plausible.
2. The first hostile q11 exchange produced a deficiency-one N successor.
3. The quantifier, not merely the edge relation, was wrong: arbitrary replies
   are irrelevant to an existential P-reply theorem.
4. Adding the proved `K_Omega` survivor as a typed admission predicate gives
   6,124/6,124 q11 and 1,930/1,930 q13 admitted opponent fibres.
5. Stratification then discovers a field split: q11 uses support equality plus
   `Omega` descent, while q13 has strict support surplus.
6. Failure attribution shows every legal reply already decreases `Omega`; the
   live obstruction is hereditary survivor re-entry.

An attack controller should perform steps 1--6 mechanically while leaving the
human-facing theorem decision explicit.

## FunSearch and AlphaEvolve as design precedents

Google DeepMind's cap-set result came from **FunSearch**: an LLM proposes
compact scoring programs, an exact executable evaluator measures the objects
those programs construct, and an evolutionary population feeds successful
programs back into later prompts.  The cap-set application matters here for
two reasons.  First, the searched artifact is a short *strategy program*, not
the enormous combinatorial object it induces.  Second, inspecting a successful
program exposed symmetry that humans could turn into a better search problem.
That is precisely the desired Ergodis loop: search over small attack policies,
then promote their recurring structure into a conjecture or theorem-derived
primitive.

**AlphaEvolve** generalizes the same proposer--evaluator--archive pattern from
one function to larger algorithms and codebases.  Its useful architectural
lessons are breadth/depth model roles, a persistent program database, multiple
objective evaluators, and evolutionary reuse of promising candidates.  The
analogue in Ergodis should be:

```text
typed attack grammar -> plan proposer -> exact stratified evaluator
                     -> Pareto archive -> mutation / human interpretation
```

Ergodis should *not* copy source-level compilation into every experiment.
Attack candidates should normally be compact data programs for the runtime VM;
only a primitive absent from the registry requires a build.  Nor should score
be confused with proof.  FunSearch's exact cap-set checker can certify a finite
construction directly, whereas an empirically successful C80 predicate is a
lead about a universal family.  Ergodis therefore adds three boundaries that
are central to mathematical use:

1. the `Necessary`/`Sufficient`/`Ordering`/`Diagnostic` effect types;
2. permanent exact counterexamples and hostile holdouts;
3. witness or refutation replay before a plan receives solver authority.

There is no primary Google source located for a system named `AlphaDerive` as
of this memo.  The likely intended general algorithm-discovery reference is
AlphaEvolve; AlphaProof is the distinct formal-proof system.

### An Ergodis-style evolutionary cycle

The proposer need not initially be an LLM.  A deterministic grammar can
enumerate all one-edit mutations of the current Pareto archive: add a feature,
change a quantifier domain, exchange a scalar for a lexicographic measure,
insert a certified survivor gate, or change an ordering key.  Each candidate
receives a content hash and parent hashes.  The evaluator returns a vector,
not one opaque reward:

```text
(soundness failures, uncovered fibres, minimum margin,
 exact states, instructions, peak bytes, evidence bytes, plan complexity)
```

Lexicographic rejection puts any soundness failure first.  Among diagnostic or
ordering plans, nondominated candidates survive.  Novelty is measured by
semantic behaviour on the permanent corpus, not merely syntax, preventing an
archive full of renamed copies.  A later language-model proposer can suggest
multi-edit plans or new symbolic features, but it talks only to the cold plan
builder and receives exact counterexamples as feedback.

The cap-set lesson about compact generative programs also suggests an output
criterion: prefer a short attack plan that generates a large certified family
or a clean symbolic pattern over a table of isolated wins.  In C80, the
q11/q13 split, the universal `Omega` descent, and the unique-survivor fibres are
exactly the kind of archive-level regularities that should be surfaced for
human theorem extraction.

AlphaEvolve adds three particularly direct refinements.  Its *evaluation
cascade* sends a candidate through test ensembles of increasing cost only
after it clears earlier gates; this is the same mechanism as the successive
halving proposed below, and should be an explicit first-class Ergodis object.
Its evolutionary database combines MAP-Elites-style behavioural niches with
island populations, which suggests defining Ergodis niches by attack family
(rank, incidence, quotient, residual obligation, certificate size) rather
than one scalar score.  Finally, it permits co-evolution of an intermediate
solution and the algorithm specialized to improve it.

For Ergodis that last mechanism becomes two coupled, but differently trusted,
archives:

- an **attack archive** of runtime plans, scores, parents, and exact failures;
- a **presentation archive** of reviewed domain views--context alphabets,
  quotient levels, strata, and registered exact feature surfaces.

The controller may redirect effort among existing presentation hashes without
recompilation and may propose a new presentation or primitive for human/code
review.  It may not mutate the trusted feature semantics itself.  A third,
append-only counterexample archive is shared by every island.  This supports
the desired loop of changing settings and redirecting the attack while keeping
old falsifiers and proof boundaries stable.

## Runtime attack algebra

Compile the domain once into immutable primitive surfaces:

- state and action sorts;
- legal-transition CSR or domain-specific transition oracle;
- exact feature producers such as defect rank, `Omega`, consumed/created
  support, cut clauses, orbit labels, moment residues, and quotient classes;
- certified survivor and necessary-bound handles;
- witness/counterexample replay functions;
- fixed workspace and evidence-footprint declarations.

An `AttackPlan` is a small typed DAG or bytecode program over those primitives:

```text
domain selector
context/quotient level
necessary filters and lower bounds
sufficient admission predicates
branch variable and move ordering
lexicographic/Pareto objective
resource/work limit
evidence and stopping policy
```

Representative operations are:

```text
Feature(id)
Cardinality(set)
Difference(left,right)
Compare(<,<=,=,>=,>)
And / Or / Not
LexLess(tuple,tuple)
AdmitCertified(handle)
ResidualFeasible(handle,budget)
Project(level,class)
BranchMin / BranchMax / OrderBy
```

Plans are loaded from a compact deterministic binary or textual schema,
validated once, and lowered to a flat micro-op array with resolved feature
indices.  No parsing, allocation, dynamic name lookup, or virtual dispatch is
allowed in the repeated state loop.

## Soundness types

Every operation and plan output carries one of four non-interchangeable roles.

| role | permitted effect | required gate |
| --- | --- | --- |
| `Necessary` | prune when false; raise a lower bound | proof constructor or exhaustive/replayable validation on its declared theorem domain |
| `Sufficient` | admit a witness/survivor or close a positive branch | independently replayable witness/certificate |
| `Ordering` | reorder branches or allocate effort | result equivalence; never changes feasibility |
| `Diagnostic` | collect correlations and propose mutations | no solver authority |

Composition follows a small effect system.  Conjunction preserves necessary
conditions; disjunction preserves sufficient conditions; an ordering or
diagnostic value can never flow into a pruning or admission opcode.  A runtime
plan failing this type check is rejected before it sees a problem state.

This is the critical safety boundary for automated attack search.  A learned
or sampled predicate may guide ordering immediately, but it cannot silently
become a theorem.

## Searching the attack space without recompilation

### Plan generation

Generate candidates from a bounded grammar rather than arbitrary programs:

- add/drop one exact feature;
- strengthen or weaken a conjunction;
- permute lexicographic coordinates;
- switch among already compiled quotient levels;
- replace a scalar bound by an exact bounded residual oracle;
- choose branch keys and value ordering from a registered family;
- introduce symbolic field/problem-size thresholds;
- lift a failed local predicate to a complete-exchange or continuation-level
  predicate;
- restrict a universal law to a certified admissible domain.

The last mutation is exactly what repaired the C80 quantifier.

### Shared feature batches

Evaluate many plans on the same states.  Build a structure-of-arrays feature
batch once, represent Boolean plan populations as bit slices, and execute one
primitive computation for every plan that requests it.  For up to 64 plans,
one machine word can carry pass/fail state across the population.  Sparse
expensive features are demand-computed and cached by exact state/presentation
key.

This changes the cost from roughly

\[
 \text{plans}\times\text{states}\times\text{feature work}
\]

to

\[
 \text{states}\times\text{distinct primitive work}
 + \text{cheap batched plan evaluation}.
\]

### Successive halving

Race plans through increasingly expensive strata:

1. permanent counterexample and corruption corpus;
2. tiny exhaustive instances;
3. symmetry-stratified sampled states;
4. held-out fields/families and hard roots;
5. instruction/RSS counters;
6. full exact solve or proof-production gate.

Kill a plan immediately on unsoundness or a strictly dominated
speed/state/evidence profile.  Promote only the small Pareto frontier.  Use
paired/interleaved timing only after state-count or instruction evidence
suggests a real gain.

### Counterexample-directed refinement

Every failed necessary or sufficient plan emits the smallest available exact
counterexample together with the first failed opcode.  The controller adds it
permanently to the first stratum, computes which missing primitive separates
the intended positive and negative controls, and proposes the smallest typed
repair.  It must also keep the unmodified failed plan and its falsifier, so the
search cannot cycle back under a renamed formula.

## Policy/controller separation

The controller is cold-path software.  Workers execute immutable validated
plans from per-thread workspaces.  A controller may compile a replacement plan
and publish it at an epoch boundary through an atomic pointer swap or low-rate
pulse.  Workers observe the new plan only between bounded search chunks; they
perform no locks, allocation, or policy bookkeeping in the candidate loop.

Parallel evaluation uses:

- one immutable feature/presentation arena;
- thread-local counters and plan workspaces on separate cache lines;
- deterministic disjoint state strata;
- batched evidence writers or per-thread files merged by record key;
- no shared mutable hash table in the hot path.

This is the same lesson as the earlier parallel-search pulse work: discovery
coordination belongs outside the core loop.

## Anti-overfitting and theorem gates

Attack-space search creates a severe multiple-testing problem.  The controller
therefore records the number and grammar complexity of tried plans and keeps
three distinct domains:

- **training:** generate/refine attacks;
- **hostile holdout:** reject accidental finite interpolation;
- **theorem domain:** exhaustive proof, symbolic argument, or independently
  replayed certificate.

Projective invariance, type correctness, monotonicity, and witness lift are
static gates when applicable.  Field thresholds must be symbolic in `q` and
tested on held-out fields; an explicit growing exception table is not a valid
uniform plan.  Description length and primitive count break empirical ties in
favour of the simpler candidate.

## C80 attack-plan instance

The present C80 plan has:

```text
Domain: positive-Omega states certified in K_Omega
Obligation: every legal opponent
Candidate: every legal reply
Admission: target in K_Omega and Omega(target) < Omega(state)
Charge: consumed > created
        or consumed = created and Omega(target) < Omega(state)
Evidence: first empty opponent fibre; first failed condition; count margins
```

The next plan population should vary only mathematically meaningful ways to
replace the recursive survivor oracle in the existence proof:

- bounded secant/pencil obstruction families;
- defect-rank continuation levels;
- complete-exchange support profiles;
- exact small-shell or `B_cc` sufficient terminals;
- symbolic q-dependent incidence bounds.

The controller should report the first opponent for which each candidate
family covers every reply.  The surviving plan must prove that this never
happens for `q >= 13`, while retaining q11 as the strict-`Omega` equality base.

### Compile against the exact residual morphism

The strongest existing C80 import is the proved depth-free residual object

```text
R(S) = (V(S), E(S), A(S)),       R(S+x) = D_x R(S),
```

where `V` is the legal locus, `E` the live load-one pair-conflict blocks, and
`A` the load-zero capacity-two blocks.  This is an exact game-tree morphism,
not a fitted signature.  It carries `Omega`, the boundary graph, and every
future legal continuation while discarding selected-point history.

The first C80 attack VM should therefore compile against `R,D`, not raw board
coordinates.  Its hottest candidate family is a short reply-priority program

```text
score(R, opponent, reply, D_reply(D_opponent(R))) -> ordered tuple
```

over exact features such as block-size spectra, consumed/created obligations,
defect-rank change, uncovered-locus shape, local secant incidence, and
continuation quotient labels.  This is the closest analogue of FunSearch's
cap-set priority functions: a compact policy describes choices across a huge
family of residuals.  The same plan is executable at every positive depth
without recompilation or a depth-indexed lookup table.

`Omega` updates should be exposed as per-active-line lost mass rather than only
one scalar.  The residual morphism proves `Omega` is monotone under every legal
move; a plan therefore searches only for a positive marginal and for the
structural survivor packet carried by the reply.  Sharing line-marginal
columns across a plan population lets many candidate incidence laws test the
same exact theorem decomposition once.

There are deliberately two payoffs.  As an `Ordering` plan, a discovered score
is safe immediately and can reduce exact recursive work even when it is not a
theorem.  As a `Diagnostic` plan, its stable algebraic motifs suggest a
nonrecursive edge predicate `E_alg(R,o,p)`.  Only a separate incidence proof or
replay certificate may promote that predicate to `Sufficient` admission.

The hostile corpus is already unusually informative:

- q17 certified `Omega=40` replies versus dominating non-survivor
  `Omega=49` decoys;
- q19 structural `Omega=169` reply versus maximum-drain `Omega=152` decoy;
- q23's 91/118 fibres where greedy minimum defect rank fails but a nonminimal
  reply enters the proved `F_d` survivor;
- the first q23 `F_d` reply outside the former rank-zero shell;
- the q11 equality branch and q13 strict-support branch found here.

A candidate that merely minimizes `Omega`, defect rank, legal-locus size, or
raw Tutte excess is already falsified by these controls.  Seeding the archive
with those killed policies and their exact witnesses prevents the evolutionary
loop from rediscovering old scalar dead ends.

### Runtime search objective for many attacks

For each `(R,o)` fibre, compute every primitive feature once in structure of
arrays and evaluate a population of priority bytecodes.  Record, per plan:

```text
top-1 survivor coverage
top-k survivor coverage and first required k
rank of first replay-certified reply
exact recursive states/instructions under that ordering
semantic failures by hostile stratum
```

Successive halving first uses rank/coverage (deterministic and cheap), then
runs exact searches only for the small Pareto archive.  This lets thousands of
plausible attacks be generated, redirected by counterexamples, and tried
without rebuilding the geometry or Rust binary.  More importantly, it avoids
requiring every useful discovery to be a theorem: an ordering win can expand
Ergodis capability now, while a persistent short expression becomes a
stepping stone toward the uniform counting theorem.

## `R^18` and residual-hitting reuse

The same runtime algebra can explore the gated real-rooted polynomial adapter:

- switch Newton-sum and congruence filters on/off;
- vary exact interlacing decks and prefix orders;
- compare residue-mask quotient levels;
- order coefficients by exact reachable-volume estimates;
- race Farkas, modular, and root-location exclusions;
- retain exact candidate and rejection certificates.

No `n=59/58` run is authorized.  The controller first has to reproduce the
approved Stage-0 counts and published `n=60` candidate census with an unchanged
plan schema.

Residual hitting becomes another registered primitive.  The newly separated
engine can decide bounded transversals with pre-sized iterative workspace and
stream complete negative evidence.  Attack plans may vary when it is invoked,
its budget, and its ordering role; they may not change the semantics of the
compiled clauses without a new proof handle.

For C80 this primitive can search *structural proof packets*: compile the
target's defect fibres as obligations and direct boundary replies, persistent
pair blocks, adaptive shells, or incidence motifs as covering actions.  A
replayed cover is a sufficient survivor certificate; an uncovered obligation
is a counterexample to that packet grammar, not to P membership.  Repeated
finite covers can then be mined for a short projectively natural packet rule.
This is a better use of evolutionary search than fitting the recursive
`K_Omega` label directly because every successful candidate retains an
inspectable proof object.

## Minimal implementation sequence

1. Define `AttackPlan`, typed primitive registry, four soundness roles, and a
   deterministic schema/hash.
2. Lower validated plans to a flat micro-op arena and evaluate them over a
   frozen feature batch.
3. Re-express the C80 `K_Omega` admission census as the first plan, requiring
   byte-identical evidence.
4. Add plan populations and successive halving in diagnostic mode only.
5. Admit ordering plans first; they have the weakest correctness risk.
6. Add replay-gated necessary/sufficient plans only after corruption and
   cross-domain controls.
7. Reuse the same surface for the integer-moment/`R^18` Stage-0 adapter and one
   residual-hitting fixture before allowing domain-specific opcodes.

## Concrete backend shape

The first implementation should use a register DAG, not a general stack
machine.  A fixed-width micro-op can be eight bytes:

```text
opcode:u8  dst:u8  left:u8  right:u8  immediate:u32
```

At most 255 registers is ample for deliberately short attack programs and
keeps decoding simple.  Compilation resolves feature names to dense indices,
canonicalizes commutative operands, folds constants, eliminates dead ops, and
records:

```text
schema version
presentation/content hash
feature-ABI hash
soundness role and proof-handle hashes
micro-op count / register count / evidence footprint
```

`AttackWorkspace::new(limits)` owns the register file, plan arena, feature
columns, survivor/result bitmaps, counters, and evidence staging buffers.
Loading a population rejects it if any declared maximum exceeds that arena.
Repeated feature production and plan execution then perform no allocation or
recursion.

For population search, lay scalar features out structure-of-arrays by reply
and evaluate one expression across a block of candidates.  Boolean results for
64 plans occupy one word; small integer comparisons can use AVX2/AVX-512 only
behind measured width/density dispatch, with the scalar path retained for tiny
fibres.  Common expression DAG nodes are interned at plan-load time so a
population pays once for shared subexpressions.

The generic interpreter is a discovery path, not necessarily the final solve
path.  A Pareto-winning `Ordering` program is lowered once into a compact
`LexKeySpec` or decision DAG over resolved feature slots.  The solver computes
that key in its existing candidate scan with no policy bookkeeping.  More
complex plans remain outside the inner loop and reorder bounded chunks at
epoch boundaries.  This gives runtime attack mutability without taxing small
solves with a permanent VM branch per primitive.

Evidence is an append-only stream of fixed records keyed by
`(presentation_hash, plan_hash, stratum, state, opponent)`.  Per-thread writers
use bounded buffers or distinct files; the merger performs deterministic key
order and duplicate suppression off the hot path.  Every run declares a byte
limit before launch, mirroring the residual-refutation writer's mandatory
record cap.

The cold grammar generator canonicalizes plans by semantic output on the
permanent corpus as well as syntax.  It can enumerate one-edit neighbours
without an LLM; an LLM or other proposer later emits the same validated plan
schema.  Thus creative generation is replaceable, while exact evaluation,
archive lineage, and proof gates remain stable infrastructure.

## Attack ledger and localized verbose tracing

Maintain two linked evidence planes with one stable identity scheme.

### Human-scale attack ledger

The source of truth is append-only structured records, with a generated
Markdown/HTML view for following the campaign.  Emit one ledger transition per
plan per evaluation stage, not one row per candidate state.  A record contains:

```text
run / presentation / plan / parent hashes
timestamp, code commit, feature ABI, seed (if any)
hypothesis and soundness role
search location: domain, quotient, stratum, depth/rank band, root/fibre set
stage and resource envelope
outcome: falsified | dominated | passed-sample | replay-certified
         ordering-win | inconclusive | resource-limit | infrastructure-error
coverage/margin, exact states, instructions, wall, peak bytes, evidence bytes
first decisive counterexample or witness key
promotion/rejection reason and next mutation family
```

The controller additionally writes low-rate **pulse summaries**--new Pareto
plans, killed attack families, first new falsifiers, current stage throughput,
and resource headroom.  These are derived views, so a crash cannot make the
human narrative disagree with the structured ledger.  `passed-sample` is a
distinct outcome and is never rendered as proved.

Keep the ledger compact by aggregating equivalent plans by semantic output on
the permanent corpus.  Store one representative, multiplicity, and parent
set; do not write thousands of renamed formulas.  Large counterexamples and
certificates live as content-addressed sidecars, while ledger records retain
only hashes, sizes, and a short decoded synopsis.

### Local verbose mode

Verbose tracing is opt-in and selected by a compiled `TraceFilter`:

```text
plan hash/prefix
state or residual hash
opponent/reply
root, depth/rank interval, quotient level, worker
event mask and maximum records/bytes
```

Events include feature production, each retained micro-op value, predicate
failure with first responsible opcode, reply ordering, prune/admit request,
certificate handle, recursive entry/exit, and resource-limit decisions.  Each
event carries the same run/plan/presentation/state keys as the ledger, so the
ledger's decisive-event link opens the exact trace.

Do not format JSON or allocate in the search loop.  When tracing is armed, a
worker writes fixed binary records into its pre-sized local staging page and
flushes to its own bounded file between chunks.  Files are merged or decoded
to JSONL/text afterward.  No shared writer, mutex, or cross-core cache line is
touched.  On byte/record exhaustion the worker emits one `trace_truncated`
record if space permits and disables its trace; solving continues unchanged.

When tracing is off, workers hold a null trace token and check it only at the
same chunk/epoch boundary used for plan pulses.  The selected trace filter is
lowered there into a direct token for the matching state/fibre; ordinary
candidates execute the original inner loop.  For exceptionally short loops
where even an event call matters, provide separate traced and untraced outer
functions so the compiler sees no logging branch in the untraced kernel.

### Replay and retention

Every trace file begins with schema, endianness, code commit, presentation and
feature-ABI hashes, plus the exact filter and limits.  A decoder rejects mixed
schemas and can independently replay feature/micro-op results against the
frozen presentation.  The default retention policy keeps the ledger,
certificates, first falsifier per semantic plan family, and promoted-plan
traces; bulk verbose traces expire or compress only through an explicit
post-run policy.  No evidence path defaults to `/tmp`, and every file sink has
a declared maximum before launch.

## Highest-EV next move

Implement stages 1--3 as a small runtime plan VM over the existing C80 feature
producers.  The acceptance test is byte-identical reproduction of both q11 and
q13 admission certificates from a loaded plan, with no source recompilation
and no allocation in repeated plan evaluation.  Then generate only
ordering/diagnostic mutations until the soundness effect system and hostile
corpus have survived independent review.

## Source scope and read depth

This section imports architecture ideas, not novelty or priority claims.  Zero
sources were read in full.

- B. Romera-Paredes et al., *Mathematical discoveries from program search with
  large language models*, Nature 625 (2024), and the accompanying Google
  DeepMind technical article -- **partial**: abstract, system description, and
  cap-set interpretation read; used for the compact-program,
  evaluator/population, and human symmetry-extraction pattern.
- M. Balog et al., *AlphaEvolve: A coding agent for scientific and algorithmic
  discovery* and the accompanying Google DeepMind technical article --
  **partial**: official system overview, evaluator/database architecture, and
  mathematical application summary read; used for the broader
  proposer--evaluator--archive design.

## Red-team boundary

- Searching a predicate grammar amplifies finite-sample coincidences.  A high
  score after thousands of trials is weaker evidence than the same score for a
  pre-registered predicate; the archive must retain trial count, genealogy,
  grammar complexity, and untouched theorem domains.
- A perfect exact evaluator certifies only what it evaluates.  It certifies a
  finite cap construction directly, but a C80 sample evaluator does not
  certify a universal field theorem.  The UI and evidence format must keep
  `Diagnostic` visibly distinct from replay-gated `Necessary`/`Sufficient`.
- Runtime programmability can quietly reintroduce interpreter overhead.  The
  admission benchmark is batched primitive work and instruction count, with
  plans lowered once to resolved flat micro-ops; no allocation, hashing, name
  lookup, locks, or indirect object graph belongs in the state loop.
- Evolution can collapse to one locally successful attack family.  Semantic
  novelty on hostile strata, multiple Pareto objectives, and explicit archive
  islands are needed before adding an expensive generative proposer.
- A newly proposed primitive is not a plan mutation: it changes the trusted
  compiled surface and needs code review, independent tests, and a fresh proof
  handle.  This prevents an LLM or controller from smuggling arbitrary logic
  through an allegedly typed opcode.
