# C980 structural compression, hostile proof review, and literature audit

**Lane:** `complete-ports`

**Date:** 2026-08-27

**Scope:** mathematics and priority framing only; no manuscript patch

## Verdict

The scalar higher-rank package survives.  Its clearest form is a four-result
spine, not the larger collection of candidate statements in the development
report:

1. a column-type normal form and realizability theorem;
2. a radius-`r` small-context theorem, with exact dual-shortening and witness
   reconstruction;
3. an explicit finite orbit-indexed contextual quotient, with universality
   and congruence under further composition;
4. exact state counts and rank-stratified evaluation algorithms.

The hostile read found no defect in this scalar spine.  It did find two proof
omissions that are now repaired in the development report and one extension
that was stated too strongly.  The fixed-batch result is presently a
small-context compression lemma, not yet a finite-state congruence theorem.
The abstract finite-interface discussion remains a criterion and research
program, not a theorem of comparable completeness.

The literature audit changes the novelty language but not the mathematical
verdict.  Contextual equivalence, syntactic congruences, minimal states, and
min--sum elimination have substantial precedents.  Finite information across
bounded matroid separations and canonical minimal state spaces for linear-code
tree realizations are particularly close conceptual neighbors.  The claim
that remains supportable is narrower and stronger: in the sources located by
this bounded audit, none gives this recovery-specific labelled response
together with the `max(2,r+1)` separating context, the exact dual-shortening
formula, and the bounded coefficient/support witness cover.

## Structural compression

### The four-theorem spine

```text
represented inner recovery problem
        |
        v
pointed target type + multiplicities of nonzero helper covector types
        |  exact realization by a represented outer code
        v
radius-r contexts use at most r active helper blocks
        |  restrict to the span of the minimizing label map
        v
dimension <= min(t,r), length <= max(2,r+1)
        |
        +--> dual shortening gives every test context exactly
        |
        +--> coefficient lifts reconstruct every bounded witness exactly
        v
finite orbit-indexed response table
        |
        +--> equality iff all compatible outer contexts agree
        |
        +--> congruence under another compatible layer
        v
finite transformation category + exact census/evaluation
```

The logical dependencies are linear until the small-context theorem.  The
dual-shortening identity and the witness-cover identity are two consequences
of that theorem, not additional state definitions.  Universality then says
that the response table is the quotient by all bounded compatible contexts;
congruence is its closure under continuation.

### Promote, retain, and demote

| Result                                            | Status                      | Editorial role             |
|---------------------------------------------------|-----------------------------|----------------------------|
| Column-type normal form and realizability         | proved                      | first lemma                |
| Radius-`r` small separating context               | proved                      | headline theorem           |
| Exact dual-shortening formula                     | proved                      | completeness certificate   |
| Bounded witness cover                             | proved                      | operational consequence    |
| Finite quotient, universality, and congruence     | proved                      | headline theorem           |
| Orbit census and rank-stratified recursion        | proved                      | algorithmic appendix       |
| Finite extensive ordered-monoid closure           | proved after repair         | sequel                     |
| Fixed-dimensional Pareto cap                      | proved in abstract algebra  | sequel                     |
| Fixed-batch packing                               | compression only            | research direction         |
| Multi-target-block compression                    | compression only            | research direction         |
| Abstract finite-interface principle               | criterion/sketch            | outlook                    |
| Code-realizable sharpness                         | open                        | optional strengthening     |

The basis-free outer signature must be described as a **pointed column-type
orbit**: change of basis in the shortened dual and helper permutations are
forgotten, but the target coordinate is retained.  Calling it merely the
orbit of a shortened subspace loses exactly the pointing needed to evaluate
the response.

## Hostile proof review

### Scalar core

| Claim                    | Resolution after attack                                                  |
|--------------------------|--------------------------------------------------------------------------|
| Column normal form       | Compatibility is exactly target membership in the helper span.          |
| Realizability            | Use the matrix with the prescribed pointed column multiset.              |
| Factorization            | A row-space generator gives every coefficient array as `B=GX`.           |
| Small separator          | Restriction preserves evaluated covectors, cost, and target constraint.  |
| Rank bound               | Image rank is at most `t` and at most the `r` active helper labels.       |
| Length bound             | Target-only and zero-sector cases give `max(2,r+1)`.                     |
| Dual shortening          | Puncture to the target and active helpers, then shorten the dual.         |
| Witness cover            | Reconstruction retains zero-label blocks with nonzero inner-dual lifts.  |
| Universality             | Every entry is realized; table equality evaluates every context equally. |
| Congruence               | Every continuation is another compatible outer context.                 |
| Orbit census             | Pointed orbits retain the target while forgetting helper order.          |
| Rank recursion           | Equal restricted types are aggregated and zero types deleted.           |
| Unbounded evaluation     | Presburger/ILP gives decidability, not a bounded-state claim.             |

