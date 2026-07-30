# C697 — the graded Cartan carrier and its Hodge boundary

**Date:** 2026-07-29

**Lane:** `clebsch`

## Outcome

C695's operator-derived twenty-seven-line set canonically gives the
minuscule \(E_6\) carrier as a graded complex representation, and its
Cartan cubic has exactly the \(30+15\) tritangent support.  The arithmetic
descent and conjugation tests then draw a sharp boundary:

- with the natural cyclotomic action, the signed Cartan tensor descends to
  the orientation field \(\mathbf Q(\sqrt5)\);
- descent to \(\mathbf Q\) requires an additional determinant-character
  twist on one row, which the underlying unoriented line configuration
  does not select;
- the \(A_1\) row reflection is an internal complex-linear Weyl action,
  whereas Hodge conjugation for the Krämer--Litt--Maculan system carries
  \(V_L\) to \(V_{L^\vee}\), hence belongs on the
  \(27\leftrightarrow27^\vee\) side.

Thus the graded-Cartan representation test passes.  The stronger claim
that the operator carrier is a model of the Krämer--Litt--Maculan
variation does not: there is no cohomological realization or Higgs/period
tensor, and non-self-duality prevents identifying row exchange with Hodge
conjugation.

## Intrinsic graded carrier

Let \(X\) be the six-axis set recovered by C682 from the shared-kernel
cubes, and put \(U=\mathbf C[X]\).  Let \(A\) be the two-dimensional row
space with ordered basis \(a_+,a_-\), where \(a_+\) denotes the tangent
row \(E_i\) and \(a_-\) the apolar-polar row \(E'_i\).  C695 canonically
identifies the remaining lines with the two-subsets of \(X\).

The free linearization of the operator line set therefore has the explicit
graded isomorphism
\[
\begin{aligned}
\Phi:\mathbf C[\{E_i,E'_i,L_{ij}\}]
&\longrightarrow
(A\otimes U^\vee)\oplus\bigwedge\nolimits^2U,\\
E_i&\longmapsto a_+\otimes u_i^\vee,\\
E'_i&\longmapsto a_-\otimes u_i^\vee,\\
L_{ij}&\longmapsto u_i\wedge u_j .
\end{aligned}
\]
The \(A_1\) cocharacter
\(\lambda(t)=\operatorname{diag}(t,t^{-1})\) gives weights
\[
1,\ 0,\ -1
\]
of dimensions \(6,15,6\).  After the usual central shift these are the
formal Hodge labels \((2,0),(1,1),(0,2)\).

Choose an ordering of \(X\), equivalently a volume form on \(U\).  If
\((x,y,\omega)\in
(a_+\otimes U^\vee)\oplus(a_-\otimes U^\vee)\oplus\bigwedge^2U\),
define
\[
\mathcal C(x,y,\omega)
=\omega(x,y)+\operatorname{Pf}(\omega)
=
\sum_{i<j}(x_i y_j-x_j y_i)\omega_{ij}
+\operatorname{Pf}(\omega).
\]
This is the standard Cartan cubic for the
\(A_1\times A_5\) binary model.  Its mixed terms are precisely the
thirty tritangents
\(\{E_i,E'_j,L_{ij}\}\), \(i\ne j\), and its Pfaffian terms are precisely
the fifteen perfect-matching tritangents
\(\{L_{ij},L_{k\ell},L_{mn}\}\).  Hence C695's complete tritangent
dictionary proves equality of the two cubic supports, while the exterior
algebra fixes the relative Pfaffian signs.

Changing the ordering of \(X\) changes the displayed volume and basis
signs but yields a graded-linearly isomorphic cubic.  The resulting
Cartan cubic is therefore intrinsic as an isomorphism class and up to the
allowed nonzero scalar; a scalar-valued presentation still remembers the
orientation character.

## The three involutions are different

### \(A_1\) Weyl reflection

The unsigned order-two exchange \(x_i\leftrightarrow y_i\) negates the
mixed summand and fixes the Pfaffian, so it does not preserve
\(\mathcal C\) even up to a global scalar.  The actual Weyl lift is
\[
x_i\longmapsto y_i,\qquad
y_i\longmapsto-x_i,\qquad
\omega_{ij}\longmapsto\omega_{ij}.
\]
It preserves \(\mathcal C\), has order four on the linear carrier, and
induces the observed order-two row permutation on the weight set.

### Cyclotomic and golden Galois action

Write the six axes as
\[
q_\infty,\qquad q_b\quad(b^5=1).
\]
For \(\sigma_a(\zeta_5)=\zeta_5^a\), the action fixes
\(\infty\) and \(b=1\), and multiplies the other exponents by \(a\).
The resulting six-point permutation has sign
\[
\operatorname{sgn}(\sigma_a)=
\begin{cases}
+1,&a=1,4,\\
-1,&a=2,3.
\end{cases}
\]
The mixed contraction \(\omega(x,y)\) is unchanged by
\(\operatorname{GL}(U)\), whereas the Pfaffian changes by
\(\det(U)\).  Therefore the raw line action preserves the Cartan cubic
exactly for the even subgroup \(\{1,4\}\).  Its fixed field is
\(\mathbf Q(\sqrt5)\), giving the intrinsic tower
\[
\mathbf Q\subset\mathbf Q(\sqrt5)\subset\mathbf Q(\zeta_5).
\]

For the odd elements, twisting one row by the determinant character makes
both cubic summands change by the same sign and descends the cubic line to
\(\mathbf Q\).  This is a valid additional linearization, but it is not
the raw Galois action on the two operator line rows: projective lines do
not record the required vector sign.

Complex conjugation is \(a=4\).  It is even, preserves each row, and fixes
\(\mathbf Q(\sqrt5)\).  It is therefore not the row reflection.

### Hodge conjugation and outer duality

For a unitary rank-one local system \(L\),
\(\overline L\simeq L^\vee\).  Hodge conjugation consequently relates
\[
H^{p,q}(F,L)
\quad\text{to}\quad
H^{q,p}(F,L^\vee),
\]
so it relates \(V_L\) to \(V_{L^\vee}\), not the two graded extremes
inside one \(V_L\).  Krämer--Litt--Maculan prove that \(V_L\) is not
self-dual when \(L\) has order \(n>2\).  Thus the correct
representation-theoretic analogue of Hodge conjugation is the outer
duality
\[
27\longleftrightarrow27^\vee,
\]
not the internal \(A_1\) Weyl reflection.

## Exact scope of the KLM comparison

For the nontrivial unitary systems in Krämer--Litt--Maculan, the extreme
Hodge pieces have dimensions \(6\) and \(6\); the rank is \(27\), so the
middle piece has dimension \(15\).  The operator carrier therefore has
the same graded dimension vector and the same abstract
\(A_1\times A_5\) minuscule representation.

That is the end of the justified comparison.  The operator construction
contains no Fano-surface cohomology, family over a base, flat connection,
period map, Kodaira--Spencer map, or iterated Higgs field.  In particular,
there is no map from its Cartan cubic to the second derivative of the KLM
period map.  Their reconstruction theorem cannot be imported, and their
generic \(E_6\)-monodromy result neither implies nor is contradicted by
this special graded carrier.

## Gauge calculation

If one records a nonzero coefficient for every tritangent monomial,
rescaling the \(27\) weight vectors acts through the \(45\times27\)
tritangent-incidence exponent matrix.  Its rank is \(21\), leaving
\(24\) multiplicative gauge invariants.

The rank has a short independent proof.  A kernel vector
\((a_i,b_i,c_{ij})\) satisfies
\[
a_i+b_j+c_{ij}=0\quad(i\ne j)
\]
and one equation
\[
c_{ij}+c_{k\ell}+c_{mn}=0
\]
for each perfect matching.  Comparing the two ordered cross equations
gives \(a_i-b_i=d\), and then
\[
c_{ij}=-a_i-a_j+d.
\]
Every perfect-matching equation becomes the single relation
\(\sum_i a_i=3d\).  The kernel has dimension \(6\), so the rank is
\(27-6=21\).

This calculation is a useful discriminator for any future geometric
linearization of the tritangent factors.  C697 does not claim that the
local plane equations already provide those \(45\) globally comparable
coefficients: each geometric line has a different defining linear form
inside each of its ten tritangent planes.

## Reproducibility

From `rust/`, run

```text
python3 ../notes/2026-07-29-c697-schlafli-hodge-e6.py --check
python3 ../notes/2026-07-29-c697-schlafli-hodge-e6-replay.py
```

The primary checker constructs the \(30+15\) support, proves the rational
rank \(21\), and verifies every cyclotomic permutation sign and Cartan
multiplier.  The independent replay reconstructs the hypergraph
separately, checks rank \(21\) modulo \(2,3,5,7,11\), and recomputes the
four orientation signs.

| file | bytes | SHA-256 |
|---|---:|---|
| `2026-07-29-c697-schlafli-hodge-e6.py` | 5844 | `e1c2fa7c877062dddc6858761e6cc6c07bedcbae7d69e93618a21fcc94bd9c03` |
| `2026-07-29-c697-schlafli-hodge-e6-replay.py` | 2664 | `6968d653e9d7c170a6149ea6c9e42b42672db5cad47368d031d971bfc61b08b5` |
| `2026-07-29-c697-schlafli-hodge-e6.json` | 3189 | `2ec1ebb678c0ea405da87a7a790ad2a9b37a13a01f28b26c7f519698055bfdaa` |

The computation is bookkeeping for the displayed exact proof.  It does
not certify an \(E_6\) classification theorem or a Hodge realization.

## Sources and claim boundary

- Laurent Manivel, *Configurations of lines and models of Lie algebras*,
  arXiv:math/0507118, especially Example 3; cached SHA-256
  `216e859a766c31fccd2e614dee85fb77b94116cdba31c0c82ce37aaf218d8ec6`.
- Thomas Krämer, Daniel Litt, Marco Maculan,
  *\(E_6\)-local systems from cubic threefolds*, arXiv:2604.20970,
  especially §§2.3, 3.2, and 4.3; cached SHA-256
  `5d21082987b22d38bc436a52edac0c105bc13c959980431f159a5964b94a868a`.
- C682 and C695 supply the operator/apolar double-six, the complementary
  fifteen lines, and the complete tritangent incidence.

No novelty, family, period, specialization, or monodromy claim is made.

## `ej` + `tt` closeout and mystery ledger

- **Closed by `ej`:** the golden field is not an accidental subfield of
  the displayed cyclotomic formulas.  It is exactly the orientation field
  of the six-axis permutation module, hence the natural field of the
  untwisted scalar Cartan tensor.
- **Closed by `ej`:** the label-level row involution needs a signed,
  order-four Weyl lift.  This prevents an order-two permutation from being
  silently promoted to a Cartan or Hodge involution.
- **Closed by `tt`:** the same \(6|15|6\) dimensions have two distinct
  meanings: the \(A_1\) grading of one minuscule representation and the
  Hodge decomposition of \(H^2(F,L)\).  Equality of dimensions and Cartan
  representation type does not supply a period tensor between them.
- **Closed by `tt`:** KLM non-self-duality positively identifies the side
  on which Hodge conjugation belongs: it relates \(27\) to \(27^\vee\),
  while row exchange remains internal to the restricted carrier.
- **Open, not promoted:** a geometric linearization of the \(45\) local
  tritangent factorizations might produce actual coefficient data whose
  \(24\) gauge invariants can be compared with Cartan's signs.  The current
  operator package gives line subspaces and plane factorizations but no
  canonical compatibility among their ten local equations per line.
- **No remaining mystery for this bounded task:** without a
  cohomological or Higgs realization, the operator construction is an
  explicit graded Cartan model but not a model of the KLM variation.

C697 is complete as a bounded extension test.
