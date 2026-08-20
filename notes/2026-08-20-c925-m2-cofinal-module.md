# Module 24. The updated \(m=2\) gate and unbounded stabilization indices

**Packet part:** Module 24.  Stable index:
notes/2026-08-19-c925-modular-direct-qdm-proof-packet.md

The original direct-QDM roadmap correctly identified the correlated
projective-space source and the need for a marking.  Subsequent hostile tests
showed that the raw irregular polygon and bare deck orbit are not sufficient
comparison invariants.  This module records the corrected target and a
uniform source recoding which turns any unbounded arithmetic progression of
stabilizations into an all-\(m\) theorem.

## 24.1 What survives from the original \(m=2\) roadmap

For a smooth cubic threefold \(X\), the source at \(m=2\) is the product
package

\[
\mathscr A_X\boxtimes QDM(\mathbf P^2),
\tag{24.1}
\]

whose three projective branches have irregular values

\[
\lambda_X+3q^{1/3},\qquad
\lambda_X+3\omega q^{1/3},\qquad
\lambda_X+3\omega^2q^{1/3}.
\tag{24.2}
\]

Only threefold centers are new in a weak factorization of the fivefold
\(X\times\mathbf P^2\).  These two observations survive unchanged.

The following proposed consumers do not yet survive:

1. independent scalar and unit shifts make the uncentered triangle (24.2)
   coordinate-dependent;
2. a bare \(\mu_3\)-orbit need not remain intrinsic after coefficient
   extension unless its descent action is transported coherently;
3. each primitive-sixth character occurs in three projective branches, so a
   simple-character argument cannot select the point marking; and
4. formal monodromy, grading, pairing, Hodge data, and integrality do not
   force that marking.

The correct marked object is therefore an augmented package

\[
(V,T,r),\qquad r:V\longrightarrow K,
\tag{24.3}
\]

with fixed-phase formal/operation data \(T\) and a Gamma point/rank row
\(r\).  Suppose both endpoint rows \(r_\pm\) are nonzero (equivalently,
surjective over the field \(K\)).  For a comparison isomorphism
\(\Phi:V_-\xrightarrow{\sim}V_+\), its entire quotient defect is

\[
\delta_\Phi=r_+\Phi|_{\ker r_-}.
\tag{24.4}
\]

The desired transport law is

\[
\delta_\Phi=0
\quad\Longleftrightarrow\quad
r_+\Phi=c_\Phi r_-,\qquad c_\Phi\in K^\times.
\tag{24.5}
\]

A chosen vector is weaker: it has variance and path-holonomy problems and
does not produce the canonical output-kernel ideal of Theorem 19.3A.
If an endpoint row vanishes, (24.5) is not the right criterion; that case is
retained separately by the core Boolean marker of Module 21.

### Corrected \(m=2\) rank-row gate

For every actual blowup step in a chosen weak factorization of a hypothetical
fivefold birational map, prove that the fixed-phase Gamma/Stokes/Orlov
comparison satisfies

\[
r_{\operatorname{Bl}}\Phi
=c\,(r_Y\oplus0_{\mathrm{exc}}),
\qquad c\in K^\times,
\tag{24.6}
\]

naturally under products and composition.  Equivalently, every exceptional
term is rank-row-null and the comparison has zero leakage.

The codimension-two threefold step is the newly difficult carrier case.  The
gate still quantifies over the higher-codimension point, curve, and surface
steps unless separate adapters in this same occurrence-indexed pointed
provider prove their exceptional sectors row-null and exclude ambient-row
mixing.  The older unpointed low-dimensional exclusions do not supply that
compatibility by themselves.

This is stronger and more compositional than the proposed local statement
that one threefold center cannot contain a transitive marked
\(\mu_3\)-triple.  Several centers along a path can assemble separate
constituents, and Stokes comparisons can mix ambient and center directions.
Only a global quotient law such as (24.6), or a strict operation-framed
length law, prevents that assembly.

The rank-row route would prove every stabilization if established for
arbitrary blowups.  The narrower operation-framed alternative retains the
nilpotent extension and asks for a strict \(J_3\) obstruction at \(m=2\).
These are sibling providers; one must not use the rank conclusion to fill a
gap in the Jordan-length provider or conversely.

