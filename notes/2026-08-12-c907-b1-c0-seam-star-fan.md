# C907 translated $(B,C)=(1,0)$ seam certificate

**Lane:** `clebsch`

**Status:** exact toric seam calculation for arbitrary $y$ weights, with its
marked compact-$y$ residual attachment; no global fan or collar claim.

## Toric seam graph and saturation

Put $u=1-B$.  After a finite ramified base change clearing rational weights,
write

\[
y_i=\delta^{-p_i}x_i,\qquad
u=\delta^\beta b,\qquad C=\delta^\gamma c,
\qquad \beta,\gamma>0,
\tag{1}
\]

where $x_i,b,c$ are torus units.  Thus $B=1-\delta^\beta b$ is a chart
unit near the central divisor.  With $p=\sum_i p_i$, set

\[
m=\max\{p_1,p_2,p_3,\gamma-p,2-\beta\}.
\tag{2}
\]

The monomial-normalized graph is

\[
\begin{aligned}
G=Xc(1-\delta^\beta b)\bigg(&\delta^mL-
 \sum_i\delta^{m-p_i}x_i
 -\delta^{m+p-\gamma}\frac{Q}{Xc(1-\delta^\beta b)}\\
 &-\delta^{m+\beta-2}b(1-\delta^\gamma c)\bigg)=0.
\end{aligned}
\tag{3}
\]

It equals $\delta^mXcB(L-F_\delta)$ on the original dense torus, under

\[
(\delta,x,b,c,L)\longmapsto
(\delta,\delta^{-p_i}x_i,1-\delta^\beta b,\delta^\gamma c,L).
\tag{4}
\]

In the local ring in which $XbcB(1-\delta^\gamma c)$ is inverted, the
pullback of the original condition $\delta YBC\ne0$ is simply
$\delta\ne0$.  All exponents in (3) are nonnegative, and one is zero by
(2); hence $\delta\nmid G$ and the exact saturated graph ideal is

\[
(G):\delta^\infty=(G).
\tag{5}
\]

This is the strict toric $(1,0)$ orbit, not the $C=1$ residual face.

## All arbitrary-$y$ support faces

The $p_i$ and $\gamma-p$ entries in (2) imply $m>0$: if every $p_i\le0$,
then $p\le0$ and $\gamma-p>0$; otherwise some $p_i>0$.  Thus $L$ always drops
from the reduced central graph, which is

\[
H=\sum_{p_i=m}x_i+
 \mathbf1_{\gamma-p=m}P+
 \mathbf1_{2-\beta=m}R=0,
\qquad
P=\frac Q{Xc},\quad R=b.
\tag{6}
\]

Each displayed monomial is a unit on the seam torus.  Consequently a
one-term support is **empty**.  Every support with at least two terms is
smooth and **free**: if $R$ occurs, $D_bH=R$ is a unit; if $R$ is absent but
$P$ occurs, $D_cH=-P$ is a unit; and otherwise an occurring $x_i$ has
$D_{x_i}H=x_i$ a unit.  This proves reducedness and normality before the
relative tangent-Fitting calculation.  The total graph is smooth along every
nonempty central face, $L$ is free there, and the reduced-stratum relative
tangent-Fitting ideal is `(1)`.

Thus the arbitrary-weight toric seam has the exact finite classification

| leading support | outcome |
| --- | --- |
| one of $x_1,x_2,x_3,P,R$ | empty |
| every other nonempty subset of those five terms | free |
| any support in the strict toric $(1,0)$ orbit | never residual |

This is again the known five-support **simplex** pattern, not a new circuit.
The residual Rees center has $C=1$, while (1) has $C=0$ on the central orbit;
the two are disjoint and must not be identified by saturation.

## Marked compact-$y$ attachment and the retained residual endpoint

The seam's compact-$y$ closure is the swapped `0/1` incidence model, not an
extra toric support.  Put

\[
ef=\delta^2,\qquad C=e,\qquad B=1-ft,
\tag{7}
\]

with $A=Q/Y$ a unit.  The normal semistable incidence ring has the exact
saturated main transform

