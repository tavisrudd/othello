# C756 — defect-two Segre discriminant comparison

**Lane**: `clebsch` · **Date**: 2026-08-01 · **Scope**: research only

## Verdict

The proposed direct comparison does **not** close defect two.  The two binary
quadratics do have opposite square classes,

\[
 \operatorname{disc}R_{P,\ell}\in (\mathbb F_q^*)^2\cup\{0\},
 \qquad
 \operatorname{disc}(Q|_\ell)\notin(\mathbb F_q^*)^2,
\]

but Segre's tangent-product relation does not identify them.  In the
nonsaturated branch every tangent function factors as

\[
 \tau_i=\kappa_i\sigma_i,
\]

where \(\kappa_i\) is the product of the lines through \(P_i\) meeting the
conic and \(\sigma_i\) is the product of the spare external lines through
\(P_i\).  Segre reciprocity compares the *product* \(\kappa_i\sigma_i\).
The factor \(\sigma_i\) is absent in the saturated-external argument, which
is why that argument forced sign coherence, but it has large positive degree
here and absorbs exactly the square-class comparison one would need.

More sharply, on the selected spare line \(\ell\) the tangent product at its
arc point sees only a pure power at that point after the factor \(\ell\) is
removed.  It does not see the residual concurrence divisor
\(R_{P,\ell}\).  Thus the hoped-for implication

\[
 \operatorname{disc}R_{P,\ell}
 \sim \operatorname{disc}(Q|_\ell)
\]

does not follow from the available Segre identities.  This is a failure of
the proposed gate, not a counterexample to C756.  The replacement gate must
retain chord intercepts, for example through the first subresultant of the
affine chord polynomial, rather than retain only the direction divisor.

## 1. Normalized direction and tangent products

Let \(P\in A\), let \(\ell\) be a spare external line through \(P\), put
\(B=A\setminus\{P\}\), and write \(n=k-1\).  Take

\[
 \ell:\ Z=0,
 \qquad P=(0:1:0),
 \qquad P_i=(x_i:y_i:1),
\]

with the \(x_i\) pairwise distinct.  The chord-direction product is

\[
 D_P(T)=\prod_{i<j}
 \bigl((x_i-x_j)T-(y_i-y_j)\bigr)
       =(T^q-T)E_P(T).                                      \tag{1}
\]

At defect two, \(E_P\) is a binary quadratic with either one double rational
root or two rational roots.  Hence its discriminant is zero or a nonzero
square.  In coordinate-free language this is the already established
factorization

\[
 H_A|_\ell=M_\ell L_P^{k-2}R_{P,\ell}.                     \tag{2}
\]

Put \(t=q+2-k=q+1-n\), the number of tangents to the arc at each arc
point.  A normalized tangent function at \(P\) is

\[
 \tau_P(X,Y,Z)
 =Z\frac{X^q-XZ^{q-1}}{\prod_{i=1}^n(X-x_iZ)}.             \tag{3}
\]

The quotient is a polynomial and (3) has degree \(t\).  If

\[
 v_j=\prod_{i\ne j}(x_j-x_i),
\]

then the derivative of \(X^q-X\) at \(x_j\) gives

\[
 \tau_P(P_j)=-v_j^{-1}.                                    \tag{4}
\]

At \(P_j\), normalize the tangent function by the missing finite directions:

\[
 \tau_j(X,Y,Z)=
 \prod_{a\in\mathbb F_q\setminus
 \{(y_j-y_h)/(x_j-x_h):h\ne j\}}
 \bigl((Y-y_jZ)-a(X-x_jZ)\bigr).                           \tag{5}
\]

The vertical line \(P_jP\) is a chord, so (5) contains all \(t\) tangents and

\[
 \tau_j(P)=1.                                               \tag{6}
\]

The scaled planar lemma of tangents supplies \(\lambda_i\ne0\) such that

\[
 \lambda_i\tau_i(P_j)
 =(-1)^{t+1}\lambda_j\tau_j(P_i).                          \tag{7}
\]

Equations (4), (6), and (7) merely determine

\[
 \lambda_j=(-1)^{t+1}(-v_j^{-1})\lambda_P.                 \tag{8}
\]

This is the affine Vandermonde normalization of Segre reciprocity.  It uses
the arc but neither the conic nor the residual quadratic.

## 2. Where the conic square class goes

Every chord is external to the fixed conic.  Therefore the nonchord lines
through an arc point split into the lines meeting the conic and the spare
external lines.  Up to a nonzero scalar,

\[
 \tau_i=\kappa_i\sigma_i,                                  \tag{9}
\]

where

\[
 \deg\sigma_i=
 \begin{cases}
  (q-1)/2-n,&P_i\text{ external to }C,\\
  (q+1)/2-n,&P_i\text{ internal to }C.
 \end{cases}                                                \tag{10}
\]

Substitution in (7) gives the exact comparison actually supplied by Segre:

\[
 \lambda_i\kappa_i(P_j)\sigma_i(P_j)
 =(-1)^{t+1}
  \lambda_j\kappa_j(P_i)\sigma_j(P_i).                    \tag{11}
\]

In the saturated-external branch, \(\deg\sigma_i=0\), so the explicit conic
factor \(\kappa_i\) can be compared in the two directions.  That is the
mechanism used in the earlier sign-coherence proof.  In the present branch
the quotient

\[
 \frac{\sigma_i(P_j)}{\sigma_j(P_i)}                        \tag{12}
\]

is new data.  Equation (11) determines only the product of (12) with the
conic-factor ratio; it does not determine either factor separately.

