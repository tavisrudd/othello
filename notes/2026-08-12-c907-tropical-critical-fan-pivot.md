# C907 tropical critical-fan pivot

**Lane:** `clebsch`

**Status:** exact finite algebraic reduction; topology remains open.

## Decision

Stop extending the boundary atlas ray by ray.  Compute one relative
Gröbner fan for the saturated graph together with its residual marking and
tangent-critical module.  The local charts already proved become regression
cases for that computation.

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

Compute a relative comprehensive Gröbner fan in the
`(y_1,y_2,y_3,B,C,delta)` weights with `w_delta>0` and `w_L=0`, including
parameter-special `L` strata.  For each cone `sigma` and toric orbit
`O_sigma`, form the reduced saturated induced graph

\[
 A_\sigma=
 \left(k[L][O_\sigma]/\sqrt{
 (\operatorname{in}_\sigma I^\circ+I_{O_\sigma}):
 \chi_{O_\sigma}^{\infty}}\right)_{red}.
 \tag{2}
\]

Resolve any non-schön or nonsmooth initial scheme before testing criticality.

Let `T_sigma` be the kernel of the full tangent Jacobian of (2) at fixed
`delta`, with `L` included among the tangent variables.  Define

\[
 \mathfrak c_\sigma=
 \operatorname{Fitt}_0\operatorname{coker}
 (dL:T_\sigma\to A_\sigma).
 \tag{3}
\]

Equivalently, compute tangent-Jacobian syzygies and take their `L` components.
This recognizes a free `L` coordinate by producing `(1)` and retains all
leading cancellations.

## Finite cone verdict

Every cone must carry one exact certificate:

1. **empty:** `A_sigma=0`;
2. **exterior:** `c_sigma=(1)`, or the critical-value elimination ideal has no
   root in the fixed disk `Omega`, certified by exact root isolation; or
3. **residual:** the radical critical scheme lies in the strict residual Rees
   transform and an explicit transition identifies its scheme and Hessian
   with the four Morse points of `f_Q+ZU`.

The Gröbner fan of this finite ideal package is finite rational polyhedral.
Its normalized slice `w_delta=1,w_L=0` therefore supplies the finite algebraic
fan that the hand atlas lacked.  This statement requires the graph, residual
Rees marking, comprehensive `L` strata, and log resolutions together;
`Trop(I^circ)` by itself is insufficient.

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
