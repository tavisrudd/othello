# C907 $B=0$, $C\notin\{0,1\}$ mixed-star certificate

**Lane:** `clebsch`

**Status:** exact one-pole exterior-star calculation; no global fan claim.

## Chart and saturated graph

Work on the translated torus chart `C=c` with `c(1-c)` inverted.  Put, after
a ramified base change clearing rational weights,

\[
y_i=\delta^{-p_i}x_i,\qquad B=\delta^\beta b,\qquad
\beta>0,
\]

where `x_i,b,c,1-c` are units, and set `p=sum_i p_i` and

\[
m=\max\{2,p_1,p_2,p_3,\beta-p\}.
\tag{1}
\]

The monomial-normalized transform of the saturated graph is

\[
\begin{aligned}
G=Xbc\bigg(&\delta^mL-\sum_i\delta^{m-p_i}x_i
-\delta^{m-(\beta-p)}\frac Q{Xbc}\\
&-\delta^{m-2}(1-\delta^\beta b)(1-c)\bigg)=0,
\end{aligned}
\tag{2}
\]

with `X=x_1x_2x_3`.  On the dense torus, this is
`delta^m Xbc(L-F_delta)=0`.  It is a toric monomial multiple of the
pulled-back cleared graph.  One coefficient has order zero by (1), so after
localizing at `Xbc(1-c)` its principal ideal is already saturated by
`delta` and all chart units.

The reduced central induced graph is

\[
H=\sum_{p_i=m}x_i+
\mathbf1_{\beta-p=m}\frac Q{Xbc}+
\mathbf1_{m=2}(1-c)=0.
\tag{3}
\]

It is independent of `L`; this is the graph after saturation and reduction,
not the initial ideal of the open critical locus.

## Tangent-Fitting alternative

If (3) is a single monomial, it is a unit on this chart, so the induced graph
is **empty**.  Otherwise it has at least two monomials.  When its polar
monomial occurs, $D_bH=-Q/(Xbc)$ is a unit; otherwise an occurring `x_i`
has $D_{x_i}H=x_i$ a unit.  Consequently $H=0$ is smooth, hence already
reduced and normal, and the full graph is smooth along the central stratum.
The coordinate $L$ is free, so $dL$ is a cotangent direct summand; after its
quotient the reduced-stratum relative tangent-Fitting ideal is `(1)`.
Every nonempty cone in this star is therefore **free**.

There is no residual outcome here: the residual Rees center has `B=C=1`.
The omitted seam `c=1` is not a failure of the lemma; it is exactly the
translated finite-pole/residual interface and must be treated by the
`0/1` incidence-to-imbalanced transition.  The omitted `c=0` face is the
two-pole star already certified separately.

## Finite support replay

The five possible leading terms are

\[
x_1,x_2,x_3,Q/(Xbc),1-c.
\]

The Singular generator enumerates the 31 nonempty support masks, clears the
polar denominator, saturates the graph by `Xbc(1-c)`, and only then tests the
relative tangent ideal with source directions
`D_{x_1},D_{x_2},D_{x_3},D_b,partial_c`.  It reports 5 empty masks, 26 free
masks, and no holds.  Setting `Q=1` preserves every saturation outcome
because `Q` is a nonzero coefficient unit.

From repository root:

```sh
nix shell nixpkgs#singular -c Singular -q \
  notes/2026-08-12-c907-b0-cunit-star-fan.sing \
  > notes/2026-08-12-c907-b0-cunit-star-fan.out
```

The direct unit-derivative argument above is an independent check.  It proves
the normalization/reduction shortcut used by the replay rather than taking an
initial degeneration of the open-torus critical ideal.

To check the tracked output without changing it:

```sh
nix shell nixpkgs#singular -c Singular -q \
  notes/2026-08-12-c907-b0-cunit-star-fan.sing | \
  cmp -s - notes/2026-08-12-c907-b0-cunit-star-fan.out
```

The script and canonical output are 1,968 and 931 bytes; their SHA-256 values
are recorded in `2026-08-12-c907-b0-cunit-star-fan.sha256`.

## Coverage and remaining stars

This is the full one-pole star `B=0`, `C` a unit away from `0,1`, for
arbitrary `y` weights—including every `p_i` outside the initial `[0,2]`
window.  Interchanging `B,C` gives a second, isomorphic star without another
calculation.  Together with the two-pole `B=C=0` theorem, this closes three
maximal exterior star types of the (B,C) boundary stratification.

The next distinct types are the two translated seams `(B,C)=(0,1)` and
`(1,0)` with noncompact `y`, the `B`- or `C`-infinity stars, the
`B=1` or `C=1` one-pole stars away from the residual corner, and their
intersections.  The compact-`y` portions of the first two are already covered
by the finite-pole incidence theorem, but they are not covered here.  A common
fan may identify some of these types; no count of final cones is asserted.

## Boundary

This calculation supplies neither a global projective toric/Rees model nor
overlap or collar data.  It makes no statement on the exceptional central
chart `C=1`, so it cannot blow up through the retained residual Morse core.

## EJ/TT and mystery ledger

- **EJ:** arbitrary `y` valuations again collapse to a five-term support
  system, so one generic one-pole star costs the same finite 31-mask replay as
  the two-pole star.
- **TT:** keeping `1-c` as a unit is essential.  Adjoining the `c=1` face to
  this torus chart would erase the translated residual seam that must remain
  attached to the compact core.
- **Settled:** the `B=0`, `C`-generic star and, by symmetry, its `C=0`,
  `B`-generic counterpart are empty/free for every toric `y` weight.
- **Open:** noncompact translated seams, infinity stars, one-stars at `B=1`
  or `C=1`, and global fan/collar compatibility.  No genuine mystery remains
  inside the generic one-pole star.
