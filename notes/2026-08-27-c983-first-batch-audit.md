# C983 first-batch theorem matrix and hostile literature audit

**Lane**: `complete-ports`

**Date**: 2026-08-27
**Status**: IN PROGRESS; PRELIMINARY THIRTY-SOURCE PASS; FOUR SOURCES READ AT
FULL TEXT AND TWENTY-SIX AT PARTIAL DEPTH; NO NOVELTY OR ABSENCE VERDICT
LICENSED

## Executive verdict

The broad claim “exact compositional optimization has a canonical minimal
state obtained from contextual behavior” is not a viable novelty target.  Its
pieces already occur in generalized distributive-law inference, weighted-
series/Hankel realization, categorical automata minimization, syntactic
congruences, and correctness-kernel/complete-abstraction theory.

The viable C983 question is narrower and more concrete:

> Can the C980 pattern derive a small, effective, witness-preserving exact
> interface from a domain's restricted admissible contexts, prove a bounded
> separating-context theorem, and compile that quotient through one reusable
> engine in genuinely different domains?

This is not generic semiring elimination or generic minimization.  The
candidate contribution is the domain-to-interface compiler, useful finite
small-model bounds, exact certificates, and empirical state reduction.

## First red-team lemma: unrestricted contexts trivialize the quotient

Let a finite typed component over a semiring have kernel

```text
K : I x J -> S
```

with serial composition by semiring matrix product.  If admissible contexts
contain the left and right coordinate selectors for every `i in I` and
`j in J`, and the observation returns the resulting scalar, then

```text
K and L are contextually equivalent iff K = L entrywise.
```

Indeed, the context consisting of the `i` left selector and `j` right selector
observes exactly `K(i,j)`.  The reverse implication is immediate from
compositionality.  Thus unrestricted exact contexts yield no nontrivial
semantic compression beyond representation-level factorization **when the
observation requires absolute scalar equality**.  For integer threshold
observations with a transported budget, finite-integer-index equivalence shows
that the exact obstruction is only equality up to an additive potential.

A nontrivial Ergodis quotient must therefore expose at least one of the
following explicitly:

1. a restricted typed context language;
2. a coarser observation, such as a radius-truncated value;
3. a gauge or normalization under which raw kernels differing entrywise have
   the same behavior;
4. unreachable or unrealizable boundary probes; or
5. a compact realization of the same kernel rather than a quotient of kernel
   values.

This distinction separates C980's bounded outer-code contexts from generic
min-plus matrix multiplication.

## Second red-team lemma: congruence is cheap; finiteness is not

For any typed compositional algebra and fixed observation family, define two
components to be equivalent when every well-typed surrounding context gives
the same observation.  Closure of contexts under substitution makes this
equivalence a congruence directly.  The quotient is the syntactic/behavioral
quotient and is minimal in the ordinary factor-through sense.

What does not follow formally is that the quotient is finite, effectively
computable, smaller than the raw response table, or represented compactly.
Those are the load-bearing Ergodis gates.  C980 supplies them for bounded
recovery by proving a finite separating-context theorem with explicit length
and rank bounds.  C983 must find analogous domain structure, not restate the
formal congruence argument.

## Preliminary theorem matrix

| Candidate C983 statement | Closest established framework | Preliminary status | Exact C983 burden |
|---|---|---|---|
| Exact local elimination over min-plus or another commutative semiring | Aji--McEliece generalized distributive law | Pre-empted as a general algorithmic principle | Supply a derived smaller interface or context class, not another message-passing statement |
| Minimal finite-dimensional weighted realization | Weighted-series Hankel rank over a field | Pre-empted over fields | Keep field-linear dimension distinct from tropical state cardinality and contextual quotient size |
| Minimal automaton from reachability and observability | Functorial automata minimization via initial/final objects and a factorization system | Pre-empted abstractly | Identify a concrete output category/context restriction and prove effective finite bounds |
| Simplify an abstract state domain while preserving exact analyzed behavior | Correctness kernels and complete abstract domains | Pre-empted abstractly | Show the Ergodis quotient is a useful computable instance with quantitative optimization and witnesses |
| Every tropical behavior has a finite deterministic exact state | Tropical weighted-automata determinization | False in general; deciding existence was a long-standing problem resolved only recently, without a complexity bound in the consulted version | State determinization/finiteness hypotheses explicitly and prefer bounded context languages at first |
| Contextual equivalence is a congruence | Syntactic congruence/functorial semantics | Formally routine once contexts compose | The result must be a small-model, effective-compilation, or state-complexity theorem |
| Witness-preserving quotient | Provenance semirings, algebraic model counting, and backpointer variants of dynamic programming | Pre-empted as a universal symbolic-evaluation idea; open as an independently compressed sidecar | Specify whether witnesses are canonical, existential, or observed only through a projection; literal witness identity can destroy quotienting |
| Compile once, answer several algebraic queries | Provenance semirings, algebraic model counting, and semiring-DP solution expressions | Pre-empted in the unrestricted algebraic sense | Test whether an additional contextual quotient shrinks the boundary state or circuit interface while retaining value, count, optimal-count, and witness projections |
| Compose typed open systems through explicit boundaries | Structured/decorated cospans and related compositional-systems formalisms | Pre-empted as composition syntax | Supply an observation compiler, effective finite carrier, quotient, separator certificate, and optimization/witness semantics |
| Derive efficient semiring DP from exhaustive specification | Polymorphic semiring shortcut fusion and constraint lifting | Pre-empted as a general derivation pattern | Derive the finite interface/context presentation itself, or add a measurable post-fusion quotient rather than restating fusion |
| Minimal exact state for bounded-boundary graph/hypergraph composition | Myhill--Nerode methods for boundaried graphs/hypergraphs and finite-state tree-decomposition DP | Strongly pre-empted for Boolean properties | Treat the theory as a graph adapter and pursue quantitative/resource/witness observations only after auditing finite-integer-index and optimization variants |
| Quotient quantitative responses up to additive cost shift | Finite integer index and progressive representatives in protrusion replacement; tropical normalization | Strongly pre-empted as a graph equivalence and algebraic gauge | Generalize it as a typed potential-bearing backend, prove threshold/FII as a corollary, and test state reduction plus witness/potential replay across domains |
| Compress a family of weighted partial solutions while preserving every completion optimum | Rank-based representative sets for connectivity DP | Strongly pre-empted for partition-connectivity operators, including weighted solutions and one retained optimizer | Treat representative-family reduction as a separate backend layer; do not misreport it as quotient-state minimization |
| Normalize potentials, then minimize a deterministic weighted machine | Weight pushing followed by ordinary automaton minimization | Pre-empted for deterministic weighted automata under the established semiring hypotheses | Make it the unary/sequential corollary and test the typed multiary/context-grammar implementation boundary |
| Infer a minimal interface by exact queries and distinguishing counterexamples | Angluin-style active automata learning and weighted extensions | Pre-empted as a learning paradigm; weighted feasibility depends strongly on the semiring | Add an oracle-backed domain compiler that learns a finite observational Moore machine, with separator/exhaustive/solver-backed equivalence queries |
| Represent state by predictions of a finite set of future tests | Predictive state representations and observable-operator models | Strongly pre-empted for controlled stochastic systems | Make core tests/separators the probabilistic corollary; use exact Ergodis states as ground truth for approximate learned response representations only after the exact compiler exists |
| Replace exact contextual equivalence by a behavioral pseudometric | Bisimulation metrics and approximate state aggregation for probabilistic systems/MDPs | Strongly pre-empted as a quantitative-equivalence idea | Define the optimization-context metric as the exact target, then prove computable bounds and composition error laws for the chosen domain/context grammar |
| Interpret quotient size as boundary information | One-way communication complexity and boundaried-graph Myhill--Nerode methods | Pre-empted as an abstract/lower-bound connection | Emit the quotient as an actual serialized component summary and report class bits plus potential/witness payloads |
| Compose exact multi-resource frontiers and reuse them across objectives | Pareto/antichain dynamic programming over an idempotent semiring | Pre-empted as multiobjective DP | Add a bounded Pareto value backend, scalarization/query projections, contextual minimization, and one witness per selected frontier point |
| Compile components whose environment and implementation make adversarial choices | Interface automata, alternating simulation/refinement, and open games | Strongly pre-empted as compositional game/interface syntax | Generalize the artifact to typed alternating/relational actions and an explicit solution concept; deterministic Moore refinement is only the cooperative corollary |
| Compile an exact mergeable stream/partition summary | List homomorphisms, monoid folds, and mergeable-summary algorithms | Pre-empted as parallel/streaming architecture | Emit a certified query-relative minimal finite merge carrier, with order/symmetry assumptions and potential/witness payload stated |
| Treat tropical recurrence as a state-space realization and minimize it | Max-plus discrete-event system realization, reachability, and observability | Strongly pre-empted; minimal realization is a distinct hard classical problem | Start with bounded observation-relative finite abstraction and compare against max-plus realization/observer controls |
| Compile a dynamic program to an exact reduced optimization graph | Exact decision diagrams for optimization and DP state merging | Strongly pre-empted as an OR systems pattern, including CP/IP integration | Add derived context/query minimization, independent certificates, potential/provenance layers, and black-box solver wrapping; benchmark against DD tools |

