# C907 global graph: Cartier closure and conditional schön criterion

**Lane:** `clebsch`

**Status:** hostile-audited structural theorem plus an exact open replay gate.
The global Cartier closure and its strict-transform overlap mechanism are
proved.  A finite support complex is serialized, but support masks do not by
themselves determine the full initial complete intersections.  Consequently
this note does **not** claim a smooth proper graph, schönness, a global
control stratification, or the order-zero Stokes theorem.

## 1. One global Cartier graph

Fix $Q\ne0$.  On marked projective coordinates

\[
B=b_1/b_0,\qquad C=c_1/c_0,
\]

the dense graph has the bidegree-$(2,2)$ homogenization

\[
\begin{aligned}
\overline P={}&
\delta^2Yb_0b_1c_0c_1(L-S)
-\delta^2Qb_0^2c_0^2\\
&-Yb_1c_1(b_0-b_1)(c_0-c_1).
\end{aligned}
\tag{1}
\]

Let

\[
\Delta_y=\operatorname{conv}\{0,e,e+e_1,e+e_2,e+e_3\},
\qquad e=(1,1,1).
\tag{2}
\]

On a smooth projective refinement $X_y$ of the normal fan, (1) is a section
of

\[
\mathcal O_{X_y}(D_{\Delta_y})\boxtimes
\mathcal O_{\mathbf P^1_B\times\mathbf P^1_C}(2,2).
\tag{3}
\]

Its Cartier divisor has no component contained in the complement of

\[
\mathcal U_0=
\{\delta\ne0,\ y_1y_2y_3\ne0,\ b_0b_1c_0c_1\ne0\}.
\tag{4}
\]

In particular, $B=1$ and $C=1$ belong to the original graph domain.  They
may be marked in a pair-of-pants atlas, but they are not saturated away.
On $\mathcal U_0$, (1) is integral and monic in $L$ after multiplication by
a unit.  At the generic point of every omitted irreducible divisor, at least
one of the three displayed summands in (1) remains nonzero.  Hence no divisor
component is supported in the complement, and the Cartier divisor is the
schematic closure of the dense graph.

If a regular modification $\pi:\mathcal A'\to\mathcal A$ is an isomorphism
over (4), let $x_i=0$ be all local irreducible components of
$\mathcal A'\setminus\pi^{-1}(\mathcal U_0)$, including strict transforms of
the original boundary as well as exceptional components.  Write

\[
\pi^*\overline P=u\prod_i x_i^{a_i}G.
\tag{5}
\]

Then the strict-transform ideal is

\[
(G)=(\pi^*\overline P):(\prod_i x_i)^\infty.
\tag{6}
\]

Thus the strict graph is globally Cartier and its local generators agree up
to units.  This settles graph overlap equality once a regular modification
and the genuine exceptional components have been specified.  It does not
settle smoothness of $G$.

## 2. Horizontal boundary lemma

At fixed $\delta\ne0$, the seven nonconstant Newton exponents are

\[
e_1,e_2,e_3,-(1,1,1,1,1),e_B,e_C,e_B+e_C.
\tag{7}
\]

The exponent zero carrying the $L$ term lies strictly inside their convex
hull:

\[
0=\frac2{11}\left(e_1+e_2+e_3-(1,1,1,1,1)\right)
+\frac1{11}\left(e_B+e_C+(e_B+e_C)\right).
\tag{8}
\]

All coefficients are positive and the seven exponents span the
five-dimensional affine hull.  Hence every proper horizontal Newton face of
the $(y,B,C)$-toric compactification omits $L$.  Its graph is a product with
the $L$-line, so $L$ is a split product coordinate there.  A factorwise
resolution preserves this free coordinate.

This concerns only ordinary toric horizontal strata.  A valuation centered
at $B=1$ or $C=1$ is non-toric in these coordinates and is not represented by
this Newton polytope.  The auxiliary marked $U=1-B,V=1-C$ directions remain
part of the full pair-of-pants initial replay and coarse-control gate.  The
lemma also does not identify the vertical $\delta=0$ initial schemes or prove
that their horizontal factor is smooth.

## 3. Finite vertical support skeleton

Introduce marked coordinates

\[
U=1-B,\qquad V=1-C
\tag{9}
\]

and retain the equations $B+U=1$, $C+V=1$.  Their tropicalizations are two
tripods.  On each of the sixteen ordered cones of the product, with
$t=v(\delta)$, the six support weights are

\[
0,\quad p_1,\quad p_2,\quad p_3,\quad
-p+v(B)+v(C),\quad 2t-v(U)-v(V).
\tag{10}
\]

The exact hyperplane replay in
`2026-08-12-c907-tripod-hyperplane-refinement.py` and its tracked JSON/hash
certificate intersects all fifteen pairwise equalities with all sixteen
cones.  Its full slice has

\[
944,\ 7824,\ 22231,\ 28828,\ 17508,\ 4032
\tag{11}
\]

cells in dimensions zero through five.  Every cell has one maximal-weight
tie mask, and the union of feasible masks is the set of all $63$ nonempty
subsets of the six weights.

This is a finite support theorem.  The map

\[
\text{hyperplane cell}\longrightarrow\text{maximal-support mask}
\tag{12}
\]

forgets residue coefficients and the initial forms of the pair-of-pants
relations.  Therefore it is not a schönness certificate.

