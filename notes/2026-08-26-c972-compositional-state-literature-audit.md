# C972 literature audit: labelled compositional recovery state

Date: 2026-08-26

## Question audited

Does prior work already contain the paper's new rank-one contextual quotient,
its labelled prescribed-coset min--sum state, or an equivalent exact finite
nonconfinement theorem?  What language is safe for the manuscript?

This audit covers the closest coding-theory and semiring-state precedents.  It
is evidence about positioning, not a proof of priority.

## Bottom line

No located source states the paper's coding-specific result: target-normalized
prescribed-coset support minima over the complete outer functional dual give
the exact first nonconfined recovery cost; the labelled functions close under
finite concatenation; and, at rank one, full-code and one-dimensional-dual
contexts separate the exact numerical response quotient.

There are, however, strong antecedents for every piece of the *language* used
to describe that result:

1. concatenated decoding passes symbol-labelled reliability or cost data;
2. input--output weight enumerators can depend on the chosen encoder and
   compose by convolution;
3. message-indexed weight functions refine generalized-weight minima;
4. min--sum variable elimination is the generalized distributive law; and
5. contextual/behavioural equivalence and weighted-state minimization are
   standard outside coding theory.

The safe novelty claim is therefore coding-specific.  The paper identifies
the exact target-normalized support response and an explicit separating family
of outer-code contexts.  It should not claim to invent labelled composition,
contextual equivalence, or semiring state minimization.

## Closest precedents

### Classical concatenation and labelled soft information

- Forney's generalized minimum-distance decoding uses reliability information
  rather than only hard inner decisions.  This is an early warning that a
  scalar inner distance is not all an outer decoder can observe:
  <https://doi.org/10.1109/TIT.1966.1053873>.
- Guruswami--Sudan pass a weight for every possible outer symbol from an
  arbitrary inner code and explicitly use inner coset-weight information:
  <https://doi.org/10.1109/CCC.2002.1004350>.
- Chen--Ling--Xing give the classical dual decomposition for concatenated
  codes used by the manuscript:
  <https://doi.org/10.1109/TIT.2005.851760>.
- Blomqvist--Gnilke--Greferath develop decoding of generalized concatenated
  and matrix-product codes: <https://arxiv.org/abs/2004.03538>.

These sources make the use of an intermediate symbol or functional label
unsurprising.  They do not formulate target-normalized recovery equations,
minimize their union support over the complete functional dual, or prove the
paper's exact confinement converse.

### Representation-dependent enumerators and message weights

- Loskot--Beaulieu explicitly note that an input--output weight enumerator can
  depend on the generator matrix and show convolutional composition in their
  recursive construction:
  <https://doi.org/10.1002/ett.1133>.
- Nogin proves that the full weight function on the message space determines a
  linear code up to equivalence and relates message-level weights to higher
  weights: <https://doi.org/10.1007/s11122-005-0014-6>.

These are the closest precedents to the manuscript's distinction between an
abstract image code and a represented encoder.  The manuscript must therefore
make the dependence on the isomorphism `iota : L -> I` explicit.  Its fixed
`F_2`/`F_4` separation remains stronger in a different direction: it holds the
binary image code, dual, nested pair, RGHWs, dual distance, and unlabelled
support family fixed while one outer functional line distinguishes the two
presentations.

### Coset support and generalized covering quantities

- Zhang--Yaakobi--Etzion--Schwartz introduce generalized coset weights in PIR
  access complexity: <https://doi.org/10.1109/ISIT.2019.8849827>.
- Elimelech--Firer--Schwartz develop generalized covering radii:
  <https://doi.org/10.1109/TIT.2021.3115433>.

The manuscript's ordinary prescribed-coset function is a fixed-instance,
label-indexed minimum underlying these coarser maxima.  Its target-normalized
function and exact outer-functional optimization were not found in this
literature.

### Min--sum composition and behavioural minimization

- Aji--McEliece's generalized distributive law supplies the general min--sum
  variable-elimination framework:
  <https://doi.org/10.1109/18.825794>.