## Common kernel candidate

The theorem pass shows that a typed finite weighted relation is one useful
evaluation representation, but too narrow to be the kernel: ranked operations,
tree constructors, and graph gluing need not arrive as binary serial matrices.
The smallest honest cross-domain API is instead a finite typed context
presentation:

```text
FiniteContextPresentation<Sort, State, Generator, Obs>:
    finite sorts and reachable states by sort
    typed generator action State[i] -> State[j]
    observation State[i] -> Obs[i]
    domain-state lift / canonical representative
    optional symmetry normalization
    optional witness-composition callbacks

CompiledQuotient:
    class_of(state)
    quotient generator tables
    distinguishing typed path for every separated pair
    observation projection
    witness replay sidecar
```

A typed finite weighted relation remains a backend and adapter convenience:

```text
Component<I,J,S,W>:
    value   : I x J -> S
    witness : selected finite provenance for each attainable entry

serial(C,D)(i,k):
    aggregate over j of C(i,j) combine D(j,k)
```

The relation backend compiles its admissible one-hole operations into typed
generators before minimization.  A ranked algebra does the same by fixing all
coarguments except the hole.  A boundaried-graph parser uses its finite graph
constructors.  Thus the classical automata, ranked-algebra, and graph-gluing
results are instances of the presentation rather than privileged branches in
the engine.

Domain compilers, not the kernel, provide:

- the concrete component and boundary descriptions;
- the admissible context grammar;
- the observation/truncation map;
- the normalization or symmetry action;
- the proved finite separating-context bound; and
- witness composition and replay.

The engine may store a dense table, sparse table, decision diagram, automaton,
or factored circuit.  Representation compression must not be conflated with a
semantic quotient.

## Four distinct compression layers

The graph and provenance audits expose four operations that an expanded
Ergodis should keep separate even when a domain uses several together:

| Layer | What is reduced | Preservation contract | Canonical prior art/control |
|---|---|---|---|
| Contextual state quotient | Individual reachable states | Every admitted future observation | Myhill--Nerode/observational minimization |
| Potential or gauge quotient | Response shapes | Every future value plus a carried additive offset | Finite integer index/tropical normalization |
| Representative-family reduction | A set of competing partial solutions | Aggregate optimum for every completion, with at least one optimizer | Rank-based connectivity DP |
| Circuit/provenance factorization | Shared derivation syntax | Selected algebraic evaluations or witness projections | Provenance semirings/AMC/semiring DP |

Representative-family reduction is strictly not ordinary quotienting: two
partial solutions may remain distinguishable one by one, while one becomes
redundant in the linear span or lower envelope of a whole family.  Similarly,
a small provenance DAG need not have few observational states, and a small
state quotient need not give a small witness DAG.  The compiler report must
attribute every reduction to the layer that caused it.

The shared generalization is a compiler-law schema, not a shared data
structure.  Every pass declares the equation it must preserve:

```text
state quotient:       encode(g(x)) = g_bar(encode(x))
potential quotient:   encode(g(x)) = g_bar(encode(x)) + carried cocycle
family reduction:     Opt(q, reduce(A)) = Opt(q, A) for every completion q
provenance circuit:   evaluate(phi(DAG)) = phi(evaluate_free(DAG))
approximate pass:     error(g(x), g(y)) <= declared composition modulus
```

Classical algorithms become verified implementations of one row.  A pipeline
may compose them only where the output object and preservation law of one pass
meet the input law of the next.  This is the more general Ergodis work that can
remain useful even if every individual row is pre-empted.

## First exemplar decision

The first pair should be deliberately modest and hostile to overclaiming.

1. **Observation-relative weighted tree automaton control.**  Use a small
   min-plus weighted tree automaton whose full value image is not assumed
   finite, apply an exact finite observation such as a nonnegative radius
   truncation, and compile the resulting finite bottom-up response algebra.
   Compare raw run states, valuation vectors, the reachable algebra, and its
   contextual quotient; retain a distinguishing tree context and optimal run
   as witnesses.  Boolean string/tree determinization and bounded tropical
   string behavior become control special cases.  This tests multiary
   branching where the prior theory is strongest and its finiteness boundary
   is now explicit.
2. **Symmetric weighted resource allocation.**  Use a finite repeated-machine
   assignment or scheduling component whose syntactic boundary labels are
   machine identities but whose allowed future jobs and objective are
   permutation invariant.  Compile the exact orbit/context quotient, compose
   components by min-plus elimination, and reconstruct an assignment witness.
   Compare labelled-load DP, sorted-load symmetry DP, the contextual quotient,
   and a generic exact oracle.

The second exemplar is selected as an engineering falsification test, not as a
novel scheduling algorithm.  If the common kernel needs domain-specific
special cases beyond the compiler boundary, the architecture gate fails.
Finite abstract-model simplification remains the fallback second exemplar if
the resource instance has no quotient beyond obvious symmetry.

## Immediate proof obligations

1. Define the typed context grammar independently of the equivalence it is
   meant to induce.
2. Prove the coordinate-selector lemma above in the general kernel model.
3. State a finite-context syntactic-quotient theorem with no novelty claim.
4. Identify the additional bounded-separator hypothesis that turns the
   quotient into an effective compiler target.
5. Specify witness observation.  Equal optimal values do not imply equal
   concrete argmin sets, and retaining literal argmin identity may make every
   component distinguishable.
6. Derive both exemplar compilers before changing the Ergodis architecture.

## Priority-judo extraction

The generic-minimization crown is pre-empted, but it is retained as the base
case rather than abandoned.  This bounded extraction pass follows the
repository novelty-extraction convention and identifies exactly three adjacent
gaps.

### Exact pre-emption and surviving result

- GDL pre-empts generic exact semiring elimination.
- weighted-series, categorical/coalgebraic minimization, and correctness
  kernels pre-empt a generic minimal-behavior quotient theorem.
- recent semiring-DP work already compiles solution sets into reusable
  join/union expressions and can combine optimization with counting.

What survives is an effective **observational interface compiler** whose input
is a proved finite separator system for a restricted typed context language,
whose output is a minimal response quotient plus distinguishing-context and
optimal-witness certificates, and whose cross-domain value comes from deriving
the separator system mathematically rather than asking the user to invent a DP
state.

