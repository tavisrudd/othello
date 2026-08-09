# C895 extension-field linear detectors

**Date:** 2026-08-09  
**Task:** C895  
**Status:** positive human proof; specialist challenge pending

## Statement

Let `q=p^e` be odd, let `H=PSL_2(q)`, and put

\[
 d=(q-3)/2,
 \qquad F=\operatorname{Sym}^dL(2).
\]

The two linear facts needed in Paper II's extension-field exclusion hold
without a universal finite-group socle calculation.

1. `Hom_H(St,F)=0`.
2. If `q=3 mod 4`, `e>1`, and `S=L(q-7)`, then `S` embeds in `F`, and every
   occurrence has the determinant-normalized `PGL_2(q)` parity.  Hence the
   opposite outer extension has zero linear moment.

## Finite maps are algebraic in these channels

Let `\mathbf G=SL_2(k)` over an algebraic closure of `F_q`, and let
`Gamma=SL_2(q)`.  For a `Gamma`-map `phi:S->F`, consider

\[
 D(t)=u_F(t)\phi-\phi u_S(t).
\]

The root action on `F=Sym^d L(2)` has polynomial degree at most
`2d=q-3`.  For `S=St=L(q-1)` the source degree is `q-1`; for
`S=L(q-7)` it is `q-7`.  Thus every entry of `D(t)` has degree at most
`q-1`.  It vanishes at all `q` elements of `F_q`, hence is the zero
polynomial.

Therefore `phi` commutes with the full algebraic positive root subgroup.
The finite Weyl element conjugates this to the full negative root subgroup,
and the two algebraic root subgroups generate `\mathbf G`.  Consequently

\[
 \operatorname{Hom}_{\Gamma}(S,F)
 =\operatorname{Hom}_{\mathbf G}(S,F)                   \tag{D1}
\]

for these two sources.  Central actions are trivial, so this is the required
`H` statement.  Notice that the degree is `q-1`, not `q`: no multiple of
`t^q-t` can occur.  This is the same finite-root seam that the false
all-simple Lucas formula obscured, but here it closes immediately.

## Steinberg absence

The Steinberg module `L(q-1)` is simple and has highest weight `q-1`.
The top algebraic weight of `F` is `q-3`.  Hence

\[
 \operatorname{Hom}_{\mathbf G}(L(q-1),F)=0,
\]

and (D1) proves `Hom_H(St,F)=0`.

This proof is independent of the quadratic target calculation.  Combined
with the separate identity

\[
 \operatorname{St}\otimes L(1)\otimes L(1)^{(e)}
 \simeq T(2q)
\]

and its two high Weyl sections, it supplies both the zero linear moment and
the opposite-parity quadratic Hom vanishing required for an intransitive
exceptional stabilizer.

## The `L(q-7)` occurrence

Assume `q=3 mod 4` and `e>1`.  Then `p=3 mod 4`, `e` is odd, and the
base-`p` digits of

\[
 s=q-7
\]

are all even.  More explicitly:

- if `p>=7`, they are `p-7,p-1,...,p-1`;
- if `p=3`, they are `2,0,2,...,2`.

Write `s_j=2r_j`.  There is no carry on division by two, so

\[
 r=(q-7)/2=\sum_jr_jp^j=d-2.                            \tag{D2}
\]

For every digit, the Cartan multiplication map embeds

\[
 L(2r_j)\lhook\joinrel\longrightarrow
 \operatorname{Sym}^{r_j}L(2),                         \tag{D3}
\]

because `0<=2r_j<=p-1`.  Tensor the Frobenius twists of (D3), and multiply
the resulting polynomial factors after applying the corresponding Frobenius
powers.  This gives

\[
 L(s)=\bigotimes_jL(2r_j)^{(j)}
 \lhook\joinrel\longrightarrow
 \operatorname{Sym}^{r}L(2).                           \tag{D4}
\]

The map is injective: in a monomial basis, the exponent of each of the three
coordinates has base-`p` digits bounded by `r_j<p`, so the product has a
unique digit expansion.

Let `Q` be the invariant discriminant in `Sym^2 L(2)`.  Multiplication by
`Q` is injective in the polynomial ring and, using (D2), gives

\[
 L(q-7)\lhook\joinrel\longrightarrow
 \operatorname{Sym}^{d-2}L(2)
 \mathrel{\mathop{\longrightarrow}^{\cdot Q}}
 \operatorname{Sym}^{d}L(2)=F.                         \tag{D5}
\]

At `q=9`, where the congruence hypothesis is not used by the classification,
the same mechanism specializes under Hermite reciprocity to the three
catalecticant minors found by the C895 falsifier.  Thus (D5) identifies the
general mechanism behind the omitted copy rather than introducing a new
channel.

## Outer normalization

Regard the modules as homogeneous `GL_2` polynomial modules.  The target
degree is

\[
 2d=q-3,
\]

whereas the source degree is `s=q-7`.  Scalar compatibility forces every
`SL_2` map in (D1) to acquire determinant exponent

\[
 b_0=(2d-s)/2=2.                                       \tag{D6}
\]

The explicit map (D5) has exactly this twist because the discriminant `Q`
transforms by `det^2`.  Thus it is the determinant-normalized extension.
By (D1), there are no finite-only maps carrying a different normalization;
all linear occurrences have the same outer parity.  The other
`PGL_2(q)` extension differs by `det^((q-1)/2)` and is absent from `F`.

This proves the precise fact used in the residual full nonsplit-normalizer
branch: choose the extension opposite to (D5), so its linear moment is zero.

## Audit boundary

This argument proves occurrence and parity, not a multiplicity formula for
`Hom_H(L(q-7),F)`.  No such formula is needed.  It also makes no assertion
about other simple modules in the socle of `F`; the `q=9` calculation shows
why that stronger statement should not be restored.

The specialist challenge should check four points only:

1. the `q-1` root-degree bound in (D1);
2. injectivity of the digitwise Frobenius multiplication in (D4);
3. the discriminant character and scalar-degree calculation (D6); and
4. compatibility of “determinant-normalized” with the manuscript's chosen
   `PGL_2/PSL_2` convention.
