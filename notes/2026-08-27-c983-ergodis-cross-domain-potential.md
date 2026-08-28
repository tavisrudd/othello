# C983 — Ergodis cross-domain exact compositional optimization

**Lane**: `complete-ports`

**Status**: IN PROGRESS ALONGSIDE C980; PRIVATE RESEARCH AND PROTOTYPING ONLY; DOES NOT
BLOCK C325 OR C953; NO MANUSCRIPT, MIRROR, PUSH, EXPORT, DEPOSIT, OR GENERAL
NOVELTY CLAIM AUTHORIZED

The first concentrated expansion window is summarized in the
[90-minute cross-domain report](2026-08-27-c983-90m-report.md).

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

A first exhaustive cheap test found real semantic room beyond sorting.  For
three machines of cap four, jobs `{1,2}`, and every future word through length
two, 35 sorted load profiles induce 22 absolute minimum-makespan response
classes and 14 potential-normalized classes.  A larger cap-five/job-`{1,2,3}`
case gives 56, 42, and 31 respectively.  Increasing the two-machine horizon
from one to two refines 9 absolute classes back to all 10 profiles, confirming
that gains are query-profile dependent.  This does not yet prove the adapter:
job placement is nondeterministic, so the compiled state must be a min-plus
relation or residual response, not a continuation-blind chosen profile.

The weighted-tree control now has a deterministic 13-state fixture as well:
four raw final-observation fibres refine to six contextual classes, including
a recorded height-one context that separates equal-final-value vectors, while
two nontrivial classes remain merged.  It is small enough to serve as the
independent first regression for reachability, refinement, quotient replay,
and separator reconstruction.

The repository-specific design map is
`notes/2026-08-27-c983-rust-extension-surface.md`.  It preserves the current
compact composition, contextual-cache, scheduler, and witness hot paths and
places the general minimizer behind a cold `observational` compiler boundary.
The compiled artifact is flat integer tables plus independently replayable
separator traces; potential normalization and oracle learning are separate
front ends/backends.  No Rust code was changed in this research window.

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

The deferred realization/SSM batch now has a firmer stepping stone:
predictive-state representations already define controlled stochastic state by
a sufficient finite set of future-test predictions.  Core tests are separator
coordinates; their prediction vector is the observational response state.
This pre-empts “state as future predictions” and makes PSR/realization—not
Mamba itself—the mathematical bridge.  The worthwhile hybrid is narrower:
use exact Ergodis states, separators, and counterexamples as ground truth, then
learn an approximately closed recurrent response representation only where the
exact quotient or provenance carrier becomes too large.

The approximate target is now explicit as well: the supremum, over admissible
future contexts, of observation-value disagreement.  Its zero kernel is the
exact quotient and typed context generators are nonexpansive by construction.
Bisimulation metrics already own this move for probabilistic systems and give
value/aggregation error bounds.  Ergodis would need a domain-computable upper
bound and composition/witness degradation theorem; finite sampled contexts or
geometric latent closeness alone cannot certify an approximate interface.

## Application framing that survives theorem pre-emption

Ergodis should be evaluated as an exact compositional-optimization compiler,
not as ownership of any one minimization theorem.  Its durable product claims
can be stated independently of mathematical novelty:

| Capability | Established machinery absorbed | Ergodis deliverable | Acceptance metric |
|---|---|---|---|
| Explicit domain compilation | Semiring DP, automata/ranked-algebra minimization | Domain object to typed finite interface, generated evaluator, and lift | Adapter code size; oracle agreement; generated-state/time reduction |
| Certified minimization | Myhill--Nerode, weight pushing, FII | Quotient/potential tables plus distinguishing contexts and normalization trace | Minimal class count; certificate replay; absolute value recovery |
| Exact solution recovery | Backpointers, provenance semirings, representative sets | Chosen witness or requested provenance projection | Witness validity; witness bytes separated from value-state bytes |
| Compile once, query several ways | AMC, provenance, semiring polymorphism | Value/count/optimal-count/witness projections over one domain artifact | Reuse versus separate compiles; circuit and query time |
| Black-box compilation | Active automata learning | Legacy optimizer or simulator to learned finite interface | Query count; counterexample depth; exact equivalence certificate |
| Bounded-boundary graph/network solving | Graph/hypergraph Nerode, FII, rank-based DP | Generated/minimized exact network adapter behind the same API | Performance versus bespoke and generic exact solvers |
| Negative diagnostics | Infinite-index/non-determinization and learning limitations | Precise failed gate and suggested bound/observation/parameter change | No false exactness claim; reproducible counterexample family |

