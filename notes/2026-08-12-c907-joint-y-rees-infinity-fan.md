# C907 joint $y$/Rees-infinity fan at $B=C=1$

**Lane:** `clebsch`

**Status:** exact support theorem for every toric $y$ and translated valuation
over the double-one corner, with a corrected residue-face audit.  The
product-vanishing restriction is four torus families, not four points, and
must not be made a global stratum.  The bounded residual chart contains the
four genuine Morse points.  Common-refinement strata and collars remain open.

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

Its exact restricted tangent scheme is

\[
x_1=x_2=x_3=a,qquad a^4=Q,qquad L=4a,
\tag{9}
\]

with $b,c\in\mathbf G_m$ free.  It is four copies of $(\mathbf G_m)^2$, not
four isolated points.  The earlier replay already computed this ideal, but
its output label suppressed the two free variables; the corrected replay
checks dimension two explicitly.

These families are artifacts if both translated residue directions are
declared boundary strata.  With

\[
Z=\frac{1+\delta^2A-B}{\delta},\qquad
U=\frac{1+\delta^2A-C}{\delta},\qquad A=Q/Y,
\tag{10}
\]

the compact case uses the bounded $Z,U$ chart.  If, say, $Z\to\infty$, use
$r=Z^{-1}$, $v=ZU$, and $\delta=rh$.  The exact imbalanced potential has
$\partial_vF=1$ on both central components, so the whole chart is free when
$v$ remains interior.  Setting $v=0$ manufactures restricted critical loci
and is not a valid stratum choice.  The $Z,U$ swap gives the same conclusion.

The true four residual points occur only in the bounded $(Z,U)$ chart, where
the central potential is $f_Q+ZU$ and the tangent equations set $Z=U=0$.
A global refinement must join that core to the imbalanced free charts without
marking $v=0$.

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
$\{x_1,x_2,x_3,Q/X,zu\}$.  At $M=0$, compact $y$ is forced;
$\lambda+\mu=0$ is the free product-unit restriction and
$\lambda+\mu<0$ is the same artificial product-zero restriction (9).  This
independently checks support, not genuine-stratum criticality.

## Exact replay

The Singular replay enumerates all 31 nonempty supports in (5), after
clearing denominators and saturating by $x_1x_2x_3bc$.  It reports five empty,
26 free, and zero hold masks.  It then checks the two forced order-zero
restrictions: the product-vanishing ideal is exactly four copies of
$(\mathbf G_m)^2$, and the product-unit restriction is free.  The replay sets
$Q=1$, which preserves every outcome because
$Q$ is a nonzero coefficient unit.

From repository root:

```sh
nix shell nixpkgs#singular -c Singular -q \
  notes/2026-08-12-c907-joint-y-rees-infinity-fan.sing | \
  cmp -s - notes/2026-08-12-c907-joint-y-rees-infinity-fan.out
```

The translated-weight proof and the independent strict-Rees weight check are
separate derivations of the same finite support theorem.  The replay uses
Singular 4.4.1.  The script and canonical output are 2,691 and 119 bytes;
their SHA-256 values are recorded in the adjacent
`2026-08-12-c907-joint-y-rees-infinity-fan.sha256` manifest.

## Consequence and boundary

Together with the exterior stars, this closes the support classification but
not a tangent-stratum atlas.  A global refinement must distinguish genuine
boundary divisors from residue coordinates: in particular it must keep $v$
interior in each imbalanced chart and retain the isolated residual scheme only
in the bounded core.  Then one must verify chart ideals, genuine-stratum
Fitting schemes, and completeness.  Proper fibrewise collars remain separate.

This report does not yet claim that the individually certified charts form
one proper modification, nor that their collars have trivial relative
homology.

## EJ/TT and mystery ledger

- **EJ:** the entire Rees-infinity problem at $B=C=1$ is already visible in
  the two translated orders $\beta,\gamma$; no unbounded Rees ray census is
  needed.
- **TT:** order-zero support rigidity does not imply an isolated critical
  scheme.  When $bc$ drops, both residue variables remain free; the old
  replay contained this fact but its label hid it.
- **Settled:** all support restrictions at the double-one corner; exact
  four-torus-family correction; full imbalanced-chart freeness; bounded-core
  location of the four true Morse points.
- **Open:** genuine-stratum refinement/overlap completeness, proper collars,
  and the hyperplane-equivariant Gamma/Orlov seed.