### Three adjacent gaps

1. **Effective bounded separators for multiary quantitative contexts.**  The
   categorical theory supplies existence and minimization patterns, but not the
   domain-specific finite separator radius or state-count bound.  The new
   weighted-tree-automata result shows why branching cannot be waved away:
   under initial-algebra semantics, one rank-at-least-two symbol can generate
   the entire finitely generated strong bimonoid, and hence infinitely many
   values when that bimonoid is infinite.
2. **A compiler contract joining minimization to exact provenance.**  Semiring
   DP can encode complete solution sets and evaluate many measures, while
   minimization theory identifies behavioral quotients.  The open C983 target
   is a reusable boundary between these layers: quotient the observable state,
   retain a derivation DAG as side-car provenance, and emit both an optimal
   witness and a distinguishing context without letting literal witness
   identity destroy value-state compression.
3. **Restricted-context quantitative kernels as a capability.**  Correctness
   kernels simplify an abstract domain for fixed semantic functions, and
   syntactic quotients minimize all-context behavior.  Ergodis needs the middle
   operational case: a typed grammar of admissible future components, bounded
   observations, dynamic restriction of that grammar, and exact incremental
   recompilation.  Whether this yields stronger mathematics is open; it is
   already a concrete software-expansion target.

### Six candidate extensions

1. A typed multiary bounded-observation compilation theorem with an explicit
   finite separator bound and quotient cardinality bound.
2. A separator-basis API accepting finite tests, linear/Hankel bases,
   orbit representatives, or abstract-domain extrema through one response-
   signature compiler.
3. A provenance side-car theorem reconstructing one/all/counts of optimal
   witnesses over the same value quotient.
4. Exact selective recompilation when the allowed future-context grammar
   shrinks after an input component.
5. A positive-activity theorem making bounded-cost weighted tree/context
   systems finite after zero-cost closure, with an explicit counterexample
   when activity is not extensive.
6. A decorated/structured-open-system adapter separating interface gluing from
   the quantitative observational semantics before minimization.

No new C-item is allocated: these are C983 work packages, not independent
frontiers.

### Cheap test of the top two

**Candidate 1 survives only in a sharpened form.**  Pure contextual congruence
is formal and pre-empted.  Add a finite observation set `V`, an explicitly
certified separator family `B_(I,J)`, and a domain theorem bounding `|B_(I,J)|`.
Then every component has the response signature

```text
sig(x) = (obs(R compose x compose L))_(L,R in B_(I,J)),
```

the exact quotient has at most `|V|^|B_(I,J)|` states, and a separating
coordinate is a machine-checkable distinguishing context.  The abstract bound
is elementary; the nontrivial theorem in each domain is that its small `B`
really separates all admissible contexts.  DFA suffixes, field-weighted Hankel
bases, correctness-kernel extrema, and C980 outer-code probes become supplied
separator certificates.  This is a plausible general compiler theorem, but its
mathematical novelty rests entirely on new separator bounds.

**Candidate 2 survives as the strongest application architecture.**  A
`SeparatorSystem` need expose: typed tests, finite response values, response
evaluation, completeness evidence, and a distinguisher.  The quotient compiler
deduplicates signatures and constructs transition tables.  A separate
`ProvenanceAlgebra` stores derivation DAG nodes for chosen or all optimum
transitions.  This cleanly subsumes dense Ergodis tables, projective/orbit
probes, field-linear Hankel bases, and finite partition refinement at the API
level.  It is not a new minimization theorem; it is a falsifiable route to
cross-domain capability.

The next cheap test is weighted branching.  Candidate 1 must either derive a
positive-activity/zero-closure separator bound for a useful weighted-tree class
or retreat to user-supplied finite separators.  The 2026 value-generation
theorem rules out generic finiteness from bi-local finiteness alone.

### Weighted-tree cheap-test result

The obvious full-semantics determinization route is pre-empted precisely.
Fülöp--Kószó--Vogler define the Nerode algebra of a weighted tree automaton,
construct an equivalent crisp-deterministic automaton when that algebra is
finite, give algorithms under sufficient finiteness hypotheses, and prove
undecidability of general crisp-determinizability and Nerode-algebra finiteness.
Therefore C983 must not claim a new weighted-tree Nerode construction.

The useful step past it is **observation-relative exact compilation**.  For a
nonnegative tropical automaton and radius `r`, the truncation

```text
T_r = {0,1,...,r,infinity},
a plus_r b = min(r+1, a+b),
a min_r b  = min(a,b)
```

is a finite semiring quotient when `r+1` is represented by `infinity`.
Bottom-up evaluation gives each subtree a vector in `T_r^Q`, one coordinate per
original state, so at most `(r+2)^|Q|` raw deterministic states exist.  The
reachable subalgebra can then be minimized by contextual partition refinement.
This is an application corollary of finite-Nerode/crisp-determinization theory,
not a new automata theorem, but it expands Ergodis from string-like min-plus
elimination to ranked branching and produces exact bounded values,
distinguishing contexts, and optimal-run provenance.

The potential theoretical extension is to replace a global algebra quotient by
a **typed restricted-context observation** that is compositional only for the
admissible future grammar.  This can remain finite even when full semantics and
the full Nerode algebra are infinite.  Its burden is to prove closure of the
restricted grammar and an effective separator bound; merely applying a finite
semiring homomorphism is classical.

## General theorem schema v0

Let `A` be a typed category or multicategory of components, let `V` be a finite
observation set, and let each hom-set have a well-typed family of closing
contexts.  A separator certificate for `(I,J)` is a finite context family
`B_(I,J)` such that equality of observations on `B_(I,J)` implies equality in
every admissible closing context.

Then:

1. response-signature equality is the exact contextual equivalence;
2. it is a congruence whenever admissible contexts are closed under plugging;
3. the quotient size is at most `|V|^|B_(I,J)|`;
4. every unequal pair has a distinguishing context in `B_(I,J)`;
5. any invariant predicting all admissible observations factors uniquely
   through the response signature; and
6. if each concrete composition step carries an exact derivation pointer, one
   chosen optimal witness replays inductively without refining the value
   quotient.  Observing the set or identity of witnesses instead requires the
   corresponding refined observation algebra.

This schema is deliberately presented as a compiler correctness theorem, not a
novel minimization theorem.  Its classical corollaries arise by supplying their
known separator constructions.  New C983 mathematics must provide a separator
bound for a domain where the classical frameworks do not already make it
effective.

## Sources consulted

The read depths below are unconditional and describe this preliminary pass.

1. Srinivas M. Aji and Robert J. McEliece, *The Generalized Distributive Law*.
   **Read depth: partial** — cached published PDF, DOI
   `10.1109/18.825794`, SHA-256
   `6aed6b53e9c21951f801b4bac509db26c6a68b65aa26c5a1de690cff0277779a`;
   read Sections I and II through the MPF/commutative-semiring formulation.
   The consulted text establishes exact junction-tree message passing over
   commutative semirings, includes min-sum, and explicitly emphasizes building
   graphical models to fit problems rather than assuming them a priori.
2. Stefan Kiefer, *Notes on Equivalence and Minimization of Weighted
   Automata*.  **Read depth: full text** — arXiv v1 (2020), cache key
   `arXiv:2009.01217`, SHA-256
   `db509226fae7243e165f856a30d0b1217e5c16b74c3cbcbb98239c660925cf07`.
   The field-valued theory identifies minimal linear realization dimension
   with Hankel rank and gives polynomial-time equivalence/minimization with
   short distinguishing words.