The failure is visible directly at the selected point \(P\).  Since \(\ell\)
is one factor of \(\sigma_P\), write

\[
 \sigma_P=L_\ell\sigma'_P.
\]

Every remaining factor of \(\sigma'_P\) is another line through \(P\).
Consequently

\[
 \sigma'_P|_\ell=cL_P^{\deg\sigma_P-1}                    \tag{13}
\]

for some \(c\ne0\).  Before division by \(L_\ell\), the restriction is
identically zero; after division it is the pure power (13).  By contrast,
the roots of \(R_{P,\ell}\) are the excess intersections on \(\ell\) of
chords whose endpoints lie in \(B\).  No root or discriminant of
\(R_{P,\ell}\) occurs in (13).

Thus (11) contains a high-degree spare-tangent correction, while (2) retains
only a degree-two direction correction.  Identifying the latter with the
former would discard precisely the direction--intercept coupling that the
preceding C756 report identified as load-bearing.

## 3. The discriminants are opposite but unlinked

Because \(\ell\) is external to the nonsingular conic, \(Q|_\ell\) is an
anisotropic binary quadratic.  Hence

\[
 \chi(\operatorname{disc}(Q|_\ell))=-1.                   \tag{14}
\]

At defect two, complete splitting of the Moore quotient gives

\[
 \chi(\operatorname{disc}R_{P,\ell})=+1
\]

when the two residual points are distinct, and discriminant zero in the
double-point case.  These facts alone do not contradict each other: they are
discriminants of two unrelated sections of \(\mathcal O_\ell(2)\).  The
missing assertion was an equality of their square classes.  Equations
(11)--(13) show why Segre reciprocity does not supply it.

This also isolates a common false step.  The restriction of the complete
chord product gives (2), while the restriction of the tangent product at
\(P\) gives (13); chord and tangent products are complements in the pencil at
an arc point, but their restrictions to the line *through that point* do not
remain complementary binary divisors.  All pencil lines collapse to the
same point \(P\) on \(\ell\).

## 4. Replacement gate: retain the intercept subresultant

Let

\[
 \mathcal H(U,T)=\prod_{i=1}^n(U+x_iT-y_i).                \tag{15}
\]

At a direction represented by a unique chord, \(\mathcal H(U,T)\) has one
double root; that root is the negative affine intercept of the chord.  The
first nonzero subresultant of \(\mathcal H\) and
\(\partial\mathcal H/\partial U\) therefore retains the datum discarded by
\(D_P(T)\).  Its direction denominator is controlled by

\[
 \operatorname{disc}_U\mathcal H=D_P(T)^2
 =(T^q-T)^2E_P(T)^2.                                      \tag{16}
\]

The next viable question is whether the forced Moore square in (16) can be
divided from the intercept subresultant so that the remaining numerator and
denominator have degree \(O(\delta)\).  If so, externality of the unique
chord in each of at least \(q-\delta\) directions becomes a quadratic
character condition on a rational function of degree \(O(\delta)\), the
scale at which a Weil bound can close.  If the quotient retains degree
\(\Theta(n^2)\), this route fails for the same reason as the raw chord
product.

This is a strictly stronger input than the residual direction divisor and a
strictly smaller target than the full spare-tangent products in (11).

The Segre formulas used above are the planar specialization of Ball--Lavrauw,
*Arcs in finite projective spaces*, Lemmas 27--29, cached as
`arXiv:1908.10772`, SHA-256
`00d13c01fa869889c9ab9e4e76928235c5e7b441a815059fd0f3f177365e76a4`.
No novelty or priority claim is made, no new computation supports the
verdict, and no manuscript files were edited.

## 5. EJ + TT closeout

The cheap upgrade is the explicit normalization (3)--(8).  It shows that the
pairwise Segre scale factors are exhausted by the affine Vandermonde values;
there is no hidden degree-two conic form waiting in the tangent relation at
the selected point.

The Tao-style compression is the distinction between *direction defect* and
*intercept defect*.  The Moore quotient solved the first problem completely,
but externality is a condition on a line, not merely on its point at
infinity.  Formula (15) is the smallest canonical object carrying both.  A
future pass should compute its first subresultant before attempting any
further character sum.

A second cheap upgrade is the saturated/nonsaturated mechanism boundary:
Segre sign coherence succeeded exactly because \(\sigma_i=1\).  The failure
here is not that Segre's lemma is too weak in general; it is that the omitted
spare factor is the entire new degree of freedom.  This prevents recycling
the saturated proof under a misleading change of notation.

Acceptance is exact and symbolic: (3) has the correct zeros and degree,
(4) is the derivative identity for \(X^q-X\), (5)--(6) list precisely the
remaining directions, and (9)--(13) compare the two divisor restrictions.
No finite sweep or untracked artifact is load-bearing.

## 6. Mystery ledger

| feature | status | exact gap / next gate |
|---|---|---|
| Split residual versus anisotropic conic discriminant | compared but not identified | the square classes are opposite, but Segre reciprocity contains the uncontrolled spare factor (12) |
| Why the saturated Segre argument worked | settled | every spare factor had degree zero, so the conic tangent products could be compared directly |
| Restriction of the spare factor at the selected point | settled | after removing \(\ell\), it is the pure power (13), not \(R_{P,\ell}\) |
| Double residual point | still open | the direct comparison supplies no nonvanishing statement for \(\operatorname{disc}R_{P,\ell}\) |
| Direction--intercept coupling | open with a canonical carrier | divide the forced Moore square from the first subresultant of (15) and bound the residual degree |
| A genuine defect-two contradiction | open | requires the subresultant character condition or a different invariant; Segre tangent reciprocity alone does not close it |
