# C907 first tangent-Jacobian cone certificates

**Lane:** `clebsch`

**Status:** two exact local certificates; not a complete fan.

Write

\[
 S=y_1+y_2+y_3,\quad Y=y_1y_2y_3,\quad A=Q/Y,
\]

and

\[
 F_\delta=S+\frac A{BC}+\delta^{-2}(1-B)(1-C).
 \tag{1}
\]

These calculations use the saturated-graph/tangent-Jacobian acceptance gate
of `2026-08-12-c907-tangent-jacobian-fan-certificate-spec.md`.

## 1. Compact residual chart

Put

\[
 B=1-\delta Z+\delta^2A,qquad
 C=1-\delta U+\delta^2A.
\]

Here `B,C` are units at `delta=0`, and the strict transform of the torus graph
is the single reduced equation

\[
 L=S+\frac A{BC}+ZU-\delta A(Z+U)+\delta^2A^2.
 \tag{2}
\]

Its central stratum is

\[
 L=f_Q(y)+ZU,qquad f_Q=S+A.
\]

The relative critical ideal on this stratum is

\[
 (L-S-A-ZU,Z,U,y_1-A,y_2-A,y_3-A),
 \tag{3}
\]

or the displayed ideal without its first generator modulo the graph equation.

Thus `y_1=y_2=y_3=A=a`, `a^4=Q`, and `L=4a`.  The Hessian determinant is
`-4/a^3`, so the critical scheme is reduced and consists of the four residual
Morse sections.  This cone has the **residual** outcome.

At its imbalanced end use

\[
 r=U^{-1},\qquad v=ZU,\qquad\delta=rh.
\]

Then exactly

\[
 B=1-r^2hv+r^2h^2A,\quad
 C=1-h+r^2h^2A,
\]

and

\[
 L=S+\frac A{BC}+v-hA-r^2hAv+r^2h^2A^2.
 \tag{4}
\]

The reduced saturated graph equation is

\[
 E=BC(L-S-v+hA+r^2hAv-r^2h^2A^2)-A=0.
 \tag{4a}
\]

Indeed the pulled-back cleared equation is `r^2h^2Y E`, while the pulled-back
torus product is `rhYBC`; saturation gives `(E)`, and `E=-A` at `B=0` or
`C=0` forces both to remain units.  On `r=0`,

\[
 E=(1-h)(L-S-v+hA)-A,qquad D_vE=-(1-h).
\]

Here `C=1-h` is forced to be a unit.  On `h=0`, `E=L-S-v-A` and
`D_vE=-1`.  Thus every nonempty central face is **free**; the formal subface
`r=0,h=1` has ideal `(A)=(1)` and is empty.

The symmetric end is explicit.  Put

\[
 \rho=Z^{-1},\quad v=ZU,\quad\delta=\rho k.
\]

Then

\[
 B=1-k+\rho^2k^2A,\quad
 C=1-\rho^2kv+\rho^2k^2A,
\]

and the formulas above hold with `(r,h)` replaced by `(rho,k)`.  On the
overlap,

\[
 \rho=(rv)^{-1},\quad k=r^2hv,qquad
 r=(\rho v)^{-1},\quad h=\rho^2kv.
\]

## 2. A family of genuinely mixed `y,B,C` cones

Let `p_i,beta,gamma` be nonnegative rational weights satisfying

\[
 0\le p_i\le2,\qquad \beta,\gamma>0,\qquad
 \beta+\gamma=p_1+p_2+p_3+2.
 \tag{5}
\]

For each cone selected in a future finite fan, choose `N_sigma` clearing its
ray denominators, replace `delta` by `s^(N_sigma)`, and put

\[
 x_i=\delta^{p_i}y_i,\qquad
 B=\delta^\beta b,\qquad C=\delta^\gamma c,
\]

and `X=x_1x_2x_3`.  Then

\[
 \delta^2F_\delta=
 \sum_i\delta^{2-p_i}x_i+\frac Q{Xbc}
 +(1-\delta^\beta b)(1-\delta^\gamma c).
 \tag{6}
\]