3. Thomas Colcombet and Daniela Petrisan, *Automata Minimization: a Functorial
   Approach*.  **Read depth: partial** — journal-version text in arXiv
   `1712.07121`, cache SHA-256
   `ff1fc5eccf5a537f07e85ad6b57151f8b54023a27011301ca699354f2b10df54`;
   read the abstract, Section 1, weighted-automata setup in Section 2.1,
   minimization lemma in Section 2.2, and weighted Brzozowski discussion in
   Section 5.3.  The paper derives minimal objects from initial/final automata
   and factorization systems and treats weighted automata functorially.
4. Roberto Giacobazzi and Francesco Ranzato, *Correctness Kernels of Abstract
   Interpretations*.  **Read depth: partial** — arXiv v3 (2013), cache key
   `arXiv:0910.4748`, SHA-256
   `636271d7480992f30b004a999c6d9c4a7879ea33586bcff97c5e440677d7ef73`;
   read the abstract and introduction, Section 2.2, and the correctness-kernel
   existence statement in Theorem 3.3.  It directly studies maximal abstract-
   domain simplification preserving the same best correct approximation.
5. Shaull Almagor, Guy Arbel, and Sarai Sheinvald, *Determinization of Min-Plus
   Weighted Automata is Decidable*.  **Read depth: partial** — arXiv v1
   (2025), cache key `arXiv:2503.23826`, SHA-256
   `19d8f593d428a9f0a0d4b97139b04637137870b07db8ea201496e33329a9e6ee`;
   read the abstract and Sections 1--2 through the determinization definition.
   The consulted version proves decidability, states that not every tropical
   WFA is determinizable, and gives no complexity bound for its algorithm.
6. Manfred Droste, Zoltan Fulop, Andreja Tepavcevic, and Heiko Vogler, *The
   Value Generating Power of Weighted Tree Automata with Initial Algebra
   Semantics*.  **Read depth: partial** — AFL 2026/arXiv version, cache key
   `arXiv:2608.24247`, SHA-256
   `ac3c53f23690e296d6e665d3017ca73fbeb8a677dc374ddae9360ce607437548`;
   read the abstract and introduction through both main-theorem statements and
   consequences.  The paper sharply separates string from branching value
   generation and shows that bi-local finiteness does not ensure finite initial-
   algebra behavior for weighted tree automata.
7. Ambroise Baril, Miguel Couceiro, and Victor Lagerkvist, *New Perspectives
   on Semiring Applications to Dynamic Programming*.  **Read depth: partial**
   — arXiv v1 (2025), cache key `arXiv:2512.03916`, SHA-256
   `84caf8499e0464471b1f651281e9577aab4d8d0a058af0672ae0132514777a1a`;
   read the abstract, Sections 1.1--1.2, the Semiring-Problem setup in Section
   3.1, and join/union expressions and measures in Sections 3.4--3.5.  It
   compiles solution sets for arbitrary NP problems into semiring-evaluable
   expressions and combines optimal cost with solution counting via its
   Delta-product.
8. Nick Bezhanishvili, Marcello Bonsangue, Helle Hvid Hansen, Dexter Kozen,
   Clemens Kupke, Prakash Panangaden, and Alexandra Silva, *Minimisation in
   Logical Form*.  **Read depth: partial** — arXiv v1 (2020), cache key
   `arXiv:2005.11551`, SHA-256
   `bc419d1bf5d489116c5cd90c53d015a75f3c37c92a46a983ab30fc96a15c6fd6`;
   read the introduction and contribution map.  It unifies reachability and
   observability minimization through categorical dualities and extends a
   field-weighted result to principal ideal domains.
9. Zoltan Fülöp, David Kószó, and Heiko Vogler,
   *Crisp-determinization of Weighted Tree Automata over Strong Bimonoids*.
   **Read depth: partial** — published DMTCS/arXiv v3 (2021), cache key
   `arXiv:1912.02660`, SHA-256
   `db7648afb21f4767c5d1b6e607eed90eccf7db8f2a061a17a8f5b415b47d7e12`;
   read the abstract and Section 1, including its complete contribution map.
   It constructs crisp-deterministic WTA from finite Nerode algebras or finite-
   order hypotheses, gives algorithms, and proves the relevant unrestricted
   finiteness and determinization questions undecidable.
10. Angelika Kimmig, Guy Van den Broeck, and Luc De Raedt, *Algebraic Model
    Counting*.
    **Read depth: full text** — arXiv version, cache key `arXiv:1211.4475`,
    SHA-256
    `85f68356e86627aa1929b35381a42e9aff106e129565e8a6528856c52267466c`.
    The paper evaluates semiring-labelled models over knowledge-compiled
    circuits, states the circuit/semiring conditions needed for soundness, and
    covers Boolean satisfaction, counting, weighted/probabilistic evaluation,
    MPE, shortest paths, and provenance as instances.
11. Todd J. Green, Gregory Karvounarakis, and Val Tannen, *Provenance
    Semirings*. **Read depth: partial** — cached published PDF, DOI
    `10.1145/1265530.1265535`, SHA-256
    `74e092700ff6bfc383c2049801dbe71b3dd51f38ecc4109df7073097e28c4a31`;
    read the abstract, introduction, and Section 4 through Theorem 4.3.  The
    polynomial semiring records how source tuples contribute to a positive
    relational-algebra result and is universal for subsequent commutative-
    semiring valuations.
12. John C. Baez, Kenny Courser, and Christina Vasilakopoulou, *Structured
    versus Decorated Cospans*. **Read depth: partial** — arXiv v4/published
    text, cache key `arXiv:2101.09363`, SHA-256
    `979e69fc230230f4b44c68406d6a46fb4c589bce8686ea2a4fb3100d0d8d6455`;
    read the abstract, contents, introduction, contribution map, and
    conclusion.  It constructs symmetric monoidal double categories for two
    interface-explicit presentations of open systems, compares them under
    stated hypotheses, and illustrates the syntax across circuits, Petri nets,
    dynamical systems, and epidemiological models.
13. Max A. Little, Xi He, and Ugur Kayas, *Dynamic programming by polymorphic
    semiring algebraic shortcut fusion*. **Read depth: partial** — arXiv v5,
    cache key `arXiv:2107.01752`, SHA-256
    `a0655fd6433cb72a06bed4f42138e60fc841add8b82352a500358c48e4d95b29`;
    read the abstract, introduction, Sections 2.1--2.2 through the fusion and
    constraint-lifting setup, related-work boundary, and conclusion.  It
    derives exact DP algorithms from semiring-polymorphic generators by
    shortcut fusion, supports separable algebraic constraints and generic
    backtracing, and explicitly leaves derivation of the recurrence from an
    arbitrary combinatorial generator open.
14. René van Bevern, Rodney G. Downey, Michael R. Fellows, Serge Gaspers, and
    Frances A. Rosamond, *Myhill--Nerode Methods for Hypergraphs*.
    **Read depth: partial** — arXiv v5/published text, cache key
    `arXiv:1211.1299`, SHA-256
    `abc2e891785d907596e513232f18a48797d801962e1e54d45f1630d4886da74a`;
    read the abstract, introduction and related-work survey, formal-language
    recap, and graph/hypergraph statements through Theorem 3.12.  It gives
    finite-index canonical gluing congruences as necessary and sufficient for
    finite tree-automaton recognition on generated bounded-boundary graph and
    hypergraph universes, and explicitly connects quotient index to the
    information crossing a graph boundary.
