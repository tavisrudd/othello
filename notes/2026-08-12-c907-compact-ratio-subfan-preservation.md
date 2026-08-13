# C907 compact ratio subfan preservation

**Lane:** `clebsch`

**Status:** corrected obstruction theorem.  The finite ratio chart has no
interior **graph-support** wall, but its map to the marked pair-of-pants cone
bends at `ell=k`.  A common toroidal fan subdivides by the ray `e_h+e_v`,
exactly the forbidden blowup `(h,v)`.  Graph support alone permits
preservation; compatibility with the fine auxiliary marking does not.  A
protected coarse model must avoid monomializing that translated divisor.

## Compact protected ratio cone

At the `Z`-infinity finite-ratio chart use

\[
Z=r^{-1},\qquad W=rv,\qquad\delta=rh.
\tag{1}
\]

Let

\[
\alpha=\operatorname{ord}r,\qquad
k=\operatorname{ord}h,\qquad
\ell=\operatorname{ord}v
\tag{2}
\]

be nonnegative.  On compact `y`, `A=Q/Y` is a unit.  At a double-marked
limit, away from a harmless cancellation which can only increase an order,

\[
\begin{aligned}
t&=\operatorname{ord}\delta=\alpha+k,\\
\beta&=\operatorname{ord}(1-B)=k,\\
\gamma&=\operatorname{ord}(1-C)
       =2\alpha+k+\min\{\ell,k\}.
\end{aligned}\tag{3}
\]

Indeed `1-B=h(1-r^2hA)` and
`1-C=r^2h(v-hA)`.  If the leading terms of `v` and `hA` cancel, `gamma`
increases; this only strengthens the inequality below.  The six universal
normalization weights, with the `delta` order restored, restrict to

\[
0,0,0,0,0,\quad
2t-\beta-\gamma=-\min\{\ell,k\}\leq0.
\tag{4}
\]

Thus the compact protected support has the five-term mask `01234` in the
interior and the six-term mask `012345` only on the coordinate faces
`k=0` or `ell=0`.  It has no interior graph wall in the regular coordinate
cone

\[
C_{\rm rat}=\mathbb R_{\geq0}
\langle e_r,e_h,e_v\rangle.\tag{5}
\]

The face `k=0` is the adjacent generic marked-line carrier.  The face
`ell=0` says that the smooth residue `v` is a unit; it is not the divisor
`v=0`.  In particular the raw Rees equality that looks like an interior
wall in the `U` chart becomes precisely this unit-residue face after the
ratio change.  It does not force a subdivision centered on the affine locus
`v=0`.

## Marked-map obstruction

As a graph-support cone, (5) is regular and wall-free.  But the marked
valuation coordinate (3) contains `min(ell,k)`.  The map to the
`(t,beta,gamma)` pair-of-pants complex is not linear on (5); it bends on the
interior wall `ell=k`.  Making it a fan morphism adds the ray `e_h+e_v`, the
toric star subdivision of the center `(h,v)`.

On the chart `h=h_1,v=h_1q`, one has `delta=rh_1`.  The exceptional
`h_1=0` is therefore an actual vertical boundary divisor.  Its potential is
`F_0=S+A=f_Q`, independent of `q`, and carries the four families
`y_i=a,a^4=Q`.  Before this subdivision, the cleared equation

\[
E=BC(L-S-v+hA+r^2hAv-r^2h^2A^2)-A
\tag{6}
\]

retains its unit tangent derivative: on nonempty `r=0`,
`D_vE=-(1-h)`, and on `h=0`, `D_vE=-1`.  The compact four-section Morse
scheme remains confined to the bounded chart.

## Why noncompact directions do not constrain this subfan

For an arbitrary `y` valuation the order-zero condition is

\[
\max\{0,p_1,p_2,p_3,-p,2t-\beta-\gamma\}=0.
\tag{7}
\]

It forces `p_i=0` for every `i`.  Hence every noncompact `y` direction has
positive normalization order and leaves `L` free by the joint `y`/Rees
support theorem.  Such cones may need further graph-support or ambient
resolution.  If a noncompact arc leaves the double-marked limit, it is
assigned to its exterior carrier before this argument is used.  This does not
remove the compact marked-map bend just identified.

## Scope

This proves a sharp separation.  No graph wall forces the dangerous center,
but compatibility with the **fine marked** pair-of-pants fan does.  A single
common toroidal refinement therefore cannot preserve the protected tangent
model.  The viable route is a coarse two-piece model: keep the translated
divisor interior on the protected ratio neighborhood and glue to the exterior
tropical model only where translated factors are invertible.  Constructing
that separated proper gluing and its strict overlaps is the remaining gate.

## EJ/TT

- **EJ:** the graph support is already regular; the obstruction comes only
  from insisting on a fine auxiliary marking.
- **TT:** do not monomialize data that must remain interior to the control
  problem.  The global object must be coarse/non-toroidal at this seam.