This framing makes priority judo concrete.  A pre-empted theorem becomes a
backend with a known contract and a regression oracle.  Progress is still real
when Ergodis adds a domain front end, combines previously separate reductions,
generates witnesses/certificates, or makes an exact solver reusable under a
stable interface.  A research theorem is extra upside, not the sole reason for
the software to exist.

### Product surfaces whose value does not depend on theorem priority

The application case should be decomposed into independently testable tools,
so discovering a classical theorem changes attribution and implementation but
does not erase the deliverable:

| Product surface | User supplies | Ergodis returns | Success independent of novelty |
|---|---|---|---|
| Interface compiler SDK | Finite explicit component algebra and query profile | Small typed evaluator, lift, and exact schema | Two unrelated adapters share the engine and beat their raw interface size |
| Oracle wrapper | Legacy exact solver plus constructors and counterexample oracle | Learned reusable finite machine | Repeated queries amortize the oracle and replay exactly |
| Artifact/verifier format | Domain-lift certificate and finite presentation | Portable quotient, split proof, schema hash, metrics | An independent process verifies and evaluates without the compiler |
| Profile-serving runtime | One compiled domain plus evolving query families | Monotonically refined value/count/resource/witness tiers | Refinement is cheaper than independent recompilation and never answers outside its schema |
| Boundary protocol compiler | Component and permitted remote continuations | Minimal structural message IDs plus explicit potential/provenance payload | The emitted protocol attains the exact one-way class bound |
| Exact-to-approximate lab | Certified large state machine | Training data, counterexamples, rollout monitor, exact fallback | It measures a real rate--distortion frontier regardless of which learned model wins |
| Feasibility diagnostic | Domain grammar and requested observation | Finite artifact or a reproducible failed gate/counterexample family | It prevents false exactness and suggests a bound, parameter, or query restriction |

These surfaces also identify plausible adopters more clearly than a generic
“cross-domain optimizer”: authors of bespoke dynamic programs, operators of
repeated exact planning services, formal-verification pipelines, distributed
systems with narrow boundary APIs, and researchers studying learned recurrent
compression.  The first release need not claim a new minimization theorem.  It
must demonstrate that an existing theorem can be absorbed behind a common
artifact without losing exact witnesses, certificates, or hot-loop control.

The minimum convincing application package is therefore three-axis rather
than three-new-theorems: one automata/algebra control, one operational
allocation or network adapter, and one legacy-oracle integration.  Each must
produce the same inspectable artifact and report compile time, raw and quotient
state/table bytes, certificate and witness bytes, repeated-query break-even,
and exact-oracle agreement.  Failure on any axis is useful architecture
evidence and does not require a novelty claim to publish as a systems result.

The exact state is also query-profile relative.  Adding contexts or output
projections intersects equivalences and can only split classes, so a retained
finite presentation supports monotone incremental refinement with the same
result as recompiling the union profile.  This suggests a practical tiered
artifact: begin with value-only/bounded futures, then refine on demand for
counts, resource coordinates, witnesses, or a larger continuation grammar.
Each split carries the newly distinguishing test.  Removing a query does not
permit blind merging; coarsening needs recomputation or retained history.

The generic quotient can also be proof-carrying.  A compact refinement
transcript lets an independent verifier check observation fibres, every
generator-induced split, quotient transition compatibility, and final
stability, then reconstruct distinguishing contexts on demand.  This proves
minimality relative to the finite presentation without trusting the compiler.
It deliberately does not prove the domain-to-presentation lift; that remains a
separate theorem or exhaustive-oracle certificate.  This is a concrete formal-
methods application rather than another analogy.