## 24.2 Rationality is upward closed in the stabilization index

### Theorem 24.1 -- unbounded stabilization principle

Let \(X\) be an integral variety.  If \(X\times\mathbf P^a\) is rational and
\(b\ge a\), then \(X\times\mathbf P^b\) is rational.  Consequently, if
\(X\times\mathbf P^s\) is irrational for every \(s\) in an unbounded subset
\(S\subseteq\mathbf N\), then \(X\times\mathbf P^m\) is irrational for
every \(m\ge0\).

### Proof

The rational varieties \(\mathbf P^b\) and
\(\mathbf P^a\times\mathbf P^{b-a}\) have the same dimension, hence are
birational.  Therefore

\[
X\times\mathbf P^b
\dashsim
(X\times\mathbf P^a)\times\mathbf P^{b-a}.
\tag{24.7}
\]

The right side is rational when \(X\times\mathbf P^a\) is.  If some index
\(m\) were rational and \(S\) were unbounded, choose \(s\in S\) with
\(s\ge m\); the first assertion would make the supposedly irrational
\(s\)-stabilization rational. ∎

### Corollary 24.1A -- tails and arithmetic progressions suffice

Each of the following proves the all-\(m\) conclusion:

- irrationality for all \(m\ge k\);
- irrationality for all multiples \(m=kr\), \(r\ge1\);
- irrationality on one unbounded progression \(m=m_0+kr\); or
- irrationality on any other unbounded sequence.

Thus proving a tail or a divisibility class is not a weaker final theorem.
It may nevertheless admit a more uniform source presentation.

## 24.3 Replace a growing projective space by powers of one fixed factor

### Proposition 24.2 -- fixed-factor recoding

For \(k,r\ge1\),

\[
X\times\mathbf P^{kr}
\dashsim
X\times(\mathbf P^k)^r.
\tag{24.8}
\]

More generally, for \(m_0\in\mathbf N\),

\[
X\times\mathbf P^{m_0+kr}
\dashsim
X\times\mathbf P^{m_0}\times(\mathbf P^k)^r.
\tag{24.9}
\]

### Proof

Both projective factors on either side of (24.8), and likewise of (24.9),
are rational varieties of the same dimension. ∎

No QDM invariance is used in (24.8): rationality itself is birationally
invariant.  The benefit is on the source side,

\[
QDM(X)\boxtimes QDM(\mathbf P^k)^{\boxtimes r},
\tag{24.10}
\]

which is generated by one fixed operation object.  The choice \(k=1\) is
optimal for coverage and binary-generator simplicity, and already represents
every index (a different \(k\) could still have an easier geometric provider):

\[
X\times\mathbf P^m\dashsim X\times(\mathbf P^1)^m.
\tag{24.11}
\]

## 24.4 The unique top Jordan string

Work over a field of characteristic zero.  Let \(J_s\) denote the
indecomposable \(s\)-dimensional nilpotent \(\mathbf G_a\)-representation,
and use the diagonal nilpotent on tensor products.  The Clebsch--Gordan law is

\[
J_a\otimes J_b
\cong
\bigoplus_{i=1}^{\min(a,b)}J_{a+b-2i+1}.
\tag{24.12}
\]

### Proposition 24.3 -- fixed-factor powers have one highest string

For all \(k,r\ge1\), the tensor power \(J_{k+1}^{\otimes r}\) contains one
copy of \(J_{kr+1}\), and every other summand has smaller length.  In
particular,

\[
J_2^{\otimes m}=J_{m+1}\oplus
\{\text{strings of length }<m+1\},
\tag{24.13}
\]

with the top string occurring once.

### Proof

For \(r=1\) the claim is immediate.  Suppose the unique longest summand of
\(J_{k+1}^{\otimes(r-1)}\) is \(J_{(r-1)k+1}\).  Formula (24.12) gives one
top summand

\[
J_{(r-1)k+1}\otimes J_{k+1}\supset J_{rk+1}.
\]

Every other input summand has smaller length, and (24.12) says that tensoring
it with \(J_{k+1}\) still gives top length strictly below \(rk+1\).  The
induction proves existence, uniqueness, and the bound on the remaining
summands. ∎

