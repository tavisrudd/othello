# C895 prime-field Fischer detectors

**Date:** 2026-08-09  
**Task:** C895  
**Status:** positive targeted proof; specialist challenge pending

## Claim

Let `p>=5`, `d=(p-3)/2`, and

\[
 F=\operatorname{Sym}^dL(2).
\]

Then

\[
 F=\bigoplus_{0\le j\le\lfloor(p-3)/4\rfloor}
      L(p-3-4j),                                       \tag{P1}
\]

with every summand occurring once.  Consequently each prime-field detector
`L(s)`, for `s` in `2,4,6,8,12` in the manuscript's stated characteristic
range, is either absent from `F` or is a direct multiplicity-one summand with
an `H`-retraction.

## Proof of the decomposition

The module `L(2)` is tilting.  Tensor products of tilting modules are
tilting, and `d!` is invertible because `d<p`.  The ordinary symmetrizer
therefore realizes `Sym^d L(2)` as a direct summand of `L(2)^(tensor d)`, so
`F` is tilting.

The rank-one character identity is the classical Fischer identity

\[
 \operatorname{ch}\operatorname{Sym}^dL(2)
 =\sum_{0\le j\le\lfloor d/2\rfloor}\chi_{2d-4j}.       \tag{P2}
\]

It can be checked directly from the weights `2,0,-2` of `L(2)`: the
generating function for the left side is

\[
 \frac1{(1-tz^2)(1-t)(1-tz^{-2})},
\]

and grouping its coefficient of `t^d` into Weyl strings gives the right
side.  No characteristic-dependent division enters this character identity.

Every highest weight in (P2) lies between `0` and `p-3`, hence in the bottom
alcove.  The corresponding indecomposable tilting module is the simple
module `T(n)=L(n)`.  Uniqueness of tilting decomposition and (P2) now give
(P1), including multiplicity one.

This proof uses only standard tilting closure and the displayed elementary
character identity.  It does not invoke the false extension-field Lucas
socle formula.

## Consequences for the contraction

If the selected `L(s)` is absent from (P1), its linear moment is zero and the
quadratic parity obstruction gives the contradiction directly.  If it is
present, the summand projection supplies the required retraction

\[
 L(s)\lhook\joinrel\longrightarrow F\longrightarrow L(s).
\]

The affine point-vector class is supported only on the top Fischer factor
`L(p-3)`.  The manuscript's Borel calculation proves this without a
decomposition heuristic: on `L(m)`, the prime-field root group has one
Jordan block, its first cohomology is the coinvariant line, and the torus
acts there by `a^(-(m+2))`.  For even `0<=m<=p-3`, that line is Borel-fixed
only for `m=p-3`; restriction from `H` to the Borel is injective because the
Borel index `p+1` is nonzero in characteristic `p`.

Thus contraction of the pullback cocycle gives

\[
 (s+1)[c]
\]

on a lower factor and

\[
 (s+2)[c]
\]

on the top factor.  In every detector row the relevant scalar is nonzero:
the range assumptions put a lower detector strictly below `p-1`, while a
top detector has `s=p-3` and scalar `p-1`.

Together with the manuscript's explicit root coefficient proving
`[c] != 0`, this closes the prime-field detector channel.

## Audit boundary

The specialist read should check the tilting direct-summand step, the
character grouping (P2), and the Borel cohomology weight.  No assertion about
extension-field Fischer decompositions is made.