After clearing the unit denominator, the saturated graph is

\[
 Xbc\left(\delta^2L-\sum_i\delta^{2-p_i}x_i
 -(1-\delta^\beta b)(1-\delta^\gamma c)\right)-Q=0.
 \tag{7}
\]

with `Xbc` inverted.  The pullback of the cleared graph polynomial is exactly
`delta^2 G`; this uses `beta+gamma=sum_i p_i+2`.  Since `G` is not divisible
by `delta`, saturation gives `(G)`.  Its central stratum is

\[
 1+\sum_{p_i=2}x_i+\frac Q{Xbc}=0,
 \tag{8}
\]

with `L` unconstrained.  This stratum is smooth because its logarithmic
`b`-derivative is `-Q/(Xbc)`, a unit.  Since `L` is a tangent coordinate,
the tangent critical scheme is empty.  Every selected cone satisfying (5)
has the **free** outcome.  A common ramification index exists only after a
finite fan has been specified; the rational cone family itself is not yet
that finite fan.

The following ray, previously missed by the circuit argument, is the case
`p_i=2`, `beta=gamma=4`.

The open-torus gradient argument does not classify this ray directly:

\[
 y_i\sim\delta^{-2},\qquad B\sim\delta^4,qquad C\sim\delta^4.
\]

Introduce torus coordinates

\[
 x_i=\delta^2y_i,qquad B=\delta^4b,qquad C=\delta^4c,
\]

and put `X=x_1x_2x_3`, `sigma=x_1+x_2+x_3`.  On `delta!=0`, (1) becomes

\[
 F_\delta=\delta^{-2}
 \left(\sigma+1+\frac Q{Xbc}\right)
 -\delta^2(b+c)+\delta^6bc.
 \tag{9}
\]

After clearing the unit denominator `Xbc`, the saturated graph closure is

\[
 G=Xbc\bigl(\delta^2L-\sigma-1
       +\delta^4(b+c)-\delta^8bc\bigr)-Q=0.
 \tag{10}
\]

The pullback identities are

\[
 P^{pb}=\delta^2G,qquad
 (\delta YBC)^{pb}=\delta^3Xbc.
\]

Because of the constant term `-Q`, `G` has no factor among
`delta,x_i,b,c`; hence saturation gives `(G)`.  Its central stratum is

\[
 H:=\sigma+1+\frac Q{Xbc}=0,
 \tag{11}
\]

with `L` unconstrained.  It is smooth: if `P=Q/(Xbc)`, then

\[
 D_bH=D_cH=-P,
\]

and `P` is a unit.  More importantly, `L` is a free coordinate—a direct
summand of the relative cotangent module—so the tangent critical scheme is
empty.  This cone has the **free** outcome.

The previously troublesome arc

\[
 x_1=x_2=x_3=-\frac14,qquad bc=256Q
\]

lies on (11), since `sigma=-3/4` and `Q/(Xbc)=-1/4`; it is therefore explicitly
classified as free rather than inferred from the open-torus gradient.

## Boundary and next certificate

These two charts prove neither completeness of the mixed fan nor product-pair
collars.  They do establish both possible nonempty outcomes directly from the
saturated graph and its tangent Jacobian:

- the compact residual cone contains exactly the four expected Morse points;
- the cone family (5), including the mixed escape ray that defeated the
  separate circuit argument, is free.

The next useful cones have some `p_i` outside `[0,2]`, or lie in the finite
pole continuum `B=delta^alpha b` where the bounded-value branch forces a
coupled valuation for `C`.  Each requires its own saturated initial graph.

## EJ/TT and mystery ledger

- **EJ:** the mixed counterarc is harmless for a reason invisible to UDG:
  graph saturation makes `L` a free exceptional coordinate.
- **TT:** freedom of `L` can arise when the leading graph equation loses `L`;
  this is a positive mechanism, not automatically a spurious vertical
  component, provided torus saturation and smoothness are checked.
- **Settled:** compact residual and the mixed cone family (5).
- **Open:** remaining mixed rays, finite-pole continuum, overlaps, and global
  fan completeness.