For \(r\ge1\) and \(a_j\ge1\), the same induction gives the heterogeneous
form

\[
\bigotimes_{j=1}^r J_{a_j}
\cong J_{1+\sum_j(a_j-1)}\oplus W,
\qquad
\ell(W)<1+\sum_j(a_j-1),
\tag{24.13b}
\]

with the highest string occurring once.  Thus a finite menu of fixed
projective factors, or an offset factor followed by a repeated one, has the
same additive length bookkeeping.

For the cubic source, the operation-framed primitive-sixth \(J_1\) packet
tensoring with the diagonal \(\mathcal O(1,\ldots,1)\) operation on
\((\mathbf P^1)^m\) therefore produces a unique \(J_{m+1}\) for each of the
two primitive-sixth characters **provided** the operation-framed QDM lift is
monoidal for these external products.  This is a fixed binary generator for
the growing correlation.

## 24.5 A uniform conditional all-\(m\) theorem

Let \(\theta\in\{\zeta_6,\zeta_6^{-1}\}\) denote the formal character.  For
an actual occurrence of a center, let \(\sigma\) record its
comparison-generated Novikov specialization, reconstruction value, exact
normalization, and path provenance.  Let \(\ell_\theta(Z;\sigma)\) be the
maximum Jordan length in that occurrence-specific operation-framed
\(\theta\)-primary sector, with value zero when that sector is empty.

### Input 24.S -- monoidal binary source

The operation-framed external-product lift identifies the primitive-sixth
source sector of \(X\times(\mathbf P^1)^m\), for the diagonal
\(\mathcal O(1,\ldots,1)\) operation, with

\[
J_1^{(X,\theta)}\otimes J_2^{\otimes m},
\tag{24.13a}
\]

and the corresponding sector of \(\mathbf P^{m+3}\) is empty.  The
representation-theoretic consequence of this input is Proposition 24.3; the
input itself is a QDM product-naturality statement and is kept separate.

### Hypothesis 24.C -- uniform carrier bound

For every component of every smooth projective \(d\)-fold which occurs as a
center, and every actual operation-frame occurrence index \(\sigma\) emitted
by one of the chosen weak factorizations in Hypothesis 24.B,

\[
\ell_\theta(Z;\sigma)\le\max(0,d-1)
\tag{24.14}
\]

for \(\theta=\zeta_6,\zeta_6^{-1}\).  Intrinsic center length is not a
substitute for this indexed bound.

### Hypothesis 24.B -- strict operation-framed blowup transport

For every \(X,m\), and every hypothetical birational map
\(X\times(\mathbf P^1)^m\dashrightarrow\mathbf P^{m+3}\), choose a weak
factorization for which every actual nontrivial blowup step, in either
orientation and with codimension \(c\ge2\), is realized in one globally
coherent operation-framed category.  Its center contribution is a strict
biproduct whose correlated exceptional string is

\[
V_{Z;\sigma}\otimes J_{c-1},
\tag{24.15}
\]

and the comparison preserves the primitive character and the same diagonal
nilpotent operation under composition, inverse, and all induced
specializations.  In particular, the biproduct splittings satisfy the
coherence needed to telescope the chosen zigzag; unrelated objectwise
splittings do not meet this hypothesis.

### Theorem 24.4 -- binary-source all-\(m\) criterion

Assume Input 24.S and Hypotheses 24.C and 24.B.  Then, for every smooth cubic
threefold \(X\),

\[
X\times\mathbf P^m
\quad\text{is irrational for every }m\ge0.
\tag{24.16}
\]

### Proof

Use the birational model

\[
Y_m=X\times(\mathbf P^1)^m,
\qquad \dim Y_m=m+3.
\]

Its source has Jordan length \(m+1\) in each primitive-sixth character by
Proposition 24.3.  A nontrivial weak-factorization center has
dimension \(d\le m+1\) and codimension

\[
c=m+3-d.
\]

By (24.12), (24.14), and (24.15), the longest possible exceptional string
has length at most

\[
(d-1)+(c-1)-1=d+c-3=m
\tag{24.17}
\]

