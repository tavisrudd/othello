# C907 tropical critical-fan pivot

**Lane:** `clebsch`

**Status:** exact finite algebraic reduction; topology remains open.

## Decision

Stop extending the boundary atlas ray by ray.  Compute one relative
Gröbner fan for the saturated graph together with its residual marking and
tangent-critical module.  The local charts already proved become regression
cases for that computation.

The first machine replay is green: it checks the two compact-`y` semistable
incidence saturations and the residual endpoint ideal exactly in Singular.
See `2026-08-12-c907-critical-fan-pilot.md` and its adjacent `.sing`, `.out`,
and `.sha256` bundle.

## Algebraic package

Over `k=C(Q)`, put

\[
 R=k[L,\delta,y_1^{\pm1},y_2^{\pm1},y_3^{\pm1},B^{\pm1},C^{\pm1}]
\]

and

\[
 P=\delta^2YBC(L-S)-\delta^2Q-YBC(1-B)(1-C),
\]

\[
 I^\circ=\sqrt{(P):(\delta YBC)^\infty}.
 \tag{1}
\]

Adjoin the normalized Rees model of the residual ideal
`(delta,B-1,C-1)`.  A boundary critical scheme counts as residual only when
its strict transform lies in this marked Rees model and its transition to the
`Z,U` chart identifies its Hessian with `f_Q+ZU`.

There is an exact **generic-torus critical-arc regression** before
compactification.  After restricting to `delta!=0`, its ideal is generated,
up to torus units, by

\[
 P,\quad Q-YBCy_i\ (i=1,2,3),\quad
 \delta^2Q+YB^2C(1-C),\quad
 \delta^2Q+YBC^2(1-B).
 \tag{2}
\]

Its solutions satisfy

\[
 y_1=y_2=y_3=a,\quad B=C=b,\quad
 a^4b^2=Q,\quad b(1-b)=-\delta^2a,
 \tag{3}
\]

and

\[
 L=4a+\delta^2a^2/b^2.
 \tag{4}
\]

With `v(delta)=1`, (3) has exactly two valuation types.  The bounded branch is

\[
 v(a)=v(b)=0,qquad v(1-b)=2,
\]

which is residual.  The other has

\[
 v(a)=-2/3,qquad v(b)=4/3,qquad v(L)=-2,
\]

and escapes the bounded value window.  Thus every actual bounded torus
critical arc is residual.  The fan computation is needed only for tangential
critical schemes created on boundary strata.

On this open graph, the relative cotangent quotient has the one-row
presentation whose entries are

\[
 D_{y_1}P,D_{y_2}P,D_{y_3}P,D_BP,D_CP.
\]

Thus its `Fitt_4` is exactly the five-derivative ideal yielding (2).  This is
only an open-torus regression: Fitting ideals do not in general commute with
initial degeneration or base change.

Do not saturate the total relative Fitting ideal by `delta`.  That would take
the closure of generic critical points and can delete precisely the
special-fibre failures of submersivity being tested.  On every boundary
stratum, first form and reduce the induced saturated graph, then recompute its
relative Fitting ideal from scratch.

Compute a relative comprehensive Gröbner fan in the
`(y_1,y_2,y_3,B,C,delta)` weights with `w_delta>0` and `w_L=0`, including
parameter-special `L` strata.  For each cone `sigma` and toric orbit
`O_sigma`, form the reduced saturated induced graph

\[
 A_\sigma=
 \left(k[L][O_\sigma]/\sqrt{
 (\operatorname{in}_\sigma I^\circ+I_{O_\sigma}):
 \chi_{O_\sigma}^{\infty}}\right)_{red}.
 \tag{5}
\]

Resolve any non-schön or nonsmooth initial scheme before testing criticality.
In particular, the fan produces `rad(sat(in_w I))`, not its normalization.
Every chart must compute its finite normalization (or integral generators)
before the reduced-stratum cotangent/Fitting calculation.

Let `G_sigma` be the full transformed defining ideal of `A_sigma`.  On a
resolved lci chart, let `T_sigma` be the kernel of its full tangent Jacobian
at fixed `delta`, with `L` included among the tangent variables.  Define

