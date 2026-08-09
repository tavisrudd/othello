# C895 preclassification interface

**Date:** 2026-08-09  
**Task:** C895  
**Status:** R0 interface freeze; human-proof working memo

## Purpose

This sheet records exactly what the modular exclusion may use before it proves
the sheet size and classifies the surviving fields.  It is the circularity
gate for the C895 repair.

## Groups and fields

Let `q=p^e` be odd and let `k` be an algebraic closure of `F_q`.  Keep four
groups distinct:

\[
 \mathbf G=\operatorname{SL}_2(k),\qquad
 \Gamma=\operatorname{SL}_2(q),\qquad
 H=\operatorname{PSL}_2(q),\qquad
 G=\operatorname{PGL}_2(q).
\]

Rational `\mathbf G`-modules are restricted to `\Gamma` and then, when the
central action is trivial, regarded as `H`-modules.  The two extensions of an
outer-stable simple `H`-module to `G` differ by the nontrivial character
`chi` of `G/H`.  Every parity statement must say which extension is
determinant-normalized.

## Orbit and trade input

Let `Omega` be one full `G`-orbit of perfect matchings of
`P^1(F_q)`.  The intrinsic hypothesis is that the annihilator of the square
of its affine evaluation space is one-dimensional and every nonzero vector
in that line takes exactly two values.

For `q>3`, the following consequences are available before classification:

- the trade has full support;
- its two levels are the two transitive `H`-orbits
  `Omega_+` and `Omega_-`;
- an outer element exchanges the two levels and negates the sheet sign; and
- for `M` in one sheet, `K=Stab_H(M)` is a `p'` group, because a nontrivial
  unipotent cannot preserve a perfect matching.

Thus one sheet is `H/K` and its permutation module is

\[
 P=k[H/K].
\]

Since `K` is a `p'` group, `P` is projective.  No stronger assertion about
its nonprincipal summands is part of the interface.

## Point-vector and evaluation convention

Let `A` be the full affine-linear function space on the ambient conic-ideal
quotient form space, and let `E=A^*` be its point-vector dual.  It is not the
dual of the possibly smaller span of the selected orbit.  Dualizing the
constant functions gives

\[
 0\longrightarrow F\longrightarrow E
 \mathrel{\mathop{\longrightarrow}^{\epsilon}}k
 \longrightarrow0,
 \qquad
 F=\operatorname{Sym}^{(q-3)/2}L(2).
\]

Evaluation at a matching is `v_M in E` with `epsilon(v_M)=1`.  Define

\[
 a:k[\Omega]\to E,\quad [M]\mapsto v_M,
 \qquad
 \mu:k[\Omega]\to\operatorname{Sym}^2E,\quad[M]\mapsto v_M^2.
\]

The trade hypothesis gives

\[
 \ker\mu=k\left(\sum_{M\in\Omega_+}[M]
                    -\sum_{M\in\Omega_-}[M]\right).
\]

The polarization map

\[
 \partial:\operatorname{Sym}^2E\to E,
 \qquad \partial(xy)=\epsilon(x)y+\epsilon(y)x
\]

satisfies `partial mu=2a` and has kernel `Sym^2 F`.

## Projective--trade consequence

Let `S` be a nontrivial outer-stable simple `H`-submodule of one sheet
module, and let `S^+`, `S^-` be its two `G`-extensions.  The projective--trade
lemma supplies embeddings of both extensions in `Sym^2 E`.  For either
extension `T`, with `j=mu|_T` and `i=partial j`, exactly one of the following
holds:

1. `i=0`, so `T` embeds in `Sym^2 F`; or
2. `i:T->F` is injective and the pullback of
   `0 -> Sym^2 F -> Sym^2 E -> E -> 0` along `i` splits.

If `xi` is the affine point-vector extension class, then the connecting
class is

\[
 \delta_T(i)=i^*\pi_*(F\otimes\xi),
\]

where `pi:F tensor F -> Sym^2 F`.  With a vector-space lift of `1` and
cocycle `c(g)=ge-e`, it is represented by

\[
 z_i(g)(t)=i(t)c(g).
\]

This gives a precise Hom/Ext contradiction to prove.  It does not by itself
identify a simple `S`, its outer parity, or the nonsplitting of the pullback.

## Rational-module input

Put `d=(q-3)/2` and `W=nabla(d)`.  Modular Hermite reciprocity gives the
rational `\mathbf G`-isomorphism

\[
 F=\operatorname{Sym}^dL(2)\simeq\operatorname{Sym}^2W.
\]

The simple modules are written in Steinberg digits

\[
 L(c_0,\ldots,c_{e-1})
 =\bigotimes_{j=0}^{e-1}L(c_j)^{(j)}.
\]

Hermite reciprocity and Steinberg's tensor-product theorem do not compute the
finite-group socle of `F`, the outer parity in `Sym^2 F`, or any required
Hom space.  Those are R1 and R2 obligations.

## Forbidden preclassification outputs

No R1--R3 proof may use:

- sheet size `q` or orbit size `2q`;
- one-factorization of either sheet;
- regular translations on a sheet;
- the Paley carrier or cross-sheet incidence matrix;
- the survivor fields `q=7,11`;
- the `S_4` or `A_5` survivor stabilizers; or
- C894's saturated-exterior hypotheses or conclusion.

The small fields may be used only as falsification checks for a proposed
uniform lemma.  Lean and finite certificates may corroborate a stable seam
but cannot discharge any implication above.
