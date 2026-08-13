# C907 generic finite $(B,C)$ star

**Lane:** `clebsch`

**Status:** exact normalized tangent-Fitting theorem for arbitrary $y$ weights
when both $B,C$ remain finite away from $0,1,\infty$; no common-fan or collar
claim.

## Saturated graph

Work with $B=b$, $C=c$ and invert
$bc(1-b)(1-c)$.  After a finite ramified base change put

\[
y_i=\delta^{-p_i}x_i,qquad p=\sum_i p_i,qquad X=x_1x_2x_3,
\]

and define

\[
m=\max\{2,p_1,p_2,p_3,-p\}.
\tag{1}
\]

The exact monomial-normalized graph is

\[
G=Xbc\left(
 \delta^mL-\sum_i\delta^{m-p_i}x_i
 -\delta^{m+p}\frac Q{Xbc}
 -\delta^{m-2}(1-b)(1-c)
 \right)=0.
\tag{2}
\]

It equals $\delta^mXbc(L-F_\delta)$ on the dense torus.  After localization,
the pulled-back torus condition has only $\delta$ as a nonunit.  Every
exponent in (2) is nonnegative and one is zero, so $\delta\nmid G$ and

\[
(G):\delta^\infty=(G).
\tag{3}
\]

Since $m\ge2$, $L$ always drops from the central graph.

## Feasible supports

Up to overall sign, the central support lies in

\[
H=\sum_{p_i=m}x_i+
 \mathbf1_{-p=m}P+
 \mathbf1_{m=2}K=0,
\qquad
P=\frac Q{Xbc},\quad K=(1-b)(1-c).
\tag{4}
\]

If $m>2$, $K$ is absent.  The support containing $P$ and all three $x_i$
is infeasible: it would require $p_i=m$ for every $i$ and $-p=m$, hence
$3m=-m$.  Every realizable support with $P$ therefore misses some $x_j$, and
$D_{x_j}H=-P$ is a unit.  A support without $P$ has a unit $x_i$ derivative,
unless it is a singleton, which is empty.

If $m=2$, $K$ occurs.  When $P$ also occurs, $p=-2$, so again not all three
$p_i$ can equal two; an absent $x_j$ gives the same unit derivative.  When
$P$ is absent, an occurring $x_i$ has unit derivative, while the lone $K$
support is empty because $K$ is a chart unit.

Thus every nonempty feasible central graph is smooth.  The total graph is
already smooth and normal along it, $L$ is a free coordinate, and the exact
relative tangent-Fitting ideal is $(1)$.  The generic finite $(B,C)$ star has
no residual or unmarked critical face for any toric $y$ valuation.

## Orbit-level consequence

Together with the certificates for

\[
(0,0),(0,g),(0,1),(0,\infty),(g,1),(g,\infty),
(1,1),(1,\infty),(\infty,\infty)
\]

and their swaps, this fills the remaining $(g,g)$ entry of the ten unordered
boundary-orbit types in
$\{0,1,\infty,g\}^2/(B\leftrightarrow C)$.  It proves orbit-type coverage,
not yet a single finite fan or equality of overlap ideals.

## EJ/TT and mystery ledger

- **EJ:** the relation $p=\sum p_i$ deletes the only support on which both
  generic coefficients could participate in a nontrivial tangent circuit.
- **TT:** `B,C` generic is still a $\delta=0$ boundary chart and had to be
  certified explicitly; calling it open torus would not meet the tangent-fan
  acceptance gate.
- **Settled:** every generic finite $(B,C)$ face for arbitrary $y$ weights.
- **Open:** explicit cone refinement inside each orbit type, transition and
  overlap ideals, fan completeness, and collars.
