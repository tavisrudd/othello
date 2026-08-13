# C907 zero/infinity seam certificate

**Lane:** `clebsch`

**Status:** exact normalized tangent-Fitting theorem for arbitrary $y$ weights
on $(B,C)=(0,\infty)$ and its swap; no common-fan or collar claim.

## Saturated graph

After a finite ramified base change clearing rational weights, put

\[
y_i=\delta^{-p_i}x_i,\qquad
B=\delta^\beta b,\qquad
C=\delta^{-\gamma}c,
\qquad \beta,\gamma>0,
\tag{1}
\]

where $x_i,b,c$ are torus units.  Write $p=\sum_i p_i$, $X=x_1x_2x_3$, and

\[
m=\max\{\gamma+2,p_1,p_2,p_3,-p-\gamma+\beta\}.
\tag{2}
\]

The exact monomial-normalized graph is

\[
\begin{aligned}
G=Xbc\bigg(&\delta^mL-\sum_i\delta^{m-p_i}x_i
-\delta^{m+p+\gamma-\beta}\frac Q{Xbc}
-\delta^{m-2}+\delta^{m+\beta-2}b\\
&+\delta^{m-\gamma-2}c
-\delta^{m+\beta-\gamma-2}bc\bigg)=0.
\end{aligned}
\tag{3}
\]

It equals $\delta^mXbc(L-F_\delta)$ on the dense torus.  After localizing at
$Xbc$, the pulled-back torus condition has only $\delta$ as a nonunit.  Every
exponent in (3) is nonnegative and one is zero by (2), so $\delta\nmid G$ and

\[
(G):\delta^\infty=(G).
\tag{4}
\]

## Central support and tangent theorem

The $c$ term has pole order $\gamma+2$.  The constant, $b$, and $bc$ product
terms have strictly smaller pole order, by respectively $\gamma$, $\beta+\gamma$,
and $\beta$.  They never survive on the central graph.  Also $m>0$, so $L$
drops.  Up to overall sign, every reduced central support is a nonempty subset
of

\[
H=\sum_{p_i=m}x_i+
 \mathbf1_{-p-\gamma+\beta=m}P-
 \mathbf1_{\gamma+2=m}K=0,
\qquad
P=\frac Q{Xbc},\quad K=c.
\tag{5}
\]

A singleton support is empty.  Every other support is smooth and free.  If
$P$ occurs, $D_bH=-P$ is a unit because $K$ is independent of $b$.  If $P$
is absent but $K$ occurs, $D_cH=-K$ is a unit.  Otherwise an occurring $x_i$
has unit logarithmic derivative.  The central and total graphs are therefore
already smooth and normal, $L$ is a free coordinate, and the reduced-stratum
relative tangent-Fitting ideal is $(1)$.  No residual point occurs because
the marked core has $B=C=1$.

Interchanging $B,C$ proves the $(\infty,0)$ seam.  These were the only two
coordinate corners not named explicitly in the prior ten-star summary.

## Exact replay

The Singular replay enumerates all 31 nonempty supports in (5), clears
denominators, saturates by $x_1x_2x_3bc$, and checks the logarithmic tangent
ideal.  It reports five empty, 26 free, and zero hold masks.  It sets $Q=1$,
which is harmless because $Q$ is a nonzero coefficient unit.

From repository root:

```sh
nix shell nixpkgs#singular -c Singular -q \
  notes/2026-08-12-c907-b0-cinf-seam-star-fan.sing | \
  cmp -s - notes/2026-08-12-c907-b0-cinf-seam-star-fan.out
```

The strict pole-order inequalities and unit-derivative proof independently
check the finite replay.  The replay uses Singular 4.4.1.  The script and
canonical output are 1,445 and 45 bytes; their SHA-256 values are recorded in
the adjacent `2026-08-12-c907-b0-cinf-seam-star-fan.sha256` manifest.

## Consequence and mystery ledger

- **Settled:** both zero/infinity seams for every toric $y$ valuation.
- **EJ:** the apparently mixed product corner has only one surviving product
  term; the other three are separated by strict positive weight gaps.
- **TT:** explicit boundary-orbit accounting found this corner even though it
  was absent from the previous remaining-star lists.
- **Open:** only common-fan transitions/completeness and proper collars remain
  at the local-atlas level.