15. Hans L. Bodlaender, Fedor V. Fomin, Daniel Lokshtanov, Eelko Penninkx,
    Saket Saurabh, and Dimitrios M. Thilikos, *(Meta) Kernelization*.
    **Read depth: partial** — arXiv v3/full-paper text, cache key
    `arXiv:0904.0727`, SHA-256
    `046ea4c3b7a10752f3e501f70c2d4e5abcbe09af5b6dca06608d2d25e601b385`;
    read the abstract, contents, introduction/result map, boundaried-graph
    gluing definitions, and Section 2.3 through Definition 2.8.  Its finite
    integer index identifies boundaried parameterized instances when all
    glued continuations agree after one integer parameter transposition and
    uses progressive class representatives for protrusion replacement.
16. Hans L. Bodlaender, Marek Cygan, Stefan Kratsch, and Jesper Nederlof,
    *Solving Weighted and Counting Variants of Connectivity Problems
    Parameterized by Treewidth Deterministically in Single Exponential Time*.
    **Read depth: partial** — arXiv text, cache key `arXiv:1211.1505`, SHA-256
    `26a214e72d440e11c83e8d062a22456bda5b6e8050e4321a5d2772c6b929065a`;
    read the abstract, introduction and contribution map, and Section 3 through
    Theorem 3.7.  It defines contextual representation of weighted partition
    families by equality of the optimum under every completion partition,
    proves its DP operators preserve representation, and reduces a family to
    at most `2^|U|` retained partial solutions while preserving the optimal
    value and at least one optimizer (explicitly not all optimizers).
17. Mehryar Mohri, *Weighted Automata Algorithms*. **Read depth: partial** —
    cached handbook chapter, DOI `10.1007/978-3-642-01492-5_6`, SHA-256
    `f7976bf3d934654c2f56af38637e11a526b8d3201803b8c77b9c53ad5472399d`;
    read the introduction, semiring setup, and Sections 6.3--6.4 on weight
    pushing and minimization.  Under its stated semiring/shortest-distance
    hypotheses, weight pushing normalizes path-weight distribution without
    changing accepted weights, after which ordinary labelled-automaton
    minimization yields a minimal deterministic weighted automaton.
18. Gerco van Heerdt, Clemens Kupke, Jurriaan Rot, and Alexandra Silva,
    *Learning Weighted Automata over Principal Ideal Domains*.
    **Read depth: partial** — arXiv v2, cache key `arXiv:1911.04404`, SHA-256
    `a8e6410d2a12e6b2b3163b2aa734fff11bbe8536776d24b66b19ea0b78954c92`;
    read the abstract, introduction/contribution map, and overview of the
    membership/equivalence-query algorithm.  It gives a semiring-parametric
    weighted `L*` variant with termination conditions, proves termination for
    principal ideal domains, and exhibits nontermination over the natural
    numbers.
19. Laure Daviaud and Marianne Johnson, *Feasibility of Learning Weighted
    Automata on a Semiring*. **Read depth: partial** — published LMCS/arXiv v6
    text, cache key `arXiv:2309.07806`, SHA-256
    `f33008219542b4b47c4215be2bdf50c146d48462f98481ba89b05049fc7aef6d`;
    read the abstract, introduction/contribution map, and semiring/automaton
    setup.  It classifies limits of Angluin-style weighted hypotheses over
    arbitrary semirings through levels of guessability and literal/residual
    automata, emphasizing that existence and effective discovery are distinct.
20. Michael L. Littman, Richard S. Sutton, and Satinder Singh, *Predictive
    Representations of State*. **Read depth: full text** — NeurIPS 2001
    proceedings copy, cache key
    `NIPS:2001:1e4d36177d71bbb3558e43af9577d70e`, SHA-256
    `0d9199d40bab3dc468fb95e52d5e4bf9a78e07c6a63250397d336bda215d17b8`.
    It represents controlled stochastic state by predictions of selected
    action-observation tests, defines sufficiency as predicting every test,
    and proves that every finite-POMDP environment has a linear PSR using no
    more tests than states in a minimal POMDP.
21. Norm Ferns, Prakash Panangaden, and Doina Precup, *Metrics for Finite
    Markov Decision Processes*. **Read depth: full text** — UAI 2004/arXiv
    copy, cache key `arXiv:1207.4114`, SHA-256
    `15638e92cbe07a7e1bfd8b3071c559a83622846c330c1b9d3e8321410ebb36b4`.
    It constructs fixed-point bisimulation metrics using reward distance and
    Kantorovich/total-variation distances between transition laws, proves the
    zero kernel is bisimulation, and bounds optimal-value and aggregation error
    by the resulting behavioral distances.
22. Albert Gu and Tri Dao, *Mamba: Linear-Time Sequence Modeling with
    Selective State Spaces*. **Read depth: partial** — arXiv abstract and
    primary-paper metadata, cache key `arXiv:2312.00752`; read the abstract and
    contribution summary.  The paper makes selected SSM parameters functions
    of the input, so the recurrence can selectively propagate or forget
    information, and supplies a hardware-aware parallel algorithm for the
    resulting recurrent computation.  It does not claim that its learned
    hidden state is an exact contextual quotient, a behaviorally minimal
    realization, or sufficient for every future test.  Mamba is therefore an
    experimental approximation vehicle here; PSR, automata, and realization
    theory remain the mathematical controls.
23. Luca de Alfaro and Thomas A. Henzinger, *Interface Automata*. **Read
    depth: partial** — FSE 2001 primary-paper abstract and institutional
    metadata, DOI `10.1145/503209.503226`; read the abstract and contribution
    summary.  It models temporal input assumptions and output guarantees,
    defines optimistic compatibility, and uses alternating refinement with a
    game-theoretic basis.  This pre-empts treating adversarial component
    compatibility as ordinary deterministic context minimization.
24. Neil Ghani, Jules Hedges, Viktor Winschel, and Philipp Zahn,
    *Compositional Game Theory*. **Read depth: partial** — primary arXiv
    abstract, cache key `arXiv:1603.04641`; read the abstract and model summary.
    Open games form a symmetric monoidal category, compose sequentially and in
    parallel, and expose play, returned utility, equilibria, and off-equilibrium
    best responses relative to an environment.  Composition of games is thus
    established; any Ergodis contribution must compile a finite exact response
    interface for a declared solution concept, not rediscover open-game syntax.
25. Sergei Gorlatch, *Extracting and Implementing List Homomorphisms in
    Parallel Program Development*. **Read depth: partial** — primary journal
    abstract and metadata, DOI `10.1016/S0167-6423(97)00014-2`; read the
    abstract and contribution summary.  It treats homomorphic list functions
    as the divide-and-conquer parallel pattern, systematically extracts
    homomorphic representations (including embeddings of almost-homomorphic
    functions), and derives parallel implementations by equational reasoning.
26. Pankaj K. Agarwal, Graham Cormode, Zengfeng Huang, Jeff M. Phillips,
    Zhewei Wei, and Ke Yi, *Mergeable Summaries*. **Read depth: partial** —
    primary PODS/full-paper copy; read the abstract/model summary and opening
    definition.  A mergeable summary combines independently computed summaries
    of data partitions and then answers queries; restricting one partition to
    a single item recovers streaming updates.  It develops approximate and
    randomized as well as deterministic summaries, so exact finite Ergodis
    compilation is a narrower regime, not a replacement for the broader
    streaming literature.
27. Bart De Schutter, Vincent Blondel, Remco de Vries, and Bart De Moor,
    *On the Boolean Minimal Realization Problem in the Max-Plus Algebra*.
    **Read depth: partial** — primary journal abstract and metadata, DOI
    `10.1016/S0167-6911(98)00035-8`; read the abstract and problem statement.
    It studies the smallest max-linear discrete-event-system state-space model
    realizing a given impulse response, characterizes minimal system order in
    its Boolean regime, and gives a canonical response representation.  This
    makes tropical minimal realization established specialist territory, not a
    consequence that C983 can claim from finite contextual minimization.