\[
 \mathfrak c_\sigma=
 \operatorname{Fitt}_0\operatorname{coker}
 (dL:T_\sigma\to A_\sigma).
 \tag{6}
\]

Equivalently, compute tangent-Jacobian syzygies and take their `L` components.
This recognizes a free `L` coordinate by producing `(1)` and retains all
leading cancellations.

## Finite cone verdict

Every cone must carry one exact certificate:

1. **empty:** `A_sigma=0`;
2. **exterior:** `c_sigma=(1)`, or the critical-value elimination ideal has no
   root in the fixed disk `Omega`.  Fix `Q` algebraic and specify `Omega` by
   algebraic boundary data for exact complex root isolation, or give a
   symbolic semialgebraic partition in `Q`; or
3. **residual:** the radical critical scheme lies in the strict residual Rees
   transform and an explicit transition identifies its scheme and Hessian
   with the four Morse points of `f_Q+ZU`.

After fixing a projective toric/Rees compactification and its finite translated
chart package, its relative Gröbner fans are finite rational polyhedral.  A
finite comprehensive decomposition in `L` then exists by Noetherianity, and a
finite characteristic-zero log resolution handles non-schön initials.  Their
normalized slice `w_delta=1,w_L=0` supplies the finite algebraic fan that the
hand atlas lacked.  `Trop(I^circ)` by itself is insufficient.

One finite pre-fan is explicit.  Write

\[
 p_i=v(y_i),\quad \beta=v(B),\quad\bar\beta=v(1-B),\quad
 \gamma=v(C),\quad\bar\gamma=v(1-C),\quad \ell=v(L)\ge0.
\]

The two marked-`P^1` tropical relations require the minimum of
`{beta,bar beta,0}` and of `{gamma,bar gamma,0}` to occur at least twice.  The
bounded graph relation requires the minimum of

\[
 \{\ell,p_1,p_2,p_3,-\sum p_i-\beta-\gamma,
   -2+\bar\beta+\bar\gamma\}
 \tag{7}
\]

to occur at least twice.  These are finitely many rational linear chambers.
On each one, use the homogenized graph

\[
 P^h=\delta^2YBC(L_0-SL_\infty)-\delta^2QL_\infty
     -YBC(1-B)(1-C)L_\infty,
 \tag{8}
\]

restrict to `L_infty!=0`, and refine by the Gröbner fans of the finitely many
`B,C` translated charts and `y` toric charts.  The residual `B=C=1` blow-up
remains a separate marked chart.

Do not replace the reduced-stratum Fitting calculation by
`in_w` of the open critical ideal.  Initial ideals and saturation need not
commute, and a special-fibre tangent critical locus need not be the limit of
generic critical sections.

Weights outside the first hand range are genuinely present but benign in
sample chambers.  For example, if `p_1=P>2`, `p_2=p_3=0`, and
`beta=gamma=(2-P)/4<0`, the leading graph is
`Q/(Xbc)+bc=0`; its logarithmic `b`-derivative is `2bc`, a unit on the graph,
so `L` is free.  Thus valuation bounds alone do not make all remaining cones
empty; the finite Fitting fan is the correct compression.

## What this does not prove

Even a green algebraic fan does not supply the topological excision.  One
still needs:

- a proper normalized projective realization of the chart system;
- one Whitney/Thom stratification on all exterior and residual intersections;
- controlled collars and an integrable `L`-lift giving
  `(N_I x Omega,N_I x {u_0})`; and
- uniform extension from the central initial strata to small nonzero
  `delta`.

Only then does relative Mayer--Vietoris isolate the four residual thimbles.

## EJ/TT and mystery ledger

- **EJ:** the finite fan is produced by the critical ideal itself; cancellations
  become input rather than exceptions discovered after compactification.
- **TT:** include the residual Rees marking before computing the fan.  A
  critical scheme cannot be labeled residual from support at
  `(delta,B-1,C-1)` alone.
- **Settled:** a finite algebraic completeness target exists.
- **Open:** execute the comprehensive fan, resolve non-schön cones, and build
  the proper collar topology afterward.
