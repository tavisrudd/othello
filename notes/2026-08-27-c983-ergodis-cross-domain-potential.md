# C983 — Ergodis cross-domain exact compositional optimization

**Lane**: `complete-ports`

**Status**: IN PROGRESS ALONGSIDE C980; PRIVATE RESEARCH AND PROTOTYPING ONLY; DOES NOT
BLOCK C325 OR C953; NO MANUSCRIPT, MIRROR, PUSH, EXPORT, DEPOSIT, OR GENERAL
NOVELTY CLAIM AUTHORIZED

## Goal

Test the hypothesis that Ergodis is not intrinsically a coding-theory solver,
but an engine for compiling structured objects into exact finite observable
interface states and composing those states by elimination with witness lift.
The proposed organizing principle is

```text
structured component
  -> mathematically sufficient observable interface
  -> contextual quotient
  -> exact semiring-style elimination
  -> concrete optimal witness.
```

The task succeeds only if this pattern survives genuinely different domains
through one common kernel and a precise theorem boundary.  Analogy alone is not
an outcome.

## Primary research questions

1. **Contextual quotient.**  For a specified component class, admissible
   contexts, and quantitative observation, when is contextual cost equivalence
   a compositional congruence?
2. **Finite exact compilation.**  Under what explicit hypotheses does a finite
   quotient yield a canonical weighted state machine through which every exact
   optimization over a composition tree factors?
3. **Minimality.**  Which Myhill--Nerode-style minimality statement is actually
   valid over min-plus or a more general semiring, and which determinization or
   finiteness hypotheses are indispensable?
4. **Complete abstraction.**  When can the quotient be identified with a
   complete abstract domain for the chosen observations and contexts?
5. **Witnesses.**  What additional provenance must the quotient retain so an
   optimal abstract computation lifts to a concrete optimizer?
6. **State reduction.**  Can algebraic or symmetry-derived contextual classes
   reduce syntactic boundary states enough to matter beyond the current
   recovery application?

## Required exemplars

Use one common interface/compiler kernel on all three:

1. the existing exact recovery problem as the control;
2. a finite weighted-automata or quantitative-semantics problem, testing
   contextual minimization directly; and
3. an exact factor-graph, valued-CSP, scheduling, network-design, or resource-
   allocation problem whose naive boundary state has a real algebraic or
   symmetry quotient.

The third exemplar must not be a coding problem in disguise.  At least one new
exemplar must reconstruct a concrete optimal witness, not merely its value.

## Work packages

1. Run a bounded hostile priority and terminology audit covering generalized
   distributive law and exact inference, tropical/weighted automata and their
   minimization limits, valued CSP and dynamic-programming compilation,
   quantitative contextual equivalence, complete abstract interpretation,
   semiring provenance, tensor contraction, and relevant knowledge-compilation
   work.  Follow the repository literature-audit conventions before any
   novelty or absence verdict.
2. Specify the smallest common algebraic API: components, interfaces,
   observations, contexts, composition/elimination, quotient maps, and witness
   provenance.  Keep scalar min-plus, Pareto/resource, and probabilistic
   variants distinct until their laws are proved.
3. Prove or refute the congruence, exact-factorization, finiteness, and
   minimality candidates under explicit hypotheses.  Record counterexamples as
   first-class results rather than weakening definitions silently.
4. Implement the two noncoding exemplars against the common Ergodis kernel,
   retaining small independent exhaustive or generic-solver oracles.
5. Measure quotient size, compilation cost, elimination cost, memory, reuse
   break-even, and witness parity against syntactic boundary DP and an honest
   generic baseline where applicable.
6. Issue a go/no-go verdict among: recovery-only software, reusable coding and
   storage toolkit, cross-domain exact compositional-optimization library, or
   candidate general theory/compiler architecture.

## Acceptance gates

C983 closes only after all of the following:

- one precise common API is exercised by the recovery control and two genuinely
  different domains;
- every exemplar has an exact oracle and deterministic replay fixture;
- the contextual quotient and composition law have complete human proofs or an
  explicit counterexample-bounded failure report;
- the comparison separates classical min-sum/elimination machinery from any
  genuinely new interface-derivation or minimality contribution;
- at least one noncoding exemplar demonstrates material exact state reduction,
  or the task records a negative verdict with the exact searched domain and
  stop condition;
- witness lifting is exact for the accepted exemplars;
- bounded runtime and memory evidence is committed with its generator and
  replay route; and
- an independent hostile review checks theory, prior-art boundaries, API
  commonality, and benchmark fairness.

## Boundaries

Do not market analogies as results, claim a general Myhill--Nerode theorem
without its algebraic hypotheses, or call a collection of bespoke adapters one
engine.  Do not let this exploratory task alter the complete-ports manuscript,
its public Ergodis surface, or the C325/C953 release path.  Pareto repair
resources, tensor-network language, probabilistic inference, and program
synthesis remain optional probes until the three-exemplar gate passes.

