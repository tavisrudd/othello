# C907 finite-pole continuum certificate

**Lane:** `clebsch`

**Status:** exact local theorem with compact `y`; global fan still open.

Let

\[
 F_\delta=S+\frac A{BC}+\delta^{-2}(1-B)(1-C),
 \qquad A=Q/(y_1y_2y_3),
\]

and restrict `y` to the residual compact torus, so `A` is a unit.  The
continuum of bounded-potential approaches

\[
 B\sim\delta^\alpha b,\qquad 0\le\alpha\le2,
\]

does not require infinitely many charts.  It is covered by the semistable
incidence model

\[
 ef=\delta^2,qquad B=e.
 \tag{1}
\]

For `0<alpha<2`, `e` and `f` have valuations `alpha` and `2-alpha`;
the endpoint faces `f=0` and `e=0` give `alpha=0` and `alpha=2`.

## The `0/0` branch

Put

\[
 C=fc.
\]

The pullback of the cleared torus graph, divided by the unit `Y`, is

\[
 \delta^2G_{00},qquad
 G_{00}=\delta^2c(L-S)-A-c(1-e)(1-fc).
 \tag{2}
\]

After localizing the stated chart units, saturation by the exact pullback of
`delta YBC` is equivalent to the displayed colon, and in the localized
incidence ring `R=(ef-delta^2)` one has the exact main-transform identity

\[
 (G_{00}):(\delta efc)^\infty=(G_{00}).
 \tag{2a}
\]

Indeed `G_(00)=c*(...)-A` forces `c` to be a unit; its restrictions to both
central components `e=0` and `f=0` are nonzero, so it has no component
supported on `delta=0`.  This colon identity is the saturation certificate,
not merely the absence of a visible factor.

Its central fibre has three strata.

- On `e=f=0`, `G_(00)=-A-c`; hence `c=-A` and `L` is free.
- On `e=0`, `f!=0`,
  `G_(00)=-A-c(1-fc)`.  The graph forces `c(1-fc)` to be a unit, and
  `partial_fG_(00)=c^2` is a unit.  Again `L` is free.
- On `f=0`, `e!=0`,
  `G_(00)=-A-c(1-e)`.  The face `e=1` is empty; elsewhere
  `partial_cG_(00)=-(1-e)` is a unit and `L` is free.

Thus every nonempty central stratum of the `0/0` incidence graph has empty
tangent critical scheme for `L/delta`.

## The `0/1` branch

Put instead

\[
 C=1-fc.
\]

The pulled-back cleared graph is `delta^2G_(01)`, where

\[
 G_{01}=e(1-fc)(L-S)-A-c(1-e)(1-fc).
 \tag{3}
\]

Likewise, in the chart localization,

\[
 (G_{01}):(\delta e(1-fc))^\infty=(G_{01});
 \tag{3a}
\]

`G_(01)` restricts nontrivially to both central components, and the `-A` term
excludes a component on `e=0` or `1-fc=0`.  On the central strata:

- `e=f=0` gives `-A-c=0` with `L` free;
- `e=0`, `f!=0` gives `-A-c(1-fc)=0`, with
  `partial_fG_(01)=c^2` a unit;
- `f=0`, `e!=0` gives
  
  \[
  L=S-c+\frac{A+c}{e}.
  \]
  
  Its tangent critical ideal is
  
  \[
  (e-1,A+c,y_1-A/e,y_2-A/e,y_3-A/e).
  \tag{4}
  \]
  
  Thus the unique critical locus has
  `e=1`, `c=-A`, `y_1=y_2=y_3=A=a`, `a^4=Q`, and `L=4a`.
  It is the retained residual Morse locus; the Hessian in the transverse
  coordinates `(e-1,c+A)` is nondegenerate.  Away from (4), `L` is
  submersive.

Hence `0/1` creates no new critical locus but meets the residual core at one
endpoint.  Interchanging `B` and `C` supplies the `1/0` analogue.  The `1/1`
face is the separate residual blow-up chart, not a symmetric copy of this
incidence model.

## Exact transition to the imbalanced residual chart

The `0/1` exterior must be glued to, not blown up through, its residual
endpoint.  On the overlap where

\[
 k:=1-e+\delta^2A
\]

is a unit, define

\[
 \rho=\frac\delta k,qquad
 v=k\left(A+\frac ce\right).
 \tag{5}
\]

Then `delta=rho k`, and the `Z^(-1)` imbalanced residual chart has

\[
 B=1-k+\rho^2k^2A=e,
\]

and

\[
 C=1-\rho^2kv+\rho^2k^2A
  =1-\frac{\delta^2c}{e}=1-fc.
\]

Conversely,

\[
 e=1-k+\rho^2k^2A,qquad
 c=e\left(\frac vk-A\right),qquad
 f=\frac{\rho^2k^2}{e}.
 \tag{6}
\]

Thus (5)--(6) are inverse isomorphisms on the overlap `ek!=0`.  On its
central face `rho=0`, one has `k=1-e` and

\[
 v=(1-e)(A+c/e).
\]

Substitution in the imbalanced potential

\[
 L=S+\frac A{BC}+v-kA+O(\rho^2)
\]

gives exactly `L=S-c+(A+c)/e`, the `f=0` incidence formula.  Since `v` is a
free coordinate on this imbalanced face, the exterior part `k!=0` is
submersive.  The overlap stops at `k=0`, which is precisely `e=1` and contains
the four residual Morse points.  They remain in the compact `Z,U` core; no
blow-up through that core is used.

Interchanging `B,C` supplies the symmetric transition for the `1/0` branch.

## Consequence and scope

For compact `y`, boundedness forces `c` to be a leading unit on these
branches.  The entire finite-pole continuum `0<=alpha<=2` is then covered by
the incidence charts above: their central strata are either `L`-submersive or
the already-retained residual Morse locus.  The continuum of rational
valuations therefore creates no infinite-fan obstruction and no new
bounded-value critical stratum.

This is a local algebraic certificate, not yet the exterior pair theorem.
Still required:

- the collar-level gluing at `k=0` between the compact residual core and the
  exact imbalanced overlap above;
- the faces with noncompact `y` not covered by the mixed cone family already
  certified; and
- one finite common fan, all overlaps, and product collars.

## EJ/TT and mystery ledger

- **EJ:** the apparent continuum is the central-face geometry of one
  semistable node `ef=delta^2`; no ray-by-ray enumeration is needed.
- **TT:** retain both irreducible central components and their intersection.
  Proving only the `e=f=0` face would miss the endpoint charts.
- **Settled:** compact-`y` finite-pole `0/0`, `0/1`, and `1/0` branches; the
  only endpoint critical locus is the known residual one.
- **Settled:** exact exterior transition to the imbalanced residual chart away
  from `k=0`; the construction does not blow up through the residual core.
- **Open:** collar gluing at `k=0`, noncompact `y`, and global compatibility.
