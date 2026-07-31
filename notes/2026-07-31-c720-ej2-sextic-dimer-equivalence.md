# C720 ej2 — sextic/dimer reconstruction equivalence

**Lane:** golden

**Date:** 2026-07-31

**Status:** complete; documented post-freeze corollary

## Outcome

The determinant sextic and the \(K_{3,3}\) dimer fingerprint are not merely
two reverse-faithful shadows of the golden conference class. They are
canonically interconvertible on the marked golden locus without choosing a
Pfaffian orientation.

Specific \((2,2,1,1)\)-type coefficients of

\[
 \Delta_C(x)=\det[D_x,C]=16Z_C(x)^2
\]

are exactly the four-cycle holonomies measured by ratios of adjacent
determinant-matching terms. Thus the algebraic sextic contains the complete
relative dimer fingerprint before a square root is chosen.

## The coefficient/holonomy identity

Write

\[
 Z_C(x)=\sum_{\{i,j,k\}\subset X}t_{ijk}x_ix_jx_k,
 \qquad
 t_{ijk}=C_{ij}C_{jk}C_{ki}\in\{\pm1\}.
\]

For four distinct indices \(i,j,k,l\), only the two ordered cross terms
\((ijk,ijl)\) and \((ijl,ijk)\) contribute to
\(x_i^2x_j^2x_kx_l\) in \(Z_C^2\). Therefore

\[
 \boxed{\quad
 [x_i^2x_j^2x_kx_l]\,\Delta_C
 =32\,t_{ijk}t_{ijl}.
 \quad}
\]

The product on the right is the four-cycle holonomy

\[
 t_{ijk}t_{ijl}
 =C_{ik}C_{kj}C_{jl}C_{li}.
\]

Hence the projective sextic line determines these holonomies directly.  The
selected nonzero coefficients first determine their signs up to one common
sign.  Their indices are the edges of the Johnson graph on triples, and the
product of the true edge labels around every graph cycle is \(+1\).  Since
that graph contains triangles, exactly one of the two common-sign choices
has product \(+1\) around a triangle.  This fixes the projective
normalization canonically.  No factorization of \(\Delta_C\) and no choice
between \(Z_C\) and \(-Z_C\) is required.

## Equality with the dimer readout

Fix a \(3|3\) cut containing \(i,j\) on one side and \(k,l\) on the other.
Let \(m_\pi\) be one signed determinant-matching term and let \(m_{\pi'}\)
be obtained by swapping the partners \(k,l\) of \(i,j\), leaving the third
matched edge fixed. The permutation sign changes once, so

\[
 \frac{m_{\pi'}}{m_\pi}
 =-C_{ik}C_{jl}C_{il}C_{jk}
 =-t_{ijk}t_{ijl}
 =-\frac1{32}
 [x_i^2x_j^2x_kx_l]\,\Delta_C.
\]

The last equality uses the frozen normalization of \(\Delta_C\); on a
projective sextic line it is read as a relative sign. Adjacent
transpositions generate \(S_3\), so these ratios recover the complete
relative six-matching pattern on every cut.

Conversely, every four-cycle occurs in such a cut. The products
\(t_{ijk}t_{ijl}\) label the edges of the connected Johnson graph on the
twenty triples, so they recover the triangle-sign vector \(t\) up to one
common sign. Triangle holonomies recover the edge signing up to vertex
switching, and the remaining common sign is exactly \(C\mapsto-C\).

## Reconstruction equivalence

On fully marked golden conference presentations there is therefore an exact
equivalence of orientation-free reconstruction data:

\[
\begin{aligned}
 [\Delta_C]
 &\longleftrightarrow [Z_C]
 \longleftrightarrow \{\pm(t_{ijk})\}\\
 &\longleftrightarrow
 \{\text{four-cycle holonomies}\}
 \longleftrightarrow
 \{\text{relative \(K_{3,3}\) matching fingerprints}\}\\
 &\longleftrightarrow
 \{\text{conference switching class modulo }C\mapsto-C\}.
\end{aligned}
\]

The first equivalence is the Veronese square; the middle equivalence is the
boxed coefficient formula; the last is switching reconstruction. On the
golden locus, the projective ten-cut determinant-sign word also identifies
the same one of the six sister classes. It is a compressed classifier,
whereas the full relative matching fingerprint is the object appearing
directly in the coefficient formula.

This is stronger than having two independent checks: the polynomial and
fermionic/combinatorial shadows are two presentations of the same
orientation-free object, with an explicit conversion law.

## Consequence for C727

C727 no longer needs to test marked reverse faithfulness for either the
determinant sextic or the full dimer fingerprint. Its remaining questions
are:

1. whether Paper I's coarsest sufficient recovery datum canonically supplies
   this equivalence class;
2. whether passage from one recovered conference class to the coherent outer
   six-family needs an additional marking;
3. where the orientation torsor re-enters if the Pfaffian cubic, rather than
   its determinant square, is required; and
4. how the nonzero fibres of centered squaring behave at each marking level.

The coefficient identity gives C727 a useful descent strategy: track the
selected sextic coefficients, which are switching-invariant four-cycle
holonomies, instead of choosing a square root of the determinant polynomial
at the start.

## Novelty and trust boundary

The identity is an elementary consequence of the frozen commutator
determinant and triangle formulas. No literature-priority claim is made.
The proof above is symbolic and complete; it uses no finite enumeration or
new computational certificate. The existing C704 and C720 certificates
remain corroboration for the source formulas and order-six classification,
not evidence substituted for this argument.

## ej2 mystery ledger

- **Settled:** the sextic and dimer reverse witnesses are canonically
  equivalent, not merely parallel.
- **Settled:** the dimer four-cycle holonomies occur directly as normalized
  \((2,2,1,1)\)-coefficients of the determinant sextic.
- **Settled:** the odd cycles of the Johnson graph fix the common projective
  coefficient sign, so direct sextic-to-dimer reconstruction does not need a
  square-root choice.
- **Settled:** orientation loss is exact: every object in the reconstruction
  chain is unchanged by \(C\mapsto-C\), while the Pfaffian line with a chosen
  sign is not.
- **Still open, owned by C727:** descent of this equivalence from Paper I's
  exact input hierarchy and recovery of the coherent outer six-family.
- **Still open, owned by C727:** generic and special nonzero fibres of the
  centered-square polar map.
- **No additional C720 mechanism mystery remains:** the algebraic sextic and
  fermionic frustration shadow now commute by an explicit coefficient
  identity.
