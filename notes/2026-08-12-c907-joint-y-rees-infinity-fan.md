# C907 joint $y$/Rees-infinity fan at $B=C=1$

**Lane:** `clebsch`

**Status:** exact normalized tangent-Fitting theorem for every toric $y$ and
Rees valuation over the full double-translated $B=C=1$ corner; the only
nonfree faces are exactly the four marked residual Morse points.  Common-fan
overlaps and collars remain open.

## One chart covering the full corner

Every ramified analytic arc with $B,C\to1$ has, after clearing rational
weights, a unique presentation

\[
y_i=\delta^{-p_i}x_i,\qquad
B=1-\delta^\beta b,\qquad
C=1-\delta^\gamma c,
\qquad \beta,\gamma>0,
\tag{1}
\]

with $x_i,b,c$ torus units.  Put $p=\sum_i p_i$, $X=x_1x_2x_3$, and

\[
m=\max\{0,p_1,p_2,p_3,-p,2-\beta-\gamma\}.
\tag{2}
\]

The zero in (2) is redundant but records the bounded value coordinate: the
entries $p_i,-p$ already have nonnegative maximum.  The exact transformed
graph is

\[
G=XBC\left(
 \delta^mL-\sum_i\delta^{m-p_i}x_i
 -\delta^{m+p}\frac Q{XBC}
 -\delta^{m+\beta+\gamma-2}bc
 \right)=0.
\tag{3}
\]

On the dense torus, (3) is $\delta^mXBC(L-F_\delta)$.  In the local ring
where $XbcBC$ is inverted, the pullback of $\delta YBC\ne0$ is exactly
$\delta\ne0$.  Every exponent in (3) is nonnegative and one is zero by (2),
so $\delta\nmid G$ and

\[
(G):\delta^\infty=(G).
\tag{4}
\]

Thus (3), rather than an initial ideal of the open critical equations, is the
exact saturated graph closure on every cone of this corner.

## Positive normalization order

If $m>0$, the reduced central graph loses $L$ and, up to overall sign, has
support in

\[
H=\sum_{p_i=m}x_i+
 \mathbf1_{-p=m}P+
 \mathbf1_{2-\beta-\gamma=m}R=0,
\qquad
P=\frac QX,\quad R=bc.
\tag{5}
\]

All singleton supports are empty.  Every other support is logarithmically
smooth:

- if $R$ occurs, $D_bH=R$ is a unit;
- if $R$ is absent, $P$ occurs, and some $x_j$ is absent, then
  $D_{x_j}H=-P$ is a unit;
- if neither $R$ nor $P$ occurs, an occurring $x_i$ has unit derivative; and
- for the sole remaining support $x_1+x_2+x_3+P$, the tangent equations give
  $x_i=P$, while the graph equation gives $4P=0$, impossible in
  characteristic zero.

Hence the induced graph and the total graph are already smooth and normal
along every nonempty face.  The coordinate $L$ is free, and the exact
relative tangent-Fitting ideal is $(1)$.  No noncompact $y$ valuation at the
double-one corner creates an unmarked critical point.

## Order zero forces the residual model

If $m=0$, then $p_i\le0$ for all $i$ and $p\ge0$.  Since
$p=\sum_i p_i$, this forces

\[
p_1=p_2=p_3=p=0,\qquad \beta+\gamma\ge2.
\tag{6}
\]

Thus order zero itself forces compact $y$; there is no separate noncompact
order-zero circuit.

If $\beta+\gamma=2$, the central graph is

\[
L=f_Q(x)+bc,
\qquad
f_Q=x_1+x_2+x_3+\frac Q{x_1x_2x_3}.
\tag{7}
\]

The logarithmic $b$ derivative is the unit $bc$, so this face is free.  If
$\beta+\gamma>2$, the translated product drops and the central graph is

\[
L=f_Q(x).
\tag{8}
\]

Its exact critical scheme is

\[
x_1=x_2=x_3=a,qquad a^4=Q,qquad L=4a,
\tag{9}
\]

