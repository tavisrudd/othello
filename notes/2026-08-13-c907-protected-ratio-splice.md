# C907 protected-ratio analytic splice for coarse control

**Lane:** `clebsch`

**Status:** a conditional, proper Hausdorff *analytic* replacement for the
impossible common marked toroidal fan.  It gives the smallest remaining
geometric datum: a pair of closed annular strict-graph identifications.  The
protected local chart, its Cartier strict generator, its actual-boundary
submersivity, and its bounded-value coverage are exact.  What is not yet
proved is the required annular identification with one exterior regular
model, so this is not yet a global collar theorem.

## The forced fan wall should be contracted, not controlled

At the compact `Z=infinity` protected end put

\[
 Z=r^{-1},\qquad W=rv,\qquad \delta=rh,qquad A=Q/Y.
\tag{1}
\]

The marked valuation map bends at `ord(v)=ord(h)`.  A common marked toroidal
fan therefore inserts the ray `e_h+e_v`, i.e. the blowup
\(\operatorname{Bl}_{(h,v)}\).  The exceptional divisor is an actual
vertical boundary and restricts the value map to `f_Q`; it carries the false
four families.  This is the obstruction proved in
`2026-08-12-c907-global-ratio-fan-gluing-obstruction.md`.

The ratio chart (1) is already regular and has no graph-support wall there.
The correct coarse space is consequently obtained by retaining (1) on a
protected neighborhood and using the marked regular exterior model only away
from `(h,v)=(0,0)`.  This is a local blow**down**, not a new fan refinement.
It deliberately need not map toroidally to the auxiliary pair-of-pants fan.

## Exact protected Cartier chart

Write

\[
\begin{aligned}
B&=1-h+r^2h^2A,& C&=1-r^2hv+r^2h^2A,\\
E&=BC(L-S-v+hA+r^2hAv-r^2h^2A^2)-A .
\end{aligned}
\tag{2}
\]

On the finite projective graph chart of the global multihomogeneous Cartier
section,

\[
 \overline P=\delta^2YBC(L-S)-\delta^2Q-YBC(1-B)(1-C),
\tag{3}
\]

one has the exact identity

\[
 \overline P=r^2h^2Y E\qquad(AY=Q).
\tag{4}
\]

Thus, on compact `y` where `Y` is a unit, division by the genuine central
factors `r^2h^2` gives the strict graph generator `E`.  No translated factor
has been divided out.  The exact same formula holds at the symmetric
`W=infinity` end after exchanging the marked lines.

There is a single proper carrier for this local construction.  In the
projective Cartier ambient of (3), take the closure of the rational graph of

\[
 (Z,W,\delta Z,\delta W,ZW):
 \mathcal A_0\dashrightarrow(\mathbb P^1)^5,
\tag{4a}
\]

after clearing the fixed toric/projective denominators of these meromorphic
functions.  Call its normalization `A_rat`.  The map
`A_rat -> A_0` is proper, and the chart in which
`r=Z^{-1},h=delta Z,v=ZW` are finite is exactly (1).  Taking the closure of
the dense graph in this proper ratio ambient gives the protected piece used
below.  This construction does **not** require the rational map (4a) to be
toroidal for the marked pair-of-pants fan.  Normalization alone would not
prove a Cartier strict-transform formula on every other chart; equation (4)
is the exact protected local formula, and the exterior comparison is isolated
as the annular datum below.

The actual central components of this chart are `r=0` and `h=0`; `v=0` is
interior.  Their cleared derivatives are

\[
 \left.\partial_vE\right|_{r=0}=-(1-h),
 \qquad \left.\partial_vE\right|_{h=0}=-1.
\tag{5}
\]

The apparent zero of the first derivative at `r=0,h=1` has `B=0` and
`E=-A`, so it is empty.  Hence every nonempty protected actual-boundary
stratum retains a regular unit tangent direction.  Blowing up the forced
marked wall instead gives `v=hq` and

