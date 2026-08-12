# C909 — dimension-five (k=2/k=3) comparison and unequal-depth boundary

Date: 2026-08-12  
Status: bounded hostile audit; no manuscript, PDF, mirror, Lean, or commit
change

## Verdict

For a marked one-depth finite-etale graph presentation of a five-dimensional
non-CM elliptic-power quotient, the two ambient quotients are canonically
isomorphic by integral Lefschetz multiplication:

\[
 Q^2:=\operatorname{Hdg}^{4}/P^2
   \xrightarrow{\;\Theta\wedge-\;}
 Q^3:=\operatorname{Hdg}^{6}/P^3 .
 \tag{1}
\]

After splitting the etale roots, this is the complement map on the five
four-slot summands, and it descends by faithful flatness.  Consequently
\[
 Q^2\simeq Q^3\simeq (R/\pi^aR)^5
 \tag{2}
\]
for the equal-depth local graph.  This is a Lefschetz/complement theorem,
not a consequence of Poincare duality alone: in general the annihilator of
the ordinary product lattice in one degree need not be the ordinary product
lattice in the complementary degree.

For unequal depths, dimension five still has only the same five residual
four-slot blocks, so (1) remains the right structural reduction under a
split graph presentation.  What does not survive is the single factor
`R/pi^a`: each four-slot block is a weighted two-matching Smith problem
depending on the diagonal depths and cross-root valuations.  The tropical
midpoint ideals control divided-power saturation of `NS`; they do not by
themselves determine the ambient Hodge/product quotient.

## 1. Equal-depth split calculation

Let `R` be an unramified DVR, `pi=p^a`, and split the slope as
`T=diag(t_1,...,t_5)` with all `t_i-t_j` units.  Write
`D_i=pi Omega_{ii}` and `C_{ij}=pi^2 Omega_{ij}` for the primitive graph
divisors.  In this normalization the principal polarization is
\[
 \Theta=\sum_{i=1}^5D_i .
 \tag{3}
\]

For a four-set `J` and its complement `{i}`, the exact four-slot calculation
gives, with `r_1,r_2` the two matching products and `h_J` the weighted
Pluecker cancellation,
\[
 I_J=R\,\pi^{3}h_J+R\,\pi^{4}r_1,
 \qquad
 P_J=R\,\pi^{4}h_J+R\,\pi^{4}r_1 .
 \tag{4}
\]
Here `I_J` is the integral Hodge lattice and `P_J` the ordinary product
lattice in the `(1,1,1,1)` support component.  The quotient is `R/pi`.

In degree six, the only non-saturated support type for `g=5` is
`(2,1,1,1,1)`.  The corresponding component is obtained by wedging the
four-slot component with the volume class of the complementary slot.  More
precisely, wedging (4) by `D_i=pi Omega_{ii}` gives
\[
 D_iI_J=R\,\pi^{4}\Omega_{ii}h_J
        +R\,\pi^{5}\Omega_{ii}r_1,
 \quad
 D_iP_J=R\,\pi^{5}\Omega_{ii}h_J
        +R\,\pi^{5}\Omega_{ii}r_1 .
 \tag{5}
\]
These are exactly the Hodge and product lattices in that degree-six
component.  The other diagonal summands `D_j` with `j in J` land in
support types with a doubled slot inside `J`; those components are already
product-saturated.  Thus modulo `P^3`, `Theta wedge-` sends the defect line
of `J` isomorphically to the defect line with doubled complement `i`.

The five degree-four supports and the five degree-six supports are permuted
by etale root monodromy.  The complement map and `Theta` are equivariant,
so the split isomorphism descends; no labelled generator or orientation line
needs to descend separately.  This proves (1)--(2), conditional only on the
already proved four-slot calculation and the standard base-change identities
for the marked graph lattices.

## 2. Why “Poincare-dual” needs qualification

Poincare duality gives a perfect pairing on the full integral cohomology, but
it does not imply
\[
 (P^2)^\perp=P^3
 \tag{6}
\]
for arbitrary ordinary divisor-product images.  Nor does a numerical equality
of the two Smith modules prove that the induced map is canonical.  In the
present one-depth `g=5` situation, (5) supplies the missing compatibility:
the principal theta is an actual divisor, its complement term has the exact
common scale, and all other theta terms disappear in the quotient because
their multidegree components are saturated.  Therefore the honest wording
is “canonical integral Lefschetz/complement isomorphism, compatible with the
ambient Poincare pairing,” rather than “Poincare duality alone identifies
the quotients.”