the four reduced $\mathbf P^3$ Morse points and nothing else.

These are precisely residual, including the Rees-infinity directions.  With

\[
Z=\frac{1+\delta^2A-B}{\delta},\qquad
U=\frac{1+\delta^2A-C}{\delta},\qquad A=Q/Y,
\tag{10}
\]

the compact case uses the bounded $Z,U$ chart.  If, say, $Z\to\infty$, use
$r=Z^{-1}$, $v=ZU$, and $\delta=rh$; its exact central potential is
$f_Q+v$.  Equation (7) is the $v\ne0$ free stratum, while (8)--(9) is the
$v=0$ marked residual attachment.  The $Z,U$ swap covers the other
imbalanced direction.  Thus no Rees-infinity point is discarded or mislabeled
as exterior.

## Strict residual-wedge cross-check

There is a useful independent weight check on (10).  Write

\[
Z=\delta^{-\lambda}z,\qquad U=\delta^{-\mu}u,
\]

in the strict wedge $\lambda,\mu<1$, $p>-2$, where $B,C\to1$.  In the exact
finite-Rees graph, the three correction exponents exceed respectively the
$Q/X$ exponent by $1-\lambda$, $1-\mu$, and $p+2$.  They are therefore
strictly subleading.  With

\[
M=\max\{0,p_1,p_2,p_3,\lambda+\mu,-p\},
\]

the central support is again exactly
$\{x_1,x_2,x_3,Q/X,zu\}$.  At $M=0$, compact $y$ is forced; $\lambda+\mu=0$
is the free product-unit face and $\lambda+\mu<0$ is the same product-zero
residual face (9).  This independently recovers the bounded/imbalanced
transition from the Rees coordinates rather than the translated coordinates.

## Exact replay

The Singular replay enumerates all 31 nonempty supports in (5), after
clearing denominators and saturating by $x_1x_2x_3bc$.  It reports five empty,
26 free, and zero hold masks.  It then checks the two forced order-zero faces:
the product-vanishing critical ideal is exactly (9), and the product-unit
face is free.  The replay sets $Q=1$, which preserves every outcome because
$Q$ is a nonzero coefficient unit.

From repository root:

```sh
nix shell nixpkgs#singular -c Singular -q \
  notes/2026-08-12-c907-joint-y-rees-infinity-fan.sing | \
  cmp -s - notes/2026-08-12-c907-joint-y-rees-infinity-fan.out
```

The translated-weight proof and the independent strict-Rees weight check are
separate derivations of the same finite support theorem.  The replay uses
Singular 4.4.1.  The script and canonical output are 2,628 and 113 bytes;
their SHA-256 values are recorded in the adjacent
`2026-08-12-c907-joint-y-rees-infinity-fan.sha256` manifest.

## Consequence and boundary

Together with the ten exterior stars and the translated/infinity certificate,
this removes the last unclassified local tangent circuit of the normalized
$(y,B,C)$ boundary atlas.  What remains algebraically is global rather than a
new local star: choose one finite common fan, prove that these chart ideals
agree on every nonempty overlap, and verify fan completeness.  The proper
product-pair collar theorem remains separate, followed by the directed
thimble and Gamma/Orlov marking.

This report does not yet claim that the individually certified charts form
one proper modification, nor that their collars have trivial relative
homology.

## EJ/TT and mystery ledger

- **EJ:** the entire Rees-infinity problem at $B=C=1$ is already visible in
  the two translated orders $\beta,\gamma$; no unbounded Rees ray census is
  needed.
- **TT:** order zero is much more rigid than it first appears: the relation
  $p=\sum p_i$ forces compact $y$, leaving exactly $f_Q$ or $f_Q+bc$.
- **Settled:** all local joint $y$/Rees-infinity faces at the double-one
  corner, including their exact residual attachment.
- **Open:** common-fan overlap/completeness, proper collars, and the
  hyperplane-equivariant Gamma/Orlov seed.
