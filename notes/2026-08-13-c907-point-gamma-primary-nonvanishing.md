# C907 point Gamma primary nonvanishing

**Lane:** clebsch

**Status:** exact analytic no-go.  The Gamma-framed class of a point on a
smooth cubic threefold has nonzero connection coefficient in both
primitive-sixth formal lines.  Therefore ambient primitive-sixth projection
does not annihilate point-supported Gamma classes.  Any Silver
support-square construction must use an intrinsic support packet and a Gysin
map different from ambient Gamma projection.

## The point central charge

The regularized cubic quantum period is

\[
 F(t)=\sum_{d\ge0}\frac{(3d)!}{(d!)^5}t^d
 ={}_2F_3\!\left(
   \begin{matrix}1/3,\,2/3\\1,\,1,\,1\end{matrix};27t
  \right).
 \tag{1}
\]

For the Gamma-framed point class, the Chern character is the top class.
Pairing Iritani's Gamma flat section with the unit therefore selects the
degree-zero coefficient of the small \(I\)-function.  Up to one nonzero
normalization constant, the resulting central charge at fixed nonzero
Novikov parameter \(q\) is

\[
 Z_p(z)=z^{-3/2}F(q/z^2).
 \tag{2}
\]

The factor \(z^{-3/2}\) is \(z^{-\mu}\) on \(H^6(X)\); multiplication by the
Gamma class and by \(z^{c_1(X)}\) does not change the top class.  Equation
(1) is the already audited scalar form of Cai's rank-four connection:
with \(x=27t\), its operator is

\[
 D^4-x(D+1/3)(D+2/3).
 \tag{3}
\]

## Exact algebraic asymptotics

NIST DLMF 16.11.2 and 16.11.8 give the algebraic part of the
large-variable expansion of
\({}_2F_3(a_1,a_2;b_1,b_2,b_3;x)\).  Since
\(a_1-a_2=-1/3\) is nonintegral, both algebraic poles are simple.  For

\[
 (a_1,a_2)=(1/3,2/3),\qquad b_1=b_2=b_3=1,
\]

their leading coefficients are

\[
 C_{1/3}
 =\frac{\Gamma(1/3)}{\Gamma(2/3)^4},
 \qquad
 C_{2/3}
 =\frac{\Gamma(-1/3)}{\Gamma(1/3)^4}.
 \tag{4}
\]

Neither coefficient vanishes.  The branch phases of \((-x)^{-a_i}\) vary
between admissible sectors but are also nonzero.  Thus every sectorial
large-\(x\) expansion contains nonzero terms

\[
 C_{1/3}(-x)^{-1/3},
 \qquad
 C_{2/3}(-x)^{-2/3}.
 \tag{5}
\]

Substituting \(x=27q/z^2\) into (2) gives

\[
 z^{-3/2}x^{-1/3}\sim z^{-5/6},
 \qquad
 z^{-3/2}x^{-2/3}\sim z^{-1/6}.
 \tag{6}
\]

These are precisely Cai's two primitive-sixth fractional powers.  Equations
(4)--(6) therefore prove:

> The Gamma-framed point class has nonzero projection to both rank-one
> primitive-sixth formal-monodromy lines of the cubic quantum connection.

This upgrades the leading-matrix warning in
2026-08-13-c907-cubic-point-primary-collision.md to the actual
large-radius-to-formal connection statement.

## Consequences

### Ambient support annihilation is false

There is no Gamma-natural projector

\[
 s_Y(V)\longmapsto
 \operatorname{pr}_{\zeta_6}s_Y(V)
\]

which both realizes the whole cubic formal-primary packet and vanishes on
every object whose support has absolute dimension at most two: take
\(Y=X\) and \(V=\mathcal O_p\).

This matches the independent categorical calculation.  The projected point
is nonzero in the numerical Kuznetsov component, and the entire component
has Serre polynomial \(t^2-t+1\).

### Exact consistency gate for the conditional Silver theorem

The divisorial support-square implication remains formally correct if its
supported packet axiom is read as a new intrinsic assignment.  It cannot be
implemented by ambient Gamma projection, residual-category projection, or
an objectwise localizing realization compatible with those projections.

To survive the point test, an intrinsic support packet would need

\[
 \mathcal P_6(\operatorname{Perf}(p))=0
\]

while its pushforward object has the nonzero ambient primary image just
computed.  Hence its Gysin map cannot send the intrinsic class of
\(\mathcal O_p\) to the ambient Gamma class of \(i_*\mathcal O_p\).
Compatibility with ordinary objectwise Gamma framing must fail or be
replaced by a relative correction term.

The next construction problem is therefore not simply "build the missing
projector."  It is:

> construct, or disprove, a corrected support Gysin transformation whose
> defect from ambient Gamma pushforward is exactly the primitive-sixth point
> central charge (4).

Until such a correction is exhibited and shown compatible with Orlov
component maps, the localizing-\(\Phi_6\) route is a conditional formal
scheme with an unmet consistency gate, not the leading established route to
Silver.

## Sources

- Jiaji Cai, *The cubic threefold is symplectically irrational*,
  arXiv:2608.01577, for the rank-four small connection and its fractional
  powers.  Cached PDF SHA-256:
  06bfccf9b67ed8cf224f5e7cc6ba2088271577787e2f8e0dd895c0ef3b404a9e.
- C907's audited hypergeometric identification and recurrence:
  2026-08-10-c907-quantum-monodromy-stabilization.md, Section 5.5, with
  its committed Sage and independent SymPy evidence bundle.
- Hiroshi Iritani, *Gamma classes and quantum cohomology*,
  arXiv:2307.15938, equation (1.6), for the Gamma-framed flat section.
  Cached PDF SHA-256:
  462f2e0d6eff6315d9fcc2e0db78f95f14558d532d118e31b74f2270c2e0ab8a.
- NIST Digital Library of Mathematical Functions, §16.11, especially
  equations 16.11.2 and 16.11.8, for the large-variable algebraic
  coefficients in (4): https://dlmf.nist.gov/16.11.

## AA / EJ / TT and mystery ledger

- **AA:** ambient Gamma projection and residual Serre projection are both
  closed negatively as support-local realizations.  A corrected intrinsic
  Gysin map or a route avoiding support annihilation remains.
- **EJ:** the two nonzero Gamma quotients in (4) are exact central-connection
  data.  They turn a categorical warning into an A-model theorem and give a
  mandatory regression value for every future construction.
- **TT:** compute one skyscraper before postulating a localizing quantum
  motive.  The point already occupies both fractional lines.
- **Settled:** nonvanishing of the Gamma-framed point in both
  primitive-sixth formal branches; failure of ambient support annihilation.
- **Open:** whether a corrected Gysin transformation can subtract these
  point coefficients functorially while retaining blowup and product
  compatibility; otherwise a different Silver invariant is required.

