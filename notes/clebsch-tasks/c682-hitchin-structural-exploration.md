# C682 — Hitchin--Clebsch structural exploration

**Lane:** `clebsch`

**Opened:** 2026-07-26

**Status:** active open exploration; completion is the user's decision.

## Objective

Explore the rational \(5J_0\) incidence torsor, golden fibre,
Clebsch/Petersen modules, transvectants, and harmonic realization for
Gold/Platinum structure.  Proved results and conjectural leads must remain
explicitly separated.

## Current crown

- Third-transvectant kernels give inverse descriptions of the
  Mukai--Umemura \(U_{22}\) and \(V_5\) models.
- The corrected primitive mod-\(11\) operator lifts over
  \(\mathbf Z_{11}\) and yields the \(1+5+6+10\) kernel section.
- The maximal-subgroup mate correspondence produces all four
  characteristic-zero components and the Schläfli double-six.
- The \(D_5\)--\(S_3\) cross-Gram scalar has two golden-conjugate values
  whose fibres are complementary \((6_5,10_3)\) designs; their first-order
  collision at \(11\) explains the Bockstein shadow.
- The separator extends across both Mukai--Umemura boundary orbits as the
  saturated graph coordinate \([c^2:g_Dg_S]\) on the normalized mate
  correspondence. It cannot descend to the coarse kernel-pair boundary,
  where both golden values have the same limiting pair.
- The normalized-graph deck exchange is the global Schläfli apolar-polar
  row swap: the two five-cycle classes in each \(D_5\) give complementary
  pentagon-side and pentagram-diagonal relations on the ten \(S_3\) labels.
- In the frozen common \(A_5\)-marking, the stored mod-\(11\) matrix is the
  \(\lambda_+\) fibre with \(\sqrt5=4\); the outer order-five-class swap
  gives the complementary \(\lambda_-\) fibre.
- The independent Klein \(E_8\) branch realizes the classical three-node
  matrix factorization and its first degree-\(22\) corner failure.
- Its unexplained cubic is the scalar radial third-transvectant symbol:
  \(\mathcal R=((\,\cdot\,,F)_3/132)/t\) has principal symbol \(10p\).
  Uniformly on every McKay block,
  \(\sigma_3(\mathcal D)=10p\,m_t\), with \(m_t\) multiplication by the odd
  Klein invariant and hence the corresponding classical \(E_8\)
  factorization.
- In every degree \(0\le n\le72\) except \(22\), the two shortest upward
  returns together with the nearest downward return generate the full
  binary-icosahedral commutant.  Fifteen apparent later deficits of the
  upward pair are all repaired by that one downward word; degree \(22\)
  remains the unique certified full-corner failure in this bounded range.
- All fourteen strict multiplicity peaks in degrees \(73\) through \(112\)
  also saturate.  Together with the preceding range, this tests one base
  representative of every eventual \(60\)-periodic peak family.  Only the
  \(1,2,3,3'\) Kostant modules occur; all-weight saturation is now a
  symbolic nonvanishing problem along those four finite free modules.
- The global two-sided defect is completely classified:
  \(K_n=\ker(\Delta_n,\Delta_{n-6}^\dagger)=0\) for every \(n>52\), and its
  thirteen exceptional degrees are exactly
  \(0,1,2,6,10,11,12,20,21,22,32,40,52\).  Five exact local
  four-by-four determinants prove unique continuation on the five
  coefficient chains.  Degree \(22\) is the unique exception that can
  occupy a repeated isotypic summand.  The remaining corner gate is
  upper-support mixing at codimension-two peaks plus off-peak propagation.
- The proposed maximal-rank/multiplicity induction has been audited rather
  than assumed.  Every McKay block is maximal-rank through degree \(300\)
  at two primary and one replay prime, and the supported-two-subspace lemma
  is proved.  But the trivial module has a recurring unanchored plateau
  \(1\to2^6\to3\), first in degrees \(118,\ldots,160\), so bare
  multiplicity induction is circular.  The first exact remaining family is
  plateau-entry mixing at \(n=64+60q\).
- The trivial-module plateau-entry family is now controlled for every
  \(q\ge1\).  In the basis
  \(F^{2+5j}h^{2+3(q-j)}\), the first upward return alone mixes the
  incoming hyperplane.  A fixed-width boundary covector reduces the
  infinite family to a reduced degree-\(15\)-over-degree-\(3\) rational
  function.  Exact Sturm arithmetic places all eighteen zeros and poles at
  \(q<1\), proving controllability on the full real ray \(q\ge1\); one
  numerator root in \((0,1)\) makes that continuous wall sharp.  The
  denominator is
  \((10q+17)(10q+22)(10q+27)/2\); alternating pole residues identify a
  signed off-diagonal transfer pencil rather than a positive Weyl function.
- The reduced scalar witness now has an intrinsic signed symmetrization.
  The boundary Bezout form \(\operatorname{Bez}(N,D)\) symmetrizes the
  degree-\(15\) numerator companion and has exact inertia \((8,7,0)\).
  The separate positive Hermite forms
  \(\operatorname{Bez}(N,N')\) and \(\operatorname{Bez}(D,D')\) turn the
  scalar Sturm calculation into spectral flow, deriving the consecutive
  numerator and denominator chamber counts \(1|13|0|1\) and \(2|1|0|0\)
  intrinsically.  The signed form alone carries oriented Cauchy data and
  cannot supply unsigned counts.
- The combined normalized operator, apolar-polar, and golden-incidence
  package has minimal base \(\mathbf Z[1/30]\) and structural bad primes
  exactly \(2,3,5\).  An \(11\)-elementary dodecic lattice removes the
  apparent operator failures at \(7,11\); the cross-Gram scalar alone has
  nonstructural collision primes \(11,23\).  The exact identity
  \(\Delta_n^\dagger=-(\,\cdot\,,F)_9/60480\) now isolates the prime \(7\)
  in the Fischer-adjoint normalization itself.
- At \(23\), the cross-Gram scalar generates the conductor-\(23\) suborder
  \(\mathbf Z_{23}+23\mathbf Z_{23}\sqrt5\).  Its coarse special fibre is a
  dual-number point, while normalization gives the inert étale algebra
  \(\mathbf F_{529}\); the divided separator is exactly the missing
  Frobenius-odd normalization generator.  Globally over
  \(\mathbf Z[1/30]\), the scalar image is the conductor-\(253\) order, with
  local defects exactly at the split prime \(11\) and inert prime \(23\).

## Active order

The later McKay-corner classification is active.  The all-weight
two-sided-defect gate and the trivial-module plateau-entry family are
closed, its scalar signed/Hermite pencil is constructed, and bare
multiplicity induction is retired.  The next gate is to construct the
corresponding fixed-width boundary witnesses and block Bezout/Hermite
pencils for the \(2,3,3'\) Kostant modules.  The former twenty-one family
minors remain the fallback.  C682 remains open.

## Parked branches

QG's converse monomial/Gale fibre theorem; E3's all-size full-conic
classification.

## Boundaries and records

C682 is not a paper gate and does not reopen Paper III.  Silver results do
not automatically close it.

Working archive and thematic report index:
`notes/handoffs/2026-07-13-clebsch-c682-archive.md`.
Latest proof bundle:
`notes/2026-07-29-c682-signed-boundary-pencil.md`.
