# C907 nodal Clifford obstruction to a universal square-zero carrier proof

**Lane:** `clebsch`

**Status:** theorem-grade negative for the proposed categorical mechanisms.
Neither cohomological amplitude, Serre/Poincare duality, discriminant support
dimension, nor reduced-discriminant Clifford geometry forces a square-zero
primitive Rees ideal for arbitrary smooth threefolds.  A smooth projective
conic bundle can have a normal-crossing discriminant with a rank-one fibre;
the even-Clifford algebra at that node has radical cube zero but radical
square nonzero.  This is not an actual C907 Stokes counterexample: no
primitive-sixth Rees realization of this Clifford fibre is known.  It proves
that any universal carrier theorem needs one extra analytic/singular-support
input, identified precisely below.

## The local obstruction

Let `R=k[[x,y]]`, with `char(k) != 2`, and take the rank-three quadratic form

\[
 q=\langle1,x,y\rangle . \tag{1}
\]

Its discriminant is the reduced normal-crossing divisor

\[
 D=(xy=0). \tag{2}
\]

Write `e_0,e_1,e_2` for the Clifford generators, and put

\[
 i=e_0e_1,\qquad j=e_0e_2.
\]

The even Clifford order is free over `R` on `1,i,j,ij`, with

\[
 i^2=-x,\qquad j^2=-y,\qquad ij=-ji. \tag{3}
\]

At the crossing `x=y=0` its fibre is the two-generator exterior algebra

\[
 E=k\langle i,j\rangle/(i^2,j^2,ij+ji).
\tag{4}
\]

If `\mathfrak j=(i,j)`, then

\[
 \mathfrak j^2=k\,ij\ne0,\qquad \mathfrak j^3=0. \tag{5}
\]

Thus the reduced discriminant has not made the local radical square-zero.
The square-zero conclusion in the smooth-discriminant calculation of
`2026-08-12-c907-clifford-rees-carrier-calibration.md` relies on a corank-one
fibre over a *smooth* discriminant point.  At a crossing, the fibre has rank
one and the two branch arrows have the nonzero composite `ij`.

The calculation is unchanged after strict henselization or an etale change of
coordinates.  It is therefore a local obstruction to any putative theorem
whose hypotheses allow an SNC discriminant and use only its reduced support.

## It occurs on a smooth projective threefold

The obstruction is not a singular-total-space artefact.  Let `B=P^2`, choose
three smooth plane curves

\[
 D_r=(a_r=0)\in|\mathcal O_B(d)|\quad(r=0,1,2)
\]

which meet pairwise transversely and have no triple point.  In
`B x P^2_{[u:v:w]}` take

\[
 V=\{a_0u^2+a_1v^2+a_2w^2=0\}. \tag{6}
\]

The completely explicit instance `d=1`,
`(a_0,a_1,a_2)=(X,Y,Z)`, already has all these properties; its discriminant
is the coordinate triangle.  The slightly general form makes clear that the
obstruction is stable under ordinary SNC deformations.

The projection `V -> B` is a flat projective conic bundle, with discriminant
`D_0 union D_1 union D_2`.  The total space is smooth.  Indeed, over a smooth
point of (say) `D_1`, the singular point of the rank-two fibre has a nonzero
base derivative `da_1`.  At a crossing of `D_1,D_2`, with `a_0` a unit, the
fibre is the double line `u=0`; on that line the base differential is

\[
 v^2da_1+w^2da_2,
\]

which cannot vanish because `da_1,da_2` are independent and `[v:w]` is
projective.  There are no other candidate singularities.

Near such a crossing, divide by the unit `a_0` and use `x=a_1/a_0`,
`y=a_2/a_0`; the even Clifford algebra is exactly (3).  Hence a smooth
projective terminal Mori conic bundle already realizes the non-square-zero
reduced-discriminant radical.  More explicitly, for `d>=1` the divisor (6)
is ample in `B x P^2`, so Grothendieck--Lefschetz gives
`Pic(V)=Pic(B x P^2)` and `rho(V/B)=1`; moreover
`-K_(V/B)=H_{P^2}-dH_B` has relative class `H_{P^2}` and is relatively ample.

## Why the usual proposed inputs do not remove it

The radical filtration of the regular `E`-module is

\[
 0\subset \mathfrak j^2\subset\mathfrak j\subset E,
 \qquad \dim_k\operatorname{gr}=(1,2,1). \tag{7}
\]

