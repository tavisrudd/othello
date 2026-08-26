# C973 hostile audit — simultaneous-marker and R11 checkpoints

**Lane:** `reed-solomon` · **Date:** 2026-08-26 · **Reviewer status:**
author-side adversarial audit, not the independent specialist gate

## Verdict

**Primary simultaneous-marker theorem: internal PASS.**  The proof has no
remaining stagewise hypothesis.  Its load-bearing inputs are exactly C820's
reduced component converse and C881's exact R5 split-member count.  The new
steps are elementary contraction algebra, a degree-six pullback, the
Vandermonde grid lemma, and one forbidden-member count.

**Quantitative witness lower bound: internal PASS.**  It is useful as a
fixed-redundancy asymptotic; its explicit finite lower bound can be zero near
the sharp existence threshold and is not advertised otherwise.

**R11 Lucas closure: internal PASS at the stated asymptotic boundaries.**  The
characteristic-seven fixed-root propriety argument is the most delicate new
piece and should be the first target of independent review.

## 1. Type and contraction audit

For `f in Gamma^(r-1) E`, a marker product
`R in Sym^(r-5)(E^vee)` contracts to `Gamma^4 E`; the terminal kernel therefore
contains cubics, and multiplication gives degree
`(r-5)+3=r-2`, exactly the PRS locator degree.  Pairing against an additional
linear form proves

\[
 g\in W_{\iota_Rf}\iff Rg\in W_f
\]

before projectivization.  Selector nonvanishing separately proves that the
chosen contraction is nonzero.  No rank assumption is smuggled into the
identity.

The squarefree statement is also exact: `R` is a product of distinct rational
linear forms, and `Rg` is squarefree precisely when `g` is squarefree and
coprime to `R`.  Intermediate partial products have no logical role.

## 2. Carrier-selector audit

C820 identifies the geometric composite-contraction image closure with the
projective row space `L_f` and proves

\[
 L_f\subset B_5^{red}\Longrightarrow
 f\in P_r\cup M^{max}_{r,p}.
\]

The contrapositive is applied only over a geometric fibre.  Because `L_f` is
irreducible, noncontainment in `V(D) union V(I_A)` means both `D|L_f` and some
listed `A|L_f` are nonzero.  Their product is nonzero in the domain `k[L_f]`.
This avoids the invalid inference that noncontainment in a union supplies one
universal residual generator in every characteristic.

The degrees are correct:

- generic residual equations have degree three, giving `deg(D A)=6`;
- the characteristic-two plane is linear, giving degree four; and
- the characteristic-three wild ideal has generators in degrees two and
  three, giving degree at most six.

The ordered root-product map is dominant even when the characteristic divides
`m!`; only dominance, not an etale symmetric-group quotient, is used.  Thus
the selector remains a nonzero multihomogeneous polynomial of degree at most
six in each root pair.

Positive terminal gcd is genuinely excluded by `D != 0`.  A common geometric
root puts its twisted-cubic evaluation row in the terminal Hankel row space.
At root zero, the resulting three minors force the expansion of `D` to vanish;
equivariance handles every root.  Separability and `S_3` monodromy then follow
from the exhaustive characteristic-wise residual component theorem, not from
a genericity slogan.

## 3. Finite-field selector audit

After affine dehomogenization, multiply the selector by the Vandermonde.  The
degree in each variable is at most `d+m-1`.  If this is below `q`, a nonzero
reduced polynomial cannot vanish on all of `F_q^m`.  This uses the standard
function-algebra basis with individual degrees below `q`; it is stronger and
cleaner than a union bound on all diagonals.

The pointed version multiplies by one factor for each prescribed finite root
in each marker variable.  A forbidden point at infinity costs nothing because
the selected markers are affine.  Its degree condition is therefore exactly
`q>d+m-1+s`.

## 4. Terminal count and threshold audit

Outside the terminal carrier, C881 gives

\[
 N_b\ge(q+1-2\sqrt q-B_p)/6,
 \qquad B_2=6,\quad B_p=12\ (p\ne2).
\]

Base-point-freeness means each prescribed rational root lies in one pencil
member, so `m` roots exclude at most `m` split members.  The proof does not
double-count ordered fibre-square points or add an unnecessary singular-point
deletion.  Existence is exactly

\[
 q+1-2\sqrt q>B_p+6m.
\]

For `Delta=B_p+6m`, the least integer bound forced by this strict inequality
is

\[
 1+\lfloor(1+\sqrt\Delta)^2\rfloor
 =\Delta+2+\lfloor2\sqrt\Delta\rfloor.
\]

This gives the stated general and binary thresholds.  At R6--R10 the general
integer thresholds are `28,35,42,50,56`; the next prime powers are exactly
`29,37,43,53,59`, matching the five existing fixed-level theorems.

The large-characteristic coding promotion remains separate.  The improved
threshold is still much larger than the Seroussi--Roth dimension condition,
so lowering the geometric threshold does not fall out of the imported radius
range.

## 5. Quantitative multiplicity audit

Schwartz--Zippel bounds selector-zero ordered tuples by
`6m q^(m-1)`, while the number of ordered distinct affine tuples is `(q)_m`.
For each good tuple, the exact R5 lower bound loses at most `m` members.  A
degree-`m+3` locator has at most

\[
 \binom{m+3}{m}m!=(m+3)!/6
\]

ordered-marker/unordered-cubic decompositions.  Dividing by this maximum gives
the recorded lower bound.  The leading fixed-`r` term is
`q^(r-4)/(r-2)!`; the genus-one error is of order `q^(r-9/2)` and dominates
the marker-selector error, as stated.

## 6. R11 Lucas audit

Lucas' digit criterion gives only the supports recorded for `p=2,3,7`.
The contraction supports are direct unions with their one-step shifts.

- In characteristic three the lower carrier is empty.  Off the persistent
  intersection, a polar line has at most three persistent parameters; the
  pointed redundancy-ten theorem with one retained root gives the `q>=81`
  boundary.
- In characteristic two, contraction at infinity lands in C620's carrier.
  The graph, off-graph, rank-two, and two-moduli proofs all provide monic
  finite-root witnesses uniformly by `q>=128`, so the upper infinity lift is
  squarefree.
- In characteristic seven, choose upper infinity, then an internal finite
  marker outside the proved fixed-gcd/collision budget and translate it to
  zero.  On the R9 slice, one nonzero coefficient of the zero-root resultant
  `N_u(x)` exists because zero is not a fixed factor.  Adding it and four
  base-root avoidances raises the selector degree from `102` to at most `114`.
  Moving-root and residual-root avoidance raise curve deletion from `32` to
  at most `38`.  Both bounds are cleared at the first relevant field `343`.

The characteristic-seven nonzero-resultant argument uses density of the
squarefree open in the linear system.  An independent reader should verify
this against the precise R9 parameterization and confirm that no
determinant-zero chart is silently reused.

## 7. Remaining gates

1. A reader independent of C820 must reconstruct the component converse used
   by the selector.
2. A finite-field/arithmetic reader must recheck the Vandermonde grid lemma,
   exact R5 subtraction, and strict threshold arithmetic.
3. A coding reader must reconfirm the reduced geometric containment versus
   covering-radius promotion.
4. The R11 characteristic-seven fixed-root resultant needs the focused review
   described above.
5. Small pointed binary fields and further Pascal digit blocks remain outside
   these checkpoints.

No manuscript, Lean, software, certificate, or literature-priority claim was
changed by this audit.