\[
G_{10}=e(1-ft)(L-S)-A-t(1-e)(1-ft)=0,
\qquad
(ef-\delta^2,G_{10}):(\delta e(1-ft))^\infty
=(ef-\delta^2,G_{10}).
\tag{8}
\]

Its central strata have the following exact outcomes.

| stratum | reduced graph / value map | outcome |
| --- | --- | --- |
| $e=f=0$ | $-A-t=0$, with $L$ free | free |
| $e=0$, $f\ne0$ | $-A-t(1-ft)=0$; $\partial_fG_{10}=t^2$ is a unit | free |
| $f=0$, $e\ne0$ away from the ideal below | $L=S-t+(A+t)/e$ | free |
| $f=0$, $e=1$, $t=-A$, $y_i=A=a$, $a^4=Q$ | $L=4a$ | residual |

On the third stratum, the exact relative tangent-Fitting ideal is, after
localizing $e$,

\[
(e-1,t+A,y_1-A,y_2-A,y_3-A,L-S-A,A^4-Q),
\tag{9}
\]

so the last row is precisely the four reduced Morse points already retained
in the compact residual core.  The Hessian is the residual Hessian: the
$(e-1,t+A)$ block is nondegenerate, and the $y$ block is that of $S+A$.

For the exact marked transition, put

\[
k=1-e+\delta^2A,\qquad
\rho=\frac\delta k,\qquad v=k\left(A+\frac te\right).
\tag{10}
\]

On $ek\ne0$ this is the $U^{-1}$ imbalanced residual chart, with

\[
C=1-k+\rho^2k^2A=e,qquad
B=1-\rho^2kv+\rho^2k^2A
=1-\frac{\delta^2t}{e}=1-ft.
\tag{11}
\]

Thus (9) is not discarded as an exterior tangent point.  At $\rho=0$ and
$k\ne0$, $v$ is a free coordinate; $k=0$ is exactly the retained residual
endpoint.  This attachment is the compact-$y$ result already needed at the
seam boundary, and does not claim to settle new noncompact strata at
$B=C=1$.

## Finite replay

For the strict toric seam, the five leading terms in (6) give all 31
nonempty masks.  The replay saturates by $Xbc$, then computes the
reduced-stratum logarithmic tangent ideal.  It reports 5 empty, 26 free, and
0 hold masks.  In the same replay, the semistable $(1,0)$ incidence graph is
checked unchanged by its exact torus saturation, and its $f=0$ tangent ideal
is checked equal to (9).

From repository root:

```sh
nix shell nixpkgs#singular -c Singular -q \
  notes/2026-08-12-c907-b1-c0-seam-star-fan.sing | \
  cmp -s - notes/2026-08-12-c907-b1-c0-seam-star-fan.out
```

The direct calculations above establish saturation/reduction before the
Fitting conclusion and independently check the finite replay's simplex
classification; this is not an initial degeneration of the open critical
ideal.  The replay uses Singular 4.4.1.  The script and canonical output are
3,432 and 958 bytes; their SHA-256 values are recorded in the adjacent
`2026-08-12-c907-b1-c0-seam-star-fan.sha256` manifest.

## Symmetry and scope

Swapping $B,C$ gives the $(0,1)$ seam and exchanges the $U^{-1}$ and
$Z^{-1}$ imbalanced residual charts.  This certificate exhausts arbitrary
toric $y$ valuations on the strict $(1,0)$ orbit and keeps its unique
compact-$y$ residual attachment marked.  It does not construct the common
projective Rees chart across the raw finite-$t$ endpoint, classify new
noncompact strata of $B=C=1$, or prove global fan/collar compatibility.

## EJ/TT and mystery ledger

- **EJ:** the entire noncompact toric seam again collapses to a five-support
  simplex calculation; no ray enumeration is required.
- **TT:** the strict $C=0$ orbit is exterior, but its incidence closure has a
  genuine $C=1$ residual endpoint.  Keeping those charts distinct is
  essential.
- **Settled:** $(1,0)$ and, by symmetry, $(0,1)$ are empty/free on their
  toric orbits, with exactly the known four compact residual endpoint points.
- **Open:** a proper common Rees chart for the raw finite-$t$ endpoint,
  noncompact $B=C=1$ strata, infinity seams, common fan, and collars.