when \(d\ge2\); for \(d\le1\) the primitive center sector is empty by
(24.14).  Thus no center contribution contains \(J_{m+1}\).  Strict
biproduct transport prevents several shorter strings, even across multiple
steps, from becoming one longer string.

Equivalently, on the strict-biproduct core retain only the isomorphism-class
marker with target \((\mathbb B,\vee,0)\),

\[
h_m(V)=\mathbf 1\{\ell_\theta(V)>m\}.
\tag{24.17a}
\]

Projective space has empty primitive-sixth operation-framed sector, and every
exceptional biproduct has \(h_m=0\).  Since Jordan length of a biproduct is
the maximum of the lengths of its summands, coherent strict transport makes
\(h_m\) invariant along the whole factorization, while the source has
\(h_m=1\) and the target has \(h_m=0\).  This is impossible.
Therefore \(Y_m\), and by (24.11) \(X\times\mathbf P^m\), is irrational for
every \(m\ge1\).  Theorem 24.1 then also gives \(m=0\). ∎

### Corollary 24.4A -- a cofinal fixed-factor provider suffices

Fix \(k\ge1\).  It is enough to prove the analogues of Input 24.S and
Hypotheses 24.C--B only for the family

\[
X\times(\mathbf P^k)^r,\qquad r\ge1,
\tag{24.17b}
\]

with source length \(kr+1\), empty projective endpoint, every exceptional
contribution of length at most \(kr\), and globally coherent transport through
one chosen factorization for each hypothetical birational map.  Those inputs
prove irrationality for every index \(m=kr\), and Theorem 24.1 then proves
irrationality for every \(m\ge0\).

Thus the source and transport providers need only be uniform on one cofinal
family of ambient dimensions.  No arithmetic structure is needed for the
logical last step; fixed \(k\) is useful because it presents that family by
one repeated operation object.  Formula (24.13b) gives the corresponding
mixed-factor or offset variant when those product providers are available.

The codimension term in (24.17) is load-bearing.  A blowup center contributes
not merely its own packet but its exceptional \(J_{c-1}\) string.  The
dimension arithmetic still leaves a one-step gap between the maximum center
contribution \(m\) and the source length \(m+1\).

At \(m=2\), the **new top-dimensional clause** of Hypothesis 24.C is the
threefold bound

\[
\ell_\theta(Z;\sigma)\le2.
\tag{24.18}
\]

The same operation-framed provider must also supply the occurrence-indexed
surface bound \(\ell_\theta\le1\) and empty point/curve sectors: a surface
center of codimension three carries an exceptional \(J_2\), so an illicit
surface \(J_2\) would produce \(J_3\).  The earlier low-dimensional results
do not transfer automatically to this enriched provider.  After those lower
clauses are discharged, the threefold clause is the only newly dimensional
one.  Thus \(m=2\) is the first top-dimensional case of the uniform carrier
theorem, not merely an isolated classification problem.

## 24.6 Exact current boundary

The representation-theoretic recursion is exact.  Input 24.S is the separate
monoidal QDM source realization; its \(m=2\) instance is supplied by product
naturality, while its uniform operation-framed formulation remains part of
the stated all-\(m\) interface.  Neither Hypothesis 24.C nor Hypothesis 24.B
is proved in general.  Formal grading and duality do not prove (24.18): the
stationary Picard--Lefschetz length-three model with \(N^2\ne0\) is an exact
formal countermodel to such a deduction.  The rank-row route bypasses 24.C
but still needs arbitrary
normal-bundle Gamma/Stokes/Orlov transport.  The operation-framed route makes
the carrier bound explicit but additionally needs strictness of (24.15).

The raw \(\mathbf P^2\) triangle should therefore not be recomputed.  The
highest-value regressions are:

1. fixed-phase Gamma/rank-row purity for arbitrary nonsplit rank-two normal
   bundles, after the already-positive split and nef-complete-intersection
   cases; and
2. the geometric threefold case of (24.14), together with strict
   codimension-two operation-framed transport.

An arithmetic progression is a valid endgame, by Theorem 24.1, but it does
not by itself weaken either uniform provider gate.  Its value is that a fixed
factor such as \(\mathbf P^1\) exposes the exact tensor recursion which an
all-\(m\) provider must respect.

---
