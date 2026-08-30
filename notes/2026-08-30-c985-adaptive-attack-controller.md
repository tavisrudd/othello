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