### Repaired finite-monoid step

The original stabilization proof jumped from a descending chain of nonempty
upward closures to the cap `|M|-1`.  The missing point is that extensivity
makes the monoid identity the least element.  If the first upward closure is
all of `M`, it contains the identity, so every positive power is already
stable.  Otherwise it has at most `|M|-1` elements, and the descending
nonempty chain stabilizes by exponent `|M|-1`.  Equality then propagates by
multiplication.  This closes the claimed cap
`max(1,|M|-1)`.

### Pareto wording repair

The budget-box proof should compare upward-closed **feasible budget sets**,
not assert that the separating budget itself is exactly attainable.  From a
budget feasible in one state and not the other, choose an attainable witness
cost dominated by it; the same small-context restriction then separates the
states.  The development report now uses this formulation.

### Claims not yet hostile-proof

For fixed-batch packing, a bounded number of active blocks proves a small
separator.  A full finite quotient additionally needs an explicit quotient of
bounded coefficient/overlap patterns under inner-helper relabelling.  A
congruence theorem additionally needs a typed batch-composition operation.
Neither should be inferred automatically from the scalar continuation proof.

For the abstract finite-interface principle, the current text correctly
identifies sufficient ingredients—finite interface labels, local independent
lifting, a finite or truncated cost algebra, and a typed associative
composition—but it does not prove a general representation or minimality
theorem.

## Literature audit

This pass uses the 30-source C976 audit of recent repair, locality,
generalized-weight, and concatenation work as its coding-theory base.  It adds
the literature most likely to anticipate the new higher-rank claim:
weighted-tree semantics, finite matroid interfaces, minimal code
realizations, semiring elimination, and prescribed-coset optimization.

### Closest bodies of work

| Literature                          | Existing idea                         | Specific contribution here               |
|-------------------------------------|---------------------------------------|------------------------------------------|
| Weighted-tree Myhill--Nerode        | contextual congruence/minimal states  | explicit recovery quotient and tests     |
| Matroid decomposition width         | finite data across separations        | quantitative `r+1` separator and witness |
| Minimal code tree realizations      | canonical states for a fixed tree     | all compatible recovery contexts         |
| Generalized distributive law        | exact semiring elimination            | proved small algebraic interface         |
| Coset weights/covering radii        | joint single-code support minima       | functional labels under composition      |
| Concatenated decoding               | multilevel labelled propagation       | exact recovery/nonconfinement objective  |
| Concurrent recovery/service regions | recovery sets and capacity polytopes  | compositional coefficient-labelled state |
| Weighted-tree value generation      | finite images need algebraic control  | radius truncation or finite cost monoid  |

The important qualifications behind the compact table are these.  Weighted
tree automata already provide equality under every context, finite-index
criteria, and minimal deterministic weighted states; over general semirings,
a finite congruence need not automatically be implementable.  Finite-field
matroid work compares subsets against every complement across a separation.
Minimal code realizations choose canonical quotient state spaces for a fixed
tree decomposition.  None of those sources supplies the quantitative
prescribed-coset recovery response and exact bounded witness reconstruction
proved here.

### Priority-safe conclusion

Do not claim priority for “a Myhill--Nerode theorem,” “minimal compositional
state,” “finite information across an interface,” or “min--sum composition”
without qualification.  Those phrases describe established abstract
patterns.

A defensible statement after this audit is:

> We give an explicit finite contextual quotient for bounded linear-recovery
> cost.  Its entries are indexed by pointed functional column types; every
> radius-`r` distinction has a compatible separating outer code of length at
> most `max(2,r+1)` and dual dimension at most `min(t,r)`.  Exact
> dual-shortening and witness-cover formulas show that this finite family
> recovers both costs and bounded coefficient/support witnesses.

An absence statement must remain scoped:

