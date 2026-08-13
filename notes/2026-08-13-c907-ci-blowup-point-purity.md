# C907 — complete-intersection blow-up point purity

Date: 2026-08-13

Status: exact non-toric pilot theorem.  For the blow-up of projective space
along a smooth codimension-two complete intersection, the Gamma point period
has no algebraic exceptional-sector contribution.  In particular the
primitive-sixth center packet of
\(\operatorname{Bl}_X\mathbf P^5\), for a cubic threefold
\(X\subset\mathbf P^4\subset\mathbf P^5\), has zero ambient rank functional.

This proves the first nonvacuous regression required by
`2026-08-13-c907-coniveau-principal-symbol-repair.md`.  It does not yet prove
the same point purity for an arbitrary smooth blow-up center.

## 1. Toric complete-intersection presentation

Let

\[
 Z=V(f_a,f_b)\subset\mathbf P^n,
 \qquad 1\le a\le b,
\]

be a smooth codimension-two complete intersection.  Put

\[
 T=\mathbf P_{\mathbf P^n}
   (\mathcal O(-a)\oplus\mathcal O(-b))
\]

in the quotient convention, write \(H\) for the base hyperplane and
\(\xi=c_1(\mathcal O_T(1))\), and set

\[
 A=\xi+bH.
\]

The class \(A\) is nef.  The two fibre coordinates have divisor classes
\(A-(b-a)H\) and \(A\).  The incidence equation

\[
 f_aV-f_bU=0
\]

has class \(A+aH\), and its zero locus is
\(Y=\operatorname{Bl}_Z\mathbf P^n\).  Both \(H\) and \(A\) are nef.  The
anticanonical class is

\[
 -K_Y=A+(n+1-b)H,
\]

agreeing with \((n+1)H-E\) under \(\xi=-E\).

## 2. Exact point-period slice

Write \(d=H\cdot\beta\) and \(e=A\cdot\beta\).  The other fibre divisor has
degree \(e-(b-a)d\).  Terms with this degree negative occur in the full
toric \(I\)-function, but each contains a factor of that divisor class and
therefore has zero \(H^0\) coefficient.  Put

\[
 k=e-(b-a)d.
\]

The toric mirror theorem and quantum Lefschetz consequently give the unit
coefficient, after the harmless monomial change in the first Novikov
variable, as

\[
 G(Q,R)=\sum_{d,k\ge0}
 \frac{(k+bd)!}
 {(d!)^{n+1}k!\,(k+(b-a)d)!}\,Q^dR^k.
 \tag{1}
\]

The four factorial blocks in (1) are respectively the hypersurface
\(A+aH\), the \(n+1\) base toric divisors, the fibre divisor
\(A-(b-a)H\), and the fibre divisor \(A\).  Replacing \(Q\) in (1) by the
original first Novikov variable times \(R^{b-a}\) only multiplies the
coefficient of \(Q^d\) below by \(R^{(b-a)d}\); it cannot create a negative
algebraic tail.

For fixed \(d\), the complete exceptional-variable slice is

\[
 \begin{aligned}
 G_d(R)
 &=\sum_{k\ge0}
 \frac{(k+bd)!}
 {(d!)^{n+1}k!\,(k+(b-a)d)!}R^k\\
 &=\frac{(bd)!}{(d!)^{n+1}((b-a)d)!}
 {}_1F_1(bd+1;(b-a)d+1;R).
 \end{aligned}
 \tag{2}
\]

Kummer's transformation gives

\[
 {}_1F_1(bd+1;(b-a)d+1;R)
 =e^R{}_1F_1(-ad;(b-a)d+1;-R).
 \tag{3}
\]

The second factor in (3) is a polynomial of degree \(ad\).  Therefore, after
the universal string normalization \(e^{-R}\), every coefficient of \(Q^d\)
in the point period is a polynomial in \(R\).  There is no algebraic
large-\(R\) branch.  Equivalently, the usual Kummer connection coefficient
for that branch contains

\[
 \frac1{\Gamma((b-a)d+1-(bd+1))}
 =\frac1{\Gamma(-ad)}=0.
 \tag{4}
\]

This is an identity for every \(d\), not a finite-order calculation.

## 3. Point-purity theorem

The unit coefficient is the scalar central solution of the Gamma point
class: multiplication by \(\widehat\Gamma_Y\) and \(z^{c_1(Y)}\) does not
change the top class.  In the projective-bundle mirror presentation, the
algebraic large-\(R\) solutions are exactly the center summand in Iritani's
exceptional Fourier decomposition.  The unit is cyclic on each center
quantum D-module, so the absence of its scalar algebraic coefficient in
(3)--(4) is equivalent to absence of the full center component.