28. Michael J. Gazarik and Edward W. Kamen, *Reachability and Observability of
    Linear Systems over Max-Plus*. **Read depth: partial** — primary journal
    summary and metadata, *Kybernetika* 35(1), 1999; read the abstract/summary.
    It develops weak reachability and weak observability conditions for
    max-plus linear systems and uses residuation both to generate controls and
    to estimate states.  The control-theoretic observability bridge is therefore
    literal and classical; Ergodis must specify its restricted query semantics,
    finite abstraction, and witness/certificate additions.
29. Willem-Jan van Hoeve, *An Introduction to Decision Diagrams for
    Optimization*. **Read depth: partial** — primary INFORMS tutorial abstract
    and accessible tutorial text, DOI `10.1287/educ.2024.0276`; read the
    abstract and exact top-down compilation summary.  It presents decision
    diagrams as scalable representations of state-based dynamic programs,
    builds exact diagrams by expanding the transition graph while merging
    equivalent states, and integrates them with constraint programming,
    integer programming, network flow, and branch-and-bound.
30. Alejandro A. T. Castro, Andre A. Cire, and J. Christopher Beck,
    *Decision Diagrams for Discrete Optimization: A Survey of Recent
    Advances*. **Read depth: partial** — primary arXiv abstract and survey
    metadata, cache key `arXiv:2201.11536`; read the abstract and scope summary.
    It surveys exact and approximate decision diagrams as an established
    optimization technology used inside integer and constraint programming.
    This makes the decision-diagram ecosystem a required implementation and
    benchmark control for the C983 OR path.

## Max-plus control and discrete-event systems

The tropical SSM analogy has a direct classical ancestor.  Max-plus linear
discrete-event systems use recurrences of the form

```text
x(k+1) = A tensor x(k) plus B tensor u(k)
y(k)   = C tensor x(k),
```

and already study reachability, observability, state estimation, and minimal
realization from input/output behavior.  This is a stronger and more relevant
mathematical control than Mamba for Ergodis' min-plus recurrence.  It also
blocks the ambitious claim that observational tropical state or minimal
tropical realization is newly introduced here.

The surviving application is discrete-event planning: manufacturing/event
timing, transport, queues, and synchronization networks naturally expose
max-plus/min-plus recurrences.  An Ergodis adapter can bound or type the event
interface, compile only the requested deadline/resource observations, minimize
the resulting finite exact machine, retain schedule/control witnesses, and
ship a verifier.  Its controls are the original max-plus realization and
observer where applicable, plus the unquotiented bounded evaluator.

This distinction may be productive theoretically.  Classical realization
minimizes a model for the full impulse/input-output behavior under its algebraic
hypotheses.  Ergodis deliberately asks for the coarsest exact state relative to
a restricted context grammar and query profile, possibly after capacity or
deadline truncation.  Neither state count need dominate the other: linear or
tropical realization dimension, finite quotient cardinality, and circuit size
are different measures.  The experiment must report all applicable measures
and must not call a bounded quotient a realization of the unbounded system.

## Decision diagrams and the OR compiler boundary

Decision diagrams are the closest mature systems competitor to the proposed
operations-research expansion.  They already compile a sequential DP model
into a layered graph, merge equivalent states in exact diagrams, deliberately
merge or drop states for relaxed/restricted approximations, and integrate the
result with CP, IP, network-flow, and branch-and-bound methods.  Therefore the
claim “compile a structured optimization problem into a smaller reusable DP”
is not merely broad—it is already a working OR paradigm.

The Ergodis wedge must be testably different:

1. derive an observation/context-relative equivalence rather than accept only
   the state-equivalence supplied by a DP formulation;
2. emit a coarsest finite quotient certificate for the declared presentation;
3. keep potential normalization, representative-family reduction, and
   provenance factorization as typed passes instead of one generic node merge;
4. refine an artifact as new query profiles arrive;
5. reconstruct and validate domain witnesses with separately measured memory;
6. learn the interface from a black-box exact optimizer when no explicit DP is
   supplied; and
7. serialize the same verifier-facing artifact across non-OR adapters.

If a decision-diagram package already provides those features for an exemplar,
Ergodis should use or wrap it.  A head-to-head systems gate compares node/arc
count, bytes, compile time, repeated-query time, witness memory, and solver
integration effort against exact DD compilation.  “Beats CP-SAT” without this
control is no longer an adequate practical claim.

This also gives approximation a safer route.  Relaxed decision diagrams can
supply admissible optimization bounds and branch-and-bound controls, while the
contextual pseudometric supplies a semantic distortion target.  A merge is
certified exact only by the quotient law; otherwise it must advertise either a
DD relaxation bound or a proved contextual error modulus.  Learned latent
states are a third, heuristic tier and do not inherit either guarantee.

## Exact mergeable summaries and parallel folds

Sequential contexts and tree constructors already imply a streaming/parallel
interpretation, but the application contract should say when arbitrary
partitioning is legal.  For an ordered stream, a summary map `S` is exactly
mergeable when

```text
S(u ++ v) = merge(S(u), S(v))
```

with associative `merge` and an empty-stream identity.  This is a list/monoid
homomorphism, an established parallel-programming pattern.  If the input is an
unordered multiset or partitions may be permuted, `merge` must additionally be
commutative or the artifact must retain order.  A one-item streaming update is
weaker than arbitrary mergeability; an adapter must not infer the latter from
the former.

Ergodis can contribute an application product without claiming this algebra:
given a finite segment algebra and a declared family of suffix/prefix or merge
contexts, compute its smallest certified exact query-relative quotient and
emit `summarize`, `merge`, `query`, and optional witness/provenance replay.  The
ordinary syntactic monoid/list-homomorphism construction is the classical
control.  Potential-bearing summaries add an explicit offset, and query-profile
refinement lets the same stream service add exact outputs without silently
using an under-specified state schema.

This terrain connects the compiler to parallel data processing, distributed
telemetry, incremental analytics, and exact cache/materialized-view summaries.
The convincing metric is not asymptotic novelty: compare raw segment state,
minimal exact merge state, merge-table bytes, partition-order restrictions,
certificate size, and the break-even over repeated distributed queries.
Approximate sketches remain a later metric/covering backend and must retain
their probability and error guarantees rather than being described as an
exact quotient.

## Knowledge-compilation and provenance connection

The provenance audit changes the witness design from an analogy into a
backend boundary.  A factorized solution/provenance DAG can be evaluated under
several observations, while the Ergodis quotient can minimize the reachable
boundary behavior for a chosen family of future contexts.  The two
compressions are orthogonal:

1. knowledge compilation factors the derivation or model set;
2. contextual quotienting merges interface states with the same admissible
   future behavior.

The useful capability target is therefore not the already-established claim
that one symbolic object supports many semiring evaluations.  It is an
adapter that compiles a domain object into a factorized provenance carrier,
then proves or computes a smaller context-relative interface without losing
the requested value/count/optimal-count/witness projections.  Experiments
must report solution-DAG size, reachable raw response count, minimal quotient
count, transition/circuit size, and runtime provenance memory separately.

This opens two concrete application adapters missed by the initial ranking:
database-query provenance and knowledge-compiled exact inference.  They count
as Ergodis expansion only if the interface quotient or witness/query plumbing
adds a measurable capability beyond the existing circuit compiler.

## Open-system and constructive-DP connection

Structured and decorated cospans supply a mature typed syntax for composing
open systems in series and parallel.  They make explicit what Ergodis needs at
its front end—objects as interfaces and morphism-like cells as components—but
do not by themselves derive an optimization observation, a finite sufficient
carrier, or its minimal context-relative quotient.  The useful adapter split
is therefore:

