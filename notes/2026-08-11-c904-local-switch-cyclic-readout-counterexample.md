# C904 local-switch cyclic readout: exact counterexample and corrected gate

Date: 2026-08-11

Status: exact correction theorem; Paper V research only; no manuscript or
Lean edit

## Verdict

The proposed termwise descent of cyclic readout through a local signed
square-switch or three-term Pluecker relation is false.  More precisely, the
local switch is not a linear relation among arbitrary mixed-cofactor
matching diagrams in the first place.  It is one of the nonzero determinant
contributions that the full antisymmetrizer sums.

For the canonical Frobenius algebra

\[
 R=O[u]/u^h,
\]

the cyclic readout of two disjoint alternating loops labelled \(a,b\in R\)
is

\[
 \operatorname {tr}(m_a)\operatorname {tr}(m_b),
 \tag{1}
\]

whereas reconnecting the same four local legs into one loop gives

\[
 \operatorname {tr}(m_{ab}).
 \tag{2}
\]

These are not equal.  Taking \(a=b=1\) gives \(h^2\) and \(h\).  Thus even
the first two-term square switch has nonzero cyclic readout
\(h^2-h\), and the standard signed three-pairing expression has readout
\(h^2-h+h=h^2\) under the corresponding orientation convention.

This does not contradict a Pluecker identity.  Such identities are
quadratic identities among minors of a decomposable tensor or a fixed
Grassmannian point.  A generic Hodge divisor two-form is not decomposable,
and individual permutation matchings in a mixed determinant are not
identified by those identities.  The full determinant antisymmetrizer is a
signed **sum** of the switched matchings; it does not quotient each local
switch to zero.

Accordingly, there is no local Pluecker chain map to prove.  The corrected
gate is global:

> construct a linear cyclic obstruction on the image of the complete mixed
> adjugate map, or equivalently prove that the cyclic readout of a full
> antisymmetrized sum depends only on its resulting cofactor tensor; then
> determine its value and primitivity on the principal cofactor class.

The Frobenius-unit test is positive for the part already constructed.  Loop
readout, the diagonal resolution, Connes \(B\), and the Euler-loop
contraction are all invariant under
\(\lambda\mapsto\lambda_c=\lambda(c\,\cdot)\), \(c\in R^\times\).  This does
not yet prove invariance of the unconstructed global cofactor obstruction.

## 1. Explicit four-leg readout

Let \(B(a,b)=\lambda(ab)\) be a perfect symmetric Frobenius pairing and let
\(m_a\) denote multiplication by \(a\).  Contracting a labelled alternating
cycle against the inverse Frobenius pairing gives the ordinary operator
trace

\[
 \operatorname {Loop}(a_1,\ldots,a_r)
 =\operatorname {tr}(m_{a_1}\cdots m_{a_r})
 =\operatorname {tr}(m_{a_1\cdots a_r}).
 \tag{3}
\]

On four local legs there are three pairings.  Relative to a fixed reference
pairing, one of them produces two alternating cycles and the other two
produce a single alternating cycle.  Hence, with labels \(a,b\) on the two
variable edges, their cyclic readouts have the form

\[
 \operatorname {tr}(m_a)\operatorname {tr}(m_b),
 \qquad
 \operatorname {tr}(m_{ab}),
 \qquad
 \operatorname {tr}(m_{ab}).
 \tag{4}
\]

In the power basis \(1,u,\ldots,u^{h-1}\), multiplication by
\(a=a_0+a_1u+\cdots\) is triangular with diagonal entry \(a_0\).  Therefore

\[
 \operatorname {tr}(m_a)=h a_0.
 \tag{5}
\]

Putting \(a=b=1\) in (4) gives \((h^2,h,h)\).  Neither the two-term switch
nor the usual signed three-pairing combination vanishes over the
characteristic-zero discrete valuation ring \(O\).

The smallest linear-algebra version is already the determinant of a
two-by-two matrix:

\[
 \det\begin{pmatrix}x_{11}&x_{12}\\x_{21}&x_{22}\end{pmatrix}
 =x_{11}x_{22}-x_{12}x_{21}.
\]

