# C983 first-batch theorem matrix and hostile literature audit

**Lane**: `complete-ports`

**Date**: 2026-08-27
**Status**: IN PROGRESS; PRELIMINARY FIVE-SOURCE PASS; ONE SOURCE READ AT FULL
TEXT AND FOUR AT PARTIAL DEPTH; NO NOVELTY OR ABSENCE VERDICT LICENSED

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
| Witness-preserving quotient | Provenance/backpointer variants of dynamic programming; detailed audit not yet run | Open positioning | Specify whether witnesses are canonical, existential, or observed only through a projection; literal witness identity can destroy quotienting |

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

1. **Tropical weighted automaton control.**  Use a small determinizable
   min-plus weighted automaton and compile normalized residual response states.
   Compare raw run/subset states, residual functions, and a minimal exact
   realization; retain a distinguishing word or optimal run as witness.  This
   tests the automata/minimal-realization bridge where the prior theory is
   strongest.
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

## Coverage gaps and next search

No absence claim is licensed.  The next pass must cover primary work on
tropical rational-series realization and minimization, subsequential
transducer residuals, valued-CSP and tree-decomposition compilation,
quantitative/syntactic congruences, provenance-preserving dynamic programming,
and observational completeness.  The promised C980 structural-compression
audit file named by the C980 report was not present at its recorded path during
this pass; its missing state must be resolved before treating C980's literature
gate as reusable evidence.

MathSciNet is not covered.  zbMATH, Crossref, OpenAlex, and Semantic Scholar
have not yet been queried.  No citation-graph negative is attempted in this
preliminary pass.

