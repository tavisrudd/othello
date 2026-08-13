# C907 compact ratio subfan preservation

**Lane:** `clebsch`

**Status:** local existence theorem for a residue-admissible refinement over
the compact protected core.  The finite ratio chart has an already regular
compact-`y` support subfan which no graph wall cuts in its interior.  Ordinary
relative fan resolution can preserve that subfan, so the forbidden
`(r,v)`- and `(h,v)`-type centers are not forced there.  This is local to the
protected ratio carrier; it does not replace the global strict-transform
attachment to exterior charts.

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

## Relative preservation

The cone (5), together with its faces and the compact `y` face
`p_1=p_2=p_3=0`, is a regular subcomplex of the ratio-chart support complex.
For a finite rational fan with a regular subfan, standard relative toric
desingularization gives a regular subdivision which is the identity on that
subfan: apply determinant-descent star subdivisions only to nonregular cones
not belonging to it.  A star subdivision outside a subfan leaves each of its
cones unchanged, and termination is the usual strictly decreasing lattice
determinant argument.

Applied here, this gives a regular local refinement whose restriction to the
compact protected ratio carrier is exactly (5).  Its actual central boundary
there is still `rh=0`; the smooth variable `v` is not used in a center.  The
cleared equation

\[
E=BC(L-S-v+hA+r^2hAv-r^2h^2A^2)-A
\tag{6}
\]

therefore retains its unit tangent derivative: on nonempty `r=0`,
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
resolution, but their resolution is not needed to subdivide the compact
subfan (5).  Relative resolution can be performed away from (5), retaining
the compact `v` tangent direction.  If a noncompact arc leaves the
double-marked limit, it is assigned to its exterior carrier before this
argument is used.

## Scope

This proves existence of a **local residue-admissible regular refinement**
on the protected compact ratio carrier.  It refutes the concern that a graph
wall forces the dangerous blowups `(r,v)` or `(h,v)` at the compact residual
points.  It does not yet construct a global common model in which the local
ratio chart and every exterior chart have identified strict graph generators.
That attachment, and any tangential audit of a genuinely forced mixed
exceptional divisor outside the preserved subfan, remain separate.

## EJ/TT

- **EJ:** in ratio coordinates the apparent Rees wall is a unit-residue
  face, not a translated-residue boundary.  The compact protected cone is
  already regular and wall-free.
- **TT:** the dangerous false packets come from optional blowups, not from a
  support-theoretically forced compact-core resolution.  Preserve the regular
  subfan first; resolve the noncompact/free-`L` complement relatively.