The two matchings differ by a switch, but their signed difference is the
minor, not a relation saying zero.  Three-term Pluecker equations enter only
after imposing decomposability on a family of minors; that hypothesis is
absent for arbitrary mixed divisor forms.

## 2. What remains exact from the cyclic model

The exact Frobenius identification

\[
 \Phi_\lambda:R\otimes R\longrightarrow\operatorname {End}_O(R),
 \qquad
 \Phi_\lambda(a\otimes b)(z)=a\lambda(bz),
\]

still intertwines commutation with \(u\) and multiplication by
\(y-x\).  Together with

\[
 q_h(x,y)=\frac{y^h-x^h}{y-x},
\]

it gives the exact two-periodic diagonal resolution, and Connes
\(B(a)=da\) gives

\[
 \operatorname {coker}B
 =\Omega^1_{R/O}/dR
 \simeq\bigoplus_{n=2}^{h}O/nO.
 \tag{6}
\]

Thus the cyclic complex remains an exact model for the local carry and its
marked-cycle denominator.  The counterexample only rules out extending
that model term by term across determinant matchings.

The next possible construction must start with the complete multilinear
adjugate

\[
 \operatorname {Adj}(D_1,\ldots,D_{g-1}),
\]

not with its individual permutation summands.  One needs either

1. an invariant linear functional on the mixed-adjugate image whose
   reduction is the Connes/ghost class; or
2. a global antisymmetrizer identity showing that all dependence on the
   chosen matching expansion is exact in the cyclic complex.

The local square-switch calculation proves that no relation-by-relation
quotient of free matchings can supply this automatically.

## 3. Frobenius-unit invariance

Replace \(\lambda\) by

\[
 \lambda_c(z)=\lambda(cz),\qquad c\in R^\times.
\]

Then

\[
 \Phi_{\lambda_c}(a\otimes b)
 =\Phi_\lambda(a\otimes cb).
 \tag{7}
\]

Because \(c\) commutes with \(u\), equation (7) preserves multiplication by
\(y-x\) and hence the diagonal matrix factorization.  Connes \(B\) depends
only on the algebra \(R\), so (6) is unchanged.

If \(e_\lambda\) is the Frobenius Euler element, dual-basis comparison gives

\[
 e_{\lambda_c}=c^{-1}e_\lambda.
 \tag{8}
\]

Consequently every closed-loop contraction is exactly invariant:

\[
 \lambda_c(e_{\lambda_c}a)
 =\lambda(e_\lambda a)
 =\operatorname {tr}(m_a).
 \tag{9}
\]

For the normalized truncated-polynomial trace,
\(e_\lambda=h u^{h-1}\); equation (8) changes it by a unit and therefore
also preserves its \(p\)-adic primitivity defect.

This proves Frobenius-unit invariance of the diagonal/cyclic and closed-loop
parts.  It does not prove that the principal class has invariant order in
the full mixed-adjugate quotient: that would require the global obstruction
map which the local counterexample shows cannot be defined termwise.

## Consequence for the crown

The previous proposed “principal-chain Pluecker lemma” should not be pursued
in its local form.  The correct high-value target is a global representation-
theoretic map out of the polarized adjugate functor.  A plausible domain is
the determinant isotypic component of the walled-Brauer/Frobenius diagram
module; the cyclic obstruction must be constructed after applying that
idempotent, not before it.

## Mystery ledger

- **Settled:** local cyclic readout does not kill a signed square switch;
  the all-unit values are \(h^2\) versus \(h\).
- **Settled:** this is not a failure of a valid Pluecker relation; arbitrary
  mixed divisor forms do not satisfy the decomposability hypothesis.
- **Settled:** the diagonal resolution, Connes operator, loop trace, and
  Euler-element valuation are invariant under every Frobenius-unit change.
- **Open:** construction of a cyclic obstruction after the complete
  determinant antisymmetrizer.
- **Open:** primitivity and Frobenius-unit invariance of the principal class
  in the actual mixed-adjugate quotient.

Vibe check: the local straightening route is closed by an exact
counterexample.  The cyclic explanation survives, but it must be attached
globally to the determinant-isotypic component rather than imposed as a
local Pluecker quotient.