\[
 E|_{h=0}=L-S-A=f_Q,
\tag{6}
\]

independent of `q`.  This is exactly why the coarse chart must be retained.

The adjacent exact replay verifies (4)--(6):

```sh
cd /home/tavis/src/othello
nix shell nixpkgs#singular --command Singular -q \
  notes/2026-08-13-c907-protected-ratio-splice.sing | \
  cmp -s - notes/2026-08-13-c907-protected-ratio-splice.out
```

The 1,458-byte Singular source and 215-byte canonical output are pinned by
the adjacent SHA-256 manifest.  Direct substitution of (1) into (3), using
`AY=Q`, is an independent hand check of (4); the separate derivative
specializations give (5)--(6).

## Closed-collar splice lemma

The following is the usable replacement for a global common fan.  It is a
topological/analytic construction, not a claim of one global toroidal
scheme.

Let `R_Z` and `R_W` be the two protected ratio charts, with the bounded
residual core included in their finite complements.  Let `M_ext` be any
proper regular exterior model of the intrinsic tropical graph over
\(\overline\Delta\times\overline\Omega\).  Choose a relatively compact
protected polydisc in `(r,h,v,y)` (and its symmetric mate), containing a
compact `y` box around the residual critical points, and choose inside it

\[
 0<\epsilon<2\epsilon,
 \qquad
 C_Z=\{\epsilon\le |h|^2+|v|^2\le2\epsilon\},
\tag{7}
\]

with the symmetric collar `C_W`.  The radii are chosen so that the four
Morse points are inside the protected side and no central marked-face
singularity lies on a collar.  The collars avoid the center `(h,v)=0` of the
forced blowup.

Assume the following **annular seam datum**, and only this additional local
datum:

\[
 \iota_Z:(M_{\rm ext}|_{C_Z},\operatorname{StrTr}(\overline P),D_{\rm act},L)
 \xrightarrow{\ \sim\ }
 (R_Z|_{C_Z},(E),\{rh=0\},L),
\tag{AS-Z}
\]

and its `W`-symmetric analogue.  Here the arrows are biholomorphisms on an
open neighborhood of the displayed **closed** collars, over the parameter
and value bases.  They must identify the strict Cartier equations up to a
unit and identify only the genuine actual-boundary components.  They do not
remember `B=1`, `C=1`, `U=0`, `V=0`, or `v=0` as control boundary.

**Splice lemma.**  Under (AS-Z/W), replace the portions of `M_ext` inside the
two inner collars by the protected ratio pieces and identify the two closed
annuli using \(\iota_Z,\iota_W\).  The result `M_coarse` is Hausdorff and
proper over \(\overline\Delta\times\overline\Omega\).  It contains the
original dense graph over `delta != 0`, and its bounded-value ends are
covered by

\[
 \boxed{\text{bounded Morse core}}
 \ \cup\ \boxed{R_Z}\ \cup\ \boxed{R_W}
 \ \cup\ \boxed{\text{exterior}}.
\tag{8}
\]

**Proof.**  Restrict first to the inverse image of a compact subset of the
base.  The protected and exterior cut pieces are compact Hausdorff spaces:
the exterior piece is closed in the proper `M_ext`, while a protected piece
is closed in the projective graph of the two residual ratios.  The gluing
relation is the union of the two diagonals and the graphs of the collar
homeomorphisms.  Those graphs are closed because the collars are closed and
compact.  The quotient is therefore compact Hausdorff.  This argument on
every compact base subset proves properness.  Since the two modifications are
identical on the generic dense graph and are identified on the collars, the
dense graph embeds without a doubled limit.

