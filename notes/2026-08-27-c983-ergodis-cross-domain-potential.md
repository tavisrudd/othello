# C983 — Ergodis cross-domain exact compositional optimization

**Lane**: `complete-ports`

**Status**: QUEUED AFTER C980; PRIVATE RESEARCH AND PROTOTYPING ONLY; DOES NOT
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

## First move

Perform the hostile literature/definitions audit and build a one-page theorem
matrix contrasting weighted automata, generalized distributive law, valued
CSP/DP compilation, contextual equivalence, and complete abstract domains.
From that matrix select the smallest noncoding pair that can exercise one
common exact interface and witness API without architecture commitment.

