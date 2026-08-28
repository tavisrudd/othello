# C983 first-batch theorem matrix and hostile literature audit

**Lane**: `complete-ports`

**Date**: 2026-08-27
**Status**: IN PROGRESS; PRELIMINARY THIRTEEN-SOURCE PASS; TWO SOURCES READ AT
FULL TEXT AND ELEVEN AT PARTIAL DEPTH; NO NOVELTY OR ABSENCE VERDICT LICENSED

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
semantic compression beyond representation-level factorization.

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

## Common kernel candidate

The smallest honest first-batch API is a typed finite weighted relation with
provenance:

```text
Component<I,J,S,W>:
    value   : I x J -> S
    witness : selected finite provenance for each attainable entry

serial(C,D)(i,k):
    aggregate over j of C(i,j) combine D(j,k)
```

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
