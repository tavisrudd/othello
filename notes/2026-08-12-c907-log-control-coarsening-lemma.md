# C907 log/control coarsening lemma

**Lane:** `clebsch`

**Status:** human structural local theorem.  It separates the auxiliary
pair-of-pants log atlas from the Whitney/control stratification used for
fibrewise excision.  This removes the artificial translated-residue critical
families without deleting any part of the original graph.

## Two different boundary data

The original dense graph domain is

\[
\mathcal U_0=\{\delta\ne0,\ y_1y_2y_3\ne0,\ B\ne0,\ C\ne0\}.
\tag{1}
\]

It contains $B=1$, $C=1$, and the zero loci of the residual coordinates.
The pair-of-pants log atlas nevertheless marks $B=1,C=1$ so that their
degeneration can be resolved by monomial charts.  These are **auxiliary
algebraic markings**, not components removed from (1).

The topological excision pair has a different closed datum:

\[
D_{\mathrm{actual}}\cup\{\delta=0\}\cup R\cup I,
\tag{2}
\]

where $D_{\mathrm{actual}}$ is the genuine infinity boundary, $R$ is the
residual Morse tube, and $I$ is its controlled interface.  A Whitney/control
stratification must be compatible with (2), but need not refine every
auxiliary pair-of-pants divisor.  Its vector fields may cross $B=1,C=1$.

## Imbalanced coordinate theorem

Use distinct residual coordinates

\[
Z=\frac{1+\delta^2A-B}{\delta},\qquad
W=\frac{1+\delta^2A-C}{\delta},\qquad A=Q/Y.
\tag{3}
\]

In the $Z$-imbalanced chart put

\[
r=Z^{-1},\qquad v=ZW,\qquad \delta=rh.
\tag{4}
\]

It is the regular chart obtained by compactifying the $Z$-line, blowing up
the boundary center $(r,W)=(0,0)$, and then the boundary center
$(r,\delta)=(0,0)$.  Thus

\[
Z=r^{-1},\qquad W=rv,qquad \delta=rh.
\tag{5}
\]

Both centers lie outside $\mathcal U_0$, so the modification is an
isomorphism on the original graph domain and leaves the bounded $(Z,W)$ core
untouched.  The exact identities are

\[
\begin{aligned}
B&=1-h+r^2h^2A,\\
C&=1-r^2hv+r^2h^2A,\\
1-B&=h(1-r^2hA),\\
1-C&=r^2h(v-hA).
\end{aligned}
\tag{6}
\]

Consequently:

- $v=0$ is the strict closure of $W=0$, equivalently
  $C=1+\delta^2A$.  It meets $\mathcal U_0$ and is interior.
- The marked pair-of-pants divisor $C=1$ has strict transform
  $v-hA=0$, not $v=0$.
- The strict transform of $B=1$ is $1-r^2hA=0$, which misses the
  $r=h=0$ corner.  The factor $h$ in $1-B$ is exceptional.

The exact potential is

\[
\Phi=S+\frac A{BC}+v-hA-r^2hAv+r^2h^2A^2.
\tag{7}
\]

On both components of the central fibre $rh=0$,

\[
\partial_v\Phi=1.
\tag{8}
\]

Hence the full imbalanced central chart is relative-Fitting-free.  The
bounded $(Z,W)$ chart is the only chart carrying the four residual Morse
points $Z=W=0$, $y_1=y_2=y_3=a$, $a^4=Q$.

## Local control-coarsening lemma

Let $U$ be a smooth resolved-chart neighborhood with coordinates
$(w,r,h,v)$ and $\delta=rh$.  Assume:

1. the actual topological boundary is a union of coordinate strata in
   $(w,r,h)$ and is independent of $v$;
2. an auxiliary algebraic divisor has equation $v-g(w,h)=0$ but is not part
   of the excision-pair boundary; and
3. $\partial_vL$ is a unit on $U\cap\{\delta=0\}$.

After shrinking $U$, partition it only by the actual boundary coordinates and
the two central components $r=0,h=0$, leaving $v$ unsplit.  This coordinate
partition is Whitney.  On every fixed-$\delta$ stratum, $L$ is a submersion,
and a value vector field $\xi$ has the explicit lift

\[
\widetilde\xi=
\frac{\xi(L)}{\partial_vL}\,\partial_v.
\tag{9}
\]

The lift preserves every actual boundary coordinate and $\delta$, but need
not preserve the auxiliary divisor.  The kernels of $dL$ are graphs over the
same coordinate hyperplanes with coefficients varying continuously; hence the
coordinate partition satisfies the local Thom $a_L$ condition.  It is the
required control coarsening of the finer algebraic log partition.

For (7), all hypotheses hold near the imbalanced central chart.  The
symmetric $W$-imbalanced chart is identical.

## Why the coarsening is necessary

Refining the control partition by $v=0$ deletes the unit direction in (8).
On $r=v=0$, the restricted tangent equation becomes $h(2-h)$ and creates
two false four-point packets.  Refining by the actual marked divisor
$v-hA=0$ likewise creates restricted families on its central intersections.
These are critical schemes of a chosen hypersurface restriction, not of the
full value map.

The algebraic atlas may and must retain these divisors to prove graph gluing.
The collar flow is simply allowed to cross them.  If a future topological
argument requires preserving $B=1$ or $C=1$, this coarsening no longer
applies and a different excision argument is required.

## Global use

The global order-zero proof should therefore have three ledgers:

1. a **support ledger** for the six-weight product-of-tripods complex;
2. an **algebraic chart ledger** for the multihomogeneous strict graph and
   its auxiliary log markings; and
3. a coarser **control-stratum ledger** for (2), on which relative submersivity
   and Thom $a_L$ are checked.

Conflating the second and third ledgers was the source of the apparent
endpoint obstruction.

## EJ/TT and mystery ledger

- **EJ:** the unit residue direction gives both the critical-locus proof and
  the controlled lift.  One formula, (9), replaces an endpoint case split and
  a chartwise vector-field construction.
- **TT:** algebraic log markings are not automatically topological boundary
  conditions.  Refining a control stratification can create critical points
  by deleting a normal direction, so “finer” is not monotone for
  submersivity.
- **Settled:** exact imbalanced blowup chart; identity of $v=0$ and the true
  $C=1$ strict transform; preservation of the original graph domain;
  full-chart freeness; local Whitney--Thom coarsening and controlled lift.
- **Open evidence gap:** construct the complete regular modification and
  verify globally that its actual boundary datum has local product coordinates
  independent of a unit value direction on every exterior chart.