For coverage, the exact ratio valuative trichotomy says that a compact-`y`,
bounded-value arc at either residual infinity has a center in the relevant
finite ratio chart, has unbounded `L`, or exits to an exterior marked-line
type.  A noncompact-`y` arc is positive-order/free-`L` while double marked,
and otherwise also exits to the exterior carrier.  Properness gives a
convergent subsequence, so these alternatives cover every bounded-value end.
The double-residual-infinity case is already in the pole/exterior alternative
(the product ratio has a pole); it needs no third protected chart. \(\square\)

This proves Hausdorffness and proper coverage from a *closed* collar.  The
protected pieces are taken with their closure in the projective graph of the
ratios, so the displayed local polydisc does not introduce a nonproper end.
An
open-chart gluing would be insufficient: its equivalence relation need not
be closed and can produce a doubled boundary limit.

## Coarse value-submersivity after the splice

On the protected central strata (5) gives a literal unit derivative in the
interior coordinate `v` (or `w`).  The bounded core is set aside as the four
section relative Morse family

\[
 Z=W=0,\qquad y_1=y_2=y_3=a,\qquad a^4=Q,\qquad L=4a.
\tag{9}
\]

On the exterior, the 70 exact `L`-mask records have regular tangent lifts in
the intrinsic tropical chart: their derivative has unit initial reduction,
so it is a unit in the filtered local ring.  The two remaining `L`-masks
give `L=0` and are absent over \(\Omega\Subset\mathbb C^*\); masks without
`L` leave `L` free.  In particular the two former problematic masks use the
regular infinity-residue derivatives

\[
 ((1,\infty),01234):\ d\log c\,H=-P,
 \qquad
 ((\infty,1),01234):\ d\log b\,H=-P,
\tag{10}
\]

not the nonregular `partial_B` or `partial_C` lift.  The collar
identifications carry these tangent directions into the ratio chart.  Hence,
conditional only on (AS-Z/W) and the already stated exterior chart descent,
`L` is submersive on every exterior actual-boundary stratum of
`M_coarse`; the four points (9) are the only protected exception.

This is intentionally a submersivity statement.  A common Whitney
stratification, a control function whose pair with `L` is submersive, and
Thom \(a_L\) remain distinct collar inputs.

## What is actually still missing

The local ratio computation and the valuative carrier cover do **not** need a
new common fan.  The minimum unproved geometric record is exactly (AS-Z/W):

1. identify, on a finite closed annulus away from `(h,v)=0`, the chosen
   exterior regular chart with the ratio chart;
2. prove that their strict graph generators are the same Cartier section up
   to a unit after saturation by only the original dense complement; and
3. verify that the exterior actual-boundary labels and the lifted tangent
   derivations descend through this identification.

The first part is locally expected because `Bl_(h,v)` is an isomorphism off
its center.  Formula (4) supplies the protected half of the second part.
What remains is to serialize that this is the **only** local modification
between the selected exterior chart and the ratio collar, with no extra
Kummer/strict-transform component meeting the annulus.  This is a finite
collar-attachment audit, far smaller than a global all-face Fitting replay.

If it fails, it fails in a concrete way: an additional exceptional component
meets the annulus or its strict graph equation is not a unit multiple of
`E`.  That is the minimum obstruction to the coarse splice, rather than an
unspecified nonseparatedness concern.

## EJ/TT and mystery ledger

- **EJ:** replace the forced marked blowup by its inverse only inside a
  protected closed collar.  Properness is then a closed-equivalence-relation
  argument, not a global-fan problem.
- **TT:** the dangerous divisor is created only to linearize an auxiliary
  valuation map.  Contracting it is mathematically natural for the control
  problem, but it must be done with a closed collar; naive open gluing can be
  non-Hausdorff.
- **Settled:** exact protected Cartier strict equation; unit tangent
  derivative; forced-blowup regression; bounded-value carrier cover; and the
  precise conditional proper Hausdorff splice.
- **Open:** the two annular strict-Cartier identifications (AS-Z/W), exterior
  chart descent on them, then a controlled Whitney--Thom interface.  No
  common marked toroidal fan is sought or needed.
