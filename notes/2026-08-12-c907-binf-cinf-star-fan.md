# C907 $B=C=\infty$ mixed-star certificate

**Lane:** `clebsch`

**Status:** exact two-infinity exterior-star calculation; no global fan
claim.

## Saturated central graph

Put, after clearing rational weights by a finite ramified base change,

\[
y_i=\delta^{-p_i}x_i,\qquad
B=\delta^{-\beta}b,\qquad C=\delta^{-\gamma}c,
\qquad \beta,\gamma>0,
\]

where every `x_i,b,c` is a torus unit.  With `p=sum_i p_i`, define

\[
m=\max\{2+\beta+\gamma,p_1,p_2,p_3,-p-\beta-\gamma\}.
\tag{1}
\]

The monomial-normalized saturated graph is

\[
\begin{aligned}
G=Xbc\bigg(&\delta^mL-\sum_i\delta^{m-p_i}x_i
-\delta^{m+p+\beta+\gamma}\frac Q{Xbc}
-\delta^{m-2}\\
&+\delta^{m-2-\beta}b+\delta^{m-2-\gamma}c
-\delta^{m-2-\beta-\gamma}bc\bigg)=0.
\end{aligned}
\tag{2}
\]

It equals `delta^m Xbc(L-F_delta)` on the dense torus.  Since a coefficient
has zero order by (1), its principal ideal is already saturated after
localizing at `Xbc`.  The reduced central graph is

\[
H=\sum_{p_i=m}x_i+
\mathbf1_{-p-\beta-\gamma=m}\frac Q{Xbc}+
\mathbf1_{2+\beta+\gamma=m}bc=0.
\tag{3}
\]

Thus $L$ drops out before the tangent-Fitting calculation.

## Tangent-Fitting alternative

Single-term supports are empty.  If exactly one of

\[
P=Q/(Xbc),\qquad R=bc
\]

occurs, its logarithmic `b` derivative is a unit.  If neither occurs, an
occurring `x_i` gives a unit logarithmic derivative.  In the only mixed case,
write $H=T+P+R$ with $T=\sum_{i\in I}x_i$.  The equation
$D_bH=-P+R=0$ gives $R=P$.  A missing index has derivative $-P$, impossible
on the torus.  If all three indices occur, $D_{x_i}H=x_i-P=0$ gives
$x_i=P$, while $H=0$ gives $3P+P+P=5P=0$, again impossible in
characteristic zero.  Hence every nonempty central graph is smooth and
already reduced and normal.  The total graph is smooth along that stratum,
$L$ is a free coordinate, and its relative tangent-Fitting ideal is `(1)`.
Every nonempty cone is **free**; none is residual.

For compact `y`, (3) has only the $R$ term and is empty.  This recovers the
earlier ``unique dominant $q$-term'' observation.  With escaping `y`, other
support masks occur, but the calculation proves they remain free rather than
silently extending that compact-`y` argument.

## Finite replay and compression

The five possible leading terms are

\[
x_1,x_2,x_3,Q/(Xbc),bc.
\]

The Singular certificate enumerates all 31 nonempty masks, first saturates
the graph by `Xbc`, then computes its tangent-logarithmic ideal.  It reports
5 empty masks, 26 free masks, and 0 holds.  This is the same five-support,
31-mask compression as the five preceding exterior stars, but it is a new
reciprocal chart: the positive product term is `bc`, not a unit or a
translated factor.

From repository root:

```sh
nix shell nixpkgs#singular -c Singular -q \
  notes/2026-08-12-c907-binf-cinf-star-fan.sing \
  | cmp -s - notes/2026-08-12-c907-binf-cinf-star-fan.out
```

The direct derivative proof above independently verifies the reduction and
tangent-Fitting conclusion; it is not an initial degeneration of the open
critical ideal.

## Coverage and remaining stars

This closes the sixth exterior boundary-star type: `B=C=infinity` with
arbitrary toric `y` weights.  Unlike the one-pole finite and infinity stars,
it has no distinct `B,C` swap.  The remaining coordinate types are the
translated `(0,1)` and `(1,0)` seams with noncompact `y`, generic/intersecting
`B=1` and `C=1` stars, their infinity seams, and their global common-fan and
collar compatibilities.  No total cone count is asserted.

## EJ/TT and mystery ledger

- **EJ:** the compact-y ``empty'' argument extends to all escaping-y weights
  after one fixed finite support calculation.
- **TT:** the $P+R+\sum x_i$ pattern is the only possible escape from
  product dominance, and it is killed by the coefficient-$5$ tangent
  contradiction.
- **Settled:** the two-infinity star is empty/free and compresses with the
  five earlier stars at the same 31-mask size.
- **Open:** translated and one-seams plus global fan/collars remain; no
  genuine mystery remains inside the two-infinity star.
