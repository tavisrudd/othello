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
- The first \(2,3,3'\) plateau families now have exact block three-term
  annihilator recurrences.  Their block sizes are \(2,3,3\), and every
  coefficient is polynomial of total degree at most three in the family
  parameter \(q\) and level \(j\).  The backward block determinants factor
  completely and are nonzero for every integral \(j\ge1\); their only
  nonboundary zeros are the virtual levels
  \(j=\pm1/3,\pm2/3\).  The scalar Jacobi fit is superseded for the trivial
  theorem, but its block continued-fraction analog is exactly the remaining
  nontrivial transfer problem.
- That transfer problem is now closed on the first periodic plateau family
  in each of the three modules.  The exact signed block Wronskian
  \(W_j=y_j^{\mathsf T}C_jx_{j+1}
  -y_{j+1}^{\mathsf T}A_{j+1}x_j\) satisfies the discrete Green identity.
  On the last ten levels, the local boundary quotients have dimensions
  \(3,4,4\), and fixed endpoint-return tuples map onto them.  Direct exact
  determinants also give full quotient surjectivity on every shorter initial
  chain \(q=1,\ldots,9\).  The stable exact
  boundary determinants have degrees \(83,121,120\); after removing only
  roots below \(q=10\), coefficientwise sign certificates prove their
  nonvanishing on the stable ray.  Exact Smith-at-infinity profiles
  \((0^{17},3,4,6)\), \((0^{26},3,4,4,6)\), and
  \((0^{26},3,3,4,8)\) account for every degree lost from the formal bounds.
  Thus at least one endpoint return mixes in every \(2,3,3'\) family.
- The phase-specific operators now lift to finite global Weyl operators in
  the actual invariant exponents \((a,b)\) of \(F^ah^b\).  On the complete
  \(2,3,3'\) Kostant free modules, both the third- and ninth-transvectants
  are exact falling-factorial differential operators of orders \(3,9\).
  Exact larger-grid verification and an independent two-prime replay close
  the operator-construction gate for every modulo-\(60\) phase.  The
  remaining gate is nonvanishing of the compressed quotient determinants,
  not construction of further phase-specific matrices.
- Four additional rays are now all-\(q\) boundary-surjective:
  \(2_{13},3_{14},3'_{14},3'_{18}\) modulo \(20\), with determinant
  degrees \(83,124,122,122\).  Together with the preceding rays, every
  plateau-entry type modulo \(20\) has one certified representative.
  Degree-\(20\) Hilbert translation is not transvectant linearity; the
  exact uncaptured modulo-\(60\) phase count is sixteen.
- All sixteen formerly uncaptured modulo-\(60\) phase quotients are now
  boundary-surjective for every integer \(q\ge1\).  Their exact determinant
  degrees are \(47,81,113,118,120\), depending on module and phase.  The
  resulting anchors propagate through all twenty-one eventual strict peak
  families in the full graded path corner: the all-weight defect theorem
  supplies spanning lower/upper images, while explicit global-Weyl
  two-step compositions certify nonorthogonality.  Every peak witness is
  a coefficientwise one-signed degree-four polynomial from \(q=1\).
  The off-peak path-corner step and the separate three-local-return
  identification remain open.
- Every McKay block of the third transvectant now has maximal rank in
  every weight.  Dehomogenization bounds the total kernel by three;
  central parity and \(C_5\)-weights reduce the unforced cases to
  triangular coefficient-chain minors with diagonals \(d_1\) or
  \(d_{11}\).  This proves the exact one-sided kernel series and removes
  the former finite maximal-rank hypothesis.  It closes all off-peak full
  graded path corners in \(1,2,3,3'\).  The exact remaining frontier is
  sixty-three modulo-\(60\) plateau entrances in the monotone
  \(2',4,4_s,5,6\) modules, or twenty-one types modulo \(20\).
- The monotone global-Weyl package is now constructed on all five remaining
  modules.  Exact order-three/order-nine falling-factorial operators are
  verified beyond their fit grids and independently replayed at two
  primes.  Complete last-seven-level boundary quotients close fifty-one of
  the sixty-three entrance phases for every \(q\ge1\), with quotient
  dimensions \(3,5,5,6,7\) and determinant degrees
  \(67,126,126,156,185\).  The exact residual frontier is twelve phases:
  \(4:\{6,26,46\}\), \(4_s:\{3,23,43\}\),
  \(5:\{4,24,44\}\), and \(6:\{5,25,45\}\).  These are four types modulo
  \(20\); each requires the global signed block Schur complement because
  first returns miss one direction in the raw local quotient.
- The four exceptional modulo-\(20\) signed block Schur recurrences are now
  explicit.  The global level \(\lfloor b/3\rfloor\) makes all twelve phases
  block tridiagonal with interior sizes \(4,4,5,6\).  Every backward block
  factors over the virtual levels \(0,\pm1/3,\pm2/3\), so no integral
  interior step is singular.  Exact elimination leaves phasewise Schur
  complements of sizes \(5|6|7\), \(5|6|7\), \(6|7|9\), and
  \(7|9|11\).  Their selected endpoint determinants are nonzero on the
  exact finite audit \(6\le r\le35\); the following scalar-chain theorem
  supersedes that finite evidence as the load-bearing transversality proof.
- All-\(r\) transversality is now proved for the four exceptional types.
  On coefficient-chain residues \(4,2,2,0\), the growing block problems
  collapse to scalar codimension-one \(C_5\) chains.  A two-coordinate
  boundary minor detects whether \(D_n^\dagger D_n\) preserves the incoming
  hyperplane.  Its exact rational obstruction has numerator degree
  \(17,18,17,18\), respectively; after \(r=6+s\), every numerator
  coefficient is negative and every denominator is positive.  Thus the
  obstruction is strictly negative on the full real ray \(r\ge6\).
  The canonical Fischer endpoint
  \(x=D_{n-6}^\dagger D_n^\dagger D_ny\) has positive Schur contraction.
  Consequently all sixty-three monotone entrances, and hence every graded
  path corner, now propagate.  The old arbitrary coordinate endpoints are
  no longer load-bearing.
- The local-return gate is closed, in a stronger two-form version.  On
  every McKay multiplicity block except \((\mathbf3,22)\), the nearest
  lower and upper Gram returns
  \[
    D_{n-6}D_{n-6}^{\dagger},\qquad D_n^\dagger D_n
  \]
  already generate the full matrix corner.  The signed block Wronskian,
  complete endpoint quotients, strict-peak connectors, and the four
  exceptional scalar obstructions form the cyclic-kernel proof; the
  rectangular endpoint system separates distinct McKay blocks.  Thus the
  full graded path corner equals the requested three-return algebra for
  every \(n\ne22\), and the two-step upward return is redundant.  At
  degree \(22\), the lower \(\mathbf3\)-space is zero and the sole upper
  Gram has rank one on the doubled block, giving the exact \(2<4\)
  obstruction.  A two-prime audit of all \(658\)
  multiplicity-greater-than-one blocks through degree \(180\) corroborates
  the unrestricted Wronskian proof.  This pair is generator-minimal on
  every nontrivial full block: one operator generates a commutative
  polynomial algebra, while the block corner is a noncommutative matrix
  algebra.  Thus the corner is intrinsically the algebra of its two
  canonical positive local energy forms.
- The universal transfer levels
  \(0,\pm1/3,\pm2/3\) now have an intrinsic \(E_8\) explanation.  The
  degree-\(60\) relation \(t^2=1728F^5-h^3\) makes a level step exchange
  \(h^3\) with \(F^5\), so a generator chain has \(h\)-exponent
  \(b=3j+s\).  The third transvectant contributes the indicial factor
  \((b)_3=(3j+s)_3\).  If \(c_s\) counts source chains in residue \(s\),
  the backward determinant is
  \[
    C\prod_{s=0}^2((3j+s)_3)^{c_s}.
  \]
  This gives every recorded root multiplicity, explains the identical
  \(3,3'\) normalized determinants by counts \((1,1,1)\), and explains
  the phase-independent \(6\)-profile by counts \((2,2,2)\).
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
- C690's continuation-lattice comparison identifies the signed
  six-axis orbital operator with the conference matrix extracted from the
  golden axis Gram matrix, up to one exact signed permutation. The coarse
  order is \(\mathbf Z[\sqrt5]\), while the \(t\)-coordinate golden lattice
  is its conductor-two normalization. This is the same prime-\(2\)
  conductor defect on the golden subpackage, but it does not explain away
  C682's additional boundary-rank, apolar, or Mukai--Umemura failures at
  \(2\). Locally it joins the cross-Gram defects at \(11,23\) in the
  universal template \(\mathbf Z_p+p\mathcal O_p\), with normalized fibres
  inert at \(2,23\) and split at \(11\).

## Active order

The McKay-corner classification is complete.  The all-weight
two-sided-defect gate, every modulo-\(60\) plateau-entry phase, all
twenty-one eventual strict peak families, every off-peak propagation step,
all sixty-three monotone entrance phases, and the local-return
identification are closed.  The nearest lower and upper Gram forms already
generate every full block corner; degree \(22\) is the unique exact
failure.  C682 remains open exploration, with completion or selection of a
parked branch left to the user.

## Parked branches

QG's converse monomial/Gale fibre theorem; E3's all-size full-conic
classification.

## Boundaries and records

C682 is not a paper gate and does not reopen Paper III.  Silver results do
not automatically close it.

Working archive and thematic report index:
`notes/handoffs/2026-07-13-clebsch-c682-archive.md`.
Latest proof bundle:
`notes/2026-07-29-c682-monotone-entrance-propagation.md`.
Latest exceptional-transfer bundle:
`notes/2026-07-30-c682-exceptional-monotone-schur.md`.
All-\(r\) exceptional transversality bundle:
`notes/2026-07-30-c682-all-r-schur.md`.
Local-return algebra bundle:
`notes/2026-07-30-c682-local-return-algebra.md`.
\(E_8\) indicial virtual-level bundle:
`notes/2026-07-30-c682-virtual-levels.md`.