## Deferred second batch: realization, observability, and learned state

Open this batch only if the three-exemplar gate establishes a genuine common
kernel.  The mathematical bridge is minimal realization and observability;
Mamba or another selective state-space architecture is a possible experimental
vehicle, not the foundation or the initial claim.

### Exact realization layer

1. Formulate sequential Ergodis composition as a discrete tropical or
   min-plus state-space system

   ```text
   s_(t+1) = F(s_t, x_t),
   y_t     = G(s_t),
   ```

   and state exactly which component trees can be represented by a scan and
   which require a more general composition graph.
2. Compare contextual indistinguishability with observability equivalence:
   two states agree exactly when every admissible future input/context produces
   the same optimal value and requested witness observables.
3. Seek a minimal-realization theorem for a bounded min-plus compositional
   class.  Separate finite quotient cardinality, tropical module dimension,
   automaton state complexity, and real vector-space dimension; none may be
   substituted for another without proof.
4. Identify the roles, if any, of reachability/controllability and
   observability.  Determine whether the canonical contextual quotient is a
   minimal reachable realization, merely a minimal deterministic quotient, or
   neither.
5. Compare the exact quotient with predictive-state representations,
   quantitative bisimulation, and complete abstract domains through a hostile
   definitions and priority audit.

### Selective exact reduction

Test whether an incoming component or a restricted future-context language
permits an exact context-dependent projection

```text
s_t -> Q_(x_t)(s_t)
```

that discards distinctions no remaining continuation can observe.  Prove
closure and witness preservation before calling this selective forgetting.
Measure it against the universal quotient and ordinary reachable-state
pruning; a relabeling of either is not a result.

### Approximate contextual geometry

Only after the exact realization layer is stable, define a bounded contextual
pseudometric such as

```text
d_C(s,s') = sup over C in C of |V(C[s]) - V(C[s'])|,
```

with an explicit finite or compact context class and finite-value conventions.
Establish nonexpansiveness or quantified error propagation under composition;
without such a theorem, local approximation error is not licensed as a global
guarantee.

Then test whether a learned encoder and recurrence can approximate the exact
semantics on instances where the exact state grows too large:

```text
phi : S -> R^d,
phi(s compose x) approximately equals F_theta(phi(s), x),
V(s,C) approximately equals G_theta(phi(s), C).
```

Use exact quotients and continuation responses on tractable instances as
ground truth.  Hold out context families and composition depths, compare
against nonrecurrent and generic neural baselines, and report worst-case as
well as average error.  Mamba earns a named role only if its input-dependent
state update materially outperforms those controls on continuation behavior or
state dimension.

### Second-batch acceptance gates

- a correct exact state-space/realization formulation with its scan-versus-tree
  boundary;
- a proved or sharply refuted minimal-realization/observability theorem;
- a literature audit spanning tropical systems, weighted automata, nonlinear
  realization, predictive-state representations, quantitative bisimulation,
  and selective state-space models;
- an exact selective reduction that is stronger than static quotienting and
  reachable-state pruning, or a bounded negative result;
- a compositional error theorem for the approximate pseudometric before any ML
  extrapolation claim; and
- learned-state experiments only after the exact gates, with exact small-case
  ground truth, held-out continuations, honest baselines, witness or value
  error, memory, and scaling evidence.

Possible outcomes must remain separated: an exact realization theorem can
succeed even if learned compression fails; learned prediction can succeed
empirically without establishing a new realization theory; and a Mamba analogy
alone closes no gate.

## First move

Perform the hostile literature/definitions audit and build a one-page theorem
matrix contrasting weighted automata, generalized distributive law, valued
CSP/DP compilation, contextual equivalence, and complete abstract domains.
From that matrix select the smallest noncoding pair that can exercise one
common exact interface and witness API without architecture commitment.

Work began on 2026-08-27 under a user-directed 90-minute research window with
15-minute hostile-review, `ej`/`tt`, and vibe checkpoints.

The preliminary theorem matrix and hostile source audit are recorded in
`notes/2026-08-27-c983-first-batch-audit.md`.  Its first verdict is narrowing:
generic semiring elimination, abstract minimization, and correctness-kernel
claims are pre-empted; C983 must contribute restricted-context small-model
bounds, an effective domain-to-interface compiler, exact witnesses, and
cross-domain evidence.  Unrestricted coordinate-selector contexts distinguish
every raw kernel entry, so they admit no nontrivial semantic quotient.

The first two executable noncoding exemplars are now fixed.  The control is a
bounded tropical weighted-tree automaton compiled through its finite reachable
valuation algebra.  The engineering falsifier is symmetric finite resource
allocation: job batches compile to min-plus relations on sorted machine-load
profiles, compose exactly, and replay assignment witnesses.  Full coordinate
queries are the required no-compression control; restricted future-job and
terminal-query grammars must show either reduction beyond permutation sorting
or a concrete reusable-composition/multi-query capability gain.  Quantitative
boundaried-network optimization is the first stretch adapter.

