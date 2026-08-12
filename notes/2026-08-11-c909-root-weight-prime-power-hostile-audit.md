# C909: hostile audit and repair of the nonscalar root-weight family

Date: 2026-08-11  
Status: local construction audited; corrected nontrivial prime-power family
recorded; no manuscript, PDF, mirror, Lean, or commit

## Verdict on the prime-level construction

The explicit family in
`2026-08-11-c909-prime-power-etale-graph-theorem.md` is locally sound.  For
an odd prime `ell`, its root-weight block has rank

\[
 d=\ell-2<\ell,
\]

so `d` pairwise distinct scalars exist in `F_ell`.  The local decomposition

\[
 G_\ell\simeq\langle\ell-1\rangle\perp\ell B
\]

is integral over `Z_ell`: the all-ones vector is a unit line and the
sum-zero complement is a direct orthogonal summand.  Every unimodular
symmetric form over `Z_ell` for odd `ell` diagonalizes into unimodular lines
by integral Gram--Schmidt.  Giving those lines distinct Teichmuller slopes
therefore produces a `B`-self-adjoint split-etale operator, and its graph is
a maximal isotropic subgroup of the `ell`-primary polarization kernel.  The
standard maximal-isotropic quotient is principally polarized.

The saturation conclusion in that prime-level family is nevertheless
tautological: its dimension is `g=ell-1`, hence

\[
 \ell\nmid(g-1)!=(\ell-2)!.
\]

The prime-support/factorial-threshold theorem already proves primitivity for
*every* `ell`-primary graph at this dimension.  Thus the family is a useful
nonscalar elementary example, but it neither tests the higher-thickening
theorem nor supplies a nontrivial new saturation case.

## Corrected nontrivial family

Take instead

\[
 N=p^a,\qquad a\ge2,\qquad g=N-1,
 \qquad G_N=NI_g-J_g.
\]

At `p`, with `e=(1,...,1)` and

\[
 S=\{x\in\mathbf Z_p^g:\sum_i x_i=0\},
\]

one has the exact integral orthogonal decomposition

\[
 \mathbf Z_p^g=\mathbf Z_pe\perp S,
 \qquad G_N=(N-1)\perp p^aB,
 \tag{1}
\]

where `B` is unimodular.  The first summand is a unit block.  On the scaled
block choose the following idempotent finite-etale graph slopes.

### Odd `p`

Integral diagonalization writes `B` as a sum of unimodular lines.  Let `T`
be zero on one line and one on its nonzero orthogonal complement.  Then

\[
 T=T^\dagger,\qquad (\mathbf Z/p^a)[T]\simeq
 (\mathbf Z/p^a)\times(\mathbf Z/p^a).
 \tag{2}
\]

It is nonscalar.  Since `p^a-2>=p` for `p` odd and `a>=2`, `p` divides
`(g-1)!=(N-2)!`; the resulting primitive saturation is not supplied by the
factorial-unit shortcut.

### `p=2`

For `N=2^a` with `a>=3`, take the standard basis
`s_i=e_i-e_g` of `S`.  The unimodular residual form has Gram matrix

\[
 I_{N-2}+J_{N-2}.
\]

Its first two coordinates span the exact nondegenerate plane

\[
 \begin{pmatrix}2&1\\1&2\end{pmatrix}
\]

of determinant three.  Its integral orthogonal complement is nonzero.  Let
`T` be zero on that plane and one on its complement.  Again (2) holds and
the graph is nonscalar finite etale.  Here `2` divides `(N-2)!`.  The small
case `N=4` is not covered by this split construction; the scalar graph still
gives the valid higher-exponent family there.

In both cases the local graph is maximal isotropic in the scaled block's
polarization kernel.  There are no other bad primes for `N=p^a`, so the
quotient by this graph carries a principal polarization with pullback
coefficient matrix `G_N`.  Equivalently, this is the single-prime instance
of the CRT construction in
`2026-08-11-c909-etale-block-crt-cofactor-theorem.md`.

The finite-etale block cofactor theorem therefore gives, for these nonscalar
prime-power root-weight quotients,

\[
 \Theta^{N-2}/(N-2)!\in P_A^{N-2}.
\]

## Required proof repairs in the prime-power draft

1. The complete graph Neron--Severi lattice should first state that
   integrality against the source lattice forces a divisor coefficient to be
   `p^aBD`, with `D` `B`-self-adjoint.  Integrality on graph generators then
   gives exactly `[D,T]=0 mod p^a`.
2. Primitive idempotents initially live modulo `p^a`.  Their exact
   `O`-orthogonal lifts require the unimodular-Gram-complement induction;
   they do not arise from an unproved integral diagonalization of `T`.
3. The elementary prime family should be described as a nonscalar chart
   example only.  The `N=p^a` repair above is the family that genuinely
   exercises the higher-exponent theorem.

## Mystery ledger

- **Settled:** there is no root-weight self-duality obstruction to either
  scalar or nonscalar finite-etale graph quotient constructions.
- **Settled:** enough distinct scalars exist at prime level, but that does
  not make its saturation conclusion substantive.
- **Settled:** prime-power root weights yield nonscalar split-etale examples
  in the factorial-active range, including dyadic `N>=8`.
- **Open:** classify the non-split finite-etale operators compatible with the
  root-weight local forms, rather than selecting an idempotent split factor.
- **Open:** determine whether any such family is polarized-indecomposable or
  supplies a second geometric separation detector.

**Vibe:** the root-weight application is real after the prime-power repair;
the prime-only version had the right local algebra but landed below the
factorial wall.