```text
open-system syntax (cospan/operad/domain tree)
    -> exact finite observational semantics
    -> reachable carrier
    -> contextual minimizer + separator certificate
    -> value/query/witness projection.
```

Likewise, polymorphic semiring shortcut fusion already derives efficient DP
evaluation from an exhaustive semiring-polymorphic generator and supports
separable constraints and generic backtracing.  Its stated limitation—relying
on a domain recurrence rather than deriving one from arbitrary combinatorial
specification—clarifies a potential Ergodis capability boundary.  Ergodis can
either compile the finite interface/context presentation from domain
structure, or apply an independently measured observational quotient after a
fusion/provenance backend.  Merely expressing an existing Bellman recurrence
over another semiring is pre-empted.

## Proof-carrying abstract interpreters and model checkers

Correctness kernels already formalize simplification of an abstract domain
while preserving the behavior of selected abstract semantic functions.  That
pre-empts “derive the least state distinctions relevant to an analysis” at the
abstract level and gives Ergodis a direct formal-methods backend.

The application product is a finite analysis compiler.  It accepts a finite
abstract carrier, typed transfer functions, and an assertion/cost query
profile; computes the coarsest stable observational quotient; and emits dense
transformer tables, a refinement certificate, and optional trace provenance.
Adding assertions or transfers refines the artifact monotonically.  The same
schema can serve finite protocol model checking, resource-aware static
analysis, runtime monitors, and repeated verification of component instances.

The trust boundary must be explicit.  The generic quotient certificate proves
only that the minimized abstract machine preserves the supplied abstract
transformers and observations.  Concrete soundness, completeness, or best-
correct-approximation claims belong to the input abstract interpreter and need
a separate proof.  Likewise, a value/reachability quotient does not
automatically reconstruct a concrete counterexample trace; transient
provenance or a witness-liftable abstraction is required.

This is a particularly clean pre-emption-proof application: even if every
mathematical step is a correctness-kernel or automata-minimization instance,
Ergodis can still provide a common serialized artifact, independent verifier,
query-profile refinement, quantitative/Pareto observations, and exact trace
plumbing.  Acceptance is measured by abstract-state/table reduction,
certificate replay, repeated-check latency, and agreement with the original
analyzer—not by claiming new abstract-interpretation theory.

## Adversarial interfaces, games, and robust composition

The deterministic context-machine theorem assumes that a fixed generator
maps one state to one successor.  That is not the right common kernel when a
component chooses outputs, an environment chooses inputs, or a controller and
disturbance alternate.  Interface automata already give component boundaries
an optimistic compatibility game and alternating refinement; open games
already compose game-theoretic components while returning utility and tracking
equilibrium and off-equilibrium best-response behavior.

This is both new application terrain and a hard generalization boundary.  An
adversarial Ergodis adapter must declare:

```text
who controls each action or branch
the information visible when it is chosen
the solution concept (winning, worst-case value, Nash, subgame-perfect, ...)
the response exposed to later composition
the witness type (strategy, counterstrategy, equilibrium profile, certificate)
```

Replacing a branch by `min`, `max`, or `min-max` without this typing can change
the game.  Likewise, preserving only equilibrium values may fail to preserve
off-equilibrium best responses needed by an outer game.  The finite artifact
must therefore use alternating or relational transition structure and an
observation closed under its declared solution concept.  Its exact quotient is
the largest compatible alternating/behavioral equivalence for that structure,
not automatically the Moore quotient of Theorem 4.

The general certified-pass law still applies: a domain encoding must commute
with every controlled constructor and the chosen game-response observation
must factor through the compiled artifact.  Deterministic context machines,
min-plus optimization, robust min-max DP, interface compatibility, and finite
open-game response compilation can then be separate backends/corollaries of
the same factorization discipline.  What does not generalize for free is the
partition-refinement algorithm, finite-index theorem, or witness lift.

A first falsification fixture should be a finite robust-planning component
with environment-labelled disturbances and controller-labelled actions.  Run
the same domain twice: once under a cooperative existential observation and
once under an adversarial worst-case observation.  If the quotient, strategy
witness, and distinguishing continuation do not change, the adapter has likely
erased control ownership.  This provides a sharp systems test before pursuing
economic equilibria, whose solution concepts and response objects are much
larger.

The smallest exact regression is a one-bit matching disturbance.  Let the
controller choose `a in {0,1}`, let the environment choose `d in {0,1}`, and
let terminal cost be `1[a != d]`.  If the controller commits before seeing the
disturbance,

```text
min_a max_d 1[a != d] = 1.
```

If the environment moves first and the controller observes it,

```text
max_d min_a 1[a != d] = 0.
```

The payoff table and available labels are identical; only ownership,
information, and order differ.  Any artifact that stores an unlabelled
relation or freely swaps `min` and `max` fails this fixture.  A valid witness is
a committed action in the first game and a contingent policy `a(d)=d` in the
second, so it simultaneously tests strategy-witness typing.

Application framing is strong even under full theoretical pre-emption: a
single artifact/verifier format spanning deterministic, nondeterministic, and
alternating interfaces would let Ergodis compile robust schedulers, protocol
controllers, fault/disturbance plans, and component compatibility checks while
reusing established solvers underneath.  The measurable claim is generated
interface size, strategy/proof payload, repeated-composition cost, and exact
agreement—not invention of compositional games.

## Boundaried graphs, hypergraphs, and communication complexity

This is the closest application-level pre-emption found in the first batch.
For fixed boundary size, established Myhill--Nerode methods define two
boundaried graphs or hypergraphs to be equivalent when gluing every compatible
continuation preserves property membership.  Finite index is equivalent, on
the generated small universe, to recognition of parse trees by a finite tree
automaton.  The literature already uses this both to obtain linear-time
bounded-width algorithms and to show that some properties admit no such
finite-state treatment.

The result does not kill the application path; it supplies an unusually clean
Ergodis adapter and a negative diagnostic:

- Boolean property recognition is a classical backend/corollary.
- The quotient index measures exact information that must cross the boundary;
  `ceil(log2 index)` is therefore a natural state-communication metric.
- Infinite index tells the compiler to seek a bounded observation, enlarge the
  parameter, accept approximation, or reject finite exact compilation.
- The open capability question is quantitative: optimal cost, Pareto resource
  profiles, multiple algebraic queries, and reconstructible solutions under
  graph gluing, with an automatically generated and minimized transition
  table rather than a bespoke treewidth DP.

No novelty claim is permitted for that quantitative step until finite integer
index, protrusion replacement, optimization versions of Courcelle-style
theorems, and representative-set DP have been audited.  Even if those fully
pre-empt the mathematics, implementing them behind the same typed
`SeparatorSystem` would still expand Ergodis into exact bounded-boundary graph
and network optimization.

The first finite-integer-index source closes part of that gap and supplies a
stronger bridge.  Its transposition constant is an additive gauge: for a
threshold problem `(G,k)` defined by `Opt(G) <= k`, equality of all glued
threshold queries after shifting `k` is equivalent to equality of the entire
integer optimum response up to the opposite constant shift.  Thus progressive
representatives are canonical projective response states with a carried
potential.  This becomes a general Ergodis backend theorem, with FII as a
classical graph corollary, rather than a graph-only exception.

The rank-based connectivity source closes another advertised gap even more
directly.  It already defines a family of weighted boundary partitions by its
optimal value under every completion partition, proves a reusable operator
set preserves that representation, reduces the family by linear algebra, and
retains one optimal solution.  Therefore “quantitative graph contexts plus a
witness” is also pre-empted as a broad claim.  The priority-judo move is to
make this a `RepresentativeReducer` backend beside—not inside—the contextual
state minimizer.  A graph adapter can then test whether typed state quotient,
potential normalization, rank reduction, and provenance factorization compose
cleanly and improve an actual exact solver without bespoke plumbing.