## 4. Correct conditional schön theorem

Let $\mathcal A^{\log}$ be a log-regular pair-of-pants ambient containing
the graph, and let $\Sigma$ be a finite rational support complex.  In every
toric trivialization, form the **full** saturated initial ideal

\[
I_{\sigma,\tau}=
\operatorname{in}_{\sigma,\tau}
\bigl(\overline P,\ B+U-1,\ C+V-1\bigr)^{\mathrm{sat}},
\tag{13}
\]

where $\tau$ ranges over every residue stratum and face specialization, and
saturation uses only components in the complement of (4).

> **Conditional initial-complete-intersection theorem.**  Assume that for
> $\Sigma$ is support-complete for every vertical valuation centered on the
> graph closure and that its residue strata cover the scheme-theoretic
> special fibre.  Assume further that for every pair $(\sigma,\tau)$:
>
> 1. (13) has the expected codimension;
> 2. (13) itself defines a geometrically smooth scheme, equivalently it is
>    radical and its geometric reduction is smooth;
> 3. (13) is the scheme-theoretic special fibre of the chart's flat
>    saturated Rees/initial degeneration;
> 4. its equation agrees, after the chart trivialization and removal of the
>    genuine exceptional multiplicity (5), with the local strict-transform
>    equation; and
> 5. these statements remain true on every face specialization.
>
> Then the graph closure is schön/log-smooth along the vertical boundary.
> Any log-étale regular subdivision preserves this property.  Combined with
> the horizontal lemma, a regular subdivision gives a smooth strict graph
> near the whole special fibre.

The theorem is the standard initial-degeneration criterion applied to the
complete intersection consisting of the graph section and the two
pair-of-pants relations.  Its hypotheses cannot be replaced by smoothness of
one polynomial with a fixed support mask.  For example,
$1+x+y+axy$ has constant support but becomes reducible and singular at
$a=1$.

## 5. Exact finite replay still required

The missing certificate must have one record for every chart, residue
stratum, and face.  Each record must contain:

1. the cone of the chosen regular integral refinement;
2. the toric and pair-of-pants residue stratum;
3. the full ideal (13), including residue coefficients;
4. the true dense-domain saturation set;
5. the exceptional multiplicity removed in (5);
6. an exact smoothness/expected-codimension certificate uniform in all
   permitted residue parameters;
7. every face specialization; and
8. an attachment to the corresponding local strict-transform formula.

The ten orbit reports and the 63 masks may compress repeated calculations
only after a uniform-coefficient lemma proves that two attached records have
the same full initial complete intersection up to units.  At present no such
attachment replay exists.

## 6. Control strata are a separate gate

Even after schönness, relative critical ideals must be computed on globally
defined **coarse control strata**, not imported from finer algebraic log
strata.  For a fixed reduced global stratum $T$, the intrinsic module

\[
\mathcal M_T=
\Omega^1_{(\mathcal G\cap T)_{\mathrm{red}}/\Delta}/
\mathcal O\,dL
\tag{14}
\]

and its Fitting ideals localize across charts.  This observation applies only
after both charts present the same $T$.
The required global indexing and outcome table is recorded separately in
`2026-08-12-c907-coarse-control-stratum-ledger.md`.

In an imbalanced chart

\[
r=Z^{-1},\qquad v=ZW,\qquad\delta=rh,
\tag{15}
\]

one has $\partial_vL=1$ on both central components.  The coordinate $v$ is
interior and must remain unsplit in the control partition.  Artificially
imposing $v=0$ deletes $dv$ and manufactures the false packets

\[
h=0,\quad a^4=Q,
\qquad\text{and}\qquad
h=2,\quad b^4=-3Q.
\tag{16}
\]

They are critical schemes of a chosen restriction, not of the full value
map.  The special fibre of the genuine four-section residual critical scheme
is confined to the bounded residual chart and equals

\[
Z=W=0,\qquad y_1=y_2=y_3=a,\qquad a^4=Q,
\qquad L=4a.
\tag{17}
\]

For $\delta\ne0$, the four nearby critical sections generally have
$Z,W\ne0$.  Their exact dense-torus equation and the six escaping ambient
branches are recorded in
`2026-08-12-c907-bounded-value-interior.md`.

## EJ/TT and mystery ledger

- **EJ:** one multihomogeneous Cartier section makes graph overlap equality
  formal; one full-initial-complete-intersection criterion is the correct
  global smoothness mechanism.  The 81,367-cell support complex is an index
  into that proof, not the proof itself.
- **TT:** support, algebraic log, and topological control partitions retain
  different information.  Coarsening support to a mask loses coefficients;
  refining control by an interior residue coordinate loses tangent
  directions.  Neither information loss is monotone for smoothness.
- **Settled:** global Cartier closure; strict-transform saturation mechanism;
  horizontal free-$L$ boundary; finite exact vertical support complex; local
  imbalanced unit direction and false-face diagnosis.
- **Open algebra:** regular integral refinement; full initial ideals with all
  residue strata and faces; chart attachment; all-point smoothness/normality;
  and global coarse-control boundary Fitting replay.  Dense-torus
  bounded-value separation is closed independently.
- **Open topology:** proper fibrewise Whitney--Thom control, controlled
  interface and pairing-preserving excision.
- **Open marking:** satellite-to-localized integral comparison and loop
  orientation.