It has a two-step path from the top to the socle.  The two first arrows live
on the two discriminant branches; their nonzero product lives at their
intersection.  In relative coniveau notation this is exactly

\[
 F^1F^1\subset F^2,\qquad F^2\ne0, \tag{8}
\]

not `F^1F^1=0`.  Dimension three leaves room for the point-supported term.
Thus support dimension improves a product by one coniveau level but supplies
no vanishing theorem.

Duality does not repair this.  `E` is Frobenius (with socle functional the
coefficient of `ij`) and the doubled module

\[
 E\oplus E^\vee \tag{9}
\]

has its tautological nondegenerate self-dual pairing and the self-dual
filtration induced by (7).  Tensoring with a two-dimensional formal
monodromy space on which the eigenvalues are `zeta_6,zeta_6^{-1}` gives a
self-dual primitive-sixth formal carrier with the same two-step radical path.
This is a countermodel to arguments using only amplitude, duality, and
coniveau.  It is deliberately **not** asserted to be the quantum Stokes
packet of (6).

Weak factorization cannot discard (5): the model (6) is already smooth, and
its discriminant node is a feature of a terminal Mori conic bundle rather
than a singularity removed by taking a smooth resolution.  Normalizing the
discriminant merely separates the branches; it does not by itself produce a
flat square-zero quotient of the order at their preimages.  Any construction
which additionally discards the point-supported `ij` term needs a
base-change-compatible theorem that its cubic Rees image is zero.

## Exact conditional mechanism that would suffice

The failure isolates a minimal positive theorem rather than merely a warning.
Let `R_alpha(Z)` be a strict cubic-isotypic Stokes/Gamma Rees realization of
a smooth threefold, with an ideal filtration

\[
 I_\alpha\supset I_\alpha^2\subset C^2_\alpha. \tag{10}
\]

Assume it is functorial for discriminant/coniveau specialization and has the
following two properties.

1. **Multiplicative coniveau.** Every pair of positive-discriminant Rees
   arrows has composite in the point-supported piece `C^2_alpha`.
2. **Singular point excision.** `C^2_alpha` is a positive biproduct of
   primitive packets of smooth points (or is zero) and this identification is
   compatible with the Rees arrow and the Gamma lattice.

Then `C^2_alpha=0`, because smooth points have empty primitive-sixth packet.
Equation (10) gives `I_alpha^2=0`; if the shifted Rees arrow is the image of
`I_alpha`, every cubic-isotypic string has length at most one.

This **coniveau-square-zero reduction** is a genuine conditional theorem: its
proof is the two displayed inclusions.  The nodal example proves that item 2
cannot be replaced by bare reduced support, duality, or ordinary Clifford
theory.  It is a required singular-discriminant Stokes/Gamma excision theorem.

For a smooth-discriminant conic bundle, item 2 specializes to the already
useful radical calculation `N^2=0`.  At a node it must specifically show that
the `kij` term in (5) has zero cubic Rees image.  This is exactly the missing
geometric datum, not a Fano-table or MMP issue.

## Consequence for the universal carrier programme

The viable universal theorem is now narrower and sharper:

> **Required carrier input.**  Construct a strict, value-localized
> discriminant-coniveau realization which kills the point-supported composite
> of a rank-one conic fibre in the primitive-sixth sector, compatibly with
> terminal MMP and resolution comparison.

Without it, neither the ramified Clifford model nor the slogan “coniveau two
is too small on a threefold” proves `ell_(1/6)<=1`.  With it, the conic-bundle
branch reduces to a square-zero ideal calculation; analogous descent ideals
are then the exact targets for del Pezzo fibrations.

## EJ/TT and mystery ledger

- **EJ:** the smooth-discriminant Clifford calculation survives as the correct
  one-arrow calibration, while the nodal calculation tells us exactly which
  extra local term the analytic comparison must eliminate.
- **TT:** a smooth total space does not mean a harmless discriminant.  A
  rank-one fibre at an SNC crossing is the minimal place two allowed branch
  extensions compose.
- **Settled negatively:** amplitude, self-duality, reduced-discriminant
  support, and raw coniveau multiplication cannot yield the universal
  square-zero theorem.
- **Open:** whether the actual value-localized cubic Stokes/Gamma packet sends
  the node socle `kij` to zero; this is the minimum analytic/singular support
  gate for conic bundles.