The quotient has a distributed-systems interpretation too.  If one process
owns a component, another owns its future context, and one exact message must
support the observation, the minimum message alphabet is exactly the
contextual quotient: inequivalent components need different messages, while a
class ID suffices.  The structural payload lower bound is therefore the log of
the class count.  Potential-bearing summaries must additionally transmit the
signed offset, and witness/provenance payloads remain separate.  This turns
the same compiler artifact into a minimal exact boundary protocol for the
declared application queries.

## Updated priority order

The first-batch evidence changes the expansion ranking:

1. **Finite typed compiler + proof artifact** — implementable now, with WTA
   and resource fixtures and classical minimization controls.
2. **Potential/query-profile specialization** — exact additional compression
   and incremental application queries, with FII/weight-pushing controls.
3. **Black-box exact interface learning** — the largest near-term capability
   expansion because it can wrap legacy optimizers without rewriting their DP.
4. **Boundaried graph/network adapter** — application-rich but heavily
   pre-empted theoretically; value lies in generated tables, layer composition,
   certificates, and solver integration.
5. **Adversarial/robust interface adapter** — generalize the artifact law to
   controlled branching, strategy witnesses, and alternating compatibility;
   interface automata and open games are controls, not novelty targets.
6. **Provenance/AMC/database adapter** — useful if contextual minimization adds
   measurable interface reduction beyond the compiled circuit.
7. **Predictive-state/SSM approximation laboratory** — high upside, deferred
   until exact states and contextual metrics provide ground truth.

The neural branch is now a concrete falsification experiment rather than an
analogy.  A certified exact quotient generates state/generator/successor and
future-response data; linear/PSR, MLP, GRU, and selective-SSM updates compete
under the same latent budget on response preservation, transition closure,
out-of-depth rollout, contextual distortion, and decoded-witness validity.
Mamba's primary contribution supports input-dependent retention and efficient
recurrent execution, not exact sufficiency or minimality.  It is therefore one
replaceable backend.  Whatever architecture wins, Ergodis retains the valuable
roles of exact ground-truth compiler, counterexample generator, error monitor,
and fallback solver.

The best remaining theorem targets are domain-specific: effective restricted-
context separator bounds, projectively complete separators, witness-lift laws,
and compositional approximation bounds.  The broad universal statements have
been absorbed as classical corollaries or backends.

The broadest honest theorem is now a compiler-factorization law: typed
encodings commute with every constructor and requested observations factor
through the compiled carrier, so all contexts agree by induction.  The
contextual quotient is the coarsest surjective instance.  Potential states,
representative families, and provenance circuits satisfy different variants
of the preservation diagram, while approximate passes replace equality by an
error modulus.  This makes the classical results corollaries of one certified-
pass framework without falsely identifying their compression mechanisms.

Richer operational resources also fit exactly without making scalar tradeoffs
up front.  Finite antichains of bounded nonnegative resource vectors form the
standard Pareto semiring under nondominated union and bounded Minkowski sum.
Before truncation, every nonnegative linear scalarization is a min-plus
homomorphism.  Under a hard capacity box, feasibility and scalarization remain
exact terminal projections but are not generally homomorphisms—partial
scalarization can discard a costlier vector needed to avoid later overflow.
One-dimensional bounded min-plus remains a corollary, and a provenance lift
reconstructs the chosen frontier plan.  This would let Ergodis expose helpers,
bandwidth, I/O,
link load, and latency buckets through one compiled object.  Frontier
explosion is the gate, so candidate, nondominated, contextual-state, and
witness sizes must be reported separately.

User direction after the first checkpoint makes priority judo part of the
method: pre-emption is a stepping stone, not an abandonment trigger.  Absorb
classical results as corollaries or compiler backends, push to typed multiary
contexts, effective separator bounds, quantitative witnesses, and new
application adapters, and keep theoretical novelty distinct from capability
expansion.