For an arbitrary ppav, or for an unmarked presentation with no specified
graph product lattice, (1) is not automatic.  The marked graph and its
multidegree decomposition are load-bearing.

## 3. Unequal depths: exact reduction and the new invariant

After a compatible etale split, let `X_i=p^{a_i}x_i` and
`Y_i=y_i-t_ix_i`.  Then
\[
 \Omega_{ij}=
 p^{-a_i-a_j}(t_j-t_i)X_iX_j
 +p^{-a_i}X_iY_j+p^{-a_j}X_jY_i .
 \tag{7}
\]
The graph Neron--Severi coefficient ideals are
\[
 I_{ii}=p^{a_i}R,\qquad I_{ij}=p^{e_{ij}}R,
 \quad
 e_{ij}=\max\{a_i,a_j,a_i+a_j-v(t_j-t_i)\}.
 \tag{8}
\]

For a four-set `J={1,2,3,4}`, the degree-four residual quotient is exactly
the saturation of the two-dimensional matching span modulo
\[
 P_J=R\,p^{e_{12}+e_{34}}r_1
    +R\,p^{e_{13}+e_{24}}r_2
 \tag{9}
\]
(with the third matching eliminated by the integral Pluecker relation).
Equivalently it is the Smith quotient of the weighted two-matching matrix
obtained by inserting (7) in `r_1,r_2`.  Formula (9), rather than a single
uniform midpoint factor, is the invariant local object in the unequal-depth
case.

There is a useful clean subcase.  If all four roots are pairwise distinct
modulo `p`, then `v(t_i-t_j)=0`, so `e_{ij}=a_i+a_j`.  Put
`S=sum_{i in J}a_i` and `m_J=min_{i in J}a_i`.  Both matching products in
(9) have scale `p^S`.  The one-`Y` rows force a coefficient combination to
have scale `p^{S-m_J}`, while the all-`X` row leaves one unit linear
congruence modulo `p^{m_J}`.  Hence
\[
 Q_J\simeq R/p^{m_J}R .
 \tag{10}
\]
Equal depths recover `m_J=a`.  If roots at different depths have nonunit
differences, (8)--(9) remain exact but the two matching scales and the
highest-term congruence can differ; no claim that the answer is cyclic, or
that its length is just a minimum depth, is justified without a separate
two-by-two Smith calculation.

The same volume-factor argument sends `Q_J` to the degree-six component with
doubled complement, so the dimension-five `k=2/k=3` comparison remains a
blockwise Lefschetz statement even when the numerical four-slot factors are
unequal.  It is not an assertion that all unequal-depth data collapse to the
equal-depth midpoint quotient.

## 4. Relation to the finite-etale PD theorem

The arbitrary-depth graph theorem proves that the matrix-of-ideals `NS`
lattice is generated by rank-one square-zero divisors, because
`e_{ij} >= max(a_i,a_j)`.  This gives
\[
 \operatorname{PD}\langle NS\rangle^k=P^k
 \tag{11}
\]
in every cohomological degree.  It does **not** say `P^k=I^k`; (9) is a
separate integral Hodge saturation calculation.  Thus “four-slot midpoint
ideal” is a correct description of the NS divided-power gate, but not a
complete description of the ambient Hodge/product defect for unequal depths.

## Strongest safe dimension-five statement

For the A5 intermediate Jacobian application, where the relevant marked
presentation is one equal-depth finite-etale block of rank five, state
\[
 \operatorname{Hdg}^{4}/P^2
 \xrightarrow[\sim]{\,\Theta\wedge-\,}
 \operatorname{Hdg}^{6}/P^3
 \simeq (\mathbf Z/p^a)^5 .
 \tag{12}
\]
Call this a canonical marked Lefschetz/complement identification.  Do not
derive it from Poincare duality by itself, and do not extend the displayed
`(Z/p^a)^5` to unequal-depth packets without retaining the weighted
four-slot Smith data (8)--(10).