## Active interface learning from an exact oracle

The compiler need not always receive an explicit transition algebra.  An
exact domain solver can answer a membership-style query

```text
observe(component, typed_context) -> value
```

and an equivalence oracle can either certify a proposed interface machine or
return a distinguishing context.  This turns every counterexample directly
into a separator coordinate and permits incremental compilation of the
reachable observational interface.  Exact equivalence can come from a proved
finite separator, exhaustive bounded contexts, or a solver-backed search; an
untested heuristic is not an exact compiler certificate.

This requires effective access sequences or constructors for reachable
components and a finite typed generator presentation (partial actions may be
totalized with typed sink states).  A bare oracle for unrelated
component/context pairs is insufficient to synthesize closed transitions, and
an equivalence oracle restricted to sampled components certifies only that
sample.  The target universe and counterexample search domain must be part of
the compiler contract.

Angluin-style active learning and weighted extensions strongly pre-empt the
generic idea.  The semiring audit also supplies a hard gate: field/PID cases
have positive weighted results, while general semirings can fail termination
or even the prescribed finite-hypothesis construction.  Ergodis should avoid
claiming a semiring-generic weighted learner.

A safer and broader systems path is to learn the already-finite observational
context machine as a deterministic Moore-style machine, treating the bounded
observation as an output label.  This works independently of linear semiring
hypothesis construction, though its quotient may be larger.  Potential and
representative-family backends can be applied only after their extra laws are
verified.

This adds a materially new application frame: wrap a legacy exact optimizer,
CP/MILP model, simulator, or theorem-backed enumerator as a query oracle and
compile a reusable minimal interface without first rewriting its internal DP.
The artifact should retain the observation table, all counterexample contexts,
and the final equivalence certificate so black-box compilation remains
auditable.

## Predictive state, realization, and the deferred SSM bridge

Predictive state representations make the second-batch analogy precise without
mentioning a neural architecture.  A controlled stochastic system is
represented by predictions of a finite set of future action-observation tests;
the set is sufficient when it determines every test prediction.  In C983
language, tests are contexts, their prediction vector is a response signature,
and a core test set is a linear separator/basis.  The finite-POMDP-to-linear-PSR
theorem is therefore a probabilistic/field-linear corollary of the broad
observation-first viewpoint, with stronger classical realization machinery
than the finite-set backend developed here.

The comparison also exposes material differences:

- PSR state updates condition on observations and therefore normalize by a
  predicted probability; tropical/min-plus optimization uses different
  algebra and may need potential normalization instead.
- A linear core-test basis minimizes linear dimension, not necessarily finite
  quotient cardinality, circuit size, or witness memory.
- PSRs represent stochastic input/output behavior; Ergodis currently targets
  exact optimum and solution reconstruction.

The SSM/Mamba path should use PSRs and realization theory as its mathematical
foundation.  An exact Ergodis compiler can provide ground-truth response
coordinates, exact separator tests, and distinguishing counterexamples on
small instances.  Only when exact state explodes should a learned recurrent
model approximate those future-response functions or their contextual metric.
“Use Mamba to optimize” remains generic and is not the target; learning an
approximately closed predictive realization of a known exact compositional
semantics is the sharper experiment.

## Approximate contextual state: metric, not geometric guesswork

For bounded real-valued observations, the direct relaxation of exact
contextual equivalence is

```text
d_C(x,y) = sup over c in C of |Obs(c[x]) - Obs(c[y])|.
```

This is a pseudometric, and its zero kernel is exactly contextual equivalence.
If the typed context grammar is closed under prefixing by generator `g`, then
`d_C(g(x),g(y)) <= d_C(x,y)` for the corresponding source/target context
families: every future test after `g` is already a future test before it.  Thus
the exact quotient and nonexpansive transition law are two faces of the same
definition.

Bisimulation metrics for MDPs strongly pre-empt behavioral distance and
approximate state aggregation as generic ideas.  They also show what a useful
Ergodis approximation theorem must add: a computable fixed point, separator or
relaxation upper-bounding the all-context supremum, plus a bound translating
state distance into optimization-value and policy/witness degradation.
Checking only finitely many contexts gives a lower bound on `d_C`, not a safe
merge certificate, unless a small-model or covering theorem controls the
unseen contexts.

The learned-state experiment should therefore optimize an observable target:
preserve core-test/response coordinates or this contextual pseudometric, and
measure closure error under every generator.  Euclidean closeness of hidden
vectors is irrelevant without a decoder/error theorem.  Exact Ergodis
instances provide the rare ground truth needed to compare latent dimension,
contextual distortion, rollout error, and optimizer/witness failure as the
exact quotient grows.

### Falsifiable learned-realization experiment

The SSM connection becomes an Ergodis capability only through a controlled
comparison against an exact compiled machine.  For a family of instances whose
exact quotient grows through a useful range, construct a transition corpus

```text
(class s, typed generator x, successor s', response vector r(s))
```

from the certified artifact.  Train an encoder `phi`, typed recurrent update
`F`, and response decoder `D` with four independently reported losses:

1. response error `D(phi(s))` against exact separator/core-test coordinates;
2. closure error `F(phi(s),x)` against `phi(s')`;
3. contextual distortion on certified equivalent and distinguishing pairs;
4. multi-step rollout value error, including contexts deeper than training.

The comparison set is deliberately architecture-neutral: the tabular exact
quotient, a linear/SVD or PSR-style realization where meaningful, an MLP
transition model, a GRU, and a selective SSM/Mamba-style recurrence receive the
same states, generators, and output budget.  Mamba earns relevance only if its
input-conditioned update improves the rate--distortion or rollout frontier;
the experiment remains useful if another architecture wins.

Witnesses are evaluated rather than assumed.  A decoded choice must replay to
a valid domain solution, and the report separates invalid-witness rate,
suboptimality, and value-prediction error.  No finite training context set
certifies all-context error.  Certification requires a domain-specific cover,
Lipschitz/error-propagation theorem, exact fallback, or an explicit statement
that the model is heuristic.  This makes exact Ergodis compilation the
benchmark generator and safety envelope rather than a disposable prelude to
neural approximation.

A safer operational hybrid is proposal plus certification.  The learned
recurrence proposes a response state, branch ordering, or concrete solution;
the domain verifier checks feasibility and realized cost.  That gives only an
upper bound for minimization.  Exact optimality additionally needs a matching
lower bound from the compiled quotient, a relaxed decision diagram, a dual or
cut certificate, or an exact fallback.  Accept automatically only when the two
bounds meet; otherwise continue exact search or report a heuristic result.

This protocol is architecture-independent and remains valuable if Mamba loses
the predictive comparison.  Certified failures become distinguishing
contexts/counterexamples for active retraining, while the proposal can still
improve branch order or warm starts without entering the trusted state.  The
benchmark must separate proposal speedup, verifier cost, fallback frequency,
and certified-optimal versus merely feasible rates.

## Coverage gaps and next search

No absence claim is licensed.  The next pass must cover primary work on
tropical rational-series realization and minimization, subsequential
transducer residuals, valued-CSP and tree-decomposition compilation,
quantitative/syntactic congruences, provenance-preserving dynamic programming,
observational completeness, and compositional open-system interfaces.  The promised C980 structural-compression
audit file named by the C980 report was not present at its recorded path during
this pass; its missing state must be resolved before treating C980's literature
gate as reusable evidence.

MathSciNet is not covered.  zbMATH, Crossref, OpenAlex, and Semantic Scholar
have not yet been queried.  No citation-graph negative is attempted in this
preliminary pass.
