# C907 protected residual ratio cover

**Lane:** `clebsch`

**Status:** hostile-audited valuation/carrier cover and exact finite-ratio
Fitting theorem.  It explains why the two imbalanced charts capture every
finite-value end of the residual core.  It does **not** yet prove that an
arbitrary common regular refinement preserves their tangent units: a later
blowup with center `(r,v)` creates a genuine actual-boundary exceptional
divisor and can resurrect false critical packets.  The remaining global gate
is an admissible regular refinement whose centers do not use the interior
translated-residue directions.

## Exact bounded chart

Write `A=Q/Y`, `S=y_1+y_2+y_3`, and use residual coordinates

\[
 B=1-\delta Z+\delta^2A,qquad
 C=1-\delta W+\delta^2A. \tag{1}
\]

The potential is exactly

\[
 F=S+\frac A{BC}+ZW-\delta A(Z+W)+\delta^2A^2. \tag{2}
\]

At `delta=0` this is `f_Q+ZW`.  Its compact critical scheme is the four
reduced Morse points

\[
 Z=W=0,qquad y_1=y_2=y_3=a,qquad a^4=Q,qquad L=4a. \tag{3}
\]

Compactify the residual plane to `P^1_Z x P^1_W`.  An end can remain
non-exterior only when both the residual product and the corresponding ratio
`delta Z` or `delta W` stay finite.

## Ratio-graph modification at `Z=infinity`

Put `r=Z^{-1}` and take the closure of the simultaneous rational graph

\[
 v=\frac Wr=ZW,qquad h=\frac\delta r=\delta Z. \tag{4}
\]

Equivalently, resolve the two projective ratios `[W:r]` and `[delta:r]`.
The affine chart in which both ratios in (4) are finite has

\[
 W=rv,qquad\delta=rh. \tag{5}
\]

Substitution in (1)--(2) gives exactly

\[
 \begin{aligned}
 B&=1-h+r^2h^2A,\\
 C&=1-r^2hv+r^2h^2A,\\
 F&=S+\frac A{BC}+v-hA-r^2hAv+r^2h^2A^2.
 \end{aligned} \tag{6}
\]

On the locus where `B,C` are units, hence on the nonempty interior portions
of the two genuine central components `r=0`, `h=0` and their intersection,

\[
\partial_vF=1. \tag{7}
\]

At `r=0,h=1`, one has `B=0`; in the cleared strict equation the reduction is
the nonzero unit `-A`, so this apparent exception is empty.  Equivalently the
cleared derivative is a unit on every nonempty part: `-1` on `h=0` and
`-(1-h)` on `r=0`.  The divisor `v=0` is the strict transform of the retained translated locus
`W=0`; it is not an actual control boundary.  Forgetting it leaves (7) as a
regular tangent unit.  The symmetric ratio graph at `W=infinity` gives the
second imbalanced chart and `partial_wF=1`.

## Valuative coverage

For noncompact `y`, first read the limiting marked-line type.  If it remains
`(1,1)`, the full joint support theorem gives positive normalization and free
`L` (order zero forces compact `y`).  If `B` or `C` exits, the arc belongs to
the corresponding exterior theorem.  Thus it remains to check compact `y`.

For a compact-`y` arc at `Z=infinity`, put

\[
 a=\operatorname{ord}(r)>0,qquad
 b=\operatorname{ord}(W),qquad
 t=\operatorname{ord}(\delta)>0. \tag{8}
\]

There are three exhaustive alternatives.

1. If `b>=a` and `t>=a`, both ratios (4) are finite and the arc has a center
   in the imbalanced chart (5).
2. If `b<a` while `t>=a`, then `v=W/r` has a pole.  In (6) its coefficient is
   `1-r^2hA`, a unit at `r=0`.  More exactly, `ord(v)=b-a<0`, while
   `ord(r^2hAv)=t+b>b-a`; `S,A/(BC),hA` have nonnegative order when `B,C`
   are generic units.  Hence `v` is the unique lowest term and
   `ord(L)=b-a<0`.  If `C` is not a unit, then `t+b<0` gives `C=infinity`
   and the remaining non-generic residues give an exterior type; `B` cannot
   be infinite in this case.  Thus no new residual end lies over bounded
   `Omega`.