The first exact theorem/backend design is
`notes/2026-08-27-c983-observation-relative-compilation.md`.  It proves the
finite ranked observational-algebra quotient and separator-refinement core,
derives bounded tropical weighted-tree evaluation as a classical capability
corollary, and isolates the witness obstruction: value minimization needs a
separate provenance side-car or a proved witness-lift law.

The next capability layer treats provenance semirings, algebraic model
counting, and semiring-DP solution DAGs as established compiler backends.  The
Ergodis question is sharper: can a second context-relative pass reduce the
reachable external interface while retaining several requested projections
(value, count, optimal count, and a witness)?  This separates theorem novelty
from application novelty and makes pre-emption productive: a classical result
can become a backend or corollary while Ergodis expands the executable query
surface or materially reduces state, circuit, or witness cost.

The common theorem has now been lifted from a one-sorted ranked algebra to a
finite multi-sorted context machine.  Interface types are sorts and admissible
one-hole constructions are typed generators; partition refinement computes
the coarsest exact quotient and emits typed distinguishing paths.  Ordinary
Moore/Myhill--Nerode minimization, finite ranked algebras, bounded weighted-tree
evaluation, and finite semantics for open systems are compiler corollaries.
This is intentionally classical as mathematics.  Its purpose is a stable
cross-domain backend whose application claim can survive theorem pre-emption:
new value comes from deriving the finite semantics, reducing it materially,
supporting richer queries/witnesses, or making a previously bespoke exact
solver executable through the shared interface.

This also sharpens the proposed API.  A binary weighted relation is a useful
backend, not the universal kernel.  The kernel consumes a finite typed context
presentation—sorts, reachable carriers, typed generator actions,
observations, domain lifts, and optional witness callbacks—and emits quotient
tables plus distinguishing-path certificates.  Relations, ranked algebras,
open-system syntax, and graph parsers compile into that presentation.

A missed near-neighbor is now explicit: Myhill--Nerode methods for boundaried
graphs and hypergraphs already characterize finite-state Boolean property
recognition under gluing and tie it to bounded-width algorithms and boundary
communication.  That strongly pre-empts a generic graph-context theorem but
creates a high-value application adapter.  Ergodis can target quantitative
cost/resource profiles, multi-query evaluation, minimized generated tables,
and exact witness recovery; an infinite quotient becomes a compiler diagnostic
rather than a failed research path.  Finite integer index, protrusion
replacement, optimization meta-theorems, and representative-set DP remain a
mandatory hostile audit before any mathematical novelty claim.

The finite-integer-index audit produced a genuine sharpening.  Parameter
transposition under every graph continuation is tropical gauge equivalence of
the optimum response: response tables differ by one additive constant.  The
common backend can therefore minimize normalized response shapes while
carrying an exact scalar potential.  FII/progressive representatives become a
classical threshold-query corollary of this potential-bearing construction.
This weakens the coordinate-selector obstruction from entrywise equality to
projective equality whenever the application observes thresholds with a
transported budget, and gives Ergodis another measurable compression mode
beyond symmetry and restricted contexts.

Weighted-automata weight pushing then supplies the sequential executable
corollary: normalize potentials by shortest distances and minimize the
resulting labelled deterministic machine.  This fully pre-empts novelty for
the unary case and gives the common backend a gold-standard control.  The
remaining capability boundary is typed/multiary admissible contexts,
domain-derived finite semantics, witnesses, and composition with the other
three reduction layers.

The weighted-connectivity audit also prevents a category error.  Rank-based
treewidth DP already preserves every completion optimum by reducing a *family*
of weighted partitions to representative partial solutions, retaining at
least one optimizer.  That is not an individual-state quotient.  The emerging
Ergodis architecture therefore has four explicit, composable reduction
layers: contextual state quotient, potential/gauge normalization,
representative-family reduction, and provenance/circuit factorization.  A
cross-domain systems contribution can survive complete theorem pre-emption if
one compiler coordinates those layers, certifies their contracts, and makes
their separate state/time/witness effects visible.

A fifth capability is compilation by queries.  Angluin-style learning is
classical and weighted variants have semiring-specific feasibility limits, so
there is no generic learning novelty claim.  But Ergodis can learn a bounded
finite observational Moore machine from a legacy exact solver: context/value
queries populate the table and failed hypotheses return distinguishing
contexts.  A separator theorem, bounded exhaustive oracle, or solver-backed
counterexample search provides exact equivalence.  This would expand Ergodis
from a DP library into a black-box interface compiler while preserving an
auditable observation table and counterexample certificate.

User direction after the first checkpoint makes priority judo part of the
method: pre-emption is a stepping stone, not an abandonment trigger.  Absorb
classical results as corollaries or compiler backends, push to typed multiary
contexts, effective separator bounds, quantitative witnesses, and new
application adapters, and keep theoretical novelty distinct from capability
expansion.
