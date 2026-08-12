# C907 incidence--residual endpoint transition

**Lane:** `clebsch`

**Status:** exact dense-torus rescaling and residual-chart identification.
It is a prospective `c`-infinity chart of a projectivized multi-Rees
compactification, not by itself a proper common refinement of the finite-`c`
incidence chart.  The current valid route across the finite-`c` endpoint is
the exterior/core collar gluing in
`2026-08-12-c907-finite-pole-continuum-certificate.md`.

Let

\[
 F_\delta=S+\frac A{BC}+\delta^{-2}(1-B)(1-C),
 \qquad A=Q/(y_1y_2y_3),
\]

with `y` in the compact residual torus, so `A` is a unit.  In the finite-pole
`0/1` incidence chart,

\[
 ef=\delta^2,\qquad B=e,\qquad C=1-fc.
\tag{1}
\]

The central endpoint `f=0,e=1,c=-A` is residual, but the finite-`c` chart
does not itself give a regular coordinate transition to the residual chart.
The `c`-infinity chart together with the `e=1` blow-up chart has the exact
residual equation below.  To make it a common chart in a proper model still
requires the projective Rees relation joining the finite-`c` and
`c`-infinity charts.

## 1. Common chart and main transform

On the dense torus set

\[
 e=1-\delta z,\qquad q=\delta c,\qquad
 D=e-\delta q.
\tag{2}
\]

Then

\[
 f=\frac{\delta^2}{e},\qquad
 B=e,\qquad C=\frac De=1-\frac{\delta q}{e}.
\tag{3}

Thus (2) is a dense-torus rescaling of the finite incidence relation (1) on
`delta != 0`.  Work on the open chart where `eD` is a unit.  The pullback
of the cleared graph equation, divided by the unit `Y`, is

\[
 \frac{\delta^2}{e}H,
 \qquad
 H=eD(L-S)-eA-qzD.
\tag{4}
\]

Since `eD` is a unit, `H` is monic in `L`.  Consequently its quotient is
regular over the `delta`-line and the exact torus-main-transform identity is

\[
 (H):(\delta YBC)^\infty=(H).
\tag{5}
\]

This is a saturation statement for the displayed rescaled chart, not an
assertion that the finite-`c` central fibre maps regularly to it.

At `delta=0`,

\[
 H_0=L-S-A-qz.
\tag{6}
\]

The tangent logarithmic critical ideal of `L/delta` is

\[
 (z,q,y_1-A,y_2-A,y_3-A).
\tag{7}
\]

It consists of the four points `y_1=y_2=y_3=A=a`, `a^4=Q`, with
`z=q=0` and `L=4a`.  The `z,q` Hessian block has determinant `-1`; together
with the Hessian of `S+A`, the total determinant is `-4/a^3`.

## 2. Exact residual transition

For the compact residual coordinates

\[
 B=1-\delta Z+\delta^2A,
 \qquad C=1-\delta U+\delta^2A,
\tag{8}
\]

the exact transition from (2) is

\[
 Z=z+\delta A,
 \qquad U=\frac qe+\delta A.
\tag{9}
\]

Conversely,

\[
 z=Z-\delta A,
 \qquad e=1-\delta z,
 \qquad q=e(U-\delta A).
\tag{10}
\]

Under (9), the residual graph equation

\[
 L=S+\frac A{BC}+ZU-\delta A(Z+U)+\delta^2A^2
\tag{11}
\]

becomes

\[
 L=S+\frac A D+\frac{qz}{e}.
\tag{12}
\]

Multiplication by the unit `eD` identifies (12) with `H=0`.  Hence, once the
projective Rees construction supplies this as its `c`-infinity chart, the
strict transformed graph ideals and their relative tangent critical schemes
agree with the residual ones here.  These equations alone do not turn the
finite-`c` central fibre into a regular overlap; the collar construction
avoids that unsupported inference.

## 3. Transition to the imbalanced residual chart

On the locus `U != 0` put

\[
 r=U^{-1},\qquad v=ZU,\qquad \delta=rh.
\tag{13}
\]

From the common chart this is exactly

\[
 r=\frac e{q+\delta eA},\qquad
 h=\frac{\delta(q+\delta eA)}e,\qquad
 v=\frac{(z+\delta A)(q+\delta eA)}e.
\tag{14}
\]

Conversely,

\[
 z=r(v-hA),\qquad
 e=1-r^2hv+r^2h^2A,\qquad
 q=e(r^{-1}-rhA).
\tag{15}
\]

Equations (13)--(15) recover

\[
 B=1-r^2hv+r^2h^2A,
 \qquad C=1-h+r^2h^2A,
\]

and the imbalanced graph formula already used in the pole-channel atlas.
At its `r=0` boundary the value coordinate `v` is free.  Thus no additional
critical boundary point appears when the `q`-infinity end of the common chart
is joined to the imbalanced chart.

## 4. Scope

The raw finite-`c` central point and the residual chart do not have a regular
direct special-fibre transition: `z=(1-e)/delta` and `q=delta c` require a
projectivized multi-Rees refinement.  Equations (5)--(12) are the exact
local target chart for such a refinement.  Until that proper construction is
given, the finite-pole note's collar gluing remains the accepted endpoint
mechanism.  Remaining work is the global common fan, the other overlaps, and
the collar/Mayer--Vietoris theorem.
