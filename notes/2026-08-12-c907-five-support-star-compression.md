# C907 five-support star compression

**Lane:** `clebsch`

**Status:** theorem-grade algebraic compression of ten certified boundary
star types; it is not a global fan or collar theorem.

## Two Laurent lemmas

Let `K` be a characteristic-zero field, or a passive-parameter ring obtained
by inverting the displayed chart parameters, and put `X=x_1x_2x_3`.  The
dependency conditions on the active pivots are stated in each lemma; passive
unit factors are allowed.  These are the exact star normal forms, not
arbitrary Laurent-unit perturbations of them.

### Distinct-pivot simplex lemma

Every hypersurface whose nonzero support is a subset of

\[
 \{x_1,x_2,x_3,P=Q/(Xu),R=\kappa v,K_0\},
 \qquad K_0\in K^*,
\tag{1}
\]

is either empty or logarithmically smooth, where `u,v` are distinct active
pivots, `Q` is independent of both `u,v`, and `kappa` is independent of `v`;
either `R` or `K_0` may be
absent.  Dependence of `kappa` on the other pivot `u` is allowed and is a
unit after localization.  Indeed, a singleton is a unit and hence empty.
If `R` occurs, `D_vH=R` is a unit.  If `R` is absent but `P` occurs,
`D_uH=-P` is a unit.  Otherwise an occurring `x_i` has
`D_{x_i}H=x_i`, a unit.  Additional passive denominator units are harmless.

### Reciprocal--linear circuit lemma

Every hypersurface whose nonzero support is a subset of

\[
 \{x_1,x_2,x_3,P=Q/(Xb),R=\kappa b\}
\tag{2}
\]

is either empty or logarithmically smooth for either sign of `R`.  Write the
mixed support as `H=T+P+epsilon R`, with `epsilon=+/-1`.  Only a support
containing both `P,R` is not immediate.  There
`D_bH=-P+epsilon R=0` gives `epsilon R=P`.  If some `x_j` is absent, then
`D_{x_j}H=-P`, impossible.  If all three occur, the equations
`D_{x_i}H=x_i-P=0` give `x_i=P`, while `H=0` becomes

\[
 3P+P+\epsilon R=5P=0,
\]

again impossible on the torus.  This proof works for `n` variables with
`5` replaced by `n+2`, away from that characteristic.

In both lemmas, smoothness makes the central graph reduced and normal and,
for the ten charts below, the displayed derivative also makes the total
graph smooth along that stratum.  Thus no further total normalization
changes the special fibre.  Since `L` is then a free coordinate, `dL` is a
cotangent direct summand and the reduced-stratum relative tangent-Fitting
ideal is `(1)`.

## What the lemmas compress

After monomial normalization and saturation, arbitrary toric valuations of
the three `y` variables affect only which of five terms survive.  The
certified stars reduce as follows.

| boundary star | central support | lemma |
|---|---|---|
| `B=C=0` | `x_i`, `Q/(Xbc)`, `1` | distinct-pivot simplex, `R` absent |
| `B=0`, `C` generic | `x_i`, `Q/(Xbc)`, `1-c` | distinct-pivot simplex, `R` absent |
| `C=0`, `B` generic | symmetric | distinct-pivot simplex, `R` absent |
| `B=infinity`, `C` generic | `x_i`, `Q/(Xbc)`, `b(1-c)` | reciprocal--linear |
| `C=infinity`, `B` generic | symmetric | reciprocal--linear |
| `B=C=infinity` | `x_i`, `Q/(Xbc)`, `bc` | reciprocal--linear, same-sign variant |
| `B=1`, `C` generic | `x_i`, `Q/(Xc)`, `b(1-c)` | distinct pivots `u=c,v=b`; separate order-zero face |
| `C=1`, `B` generic | symmetric | distinct pivots; separate order-zero face |
| `(B,C)=(1,0)` | `x_i`, `Q/(Xc)`, `b` | distinct pivots `u=c,v=b`; marked compact residual attachment |
| `(B,C)=(0,1)` | symmetric | distinct pivots; marked compact residual attachment |

Thus the six separate 31-mask replays are regressions for two human
Laurent lemmas, not 186 independent cases.  They remain useful because each
also verifies the chart saturation and tangent ideal in the exact
coordinates used by the graph model.

In the generic `B=1`/`C=1` stars the normalization index can be zero.  Then
`L` survives and the support lemma is inapplicable; the exact remaining
equations have `D_cE=P` or `D_bE=-R` a unit.  Their own Fitting ideals are
therefore free.  This exceptional face is part of the certificate, not a
consequence of positive pole order.

## Positive pole order: exact use and exact limit

Suppose a saturated graph before normalization has local form

\[
 \delta^mL-G(\delta,x)=0,\qquad m>0,\quad G(0,x)\ne0.
\tag{3}
\]

Its pre-normalization central graph is `G(0,x)=0`, independent of `L`.
This is only a valuation prefilter.  Total normalization need not commute
with passage to the special fibre and can re-entangle `L`.  The elementary
model

\[
 \delta^2L=x^2
\tag{4}
\]

normalizes by `x=delta y`, `L=y^2`; on its normalized special fibre the map
`L=y^2` is critical at `y=0`.  Thus positive pole order alone proves neither
the free alternative nor even preservation of the apparent product.

For the ten stars above, the simplex and reciprocal--linear calculations do
the missing work: they prove smoothness/normality along the central stratum,
so the normalization pathology (4) cannot occur.  In the infinity star, in
particular, the mixed `T+P-R` support survives (3), and only the circuit
calculation rules out its tangent critical point.  Nor does (3) produce a
uniform small-`delta` collar or prove compatibility on chart intersections.

## Further implications

1. The exterior fan should be organized by a short library of exponent
   configurations and their logarithmic discriminants, not by valuation
   ranges.  Arbitrarily large positive or negative `y` weights merely select
   faces of the same configurations.
2. A new exterior star can be rejected cheaply whenever its central support
   is a face of (1) or (2).  Only genuinely new circuits need a Fitting or
   discriminant computation.
3. The strict toric orbits in these ten stars are empty/free.  The compact
   incidence closure of the translated `1/0` and `0/1` seams nevertheless
   attaches to exactly the four marked residual Morse points at `B=C=1`.
   Keeping the toric seam and its residual endpoint distinct is essential.
   The bounded `1/1` Rees chart is closed separately: noncompact `y` weights
   are empty/free and the compact face is exactly the four residual Morse
   points.  Computational effort should now concentrate on joint
   `y`/Rees-infinity and translated/infinity seams.
4. Algebraic empty/free certification and topological excision remain
   different gates.  Even a finite library of smooth initial hypersurfaces
   does not supply one proper product-pair cover or the required controlled
   `delta`-transport.

## Regressions

- `2026-08-12-c907-bc00-star-fan.{md,sing,out,sha256}`;
- `2026-08-12-c907-b0-cunit-star-fan.{md,sing,out,sha256}`;
- `2026-08-12-c907-binf-cunit-star-fan.{md,sing,out,sha256}`;
- `2026-08-12-c907-binf-cinf-star-fan.{md,sing,out,sha256}`;
- `2026-08-12-c907-b1-cunit-star-fan.{md,sing,out,sha256}`;
- `2026-08-12-c907-b1-c0-seam-star-fan.{md,sing,out,sha256}`.

## Mystery ledger

- **Settled:** ten boundary-star types are consequences of two
  Laurent support lemmas for every toric `y` valuation.
- **Open:** the joint `y`/Rees-infinity and translated/infinity circuits,
  common normalized fan, overlap Fitting ideals, and proper collar topology.