3. If `t<a`, then `h=delta/r` has a pole and (1) gives
   `B=1-h+delta^2A`; `h` is the unique negative-order term, so the arc exits
   through the marked exterior `B=infinity`.  Its center belongs to
   the already-certified exterior atlas.

The alternatives may overlap on the complement charts of the projective
ratio graph, which is harmless.  They prove that every bounded-value center
at the `Z` end lies either in the exact imbalanced chart or in an exterior
chart.  The symmetric proof handles the `W` end; the double-infinity locus is
covered by the same alternatives or has unbounded product `ZW`.

## Global refinement and the remaining admissibility gate

Let `M_res` be the compact residual plane with both ratio-graph modifications.
Take the normalization of the graph of its rational map to the marked
pair-of-pants/tropical ambient.  It is proper and is an isomorphism on the
original generic graph.  Its valuation carriers factor through:

\[
 \text{bounded core},\qquad
 \text{two ratio-imbalanced charts},\qquad
 \text{certified exterior charts}. \tag{9}
\]

An arbitrary further regular subdivision is unsafe.  Blowing up the vertical
center `(r,v)` gives `r=r_1,v=r_1q`; its new exceptional lies in the total
transform of `delta=0`, hence is an actual boundary component, while its
central restriction loses `q` and recreates the artificial `h=0,2` packets.
Thus forgetting the strict transform of `v=0` does not remove the new
exceptional divisor.

The sufficient admissibility condition is explicit: resolve the common model
relative to the smooth `v`- and `w`-lines, using no center whose ideal contains
an interior translated-residue coordinate and no exceptional divisor defined
from such a center.  This condition is locally achievable over the compact
protected locus.  Indeed, for an arc in (5) put

\[
 \alpha=\operatorname{ord}r,qquad
 k=\operatorname{ord}h,qquad
 \ell=\operatorname{ord}v,qquad p_i=0. \tag{10}
\]

When the marked limit remains `(1,1)`, equations (6) give generically

\[
 t=\alpha+k,\qquad \beta=k,\qquad
 \gamma=2\alpha+k+\min(\ell,k),quad
 2t-\beta-\gamma=-\min(\ell,k)\le0. \tag{11}
\]

The other five graph weights are zero.  Thus the product term either ties on
the coordinate faces `ell=0` or `k=0`, or drops; there is no interior support
wall, including at `ell=k`, that forces a center involving `v`.  If leading
coefficients cancel at `ell=k`, `gamma` increases and the product term drops
further, so no wall is created.  The compact finite-ratio cone is already a
regular coordinate cone and can be fixed as a regular subfan while all other
cones are desingularized relatively.  The symmetric statement fixes the
`w` cone.

Under this local relative resolution, the coarse strata retain (7), giving
the protected carrier's coarse Fitting contribution.  Together with the
still-conditional exterior records—the 70 tangent units, two `L=0`
exclusions, and free-`L` masks—this is the complete local outcome table.
Existence of a regular common
refinement gluing these protected subfans to every exterior attachment is not
yet proved; noncompact mixed cones are Fitting-safe because `L` is free but
still need their strict graph/overlap attachment.

The remaining topological input is no longer an algebraic boundary search:
choose a generic residual interface and apply the controlled fibrewise-pair
theorem.  Central-to-nearby transport of (3) remains the separate
parameterized Morse step.

## EJ/TT and mystery ledger

- **EJ:** compactify the two ratios actually occurring in the exact
  imbalanced formula.  Their projective graph turns “all residual ends” into
  a three-case valuation argument.
- **TT:** the imbalanced chart is not an ordinary affine chart of
  `Bl_(delta,U,V)`; it is the finite-ratio chart of a further residual-end
  modification.  Keeping that distinction is what makes `partial_vF=1`
  honest.
- **Settled:** bounded/imbalanced/exterior valuation coverage for every
  compact-`y`,
  bounded-value arc; compatibility with the noncompact-`y` free-`L` theorem;
  exact finite-ratio Fitting freeness.
- **Open:** glue the locally admissible protected subfans to the exterior
  regular refinement with strict graph/overlap records; then the
  controlled-topology step.  No additional residual valuation type remains
  unexplained.
