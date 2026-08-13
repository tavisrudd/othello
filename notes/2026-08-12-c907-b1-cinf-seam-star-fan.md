# C907 translated/infinity seam certificate

**Lane:** `clebsch`

**Status:** exact tangent-Fitting theorem for arbitrary $y$ weights on the
strict $(B,C)=(1,\infty)$ seam and its symmetric companion, after fixing the
residual value disk away from zero; no common fan or collar claim.

## Chart, value window, and saturation

Put $u=1-B$.  After a finite ramified base change clearing rational weights,
write

\[
y_i=\delta^{-p_i}x_i,\qquad
u=\delta^\beta b,\qquad
C=\delta^{-\gamma}c,
\qquad \beta,\gamma>0,
\tag{1}
\]

where $x_i,b,c$ are torus units and $B=1-\delta^\beta b$ is a chart unit.
Write $p=\sum_i p_i$, $X=x_1x_2x_3$, and

\[
m=\max\{0,p_1,p_2,p_3,-p-\gamma,2+\gamma-\beta\}.
\tag{2}
\]

The exact monomial-normalized graph is

\[
\begin{aligned}
G=XcB\bigg(&\delta^mL-\sum_i\delta^{m-p_i}x_i
-\delta^{m+p+\gamma}\frac Q{XcB}
-\delta^{m+\beta-2}b
+\delta^{m+\beta-\gamma-2}bc\bigg)=0.
\end{aligned}
\tag{3}
\]

On the original dense torus this is
$\delta^mXcB(L-F_\delta)=0$.  In the local ring in which $XbcB$ is inverted,
the pullback of $\delta YBC\ne0$ is exactly $\delta\ne0$.  Every exponent in
(3) is nonnegative, one is zero by (2), and hence $\delta\nmid G$.  Therefore

\[
(G):\delta^\infty=(G).
\tag{4}
\]

The residual critical values are $4a$ with $a^4=Q$, so none is zero.  Fix a
distinguished path tree joining those four values to a regular basepoint in
$\mathbf C^*$ and take a sufficiently small closed regular neighborhood.
This gives a compact topological disk $\Omega$ containing the entire path
system and satisfying

\[
0\notin\Omega.
\tag{5}
\]

It is also disjoint from all six ambient critical values for sufficiently
small $\delta$, since those values escape every bounded set.  This harmless
choice of the previously unspecified bounded-value disk is load-bearing at
the one face isolated below; it does not choose an individual Gamma/Orlov
marking.

## Positive normalization order

The term $\delta^{m+\beta-2}b$ in (3) is always strictly higher order than
the $bc$ term, by $\gamma>0$, and never belongs to a central support.  If
$m>0$, $L$ drops and, up to an overall sign, the reduced central graph is

\[
H=\sum_{p_i=m}x_i+
 \mathbf1_{-p-\gamma=m}P-
 \mathbf1_{2+\gamma-\beta=m}R=0,
\qquad
P=\frac Q{Xc},\quad R=bc.
\tag{6}
\]

Every singleton support is empty because its one monomial is a unit.  Every
other support is smooth and free.  If $R$ occurs, $D_bH=-R$ is a unit; if
$R$ is absent but $P$ occurs, $D_cH=-P$ is a unit; otherwise an occurring
$x_i$ has unit logarithmic derivative.  Thus the central graph and the total
graph are already smooth and normal along the stratum, $L$ is free, and the
reduced-stratum relative tangent-Fitting ideal is $(1)$.  This is the
distinct-pivot simplex lemma with active pivots $c,b$, not a new circuit.

## Order zero and the unique apparent hold

For $m=0$, the central graph is

\[
E=L-\sum_{p_i=0}x_i
-\mathbf1_{p=-\gamma}P
+\mathbf1_{\beta=2+\gamma}R=0.
\tag{7}
\]

Whenever at least one source term in (7) occurs, the same unit-derivative
argument proves that the value map is free.  There is exactly one additional
support type: all source terms have positive order, equivalently

\[
p_i<0\ (i=1,2,3),\qquad p>-\gamma,\qquad
\beta>2+\gamma.
\tag{8}
\]

This cone is nonempty; for example
$(p_1,p_2,p_3,\gamma,\beta)=(-1,-1,-1,4,7)$ lies in it.  Its reduced graph
and exact fibrewise critical scheme are both

\[
L=0.
\tag{9}
\]

Thus it would be a genuine constant-value boundary hold in a window
containing zero.  With the admissible choice (5), however, its graph has empty
intersection with $\Omega$ and is an **out-of-window face**.  This is the only
place in the translated/infinity seam where the value-window condition,
rather than a unit tangent derivative, is needed.

Consequently every face of the strict $(1,\infty)$ seam is empty or free over
$\Omega$.  Interchanging $B,C$ proves the $(\infty,1)$ seam.

## Exact replay

The five Laurent terms in (6) give 31 nonempty supports.  The replay clears
denominators, saturates by $x_1x_2x_3bc$, and checks the logarithmic tangent
ideal.  It finds five empty and 26 free positive-order supports.  With $L$
retained, all 31 nonempty supports are free.  The remaining empty source
support is checked separately to have critical ideal exactly $(L)$, as in
(9).  Setting $Q=1$ is harmless because it is a nonzero coefficient unit.

From repository root:

```sh
nix shell nixpkgs#singular -c Singular -q \
  notes/2026-08-12-c907-b1-cinf-seam-star-fan.sing | \
  cmp -s - notes/2026-08-12-c907-b1-cinf-seam-star-fan.out
```

The direct unit-derivative proof and the weight-cone derivation of (9) are an
independent check of the finite replay.  The replay uses Singular 4.4.1.  The
script and canonical output are 2,864 and 105 bytes; their SHA-256 values are
recorded in the adjacent
`2026-08-12-c907-b1-cinf-seam-star-fan.sha256` manifest.

## Scope and next seam

This closes arbitrary toric $y$ valuations on the two strict
translated/infinity orbits.  It does not build their overlap maps with the
generic translated-one and generic infinity stars, classify the imbalanced
$B=C=1$ Rees-infinity charts, assemble the common normalized fan, or prove
product-pair collars.  The next algebraic target is the joint $y$ valuation
fan in

\[
r=U^{-1},\qquad v=ZU,\qquad \delta=rh,
\]

and its $B,C$ swap.  Any zero-valued constant face found there can now be
discarded over the same fixed $\Omega$; a nonzero constant or a genuine
critical Laurent circuit cannot.

## EJ/TT and mystery ledger

- **EJ:** choosing the residual path disk in $\mathbf C^*$ converts the only
  new constant boundary component into an out-of-window face.
- **TT:** inserting the zero entry in (2) is essential.  Without it, the
  $L=0$ face is silently lost and the seam is falsely declared simplex-free.
- **Settled:** the $(1,\infty)$ and $(\infty,1)$ seams are empty/free over the
  fixed residual window for every toric $y$ valuation.
- **Open:** imbalanced Rees infinity, common overlap ideals, the global fan,
  and proper collars.
