# C663 q=16 split-Chow / projective-code exclusion

**Lane:** `relconic`

**Date:** 2026-07-26

**Status:** COMPLETE NEGATIVE AS A PROJECTIVE-CODE MECHANISM.  CONIC
SUPPORT IS ABUNDANT IN THE DEGREE-28 CODE, WHILE COMPLETE LINEAR
FACTORIZATION AND SEVENFOLD ARC-POINT VANISHING ARE PROPERTIES OF A
POLYNOMIAL REPRESENTATIVE, NOT OF ITS CODEWORD.  THE PROPOSED LOW-WEIGHT
CLASSIFICATION THEREFORE DOES NOT REPLACE THE EXHAUSTIVE q=16 EIGHT-ARC
CLASSIFICATION.

## Question

For an eight-arc \(A\subseteq\operatorname{PG}(2,16)\), let
\[
 F_A=\prod_{\{a,b\}\in\binom A2}\ell_{ab}.
\]
This is a squarefree product of 28 linear forms and has multiplicity seven
at every point of \(A\).  If \(A\) is complete outside a nonsingular conic
\(\mathcal C=Z(Q)\) disjoint from \(A\), the evaluation support of \(F_A\)
is contained in \(\mathcal C(\mathbb F_{16})\).  C663 asked whether the
resulting low-weight projective Reed--Muller word, together with the split
and multiplicity conditions, contradicts a structural codeword
classification or forces the separately excluded ordinarily complete
branch.

No manuscript or Lean file was edited.

## Exact code obstruction

Use the standard representatives whose first nonzero coordinate is one and
write \(\operatorname{PRM}_{16}(d,2)\) for degree-\(d\) homogeneous
evaluation on the 273 projective points.  Direct finite-field linear algebra
gives
\[
 \dim\operatorname{PRM}_{16}(2,2)=6,\qquad
 \dim\operatorname{PRM}_{16}(28,2)=267.
\]
Every degree-two evaluation row is orthogonal to every degree-28 row, and
the dimensions sum to 273.  Hence, in this normalization,
\[
 \operatorname{PRM}_{16}(28,2)
   =\operatorname{PRM}_{16}(2,2)^\perp.
\]

Restriction of quadrics to the 17 rational points of a nonsingular conic
has rank five.  It follows immediately that
\[
 \dim\{w\in\operatorname{PRM}_{16}(28,2):
          \operatorname{supp}(w)\subseteq\mathcal C\}
   =17-5=12.
\]
Thus conic-supported low-weight words are not exceptional: they form a
twelve-dimensional subcode.

The obstruction already occurs at weight six.  On
\(XZ+Y^2=0\), take the six normalized points represented before
normalization by
\[
 (t^2,t,1),\qquad t=0,1,2,3,4,5
\]
in the polynomial basis \(\mathbb F_2[x]/(x^4+x+1)\).  Their quadratic
evaluation rank is five, every five-point subconfiguration has rank five,
and the unique dependence has full support, with certified weights
\[
 (5,5,11,3,12,1).
\]
Extending these weights by zero produces a weight-six word of
\(\operatorname{PRM}_{16}(28,2)\).  Therefore neither low weight, conic
support, nor even support on the minimum six-point conic circuit can yield
the desired contradiction.

The analytic cross-check is the binary-quartic restriction map: quadrics on
the plane restrict to a five-dimensional system on the parametrized conic,
and any six distinct parameters have a unique full-support Lagrange
dependence.  This independently explains the ranks and the sharp first
support size checked by the script.

## Why splitting and jets do not rescue the codeword route

The space of degree-28 ternary forms has dimension
\(\binom{30}{2}=435\), whereas its evaluation code has dimension 267.
Consequently the evaluation kernel has dimension 168.  Complete
factorization into the 28 secant lines and multiplicity seven at the eight
arc points are not invariant under adding an element of this kernel.  They
are properties of a chosen lift of a codeword to the 435-dimensional form
space.  A classification of low-weight codewords therefore cannot see
either condition.

There is an exact lift-level reformulation.  If \(F_A\) is supported on
\(\mathcal C\), then the degree-30 form \(QF_A\) vanishes at every rational
projective point.  Hence
\[
 QF_A =
 A_{01}(X^{16}Y-XY^{16})
 +A_{02}(X^{16}Z-XZ^{16})
 +A_{12}(Y^{16}Z-YZ^{16}),
\qquad \deg A_{ij}=13.
\]
The sevenfold zeros constrain the jets of the three coefficient forms at
the eight arc points.  But imposing complete splitting and these jet
conditions on this nonunique syzygy is precisely a nonlinear
representative-lift problem; it is not a theorem about the structure or
weight of the projective codeword.  No dimension or support contradiction
survives the passage back from the code.