- Mohri surveys composition, determinization, equivalence, and minimization of
  weighted automata over semirings:
  <https://doi.org/10.1007/978-3-642-01492-5_6>.
- Berstel--Reutenauer develop syntactic algebras and minimal linear
  representations of rational series:
  <https://doi.org/10.1017/CBO9780511760860.003>.

Accordingly, the facts that equality under all contexts is an observational
quotient and that associativity makes the quotient a congruence are general
semantic principles.  The manuscript's content is the explicit finite
coding-theoretic probe formula: at rank one, the zero sector plus all
zero-truncated projective outer-dual-line probes are a complete separating
family.  Calling this a "minimal contextual quotient" is accurate once the
allowed context category is defined; calling it a new general minimal-state
theorem would not be.

### Recovery-set and locality literature

The manuscript already distinguishes cooperative locality, multiple recovery
alternatives, sharp recovery structures, service regions, and regenerating
repair from its coefficient-labelled Hamming-support model.  The additional
2024 paper *Recovery Sets of Subspaces From a Simplex Code* studies counts and
packings of subspace recovery sets, not transfer through concatenation:
<https://ymchee66.github.io/home/PDF/recoverysets.pdf>.

No audited recovery-set source retained extension-field functional labels as
recursive state or gave an exact nonconfinement optimization over the complete
outer dual.

## Claim-by-claim assessment

| Manuscript claim | Audit assessment | Safe framing |
|---|---|---|
| RGHWs equal minimum helper unions | Classical specialization | State this explicitly |
| Functional-dual decomposition | Classical | Cite Chen--Ling--Xing |
| Labelled min--sum composition | New coding specialization of standard min--sum and labelled decoding ideas | Emphasize target normalization, exact support, and closure |
| Exact finite `Gamma` formula | No equivalent located | Principal theorem |
| Outer-distance collapse | No equivalent located | Exact corollary of the two-sector formula |
| Fixed `F_2`/`F_4` label separation | No equivalent located | Strong necessity example, not universal raw-table minimality |
| Rank-one projective probes | No equivalent located | Explicit separating family for the defined context category |
| Contextual quotient/congruence | General concept; coding probe characterization appears new | Avoid claiming new general semantics |
| Rank-bounded outer tests | No equivalent located | Clean generated-image reduction |
| Rank-one all-rank bottleneck | No equivalent located | State with “every target line” and a fixed radius |
| Witness propagation | Standard argmin/backpointer idea at one-witness level | Distinguish one argmin, all lifts, and the confinement bijection |

## Required manuscript repairs

1. Define the outer context category: all lengths `N >= 2`, target blocks `j`,
   and `L`-linear outer codes with nonzero projection, with the inner split and
   target line fixed.
2. Define compatible further composition as adding layers above the same
   distinguished target leaf; do not imply arbitrary retargeting.
3. State that every quantity involving `L` depends on the represented encoder
   `(I,iota)`, while the shortening--puncturing pair depends only on the image
   code and split.
4. Call the rank-one result the coarsest *response equivalence*, not a uniquely
   minimal raw data structure.
5. Cite labelled soft decoding, representation-dependent IOWEs, message weight
   functions, and weighted-automata minimization as antecedents, then state the
   precise information they do not retain.
6. Separate three witness levels: one stored argmin, all minimizing/full lifts,
   and all bounded systems transported by the confinement bijection.

## Search boundary

Searches covered exact phrases and concept combinations for prescribed-coset
support, coset weight plus concatenation, functional duals of concatenated
codes, input--output/complete/split weight enumerators, generalized coset
weights and covering radii, soft/generalized-concatenated decoding, tropical
weighted automata, syntactic congruences, and 2024--2026 recovery-set work.
Only primary papers, author copies, publisher records, and authoritative books
were used for substantive comparisons.  Absence from this search is not a
priority guarantee; citation-network review by a coding-theory specialist is
still appropriate before submission.