> In the weighted-automata, matroid-decomposition, code-realization,
> prescribed-coset, concatenated-decoding, and recovery-set literature
> examined here, we did not find this recovery-specific combination of an
> explicit contextual state, radius-controlled separator, and exact witness
> reconstruction.

### Source-depth register

Two sources were read in full and eight were read selectively at the portions
needed for the comparison.

| Source (short title)                    | Depth     | Portions used                       | Cache key                         |
|-----------------------------------------|-----------|-------------------------------------|-----------------------------------|
| Maletti, *Myhill-Nerode ... Revisited*  | full      | all sections                        | `10.1007/978-3-540-78773-0_10`    |
| Alfarano et al., *Concurrent Recovery*  | full      | all sections                        | `arXiv:2201.07503`                |
| Funk et al., *Tree Automata ... I*      | selective | equivalence and width results       | `arXiv:1910.04360`                |
| Král, *Decomposition Width*             | selective | introduction and state construction | `arXiv:0904.2785`                 |
| Kashyap, *Minimal Tree Realizations*    | selective | canonical quotient states           | `arXiv:0711.1383`                 |
| Aji--McEliece, *Distributive Law*       | selective | semiring framework and exactness     | `10.1109/18.825794`               |
| Zhang et al., *Access Complexity*       | selective | generalized coset weights            | `arXiv:1804.02692`                |
| Elimelech et al., *Covering Radii*      | selective | definitions and GHW relation         | `arXiv:2012.06467`                |
| Blomqvist et al., *Concatenated Codes*  | selective | decoding architecture                | `arXiv:2004.03538`                |
| Droste et al., *Value Generating Power* | selective | main theorems and conclusion         | `arXiv:2608.24247`                |

The cached PDFs have the following SHA-256 values, in the same order:

```text
7f5b9423db8813192bc7e437ba4200fd6a8f01ca299f95bce537677efa24244a
75dfdc9b233c2f091e987790b6cff029551b59d0289d85f0b9b3d8b30a712bbc
690781fe527daa510f56a23e527eab3c0461e972ae4968465545a65a2011ba70
ddcf74980170ade5d887900b6b89c027c77bfc3d1681389047f31ef383c834ef
3bd157d011afbb63807a80576584c172eede6758584500c12602b04b8ad68add
6aed6b53e9c21951f801b4bac509db26c6a68b65aa26c5a1de690cff0277779a
904ff548b692a9a44ff89f238f0240004cc6cb2201b3f2e2e4b823dd16f83ccc
3824adb41a84705d902d9d4933a9467103129c9e32a83f122b36da09eefc71f2
77096b0638c851a7aad9aaff4b48c091cc5de04a5357913bfaa284080bbd1974
ac3c53f23690e296d6e665d3017ca73fbeb8a677dc374ddae9360ce607437548
```

### Search coverage and limits

Searches covered weighted and tropical automata, tree-series syntactic
congruences, valued/semiring constraint programming, generalized
distributive-law and tensor-network elimination, matroid decomposition width,
minimal code realizations, generalized coset weights and covering radii,
concatenated decoding, and concurrent/local recovery.  Forward and backward
references in the selected sources were checked selectively for closer
matches.  The recent coding and storage searches were cross-checked against
[`notes/2026-08-27-c976-recent-literature-positioning-audit.md`](2026-08-27-c976-recent-literature-positioning-audit.md)
rather than duplicated here.

The audit was not citation-graph complete.  MathSciNet and Google Scholar were
not available in this environment.  The arXiv API returned rate-limit errors,
and OpenAlex/Crossref queries were intermittently unavailable or too broad to
serve as exhaustive negative evidence.  The audit therefore supports careful
positioning and a bounded “no located predecessor” statement, not an absolute
priority claim.

## Recommended next gate

Have an independent reader reread only the four-theorem scalar spine against
the definitions in the current manuscript.  If it survives, promote the
small-context and contextual-quotient theorems to the manuscript; keep the
ordered-monoid/Pareto results for a sequel and the batch/multi-target/abstract
extensions in the research queue.

## Vibe check

Strong.  Compression made the theorem package easier to defend, not smaller
in substance.  The closest literature sharpens the pitch: the abstract
automata analogy is established, while the recovery-specific finite model and
exact witness reconstruction appear to be the real contribution.  The only
material overreach was the batch congruence claim, now explicitly demoted.