The zero codeword is also exactly the ordinarily complete branch:
\(\operatorname{supp}(F_A)=\varnothing\).  Codeword classification cannot
exclude it at all.

## Conclusion and trust boundary

C663 closes negatively in its stated projective-code scope.  The degree-28
word supplies no replacement for the checked 2,633-leaf q=16 covering
classification.  Any future structural replacement must control the
specific \(K_8\) secant arrangement inside the nonlinear variety of split
representatives, or prove a new theorem about the degree-13 coefficient
syzygy and its eight sevenfold jets.  Calling that remaining problem a
low-weight PRM classification would lose the load-bearing data.

The result does not prove that no split-Chow theorem exists.  It proves the
precise negative needed here: the proposed support/weight classification
cannot use the factorization and jet hypotheses, and conic-supported
degree-28 words themselves are plentiful.

## Reproducibility

The deterministic certificate bundle is:

- `notes/2026-07-26-c663-q16-split-chow-projective-code.py`
  — 7,048 bytes,
  SHA-256
  `2e466e4a5fe109b2c6c54e45fc55cdfd82818ba8c79ca4496be8886fb6360498`;
- `notes/2026-07-26-c663-q16-split-chow-projective-code.json`
  — 859 bytes,
  SHA-256
  `3af056d02e72de5dba80b23c458957b9ee0aa2608056183beddac4282c23fce4`.

Replay from `rust/`:

```bash
python3 ../notes/2026-07-26-c663-q16-split-chow-projective-code.py --check
sha256sum ../notes/2026-07-26-c663-q16-split-chow-projective-code.{py,json}
```

The script independently implements \(\mathbb F_{16}\), projective
representatives, all degree-two and degree-28 monomial evaluations, Gaussian
elimination, cross-orthogonality, conic restriction, and the explicit
six-point word.  The analytic binary-quartic argument above is the
independent cross-check.  It certifies the code-theoretic obstruction only;
it does not classify split representatives or eight-arcs.

No source is characterized and no novelty or priority claim is made; the
task uses no literature verdict.

## `ej` + `tt` closeout

The cheap upgrade is stronger than the single counterexample requested by a
falsification pass: the entire conic-supported subcode has dimension twelve,
and weight six is its sharp first circuit size.  This explains why the three
q=16 rank-five leaves naturally have uncovered sizes six, ten, and six
without making them candidate relative-conic arcs: the code remembers only a
quadratic dependence, not whether its degree-28 lift is the secant product
of the selected eight points.

The Tao-style diagnostic is to keep the quotient map visible.  The tempting
argument mixes three levels:

1. support of an evaluation word;
2. factorization and jets of a polynomial representative;
3. the incidence labeling of those factors by the edges of \(K_8\).

Only the first belongs to projective Reed--Muller theory.  The third, not
the first, contains the possible mechanism.  No cheap task-owned upgrade
turns that nonlinear lift problem into a codeword theorem.

There is, however, a sharper residual formulation.  If the support is
nonempty, choose an uncovered conic point \(u\).  No secant of \(A\) passes
through \(u\), so projection from \(u\) maps the eight arc points injectively
to the pencil of 17 lines through \(u\).  Each of the 28 secants is a
transversal of that pencil.  On every nontangent pencil line, its 28
intersection points must cover all 15 points off the conic; on the tangent
at \(u\), they must cover all 16.  In each of the eight pencil fibers
containing an arc point, the seven transversals labeled by incident edges of
\(K_8\) coincide at that point.  Thus the surviving problem is an exact
17-fiber value-set problem with eight prescribed sevenfold collisions.  It
retains the edge labels erased by the code quotient and is the cleanest
starting point for any future mechanism theorem.

## Mystery ledger

- **Settled:** degree-28 codewords supported on a nonsingular conic are
  abundant; their subcode has dimension twelve.
- **Settled:** six conic points already support a full-support degree-28
  word, while every five of those points remain independent for quadrics.
- **Settled:** complete splitting and sevenfold arc-point vanishing are not
  codeword invariants; the degree-28 evaluation fiber has dimension 168.
- **Settled:** multiplying by the conic gives the exact degree-30
  finite-projective vanishing-ideal syzygy with degree-13 coefficients.
- **Open:** whether the edge-labeled \(K_8\) factorization forces the
  degree-28 word to be zero or a factor to meet \(A\).  This is exactly the
  original rank-three incidence problem, not a low-weight-code
  classification.  Projection from one uncovered conic point reduces it to
  the 17-fiber transversal/value-set problem above; C663 does not allocate a
  successor for it.
- **Open:** a nonexhaustive structural exclusion of ordinarily complete
  eight-arcs over \(\mathbb F_{16}\).  The current q=16 theorem continues
  to obtain that branch from the checked covering classification.