Hence:

> **Theorem.** For a smooth codimension-two complete intersection
> \(Z=(a,b)\subset\mathbf P^n\), the Gamma point flat section of
> \(\operatorname{Bl}_Z\mathbf P^n\) has zero component in every sectorial
> center summand.  Equivalently, the point pairs trivially with every
> exceptional sectorial branch, and the ambient rank functional is zero on
> that packet.

For C907 take \((n,a,b)=(5,1,3)\).  Formula (1) becomes

\[
 G(Q,R)=\sum_{d,k\ge0}
 \frac{(k+3d)!}{(d!)^6k!(k+2d)!}Q^dR^k,
 \tag{5}
\]

and

\[
 G_d(R)=\frac{(3d)!}{(d!)^6(2d)!}
 e^R{}_1F_1(-d;2d+1;-R).
 \tag{6}
\]

The cubic primitive-sixth packet of
\(\operatorname{Bl}_X\mathbf P^5\) is entirely a center packet, so (6)
proves the exact zero-rank prediction of the rank-framed obstruction.

## 4. Boundary of the theorem

The cancellation uses more than codimension two: the normal bundle is the
split restriction
\(\mathcal O_Z(a)\oplus\mathcal O_Z(b)\), and the blow-up has one global
toric complete-intersection presentation.  For a general center, Iritani's
formal stationary-phase coefficient has the same leading Gamma zero, but
curve corrections in the master space need not reorganize into the Kummer
polynomial (3).  Extending point purity from split complete intersections to
arbitrary centers remains the exact Silver/Gold gate.

Weak factorization does not remove this gate.  Its centers may be chosen
smooth and normally crossing the running boundary, but the theorem does not
say that every center is a boundary stratum.  A normally crossing center can
have a nonsplit normal bundle.  Thus one cannot invoke the splitting above at
every arrow without a new refinement of factorization.

## Sources

- Alexander Givental, *A mirror theorem for toric complete intersections*,
  arXiv:alg-geom/9701016, for the hypergeometric toric complete-intersection
  solution used in (1).  Cached PDF SHA-256:
  `b2b9a776ad8165029ec792964f357bf30ff0c80061ccead51ffac04cbda0de6b`.
- Tom Coates and Alexander Givental, *Quantum Riemann--Roch, Lefschetz and
  Serre*, arXiv:math/0110142, Theorem 2, for quantum Lefschetz:
  https://arxiv.org/abs/math/0110142.
- Hiroshi Iritani, *Quantum cohomology of blowups*, arXiv:2307.13555,
  Sections 4.2.3 and 5.8, for the exceptional Fourier center summand and its
  initial conditions.  Cached PDF SHA-256:
  `c16f56b283863322df04dadaeb0780889abd67a664f56a74fea39bc7ba8a934b`.
- Dan Abramovich, Kalle Karu, Kenji Matsuki, and Jaroslaw Wlodarczyk,
  *Torification and Factorization of Birational Maps*, arXiv:math/9904135,
  Theorem 0.3.1, for smooth centers normally crossing the boundary—not a
  stratum or split-normal-bundle assertion:
  https://arxiv.org/abs/math/9904135.

## AA / EJ / TT and mystery ledger

- **AA:** instead of proving the full analytic Gamma/Orlov theorem, compute
  only the point central solution in the first nonzero center example.  The
  toric bundle plus one hypersurface makes it a one-variable Kummer identity.
- **EJ:** the cancellation is universal for every smooth codimension-two
  complete intersection \((a,b)\subset\mathbf P^n\): the forbidden
  coefficient is always \(1/\Gamma(-ad)\).  The cubic pilot is one instance
  of a structural integrality zero, not an accident.
- **TT:** use the nef divisor \(A=\xi+bH\), and retain the possibility that
  \(A-(b-a)H\) has negative degree.  Those terms exist in the full
  \(I\)-function but vanish in its \(H^0\) coefficient.  The wrong
  coordinate produces a spurious \({}_2F_2\) tail and hides the exact Kummer
  cancellation.
- **Settled:** exact point purity for all split codimension-two
  complete-intersection blow-ups of projective space, including the first
  nonvacuous C907 cubic-center pilot.
- **Open:** whether the Gamma zero persists under arbitrary normal-bundle
  and master-space curve corrections; composition and product naturality of
  that general point-purity statement.  Standard weak factorization does not
  force the needed splitting.
