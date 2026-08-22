# Reconstruction, Rigidity, and Rationality in Geometry, Coding, and Quantum Information

- [selected headline results](#selected-headline-results)
- [theorems over infinite families](#theorems-over-infinite-families)
- [papers and entry points](#papers-and-entry-points)
- [abstracts and non-specialist guides](#abstracts-and-non-specialist-guides)
- [verification philosophy](#verification-philosophy)
- [contact and disclosure](#contact-and-disclosure)

This repository summarizes a collection of papers in algebraic and finite
geometry, coding theory, algebraic combinatorics, and quantum information.
They ask two related questions: how much structure can be recovered after most
of the original information has been discarded, and which obstructions persist
under operations, such as stabilization, that might be expected to weaken them?

Every paper is intended to stand on its own mathematically.

The five-paper series *Rigidity from Sparse Shadows* asks how much of a
structured object can be reconstructed from sparse code, matching, incidence,
and cubic-form data. *Reconstructing the Clebsch Code and Its Golden Orientation
from Its Deep-Hole Syndrome Locus*, *Quadratic Trade Rigidity and Cubic
Orientation in Conic Matching Quotients*, and *Golden Descent and Operator
Realizations of the Clebsch Cubic* reconstruct two geometrically different
`A₅`-invariant cubic forms attached to the same six axes: one conference-type
and one chordal. *Chordal and Conference Cubics: Reconstruction and a Residual
C2-Torsor* proves that each form recovers the common carrier and computes the
precise ambiguity in passing between them. *Reconstructing PG(2,13), Its Conic,
and Polarity from the Minimum Words of a Binary Conic Code* develops a separate
code reconstruction: pair data from minimum-weight words recover a marked conic
plane and its polarity.
*Diagonal Isoduality and Transversal Clifford Groups of MDS–CSS Codes* and
*Balanced Cuts of Conference Matrices: Squared-Spectrum Rigidity and Hermitian
Holonomy* are related unnumbered companions.

One main paper and two companions concern irrationality and cycle theory for
cubic threefolds. *Irrationality of Cubic Threefolds after One Stabilization*
proves that `X × P¹` is irrational for every smooth complex cubic threefold
`X`. Its birational invariant counts rank-two blocks of the generic even
quantum `D`-module whose two formal exponent classes differ modulo the
integers. *Integral Divisor Products on the Nonstandard A₅-Invariant Cubic
Pencil* proves universal `CH₀`-triviality for every smooth member of an
explicit non-isotrivial family. *Framed Formal Monodromy of Cubic Threefolds*
computes a finer primitive-sixth count for cubics and their products with
`P¹`; its operation formulas and birational-invariance theorem remain
conditional on two stated hypotheses. The three manuscripts share one
repository but are mathematically separate.
*Hodge Atoms as Occurrence-Indexed Marker Ledgers* develops the same
categorical occurrence/groupoid/fold mechanism for the standard abstract
Hodge-atom construction and derives only its one-step rank-two consequence.
*Gamma Point Rows under Quantum Wall Crossing* pursues
the same quantum obstruction past the first stabilization, to a criterion
covering every projective stabilization under explicit gauged-admissibility
and marked threshold assumptions; it is an early draft.

Many structural components have independent Lean formalizations; coverage is
claim-specific and generally not end-to-end. Each repository states which
parts are prose proofs, cited inputs, kernel-checked formalizations,
certificate-checked computations, or trusted executions. See
[VERIFICATION.md](VERIFICATION.md) for links to the detailed paper-level
evidence maps.

## Selected headline results

These are selected headlines, not a ranking. They are grouped to show the
range of the programme and to avoid counting several facets of one theorem
complex as separate victories.

### Algebraic geometry and rationality

- **One-stabilization irrationality for every smooth cubic threefold.** The
  fourfold `X × P¹` is irrational for every smooth complex cubic threefold
  `X`, and likewise `V × P¹` for every smooth prime Fano
  threefold `V` of genus eight. The proof counts rank-two blocks of the
  generic even quantum `D`-module whose centered leading Euler operator is
  nonzero square-zero and whose two formal exponent classes differ modulo the
  integers. The count vanishes on points, curves, surfaces, and projective
  four-space, but the cubic block has exponent difference `2/3`. The same
  construction gives an irrationality criterion for smooth projective
  threefolds.
  [Irrationality of Cubic Threefolds after One Stabilization](https://github.com/tavisrudd/cubic-stabilization-m1/blob/main/irrationality_after_one_stabilization.pdf).

- **Integral divisor products on the nonstandard `A₅` cubic pencil.** An
  all-degree graph-saturation theorem makes the primitive minimal class of
  the intermediate Jacobian an integral divisor product for every smooth
  member of this non-isotrivial pencil. Consequently every member is
  universally `CH₀`-trivial. Combined with the one-stabilization theorem,
  this gives an explicit family whose products with `P¹` are both universally
  `CH₀`-trivial and irrational.
  [Integral Divisor Products on the Nonstandard A₅-Invariant Cubic Pencil](https://github.com/tavisrudd/cubic-stabilization-m1/blob/main/companions/six-axis-cubic-pencil/six_axis_cubic_pencil.pdf).

- **Framed formal monodromy of cubic threefolds.** The numerical small even
  quantum connection has primitive-sixth count `ν₆(X) = 2`, and the
  unconditional product formula gives `ν₆(X × P¹) = 4`. Under explicit
  reconstruction-tail and residual divisor-tagging hypotheses, the count is
  birationally invariant through dimension four and gives a conditional
  second proof of one-step irrationality.
  [Framed Formal Monodromy of Cubic Threefolds](https://github.com/tavisrudd/cubic-stabilization-m1/blob/main/companions/cubic-framed-monodromy/cubic_framed_monodromy.pdf).

- **Conditionally, every projective stabilization of a smooth cubic
  threefold is irrational.** A common-open point has exact ambient coordinate
  in the Gu--Yu--Yu simple-wall comparison, and projective ordinary-flop
  continuation preserves its intrinsic row on a fixed continuation domain.
  For a global cobordism, support collapse and coefficientwise Gamma-ratio
  reduction combine with a rank-one derived-intersection theorem. In addition
  to the stated gauged-admissibility conditions, the remaining unproved input
  is one-object marked threshold compatibility for the cyclic Rees `z`-modules.
  A crepant toric wall supplies a genuine neutral linear-toric calibration of
  the intrinsic marked-continuation mechanism at the QDM/`I`-function level,
  but not the arbitrary-master inverse system or the zero-mode nearby-cycle
  comparison.
  Under those assumptions, the point-row primary Boolean is birationally
  invariant and distinguishes `X × P^m` from projective space for every smooth
  cubic threefold `X` and every `m ≥ 0`.  That paper is an early draft, likely
  to contain logical gaps and notational issues.
  [Gamma Point Rows under Quantum Wall Crossing and a Criterion for Stable Irrationality](https://github.com/tavisrudd/cubic-stabilization-irrationality/blob/main/cubic_stabilization_irrationality.pdf).

- **Integral and modular decomposition for the cubic-threefold theta
  divisor.** For the theta divisor of every smooth complex cubic threefold,
  the integral middle lattice is free of rank `130` with Lefschetz saturation
  quotient `(Z/2)^10`.  The resolution has two integral outer point summands
  and a residual perverse factor with central map `Z --(-3)--> Z`; modulo
  three that factor is uniserial with successive factors
  `delta_0`, `IC`, `delta_0`.  The same factor three makes relative hard
  Lefschetz fail modulo three, while an infinite-order Fano class lifts the
  local order-three link class.
  [Integral Cohomology and Modular Decomposition for the Theta Divisor of a Cubic Threefold](https://github.com/tavisrudd/blown-up-theta-lattice/blob/main/blown_up_theta_lattice.pdf).

### Finite geometry and reconstruction

- **Universal lower bound and secant-defect identity.** Even after any
  prescribed `q + 1` points are exempted from coverage, a complete-outside arc
  has size at least `√(2q) + 3/2 − 8/√(2q)`. The first two secant moments give
  the exact pointwise-nonnegative defect behind this bound; zero defect forces
  a simple maximum-matching design, and the remainder gives deletion
  stability. [Arcs Complete Outside a Conic: A Prescribed-Hole Defect Identity and Matching-Design Rigidity](https://github.com/tavisrudd/arcs-complete-outside-conic/blob/main/arcs_complete_outside_conic.pdf).

- **Sparse data recover marked finite geometry.** In the Clebsch case, a
  conic-containing deep-hole syndrome locus recognizes the non-GRS
  `[6,3,4]₁₁` code and recovers its conic, polarity, and golden orientation;
  a companion classification proves that `q = 11` is the only field order
  admitting a conic-filling six-arc. In the q=13 case, weighted pair
  concurrences of the 364 minimum words recover the binary code and the marked
  plane `PG(2,13)`, including its conic and polarity. [Reconstructing the Clebsch Code and Its Golden Orientation from Its Deep-Hole Syndrome Locus](https://github.com/tavisrudd/clebsch-rigidity/blob/main/clebsch_rigidity.pdf),
  [Reconstructing PG(2,13), Its Conic, and Polarity from the Minimum Words of a Binary Conic Code](https://github.com/tavisrudd/q13-passant-code/blob/main/passant_code_q13.pdf).

- **Quadratic trades recognize exceptional matching geometries.** Within full
  `PGL₂(q)`-orbits of perfect matchings over odd fields, a two-valued
  strength-two trade occurs only for the `B₃/F₇` and `H₃/F₁₁` geometries.
  The trade recovers their unordered sheets, and the first nonzero signed
  cubic orients them. This carrier condition is sharp: off the matching locus,
  `q − 2` nonmatching orbits retain the same trade.
  [Quadratic Trade Rigidity and Cubic Orientation in Conic Matching Quotients](https://github.com/tavisrudd/clebsch-factorization/blob/main/clebsch_factorization.pdf).

- **Golden descent fixes a conference source and its cubic shadows.** Hitchin's
  harmonic-cubic incidence cover has function field `Q(P(H))(√(5J₀))` and
  finite Stein equation `z² = 5J₀`. After a marked bridge datum is fixed, a
  chosen sheet selects a conference source whose cubic has four exact operator
  descriptions and returns as the exact degree-six Gaunt multiple
  `−784000σ₃/1247103`. The same carrier independently yields exchange-spectrum
  rigidity and sharp reconstruction of two-graphs from aligned four-sets.
  [Golden Descent and Operator Realizations of the Clebsch Cubic](https://github.com/tavisrudd/clebsch-passages/blob/main/clebsch_passages.pdf).

- **Distinct cubic shadows recover one marked carrier.** The signed residue in
  *Quadratic Trade Rigidity and Cubic Orientation in Conic Matching Quotients*
  is a chordal Hankel cubic, not the conference cubic of *Reconstructing the
  Clebsch Code and Its Golden Orientation from Its Deep-Hole Syndrome Locus*
  and *Golden Descent and Operator Realizations of the Clebsch Cubic*. Its
  singular quartic recovers the original six axes by
  exact stabilizer pairs. The two cubics occupy one invariant pencil, and
  the normalized outer difference gives an exact oriented round trip once a
  chordal companion is selected.
  [Chordal and Conference Cubics: Reconstruction and a Residual C2-Torsor](https://github.com/tavisrudd/chordal-conference-reconstruction/blob/main/chordal_conference_reconstruction.pdf).

### Coding theory and quantum information

- **Projective Reed–Solomon deep holes beyond redundancy four.** Split-free
  syndrome directions—and deep holes wherever the covering-radius gate
  applies—are classified at redundancies five and six for every prime power
  `q ≥ 7`, at redundancy seven in the stated split-free/deep-hole ranges, and
  at redundancies eight through ten for `q ≥ 43, 53, 59`, respectively. At
  redundancy five, an all-characteristic count gives splitting density `1/6`
  on the trivial-gcd separable stratum. [Deep Holes of Projective Reed–Solomon Codes Beyond Redundancy Four: Recursive Carriers and Exact Classifications Through Redundancy Ten](https://github.com/tavisrudd/beyond4-prs/blob/main/prs-beyond-redundancy-four.pdf).

- **Exact and quantitative AME rigidity.** Every product-unitary intertwiner
  between stabilizer `AME(2m,q)` states is local Clifford for every prime power
  `q` and `m ≥ 2`. A separate quantitative argument places sufficiently
  approximate local symmetries near exact Clifford symmetries; its rounding and
  robust-atlas arguments remain manuscript-level, as stated in the paper's
  formal boundary. [Local-Unitary Rigidity and Quantitative Rounding](https://github.com/tavisrudd/ame-lu/blob/main/ame-lu.pdf).

- **A nullity test determines MDS–CSS transversal groups.** For odd-prime
  `[2m,m,m+1]q` MDS codes, the diagonal multiplier space has dimension zero or
  one. Its nullity determines whether the projective transversal group is
  `Fq² ⋊ SL₂(q)` or the smaller split-torus branch. [Diagonal Isoduality and Transversal Clifford Groups](https://github.com/tavisrudd/mds-css-transversal-groups/blob/main/mds-css-transversal-groups.pdf).

- **Complete bounded repair ports transfer represented local structure.**
  Support clutters, normalized scalar decoders, and stochastic reliability are
  treated as three layers of one pointed object. Exact weighted-functional
  confinement copies a prescribed bounded port into every block, and
  asymptotically good outer families place it on a positive-density target
  class. [Complete Bounded Repair Ports](https://github.com/tavisrudd/complete-repair-ports/blob/main/complete_repair_ports.pdf).

- **Order six is the unique nontrivial cut-rigid symmetric conference
  order.** For a balanced half (Y) of a symmetric conference matrix, the
  normalized cross-block Gram spectrum is independent of (Y) exactly in the
  trivial order-two case and at order six. In the Hermitian order-six problem,
  squared real triangle holonomy parametrizes the complete degree-three Pareto
  frontier; cutwise constancy of any one sector characterizes the real
  switching class, with a quantitative stability bound.
  [Balanced Cuts of Conference Matrices](https://github.com/tavisrudd/conference-cut-spectra/blob/main/conference_cut_spectra.pdf).

## Theorems over infinite families

The exceptional Clebsch, `q = 13`, and `q = 11` objects arise as answers to
general questions rather than as assumptions. The following table records
selected infinite-family statements from the major papers; when a statement
is conditional, its hypothesis is displayed in the theorem column.

| Paper | General theorem | Quantifier range |
|---|---|---|
| Irrationality of Cubic Threefolds after One Stabilization | `X × P¹` is irrational, detected by a rank-two generic-even-QDM block with distinct formal exponent classes modulo the integers. | Every smooth complex cubic threefold `X`. |
| Irrationality of Cubic Threefolds after One Stabilization | A smooth projective threefold whose generic even QDM contains such a marked block is irrational. | Every smooth projective complex threefold. |
| Irrationality of Cubic Threefolds after One Stabilization | `V × P¹` is irrational. | Every smooth prime Fano threefold `V` of genus eight. |
| Integral Divisor Products on the Nonstandard A₅-Invariant Cubic Pencil | Finite-etale graph slopes make every divided power of the marked graph divisor lattice an ordinary integral divisor product. | Every marked finite-etale graph quotient of an elliptic power satisfying the stated local depth and self-adjointness hypotheses, in every degree. |
| Integral Divisor Products on the Nonstandard A₅-Invariant Cubic Pencil | Every smooth pencil member is universally `CH₀`-trivial; after multiplication by `P¹`, it remains universally `CH₀`-trivial and is irrational. | Every smooth member of the nonstandard `A₅`-invariant cubic pencil. |
| Framed Formal Monodromy of Cubic Threefolds | The primitive-sixth framed-monodromy count of the numerical small even quantum connection equals two. | Every smooth complex cubic threefold `X`. |
| Framed Formal Monodromy of Cubic Threefolds | The primitive-sixth count of a product with projective space is that of the factor times one more than the dimension. | Every smooth projective variety and every projective space. |
| Framed Formal Monodromy of Cubic Threefolds | Assuming the reconstruction-tail and residual divisor-tagging hypotheses, the primitive-sixth count is birationally invariant. | All smooth projective varieties of dimension at most four. |
| Reconstructing the Clebsch Code and Its Golden Orientation from Its Deep-Hole Syndrome Locus | If an arc's uncovered locus is a nonsingular conic, then `q` is odd and `2k − 3 ≤ q ≤ (k(k − 1) + 3)/3`. | Every `k`-arc with `k ≥ 4`, over every finite field order `q`. |
| Computational Strengthenings of Clebsch Syndrome Rigidity | `q = 11` is the only field order admitting a conic-filling six-arc. | Every field order. |
| Quadratic Trade Rigidity and Cubic Orientation in Conic Matching Quotients | The strength-two trade space is one-dimensional and generated by a two-valued vector if and only if the orbit is `B₃/F₇` or `H₃/F₁₁`. | Full `PGL₂(q)`-orbits of perfect matchings, for every odd prime power `q`. |
| Golden Descent and Operator Realizations of the Clebsch Cubic | Aligned four-sets reconstruct the two-graph up to complement, and seven is sharp. | Every two-graph on at least seven vertices. |
| Arcs Complete Outside a Conic: A Prescribed-Hole Defect Identity and Matching-Design Rigidity | The first two secant moments give an exact defect identity with pointwise nonnegative remainder. | Every `k`-arc with `k ≥ 3` in every finite projective plane, and every prescribed hole set disjoint from the arc. |
| Deep Holes of Projective Reed–Solomon Codes Beyond Redundancy Four: Recursive Carriers and Exact Classifications Through Redundancy Ten | Split-free directions, and deep holes wherever the covering-radius gate applies, are classified in the stated ranges. | R5–R6: every `q ≥ 7`; R7: split-free for every `q ≥ 7` and deep holes for `q ≥ 11`; R8–R10: `q ≥ 43, 53, 59`. |
| Deep Holes of Projective Reed–Solomon Codes Beyond Redundancy Four: Recursive Carriers and Exact Classifications Through Redundancy Ten | On the trivial-gcd separable stratum, `#Y = 6N + 3d₂ + d₃` in every characteristic. | Every field order and characteristic. |
| Local-Unitary Rigidity and Quantitative Rounding for Stabilizer AME States | Every product-unitary intertwiner between stabilizer `AME(2m,q)` states is Clifford on each party. | Every prime power `q = pᵉ` and `m ≥ 2`. |
| Diagonal Isoduality and Transversal Clifford Groups of MDS–CSS Codes | The diagonal multiplier nullity fixes the transversal logical group. | All `[2m,m,m+1]q` MDS codes over odd prime fields. |
| Balanced Cuts of Conference Matrices: Squared-Spectrum Rigidity and Hermitian Holonomy | Order six is the unique nontrivial realized symmetric conference order whose normalized balanced cross-block Gram spectrum is cut-independent. | Every symmetric conference matrix and every balanced half. |
| Complete Bounded Repair Ports: Transfer, Reliability, and Geometric Structure | The minimum coefficient port reconstructs the represented code, although its support projection is the generic complete uniform clutter. | Every proper `[n,k]q` MDS code with `1 ≤ k < n`, at every distinguished coordinate. |
| Complete Bounded Repair Ports: Transfer, Reliability, and Geometric Structure | Exact weighted-functional confinement transfers every represented bounded support and coefficient port below the pointed zero-functional threshold onto a designated positive-density target class. | Every fixed inner encoder and outer family with dual distance tending to infinity; asymptotic goodness follows from the stated classical outer-family inputs. |
| Integral Cohomology and Modular Decomposition for the Theta Divisor of a Cubic Threefold | The integral middle lattice has rank `130` and saturation quotient `(Z/2)^10`; the integral resolution complex has central Smith factor three, a length-three mod-three Loewy chain, and modular relative-hard-Lefschetz failure. | The theta divisor of every smooth complex cubic threefold. |

## Papers and entry points

Each link below points to the public PDF file and repository on GitHub. Each
repository README gives the paper's scope, current status, formalization
boundary, and reproducible entry points.

| Paper | Area | Central result | Public entry |
|---|---|---|---|
| Irrationality of Cubic Threefolds after One Stabilization | Algebraic geometry / birational geometry | Every smooth cubic threefold stays irrational after multiplication by `P¹`, detected by a rank-two block of the generic even quantum `D`-module with distinct formal exponent classes modulo the integers. | [PDF](https://github.com/tavisrudd/cubic-stabilization-m1/blob/main/irrationality_after_one_stabilization.pdf) · [repo](https://github.com/tavisrudd/cubic-stabilization-m1) |
| Integral Divisor Products on the Nonstandard A₅-Invariant Cubic Pencil | Algebraic geometry / algebraic cycles | Every smooth member of the non-isotrivial pencil is universally `CH₀`-trivial; after multiplication by `P¹`, it remains universally `CH₀`-trivial and is irrational. | [PDF](https://github.com/tavisrudd/cubic-stabilization-m1/blob/main/companions/six-axis-cubic-pencil/six_axis_cubic_pencil.pdf) · [repo](https://github.com/tavisrudd/cubic-stabilization-m1) |
| Framed Formal Monodromy of Cubic Threefolds | Algebraic geometry / quantum cohomology | The unconditional count is `ν₆(X) = 2` and satisfies the projective-space product formula; its operation formulas and birational invariance remain conditional on two explicit hypotheses. | [PDF](https://github.com/tavisrudd/cubic-stabilization-m1/blob/main/companions/cubic-framed-monodromy/cubic_framed_monodromy.pdf) · [repo](https://github.com/tavisrudd/cubic-stabilization-m1) |
| Deep Holes of Projective Reed–Solomon Codes Beyond Redundancy Four: Recursive Carriers and Exact Classifications Through Redundancy Ten | Coding theory | Deep-hole classifications extend through redundancy ten in stated ranges. | [PDF](https://github.com/tavisrudd/beyond4-prs/blob/main/prs-beyond-redundancy-four.pdf) · [repo](https://github.com/tavisrudd/beyond4-prs) |
| Local-Unitary Rigidity and Quantitative Rounding for Stabilizer AME States | Quantum information | Exact local-unitary rigidity has a separate quantitative rounding theorem. | [PDF](https://github.com/tavisrudd/ame-lu/blob/main/ame-lu.pdf) · [repo](https://github.com/tavisrudd/ame-lu) |
| Reconstructing the Clebsch Code and Its Golden Orientation from Its Deep-Hole Syndrome Locus | Finite geometry / coding | Deep-hole data recognize the Clebsch code and golden orientation. | [PDF](https://github.com/tavisrudd/clebsch-rigidity/blob/main/clebsch_rigidity.pdf) · [repo](https://github.com/tavisrudd/clebsch-rigidity) |
| Quadratic Trade Rigidity and Cubic Orientation in Conic Matching Quotients | Algebraic combinatorics | On the matching carrier, a two-valued quadratic trade classifies two exceptional geometries and a cubic orients their sheets. | [PDF](https://github.com/tavisrudd/clebsch-factorization/blob/main/clebsch_factorization.pdf) · [repo](https://github.com/tavisrudd/clebsch-factorization) |
| Golden Descent and Operator Realizations of the Clebsch Cubic | Algebraic geometry / combinatorics | An exact arithmetic incidence cover selects a marked conference source whose cubic shadows return in degree-six harmonics; exchange rigidity and two-graph reconstruction follow independently. | [PDF](https://github.com/tavisrudd/clebsch-passages/blob/main/clebsch_passages.pdf) · [repo](https://github.com/tavisrudd/clebsch-passages) |
| Reconstructing PG(2,13), Its Conic, and Polarity from the Minimum Words of a Binary Conic Code | Coding / finite geometry | Weighted pair data on minimum words recover a marked projective plane, conic, and polarity. | [PDF](https://github.com/tavisrudd/q13-passant-code/blob/main/passant_code_q13.pdf) · [repo](https://github.com/tavisrudd/q13-passant-code) |
| Chordal and Conference Cubics: Reconstruction and a Residual C2-Torsor | Invariant theory / algebraic combinatorics | Distinct chordal and conference cubics recover one marked six-axis carrier and admit an exact oriented marked return. | [PDF](https://github.com/tavisrudd/chordal-conference-reconstruction/blob/main/chordal_conference_reconstruction.pdf) · [repo](https://github.com/tavisrudd/chordal-conference-reconstruction) |
| Hodge Atoms as Occurrence-Indexed Marker Ledgers | Algebraic geometry / quantum cohomology | The standard abstract Hodge-atom chemical formula is the Hodge specialization of an occurrence-indexed categorical marker ledger, with an effective weak-factorization quotient and a strictly one-step rank-two obstruction. | [PDF](https://github.com/tavisrudd/hodge-atom-marker-ledger/blob/main/hodge_atom_marker_ledger.pdf) · [repo](https://github.com/tavisrudd/hodge-atom-marker-ledger) |
| Gamma Point Rows under Quantum Wall Crossing and a Criterion for Stable Irrationality | Algebraic geometry / quantum cohomology | A rank-one derived-clutching theorem, an exact simple-wall ambient point coordinate, ordinary-flop point-row transport, global support collapse, and Gamma reduction give an all-stabilizations criterion under explicit gauged-admissibility and marked threshold assumptions. | [PDF](https://github.com/tavisrudd/cubic-stabilization-irrationality/blob/main/cubic_stabilization_irrationality.pdf) · [repo](https://github.com/tavisrudd/cubic-stabilization-irrationality) |
| Standard Flips of Discrepancy One: Extremal J-Normalization and the Meijer Aperture at ν=1 | Algebraic geometry / quantum cohomology | An exact `z`-order count and the `ν=1` Barnes sector complete the discrepancy-one range in Shen--Shoemaker's extremal flip theorem. | [PDF](https://github.com/tavisrudd/discrepancy-one-flips/blob/main/discrepancy_one_flips.pdf) · [repo](https://github.com/tavisrudd/discrepancy-one-flips) |
| Arcs Complete Outside a Conic: A Prescribed-Hole Defect Identity and Matching-Design Rigidity | Finite geometry / designs | A universal pointwise defect identity gives matching-design rigidity, stability, and conic-relative bounds. | [PDF](https://github.com/tavisrudd/arcs-complete-outside-conic/blob/main/arcs_complete_outside_conic.pdf) · [repo](https://github.com/tavisrudd/arcs-complete-outside-conic) |
| Diagonal Isoduality and Transversal Clifford Groups of MDS–CSS Codes | Quantum coding / finite geometry | A diagonal-isoduality nullity test determines the projective transversal group. | [PDF](https://github.com/tavisrudd/mds-css-transversal-groups/blob/main/mds-css-transversal-groups.pdf) · [repo](https://github.com/tavisrudd/mds-css-transversal-groups) |
| Balanced Cuts of Conference Matrices: Squared-Spectrum Rigidity and Hermitian Holonomy | Matrix theory / algebraic combinatorics / mathematical physics | Order six is the unique nontrivial cut-independent case; Hermitian triangle holonomy controls the degree-three frontier and rigidity. | [PDF](https://github.com/tavisrudd/conference-cut-spectra/blob/main/conference_cut_spectra.pdf) · [repo](https://github.com/tavisrudd/conference-cut-spectra) |
| Integral Cohomology and Modular Decomposition for the Theta Divisor of a Cubic Threefold | Algebraic geometry / topology | The rank-130 integral middle lattice has canonical mod-two glue, while the same resolution carries a factor-three integral perverse attachment, a length-three modular Loewy chain, and failure of relative hard Lefschetz modulo three. | [PDF](https://github.com/tavisrudd/blown-up-theta-lattice/blob/main/blown_up_theta_lattice.pdf) · [repo](https://github.com/tavisrudd/blown-up-theta-lattice) |
| Frobenius-equivariant Pair Extension and Robust Repair of Eight-Arcs | Finite geometry / coding theory | Fixed mate-line carriers and exact collision corrections give Frobenius-compatible paired MDS extensions, including the exact two-fixed-point minimum over F₂₅. | [PDF](https://github.com/tavisrudd/equivariant-robust-completion/blob/main/equivariant-robust-completion.pdf) · [repo](https://github.com/tavisrudd/equivariant-robust-completion) |
| Complete Bounded Repair Ports: Transfer, Reliability, and Geometric Structure | Coding theory / reliability | Exact weighted-functional confinement transfers represented bounded repair ports to positive-density coordinate classes, retaining both support and normalized decoder data. | [PDF](https://github.com/tavisrudd/complete-repair-ports/blob/main/complete_repair_ports.pdf) · [repo](https://github.com/tavisrudd/complete-repair-ports) |

The repository for *Reconstructing the Clebsch Code and Its Golden Orientation
from Its Deep-Hole Syndrome Locus* also contains the computational companion
*Computational Strengthenings of Clebsch Syndrome Rigidity*. It supplies exact
finite classifications and replayable evidence for the main paper rather than
a separate series paper.

## Abstracts and non-specialist guides

The abstracts below are the papers' own abstract text, with local LaTeX macros
rendered in plain Markdown notation. Each is followed by a non-specialist
guide: what the paper delivers, who may care, and why it matters. If you are
new to the subject, use those three guide paragraphs as the orientation and
then read the abstract for the paper's technical statement.

### Highlights

#### Irrationality of Cubic Threefolds after One Stabilization

[PDF](https://github.com/tavisrudd/cubic-stabilization-m1/blob/main/irrationality_after_one_stabilization.pdf) · [Repository](https://github.com/tavisrudd/cubic-stabilization-m1) · [![DOI](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.21909943-blue.svg)](https://doi.org/10.5281/zenodo.21909943)

**Standout results.** Every smooth complex cubic threefold stays irrational
after multiplication by a projective line, and the same holds
for every smooth prime Fano threefold of genus eight. The invariant counts
rank-two blocks of the generic even quantum `D`-module whose centered leading
Euler operator is nonzero square-zero and whose two formal exponent classes
differ modulo the integers. It also gives an irrationality criterion for
smooth projective threefolds.

> *Abstract* We prove that X × P¹ is irrational for every smooth complex cubic threefold X. On the generic even quantum D-module, our invariant counts rank-two formal connection blocks whose centered leading Euler operator is nonzero square-zero and whose two formal exponent classes differ modulo the integers. Blowup and projective-bundle decompositions make this count birationally invariant because all low-dimensional centers contribute zero. It distinguishes X × P¹ from P⁴. The same count gives an irrationality criterion for smooth projective threefolds, the one-stabilization theorem for prime Fano threefolds of genus eight, and separation results on known universally CH₀-trivial loci.

**Delivers.** An unconditional birational obstruction after one
projective-line stabilization for every smooth cubic threefold; a QDM-side
irrationality criterion for smooth projective threefolds; the same
one-stabilization result for prime Fano threefolds of genus eight; and
separation from universal `CH₀`-triviality on several known loci.

**Who cares.** Algebraic geometers working on rationality, stable rationality,
intermediate Jacobians, algebraic cycles, quantum connections, or weak
factorization.

**Why it matters.** Failure of universal `CH₀`-triviality is a standard
obstruction to stable rationality, but its validity is not a parametrization.
This paper makes that limitation concrete after an actual stabilization, and
its formal-exponent marker is a direct quantum-`D`-module invariant that
applies to every smooth cubic threefold. The classical route stops short here:
after one
stabilization the direct Clemens–Griffiths mechanism gives no contradiction,
because `H³(X × P¹)` is still `H³(X)`, which the Fano surface of lines
already carries as its `H¹` up to twist, while the middle `H⁴` is Tate.  The
recent fourfold criteria that read Hodge data through quantum spectral
packets do not reach this geometry either, since they assume `b₃ = 0` and a
large vanishing middle `H⁴`.  The paper claims no novelty for that broad
philosophy; what is new is the formal-exponent marker and the operation ledger
that carries it through one stabilization.

---

#### Integral Divisor Products on the Nonstandard A₅-Invariant Cubic Pencil

[PDF](https://github.com/tavisrudd/cubic-stabilization-m1/blob/main/companions/six-axis-cubic-pencil/six_axis_cubic_pencil.pdf) · [Repository](https://github.com/tavisrudd/cubic-stabilization-m1) · [![DOI](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.21909943-blue.svg)](https://doi.org/10.5281/zenodo.21909943)

**Standout result.** Every smooth member of the nonstandard
`A₅`-invariant cubic pencil is universally `CH₀`-trivial. Combined with the
one-stabilization theorem, this gives a non-isotrivial family whose products
with `P¹` are universally `CH₀`-trivial and irrational.

> *Abstract* We study the nonstandard A₅-invariant pencil of smooth cubic threefolds. A six-axis polarization identifies its exotic two-primary gluing packet and constrains odd-degree product decompositions of the intermediate Jacobian. An all-degree integral graph-saturation theorem then proves algebraicity of the primitive minimal class for every smooth member. Consequently every member is universally CH₀-trivial. The family is non-isotrivial, and all but its Fermat point lie outside both the separated-variable locus and the explicit coprime-degree family of Yang–Yu–Zhu. Combined with the one-stabilization theorem for cubic threefolds, this gives a non-isotrivial family whose products with P¹ are universally CH₀-trivial and irrational.

**Delivers.** A six-axis description of the intermediate-Jacobian
polarization, an all-degree integral divisor-product theorem, universal
`CH₀`-triviality for the pencil, and its separation from stabilized
irrationality.

**Who cares.** Algebraic geometers working on cubic threefolds, algebraic
cycles, intermediate Jacobians, and universal `CH₀`-triviality.

**Why it matters.** Universal `CH₀`-triviality is necessary for stable
rationality but does not provide a parametrization. This family shows that it
can coexist with irrationality after an actual projective-line
stabilization.

---

#### Framed Formal Monodromy of Cubic Threefolds

[PDF](https://github.com/tavisrudd/cubic-stabilization-m1/blob/main/companions/cubic-framed-monodromy/cubic_framed_monodromy.pdf) · [Repository](https://github.com/tavisrudd/cubic-stabilization-m1) · [![DOI](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.21909943-blue.svg)](https://doi.org/10.5281/zenodo.21909943)

**Standout result.** The framed primitive-sixth count satisfies
`ν₆(X) = 2` and `ν₆(X × P¹) = 4` for every smooth cubic threefold. These
computations are unconditional; the operation formulas and birational
invariance are conditional on two explicit hypotheses.

> *Abstract* We define a framed formal-monodromy count ν₆ for the numerical small even quantum connection and compute ν₆(X) = 2 and ν₆(X × P¹) = 4 for every smooth cubic threefold. The calculation and product formula are unconditional. Under an explicit reconstruction-tail hypothesis, the count satisfies blowup and projective-bundle formulas; under a separate residual divisor-tagging hypothesis for the remaining surface centers, it is birationally invariant through dimension four. These hypotheses give a conditional second proof of one-step irrationality and the conditional identity ν₆(V) = 2 for prime Fano threefolds of genus eight. We isolate the exact comparison statements still needed to make the refinement unconditional.

**Delivers.** The unconditional cubic and product computations, explicit
conditional operation formulas, and a precise statement of the remaining
comparison hypotheses.

**Who cares.** Researchers in quantum cohomology, formal monodromy, and
birational geometry.

**Why it matters.** The framed count retains more small-point information than
the primary paper's generic formal-exponent marker. The companion keeps that
refinement and its unresolved provider assumptions separate from the
unconditional one-stabilization proof.

---

#### Deep Holes of Projective Reed–Solomon Codes Beyond Redundancy Four: Recursive Carriers and Exact Classifications Through Redundancy Ten

[PDF](https://github.com/tavisrudd/beyond4-prs/blob/main/prs-beyond-redundancy-four.pdf) · [Repository](https://github.com/tavisrudd/beyond4-prs) · [![DOI](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.21682069-blue.svg)](https://doi.org/10.5281/zenodo.21682069)

**Standout result.** Exact projective Reed–Solomon deep-hole classifications
extend to redundancies five and six for every prime power q ≥ 7, with further
exact ranges through redundancy ten.  At redundancy five the split members of
the pencil are counted exactly in every characteristic on the trivial-gcd
separable stratum.  The count gives splitting density 1/6 and Chebotarev main
term (q + 1)/6 with Weil-scale error, lowers the threshold for a split witness
to q ≥ 20, and cuts the finite residue to seven fields.

> *Abstract* We classify projective Reed–Solomon split-free syndrome directions, in the stated field ranges, from the first previously open case, redundancy five, through redundancy ten, and obtain deep-hole classifications wherever the covering-radius gate is available. A syndrome is split-free precisely when its two-row Hankel kernel contains no completely split squarefree form. At redundancy five, this kernel is a pencil of cubics. At higher redundancy, coherent polar contraction retains a removed root as a marker, allowing a lower split witness to lift without repetition.
>
> The split members of the R5 pencil are counted exactly. On the trivial-gcd separable stratum, #Y_f(F_q) = 6N_f + 3d₂ + d₃, where N_f counts the completely split squarefree members, d₂ those with a rational double root, d₃ the perfect cubes, and Y_f is the off-diagonal fiber square. The proof counts rational roots fiber by fiber and uses no discriminant, so it holds in every characteristic. The identity class has splitting density 1/6, giving the Chebotarev main term (q + 1)/6; the identity bounds N_f two-sidedly around that main term at Weil scale, lowers the geometric threshold for a split witness to q ≥ 20, and in characteristic two leaves no split-free S₃ pencil once q ≥ 16. The finite bridge is therefore q ∈ {7, 8, 9, 11, 13, 17, 19}.
>
> For every r ≥ 6, the reduced recursively contained locus is exactly the union of the catalecticant rank-two scheme and one maximal adjacent-zero Lucas carrier. Dense squarefree-marker contractions select one terminal component, while Pascal nesting merges all modular descendants into that carrier. This component theorem is unconditional. The finite-field escape statement is separate: if the explicit pointed lower packages exist at every intermediate redundancy, then q ≥ 6r − 15 + ⌊2√(6r − 17)⌋ forces every split-free syndrome into this carrier. Under the same hypothesis, when char F_q > r − 1, the Lucas carrier is empty; the radius theorem then leaves exactly the tangent and conjugate-secant deep-hole families, with q(q + 1)²/2 projective directions.
>
> The required packages are discharged at the fixed levels. Redundancies five and six are classified for every q ≥ 7; redundancy seven has a complete split-free classification for every q ≥ 7, which is a deep-hole classification for q ≥ 11; and redundancies eight, nine, and ten have exact deep-hole classifications for q ≥ 43, 53, and 59, respectively. Certificates close the bounded R5–R7 residues, the full degree-nine Lucas carrier at q = 16, 32, and its invariant block at q = 64. A final-pair Artin–Schreier argument then proves that at redundancy ten the Hankel kernel of every point on the full degree-nine Lucas carrier contains a split squarefree form over F_(2^m), m ≥ 4.
>
**Delivers.** Exact classifications of received words maximally distant from a
major family of error-correcting codes, extending well beyond the first few
understood cases.

**Who cares.** Coding theorists working on Reed–Solomon codes, covering radius,
and polynomial interpolation.

**Why it matters.** “Deep holes” are maximally far from every codeword.  Their
classification clarifies the codes' worst-case distance geometry and provides
a recursive way to organize many field sizes and redundancies.

---

#### Local-Unitary Rigidity and Quantitative Rounding for Stabilizer AME States

[PDF](https://github.com/tavisrudd/ame-lu/blob/main/ame-lu.pdf) · [Repository](https://github.com/tavisrudd/ame-lu) · [![DOI](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.21681856-blue.svg)](https://doi.org/10.5281/zenodo.21681856)

**Standout results.** Every product-unitary equivalence between stabilizer AME
states is local Clifford. A quantitative rounding theorem also places
sufficiently approximate symmetries near exact Clifford symmetries.

> *Abstract* Let q = pᵉ and m ≥ 2. Every product-unitary intertwiner between two stabilizer AME(2m,q) states is Clifford on each party. The proof recovers the complete local Weyl frame from any (m + 1)-party marginal: the supported stabilizer labels form a q²-element group and project bijectively onto the local Weyl labels. These support bijections also form a minimum-support atlas which classifies local-unitary equivalence up to local symplectic changes of frame. As an encoder consequence, every transversal conversion between the associated [[2m−1,1,m]]q stabilizer codes is Clifford on every physical and logical factor.
>
> We prove a quantitative counterpart without reading the exponentially small Weyl signal of one marginal. Viewing each party as the logical leg of the associated code, a leakage-aware three-region cleaning argument and Weyl–Fourier concentration round every local factor within 8ε of a Clifford. The uniform stabilizer overlap gap then selects an exact symmetry and gives a defect-only decomposition radius Θ(min{p⁻¹, q⁻¹ᐟ², n⁻¹ᐟ²}), n = 2m, with residual generator norm at most π√q ε. At a dimension-only radius the rounded symplectic maps already satisfy the exact minimum-support atlas. The remaining obstruction is affine: localized commutators cancel the stabilizer-character phases and therefore cannot control the product-Pauli correction. On generalized and extended Reed–Solomon AME families the certified scale is Θ(q⁻¹) over prime fields and Θ(q⁻¹ᐟ²) at extension degree at least two.
>
**Delivers.** Exact product-unitary changes between a broad class of highly
entangled quantum states must come from the code's discrete symmetry group;
approximate changes are quantitatively close to that group.

**Who cares.** Quantum-information theorists, stabilizer-code researchers, and
people studying robust classifications of entangled states.

**Why it matters.** The result gives both an exact classification and a
noise-tolerant version, which is essential when experiments and numerical
models produce near-symmetries rather than perfect ones.

---

### Rigidity from Sparse Shadows

#### Reconstructing the Clebsch Code and Its Golden Orientation from Its Deep-Hole Syndrome Locus

[PDF](https://github.com/tavisrudd/clebsch-rigidity/blob/main/clebsch_rigidity.pdf) · [Repository](https://github.com/tavisrudd/clebsch-rigidity) · [![DOI](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.21652792-blue.svg)](https://doi.org/10.5281/zenodo.21652792)

**Standout result.** Deep-hole data recover the non-GRS Clebsch code, its
conic and polarity, and its golden orientation, including an operator with
`B² = 5I`; and eleven is not an arbitrary choice of field, because a
Sylvester-graph obstruction in the computational companion shows that q = 11
is the only field order admitting a conic-filling six-arc at all.

> *Abstract* Let A be a six-arc in PG(2,11), and let U(A) be the projective points lying on no chord of A. For the associated [6,3,4]₁₁ MDS code, U(A) is its projective deep-hole syndrome locus. We prove that U(A) lies on a conic if and only if A is projectively equivalent to the Clebsch hexagon; in that case U(A) is exactly a nonsingular conic. Thus nearest-codeword data reconstruct the non-GRS Clebsch code up to monomial equivalence: the projective deep-hole locus is a recognition invariant whose metric boundary data recover the parity-check geometry. The reconstructed conic then determines its polarity, and Dye's theorem identifies the stabilizer as A₅; none of this geometry is assumed.
>
> Nearest-codeword ambiguity then reconstructs an unordered orientation torsor on six axes. Its signed orbital operator satisfies B² = 5I, and triangle holonomy gives the support cubic through cᵢⱼₖ = BᵢⱼBⱼₖBₖᵢ; equivalently, this cubic is the sole nonsymmetric term in the diagonal determinant pencil of B. Thus the same syndrome and support data recover both the code and its golden orientation; coset-leader ambiguity recovers not only incidence and symmetry but the integral quadratic order Z[B] ≃ Z[√5].
>
> The proof uses a universal chord-defect identity and a partial-cover bound for rigidity, then decoder ambiguity and the orbital pentagon for orientation. As a secondary uniform consequence, any k-arc whose uncovered locus is a nonsingular conic has q odd, with 2k − 3 ≤ q ≤ (k(k − 1) + 3)/3. Thus for each fixed k, the all-field existence problem reduces to finitely many field orders.
>
**Delivers.** The pattern of the errors farthest from every valid codeword
identifies the code itself and reveals an underlying golden arithmetic
structure.

**Who cares.** Coding theorists, finite geometers, and researchers interested
in inverse problems or in what can be learned from failures.

**Why it matters.** Error-pattern data can expose a code's underlying geometry
even when the code is not given directly.  The result turns indirect evidence
into a complete reconstruction theorem, and it is not confined to one field:
the same chord-defect argument gives a field window for every k-arc, and the
companion shows that eleven is the only field order where a conic-filling
six-arc exists.  The chord-defect identity used here is the special case, for
one arc in PG(2,q), of the all-planes secant-moment identity proved in Arcs
Complete Outside a Conic below.

---

#### Quadratic Trade Rigidity and Cubic Orientation in Conic Matching Quotients

[PDF](https://github.com/tavisrudd/clebsch-factorization/blob/main/clebsch_factorization.pdf) · [Repository](https://github.com/tavisrudd/clebsch-factorization) · [![DOI](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.21682217-blue.svg)](https://doi.org/10.5281/zenodo.21682217)

**Standout result.** Within the full matching carrier, a two-valued quadratic
trade singles out the B₃/F₇ and H₃/F₁₁ geometries and recovers their unordered
sheets; the first nonzero signed cubic orients them. Off the carrier, `q − 2`
nonmatching orbits retain the same trade.

> *Abstract* Restriction to a conic forgets how its marked points were paired into secants. Among full PGL₂(q)-orbits of perfect matchings over odd finite fields, we classify those whose conic-quotient evaluation space has a one-dimensional strength-two trade—a signed relation annihilating all quadratic coordinate products—generated by a two-valued vector. Exactly two occur: the balanced B₃/F₇ and H₃/F₁₁ orbits. The trade recovers their two complementary sheets, without assuming self-association or Gorensteinness.
>
> The restriction to perfect matchings is sharp. For either surviving stabilizer, its fixed locus in the ambient conic-product fiber is an affine line of q pairwise nonconjugate rational points. Only the matching point splits completely into linear factors, although q − 2 nonmatching orbits have the same one-dimensional two-valued strength-two trade condition. Thus complete splitting selects the matching orbit from the fixed line. The exceptional one-factorizations are classical; the new boundary is the fixed line and its unique completely split point.
>
> For the two matching configurations, the first nonzero signed tensor moment is an anti-invariant cubic. Their 14- and 22-point homogenizations are self-associated and arithmetically Gorenstein, and maximal isotropy identifies the cubic with the Macaulay inverse system of an Artinian reduction. General self-dual-code criteria already explain the Gorenstein consequence of the Schur square; the configuration-specific contributions are the all-field orbit classification, sharp matching boundary, sheet reconstruction, and cubic orientation. Targeted modular detectors, made exhaustive by Faber's tame subgroup theorem, exclude every other matching orbit without a field census. A common alternating-cycle and Dickson calculation supplies the radial nonvanishing needed for the quotient ranks.
>
**Delivers.** On the matching carrier, a two-level balancing pattern forces one
of two exceptional pairing geometries and recovers its unordered sheets; a
signed cubic then supplies their orientation.

**Who cares.** Finite geometers, combinatorialists, and researchers studying
designs, matchings, or symmetry-breaking invariants.

**Why it matters.** Local counting rules can recover pairing information that
has been deliberately erased.  A signed cubic invariant supplies the missing
orientation information.

---

#### Golden Descent and Operator Realizations of the Clebsch Cubic

[PDF](https://github.com/tavisrudd/clebsch-passages/blob/main/clebsch_passages.pdf) · [Repository](https://github.com/tavisrudd/clebsch-passages) · [![DOI](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.21682515-blue.svg)](https://doi.org/10.5281/zenodo.21682515)

**Standout results.** Hitchin's incidence cover has exact function field
Q(P(H))(√(5J₀)) and finite Stein equation z² = 5J₀. Relative to a marked
bridge datum, its conference-source cubic has four exact operator descriptions
and returns as the degree-six Gaunt multiple −784000σ₃/1247103. Exchange
rigidity and sharp two-graph reconstruction are independent consequences.

> *Abstract* Let H be the rational seven-space of harmonic cubics. Hitchin's icosahedral incidence variety is generically a degree-two cover of P(H). We prove that its function field is Q(P(H))(√(5J₀)), where J₀ is the rational equation of the reduced branch sextic normalized by ιₜ*J₀ = 16σ₃² on the Clebsch chart. The complete reduced fibre over [xyz] has residue algebra Q(√5) and determines the twist; the finite Stein algebra is O ⊕ O(−3) with multiplication z² = 5J₀.
>
> After an ordering, chart lift, outer labels, and Petersen labels are fixed as a marked bridge datum, a chosen sheet selects an order-six conference source or its opposite. The sheet alone supplies none of that marking. The source cubic and its six outer translates have four exact descriptions: triangle holonomy, middle-exterior diagonal, commutator Pfaffian, and oriented cross-golden determinant. They give the signed Joubert–Segre–Igusa–Clebsch chain. On the Petersen four-space the degree-six zonal-harmonic cubic restricts exactly to −784000σ₃/1247103. This is a relative sign comparison between cubics on different spaces, not an identification of their ambient harmonic representations.
>
> The same conference carrier has two independent structural consequences. Cut-independence of the balanced exchange spectrum singles out order six. Aligned four-sets reconstruct every two-graph on at least seven vertices up to complement, with seven sharp; hence the determinant-(−3) blocks recover symmetric conference signings of order at least ten up to switching and global negation.
>
**Delivers.** The exact arithmetic incidence cover selects a relative marked
conference source, whose cubic is tracked through holonomy, exterior algebra,
Pfaffians, determinants, classical invariant theory, and degree-six harmonics.
Exchange rigidity and two-graph reconstruction remain complete independent
consequences of the same carrier.

**Who cares.** Algebraic geometers, representation theorists, finite
geometers, and mathematical physicists.

**Why it matters.** Complementary descriptions make different aspects of the
same structured calculation visible. *Chordal and Conference Cubics:
Reconstruction and a Residual C2-Torsor* determines their precise relation:
the cubic from *Quadratic Trade Rigidity and Cubic Orientation in Conic
Matching Quotients* is a distinct chordal companion of the conference cubic,
not the same cubic in different coordinates.

---

#### Reconstructing PG(2,13), Its Conic, and Polarity from the Minimum Words of a Binary Conic Code

[PDF](https://github.com/tavisrudd/q13-passant-code/blob/main/passant_code_q13.pdf) · [Repository](https://github.com/tavisrudd/q13-passant-code) · [![DOI](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.21783970-blue.svg)](https://doi.org/10.5281/zenodo.21783970)

**Standout result.** The 364 minimum words of the [78,36,12]₂ passant-line
code reconstruct the marked projective plane PG(2,13), including its conic
and polarity.

> *Abstract* Let C be a nonsingular conic in PG(2,13), and let K be the binary column nullspace of its passant-by-internal incidence matrix: vectors on internal points annihilated by that matrix. We prove that the code has parameters [78,36,12]₂ and exactly 364 minimum words. Their weighted pair concurrences alone reconstruct the passant incidence matrix, the code, and the six-class elliptic association scheme. The resulting group action then reconstructs all points and lines of PG(2,13), the distinguished conic, and its polarity; no coordinates or triple concurrence are required. Equivalently, the weighted 2-section of the minimum-support hypergraph is a complete invariant of this marked conic-plane presentation. The four minimum-word families are one octahedral family and three chord-indexed punctured-conic families, and each spans the code. The binary relation algebra acts on the code through a scalar field F₈, making it twelve-dimensional over that field; the four orbit Grams are nonzero scalars. This marked action is recovered from pair data. An exact positive semidefinite certificate excludes weight eight; a line moment followed by exact stabilizer exhaustion excludes weight ten.
>
**Delivers.** The minimum-weight codewords of a binary code built from the
passant lines of a conic over the field with thirteen elements reconstruct the
code and the marked projective plane that produced it.  The paper also
determines the code's minimum distance and coordinate symmetries.

**Who cares.** Coding theorists and finite geometers interested in inverse
problems, minimum-weight structure, and the information retained by a code.

**Why it matters.** A small layer of codewords retains enough incidence data to
recover a much richer geometric object.  The result supplies a q=13
reconstruction counterpart to *Reconstructing the Clebsch Code and Its Golden
Orientation from Its Deep-Hole Syndrome Locus*.

---

#### Chordal and Conference Cubics: Reconstruction and a Residual C2-Torsor

[PDF](https://github.com/tavisrudd/chordal-conference-reconstruction/blob/main/chordal_conference_reconstruction.pdf) · [Repository](https://github.com/tavisrudd/chordal-conference-reconstruction) · [![DOI](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.21895530-blue.svg)](https://doi.org/10.5281/zenodo.21895530)

**Standout result.** The signed cubic from *Quadratic Trade Rigidity and Cubic
Orientation in Conic Matching Quotients* is a chordal Hankel companion, not
the conference cubic of *Reconstructing the Clebsch Code and Its Golden
Orientation from Its Deep-Hole Syndrome Locus* and *Golden Descent and Operator
Realizations of the Clebsch Cubic*. Its singular quartic recovers the original
six axes, and the normalized outer difference gives an exact oriented marked
round trip between the two companion lines.

> *Abstract* *Quadratic Trade Rigidity and Cubic Orientation in Conic Matching Quotients* produces a signed cubic in a ten-dimensional matching quotient. We identify its canonical five-dimensional residue and prove that it is not the conference cubic appearing in *Reconstructing the Clebsch Code and Its Golden Orientation from Its Deep-Hole Syndrome Locus* and *Golden Descent and Operator Realizations of the Clebsch Cubic*: the two are distinguished companions in the two-dimensional pencil invariant under the irreducible five-dimensional action of A₅. The conference member has six nodes. The chordal residue is a Hankel determinant, singular along a rational normal quartic. Its twelve rational singular points form A₅/C₅; pairing points with the same stabilizer gives A₅/D₅ and identifies its six fibres equivariantly with the original matched axes. Thus the two companion cubics realize one six-axis carrier through different singular shadows. We determine the normalized outer-normalizer action exactly on the chordal pencil and prove that, after one chordal companion is retained, its difference operator gives an exact oriented round trip between sheet and conference orientations. The result rules out a tempting literal identification of the two invariant cubic lines while recovering the marked equivalence that replaces it.

**Delivers.** A precise correction and completion of the upper series map:
the source cubics are distinct, their common carrier is intrinsic, and their
orientation transport is explicit and reversible at the stated marked level.

**Who cares.** Invariant theorists, algebraic combinatorialists,
representation theorists, and readers interested in reconstruction from
singular loci.

**Why it matters.** A false literal coincidence is replaced by a stronger
structural statement: different sparse shadows can recover the same carrier,
and the exact missing marking can itself be identified.

---

#### Computational Strengthenings of Clebsch Syndrome Rigidity — companion

[PDF](https://github.com/tavisrudd/clebsch-rigidity/blob/main/clebsch_rigidity_computational_companion.pdf) · [Repository](https://github.com/tavisrudd/clebsch-rigidity) · [![DOI](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.21652792-blue.svg)](https://doi.org/10.5281/zenodo.21652792)

**Standout result.** An exact finite classification finds only the F₅
four-frame and the F₁₁ Clebsch six-arc among conic-filling arcs through eight
points.

**Delivers.** Exact finite computations and strengthened census results support
*Reconstructing the Clebsch Code and Its Golden Orientation from Its Deep-Hole
Syndrome Locus*, with reproducible verification material.

**Who cares.** Readers checking finite classifications, computational
geometers, and anyone who wants independently replayable evidence.

**Why it matters.** The companion separates structural arguments from
exhaustive checks and makes delicate finite claims inspectable.

It is housed in the `clebsch-rigidity` repository rather than in a separate
public mirror.

*Companion abstract.* For a projective arc A ⊂ PG(2,q), let U(A) be the points on no chord of A. The geometric paper proves, without an exhaustive classification of six-arcs over F₁₁, that a six-arc in PG(2,11) whose uncovered locus lies on a conic is the Clebsch hexagon. Here exact finite computation sharpens and extends that result. There are fifteen projective classes of six-arcs over F₁₁; the Clebsch class is the unique one whose uncovered locus is contained in a cubic, and it is separated from every other class by a four-point gap in uncovered-set size. A Sylvester-graph obstruction shows that q = 11 is the only field order admitting a conic-filling six-arc. Exhaustive orbit searches then classify all conic-filling arcs through eight points: only the projective four-frame over F₅ and the Clebsch six-arc over F₁₁ occur. The companion also preserves the original q = 13 computations underlying *Reconstructing PG(2,13), Its Conic, and Polarity from the Minimum Words of a Binary Conic Code*, which gives the passant-code reconstruction theorem a standalone structural and reproducible account. The finite claims are accompanied by exact replay routes and a claim-by-claim trust ledger.

---

### Further Geometry, Coding Theory, and Quantum Information Papers

#### Frobenius-equivariant Pair Extension and Robust Repair of Eight-Arcs

[PDF](https://github.com/tavisrudd/equivariant-robust-completion/blob/main/equivariant-robust-completion.pdf) · [Repository](https://github.com/tavisrudd/equivariant-robust-completion) · [![DOI](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.22051735-blue.svg)](https://doi.org/10.5281/zenodo.22051735)

**Standout result.** Every Frobenius-invariant eight-arc over every prime-power
base order `s ≥ 5` admits a fresh nonfixed conjugate-pair extension. Over
`F₂₅` there are at least four legal pairs, and the exceptional two-fixed-point
profile has exact minimum 32; for `s ≥ 7` there are at least 319 legal pairs.

> *Abstract* Let φ be the quadratic Frobenius involution of PG(2,s²). We study
> extensions of φ-invariant arcs by fresh nonfixed conjugate pairs, or
> equivalently Frobenius-compatible two-column extensions of the associated
> dimension-three MDS codes. Every pair lies on a unique fixed mate line.
> Counting pairs carrier by carrier gives a uniform lower bound, and an exact
> correction records secant orbits that disappear at fixed centers and visible
> orbits that collide on one candidate.
>
> Every invariant eight-arc over every prime-power base order s ≥ 5 admits
> such an extension. Over F₂₅ there are at least four legal pairs; the
> exceptional two-fixed-point profile has exact minimum 32. For s ≥ 7 there
> are at least 319 legal pairs. These bounds yield alternate repairs after
> deletion of a selected orbit, and a parameterized criterion gives the
> corresponding result for invariant (k+2)-arcs. The structural reductions
> have human-scale Lean support. A separate Mathlib-only certificate checks
> the normalized exceptional census; the projective normalizations and
> semantic transport are manuscript arguments.

**Delivers.** A carrierwise theory of Frobenius-compatible paired extension,
an exact invisible-center and collision correction, uniform extension and
alternate-repair bounds, and an exact normalized classification of the
exceptional two-fixed-point minimum over `F₂₅`.

**Who cares.** Finite geometers, coding theorists studying MDS extension and
puncturing, and researchers interested in symmetry-constrained completion or
formally checked finite classifications.

**Why it matters.** Ordinary point extension does not ensure that a point and
its Frobenius conjugate are jointly legal. The mate-line quotient exposes the
extra obstruction, while the correction terms measure exactly where a naive
first-order count loses information. The resulting multiplicity bounds give
robust replacement of generator-column pairs rather than erasure decoding in
a fixed code.

---

#### Complete Bounded Repair Ports: Transfer, Reliability, and Geometric Structure

[PDF](https://github.com/tavisrudd/complete-repair-ports/blob/main/complete_repair_ports.pdf) · [Repository](https://github.com/tavisrudd/complete-repair-ports) · [![DOI](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.22051903-blue.svg)](https://doi.org/10.5281/zenodo.22051903)

**Standout result.** An exact weighted-functional confinement criterion
transfers both the support clutter and every normalized scalar decoder of a
bounded repair port. Below its pointed zero-functional threshold, any
represented port occurs on a designated positive-density coordinate class in
an asymptotically good fixed-alphabet family.

> *Abstract* For a linear code and a distinguished coordinate, the complete
> bounded repair port records every dual recovery equation using at most a
> prescribed number of helpers. Its support clutter says which helpers
> suffice, its normalized coefficients retain the represented decoder, and
> its Boolean success event governs reliability. This extra coefficient data
> is substantial: for every proper MDS code, the minimum coefficient port at
> any distinguished coordinate reconstructs the represented code, although
> its support projection is the generic complete uniform clutter.
>
> We prove an exact weighted-functional transfer theorem for concatenation.
> In the fixed-inner linear regime, a pointed zero-functional cost is the
> persistent obstruction to copying a bounded port blockwise; every
> represented port below this threshold occurs on a positive-density
> designated coordinate class in an asymptotically good fixed-alphabet
> family. We also derive exact deletion–contraction and pivotal identities, a
> bounded BEC EXIT hierarchy whose successive differences recover the
> distribution of the cheapest available repair radius, and a full-radius
> specialization of the Las Vergnas polynomial for `M∖x → M/x`. An explicit
> represented pair proves that this
> full-radius invariant does not determine the bounded-radius filtration.
>
> Characteristic-three examples exhibit both extremes: a completed
> twisted-cubic–axis code has two uniform exact matching/transversal rows and
> strict weighted transfer, while a quartic normal rational curve with its
> nucleus has a Steiner `S(3,4,q+1)` port at the nucleus and a compulsory
> nucleus helper at every curve target.

**Delivers.** A complete pointed support/coefficient/probability object; MDS
coefficient-port reconstruction; an exact concatenation threshold; a
positive-density realization theorem; deletion–contraction, pivotal, blocker,
and bounded-EXIT identities; a pointed-Tutte specialization; and exact
cubic–axis and quartic–nucleus port inventories.

**Who cares.** Coding theorists working on locality and availability,
distributed storage, erasure decoding, code concatenation, matroid
reliability, or finite-geometric code constructions.

**Why it matters.** Locality and disjoint availability retain only coarse
support data. The complete port keeps the actual scalar recovery equations
and the full failure event visible, while the transfer theorem identifies the
precise obstruction to reproducing that richer local object throughout a
long code.

---

#### Integral Cohomology and Modular Decomposition for the Theta Divisor of a Cubic Threefold

[PDF](https://github.com/tavisrudd/blown-up-theta-lattice/blob/main/blown_up_theta_lattice.pdf) · [Repository](https://github.com/tavisrudd/blown-up-theta-lattice) · [![DOI](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.22036585-blue.svg)](https://doi.org/10.5281/zenodo.22036585)

**Standout result.** The blow-up resolution of the cubic-threefold theta
divisor exhibits two distinct integral coefficient defects.  Its rank-130
middle lattice has a canonical `(Z/2)^10` saturation quotient, while its
integral direct image has central map `Z --(-3)--> Z`.  Modulo three the
residual perverse factor is uniserial of length three, and relative hard
Lefschetz fails.

> *Abstract* Let Θ be the theta divisor of the intermediate Jacobian of a
> smooth complex cubic threefold, and let σ: M = Bl₀Θ → Θ be its resolution.
> We compute the integral middle lattice IH³(Θ,Z): it is free of rank 130,
> and its Lefschetz saturation quotient is (Z/2)¹⁰. The Fano difference map
> identifies the glue and its dual escape lattice. We determine Rσ_*Z_M[4],
> split off two point objects over Z and prove that the residual perverse
> factor has central map Z → Z given by multiplication by −3. It acquires a
> third point summand after inverting three, but none integrally; modulo three
> it becomes length-three uniserial. Finally, we lift the local order-three
> link class to an infinite-order Fano class and prove that ordinary and
> intersection cohomology agree in degrees at least four. The factor three
> also forces relative hard Lefschetz to fail modulo three.

**Delivers.** An integral middle-lattice theorem with geometric Fano-labelled
glue; the complete integral point-summand decomposition and central
attachment of the resolution complex; the exact mod-three Loewy chain; a
modular relative-hard-Lefschetz counterexample; and the global fate of the
local order-three link class.

**Who cares.** Algebraic geometers and topologists working on cubic
threefolds, intermediate Jacobians, theta divisors, integral intersection
cohomology, perverse sheaves, or modular decomposition phenomena.

**Priority boundary.** The paper's claim ledger records “cubic-theta integral
object and central Smith factor retained,” “canonical `delta_0`--`IC`--
`delta_0` filtration and both nonsplit extensions retained,” and “explicit
multiplier three and failure over `F_3` retained.”  The manuscript separately
credits the general rational intersection-form, modular rank, and
small-extension frameworks on which the example-specific calculation sits.

---

#### Standard Flips of Discrepancy One: Extremal J-Normalization and the Meijer Aperture at ν=1

[PDF](https://github.com/tavisrudd/discrepancy-one-flips/blob/main/discrepancy_one_flips.pdf) · [Repository](https://github.com/tavisrudd/discrepancy-one-flips) · [![DOI](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.21924798-blue.svg)](https://doi.org/10.5281/zenodo.21924798)

**Standout result.** Shen and Shoemaker's extremal quantum-spectrum and
Gamma-class argument extends through the omitted discrepancy-one range
`r = s + 1`, `s ≥ 1`, including every codimension-two blow-up.

> *Abstract* Shen and Shoemaker compute the extremal quantum spectrum of a standard flip `X ⇢ X'` with exceptional locus `P(V) ⊂ X`, `rank V = r`, `rank V' = s`, and show that the Gamma-class decomposition of `H*(X)` attached to the Belmans--Fu--Raedschelders semiorthogonal decomposition is a decomposition into asymptotic classes. Their Theorem 4.4, which identifies an explicit hypergeometric series with the extremal `J`-function of the local model, assumes `r-s>1`; their Remark 4.5(3) asserts that for `r-s≤1` the series is not `J`-normalized; and the Barnes asymptotic expansion of their Section 7 is applied under the same inequality. Their Theorem 1.2 is printed only for `r-s>1`, while their Theorems 1.4, 9.9 and 9.14 and their Corollary 1.5 are stated in a range that includes blow-ups. The printed proof chain for these later statements does not reach the discrepancy-one case `r=s+1`, `s≥1`, which contains every codimension-two blow-up.
>
> We supply the two missing steps. First, the degree-`d` summand of their formula (35) has `z`-order at most `1-s-(r-s)d`; for `r=s+1` and `s≥1` this is at most `-1` for every `d≥1`, so the series is `z1+t̄+O(z⁻¹)`, with `1` the unit class and `t̄ = t + ln(q)c₁(T)` the extremal parameter; no mirror-map correction arises, and uniqueness of the `J`-slice of Givental's cone identifies the series with the extremal `J`-function. We prove the cone membership that this uses instead of quoting Remark 4.5(3) for it, whose printed attribution passes through a lemma of their Section 9 that presupposes Theorem 4.4: for split bundles it follows from Brown's toric-fibration theorem together with the twisted theory of Coates and Givental, and the general case follows by a flag-bundle pullback and a deformation to the associated graded. None of these inputs restricts `r-s`. The only remaining formal failure of the normalization is the degenerate endpoint `(r,s)=(1,0)`, whose point fibres contain no extremal line. Second, at `ν:=r-s=1` the sector printed after their Lemma 7.4 is unavailable: their own Theorem A.1 is valid on `|arg t|<(ν+ε)π` with `ε=1` only for `ν>1` and `ε=1/2` at `ν=1`, and the correct `ε=1/2` sector still meets the sector of their Proposition 8.2 in an open sector of opening `2π` that contains both the nonzero-eigenvalue ray and the tame ray. Once these repaired inputs are supplied, their Sections 9.1--9.4 impose no further restriction on the discrepancy, and Theorems 1.2, 1.4, 9.9 and 9.14 and Corollary 1.5 extend to every standard flip with `r=s+1` and `s≥1`. No other part of the standard-flip argument is altered: the correction is confined to the `J`-normalization of the extremal hypergeometric series and to the Barnes aperture at `ν=1`.

**Delivers.** A source-local correction: the missing `I`-to-`J`
normalization, a proof of the cone membership the source only asserts, the
correct Meijer aperture at `ν=1`, and a precise account of the formal
rank-one projective-bundle endpoint, whose fibres contain no extremal line.

**Who cares.** Algebraic geometers working on quantum cohomology, standard
flips and blow-ups, Gamma classes, semiorthogonal decompositions, or Meijer
asymptotics.

**Why it matters.** The omitted range is geometrically basic: it includes
every codimension-two blow-up. The repair proves the cone membership that
the source only asserts, uses the source's own Appendix A for the sector, and
changes no higher-discrepancy statement.

---

#### Gamma Point Rows under Quantum Wall Crossing and a Criterion for Stable Irrationality

**Early draft, likely to contain logical gaps and notational issues.**

[PDF](https://github.com/tavisrudd/cubic-stabilization-irrationality/blob/main/cubic_stabilization_irrationality.pdf) · [Repository](https://github.com/tavisrudd/cubic-stabilization-irrationality) · [![DOI](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.21937490-blue.svg)](https://doi.org/10.5281/zenodo.21937490)

**Standout result.** A rank-one derived-intersection theorem identifies the
fixed clutching data along every tail. Together with an exact simple-wall
point coordinate, ordinary-flop point-row transport, global support collapse,
and coefficientwise Gamma reduction, it reduces the remaining analytic input
to one-object threshold isomorphisms of the cyclic point-row `z`-modules. Under those
isomorphisms and the stated gauged-admissibility conditions, every projective
stabilization of every smooth cubic threefold is irrational.

> *Abstract* Assume that every smooth projective birational map admits a
> gauged-admissible marked Włodarczyk completion and, on every finite Artin
> truncation of that completion, the one-object marked threshold comparisons
> stated in the paper. We prove that
> `X × P^m` is irrational for every smooth complex cubic threefold `X` and
> every `m ≥ 0`.
>
> The endpoint contrast is unconditional. Cai's small quantum-connection
> matrices give a rank-two block with
> primitive-sixth formal monodromy. We reconstruct its indicial polynomial
> directly, and an elementary `₂F₃` Barnes calculation shows that the Gamma
> point row is nonzero on both primitive-sixth lines. Under multiplication by
> `P^m`, quantum Künneth produces `m+1` copies and preserves detection of the
> resulting packet, whereas projective space itself has no primitive-sixth
> packet.
>
> For the global comparison, the Gamma integral structure turns the class of
> a point into the flat Euler covector which reads ordinary rank. We prove an
> exact ambient point-column identity at a simple VGIT wall's extremal
> specialization and exact point-row transport across an ordinary flop on a
> fixed continuation domain. In a global cobordism, a common-open orbit
> cylinder gives one endpoint point row, rotation localization kills every
> intermediate fixed stratum, and Woodward's clutching factorization packages
> every remaining bubble tree into endpoint tails. The rank-one derived
> clutching theorem proved here makes each such tail holonomic and tempered.
> Beyond gauged-admissibility, the remaining unproved input is an inverse-system
> family of one-object marked threshold comparisons, finite at every
> Artin-energy truncation. At each sign or stability threshold, and on reduced
> nearby cycles at each zero-mode rank change, one marked local Fourier object
> must induce an isomorphism of the cyclic Rees `z`-modules which intertwines
> formal monodromy, carries the marked row, preserves the stated Stokes and deck
> data, and, at a zero mode, identifies the entire adjacent row-generated cyclic
> module with its reduced nearby-cycle realization. Preservation of primary
> projections then follows from polynomial functional calculus. Under these assumptions,
> Rees homogenization makes point-row nonvanishing on a formal-monodromy
> primary packet birationally invariant. A two-tail rational counterexample
> shows that separate holonomicity does not determine the threshold map. The
> incomplete-Gamma and Fourier-boundary countermodels rule out still weaker
> replacements based only on formal monodromy, pairing, integrality, or
> localized Fourier support.

**Delivers.** An exact simple-wall ambient point coordinate, exact
ordinary-flop point-row transport, three explicit failure models,
global support collapse, coefficientwise Gamma reduction, an unconditional
tail-holonomicity theorem, an unconditional cubic endpoint calculation, and
a conditional all-stabilizations criterion.

**Who cares.** Researchers in quantum cohomology, birational wall crossing,
Gamma structures, irregular connections, Fourier--Laplace methods, and
stable-rationality obstructions.

**Why it matters.** It separates the proved rank-one derived geometry from the
locally finite marked threshold comparisons still needed, in addition to the
explicit gauged-admissibility conditions, to turn the cubic endpoint contrast
into a global birational obstruction.

---

#### Hodge Atoms as Occurrence-Indexed Marker Ledgers

[PDF](https://github.com/tavisrudd/hodge-atom-marker-ledger/blob/main/hodge_atom_marker_ledger.pdf) · [Repository](https://github.com/tavisrudd/hodge-atom-marker-ledger) · [![DOI](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.22036390-blue.svg)](https://doi.org/10.5281/zenodo.22036390)

**Standout result.** The standard abstract Hodge-atom chemical formula is the
universal fold of an occurrence-indexed thin groupoid.  Killing atom classes
carried in dimension at most `d - 2` produces an effective quotient that is
birationally invariant by weak factorization, and the resulting obstruction
is stated only for one rank-two projective-bundle step.

> *Abstract* Hodge atoms are defined from connected components of the reduced unramified Euler spectral cover of a maximal non-archimedean A-model F-bundle, followed by elementary identifications supplied by disjoint unions, blowups, and projective bundles. We isolate the categorical mechanism behind this construction. Expanding the degree of each spectral component into labelled occurrences, we form the thin groupoid generated by the elementary correspondences and the free commutative monoid on its connected components. Its universal fold recovers the Hodge-atom chemical formula, makes the three operation laws formal, and separates the abstract atom quotient from the generally coarser quotient by isomorphism of geometric atomic F-bundles. Killing the generators carried in dimension at most d − 2 gives an effective quotient in which weak factorization makes the ledger birationally invariant for smooth projective d-folds. As a one-step consequence, if an atom of a smooth n-fold cannot be carried in dimension at most n − 1, then every rank-two projective bundle carrying that occurrence is irrational. All quantum-cohomological comparison results enter only through an explicit provider record.

**Delivers.** A compact categorical proof spine for standard Hodge atoms,
including the occurrence carrier, effective monoid, operation folds,
dimension filtration, and exact abstract-to-geometric type boundary.

**Who cares.** Algebraic geometers working on Hodge-theoretic birational
invariants, quantum cohomology, weak factorization, or stabilization problems.

**Why it matters.** It makes multiplicity and effectivity explicit, isolates
the cited quantum-cohomological providers from the formal ledger argument, and
shows exactly what the standard atom construction proves after one rank-two
projective-bundle step.

---

#### Arcs Complete Outside a Conic: A Prescribed-Hole Defect Identity and Matching-Design Rigidity

[PDF](https://github.com/tavisrudd/arcs-complete-outside-conic/blob/main/arcs_complete_outside_conic.pdf) · [Repository](https://github.com/tavisrudd/arcs-complete-outside-conic) · [![DOI](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.21682567-blue.svg)](https://doi.org/10.5281/zenodo.21682567)

**Standout result.** A universal pointwise secant-defect identity turns zero
defect into maximum-matching-design rigidity and gives explicit stability; its
principal conic application yields a quantitative lower bound and exact small
orders.

> *Abstract* We prove that if H is any prescribed set of q + 1 points in a finite projective plane of order q, then every arc A disjoint from H whose secants cover all points outside A ∪ H satisfies |A| ≥ √(2q) + 3/2 − 8/√(2q). Thus even after exempting q + 1 points from coverage, the bound retains the classical √(2q) scale with additive term 3/2 − o(1). More generally, the first two secant moments yield an exact defect identity with nonnegative local summands. At zero defect, each concurrency class containing at least two secants is a maximum matching, and these classes form a simple MATCH(k,⌊k/2⌋,1) design. In Desarguesian planes, the arc realizes this design by concurrent chord families; the defect also gives quantitative deletion stability.
>
> For a nonsingular conic C ⊂ PG(2,q), let ρC(q) denote the corresponding minimum. In characteristic two, a C-complete zero-defect arc with odd k ≥ 7 is an oval of size q + 1 whose nucleus lies on C, while even k ≥ 6 forces k = q + 2, hence a hyperoval. A kernel-checked classification gives ρC(16) = 9; exhaustive classifications with kernel-checked attaining witnesses give ρC(13) = 8, ρC(17) = 9, and ρC(19) = 10. The defect identity, equality criterion, and deletion stability are independently formalized in Lean.
>
**Delivers.** An exact counting identity governs arcs relative to any prescribed
set of points allowed to remain uncovered.  It gives matching-design rigidity
and stability in every finite projective plane, a conic-relative lower bound,
and several exact small-field values.

**Who cares.** Finite geometers, design theorists, and researchers studying
projective planes or extremal configurations.

**Why it matters.** A visual covering problem becomes a sharp defect
calculation, with zero defect forcing rigid exceptional cases.  The
secant-moment identity proved here, valid in every finite projective plane and
for every prescribed hole set, is the general form of the chord-defect identity
used in the rigidity theorem of *Reconstructing the Clebsch Code and Its Golden
Orientation from Its Deep-Hole Syndrome Locus* above. That relationship is a
specialization of the identity, not a claim that the Clebsch hexagon has zero
defect in the present paper's matching-design sense.

---


#### Diagonal Isoduality and Transversal Clifford Groups of MDS–CSS Codes

[PDF](https://github.com/tavisrudd/mds-css-transversal-groups/blob/main/mds-css-transversal-groups.pdf) · [Repository](https://github.com/tavisrudd/mds-css-transversal-groups) · [![DOI](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.21766797-blue.svg)](https://doi.org/10.5281/zenodo.21766797)

**Standout result.** A zero-or-one-dimensional nullity test determines which
projective transversal logical group an odd-prime MDS–CSS code supports.

> *Abstract* Let C be a linear [2m,m,m+1]q maximum-distance-separable code. The space of diagonal multipliers carrying C to C⊥ has dimension zero or one, and every nonzero multiplier has full support and is unique up to scalar. Over an odd prime field this nullity test determines the exact fixed-party projective transversal logical group of the associated [[2m−1,1,m]]q MDS–CSS code: it is Fq² ⋊ SL₂(q) in the diagonally isodual case and Fq² ⋊ T otherwise, where T is the split torus. Rigidity of stabilizer absolutely maximally entangled states supplies the converse: every tensor-product logical implementation is Clifford factor by factor. The linear SL₂(q) action has coherent Weil lifts, while the full affine group retains the Heisenberg obstruction to a scalar splitting.
>
> For six coordinates, diagonal isoduality is exactly self-association of the corresponding six-arc and hence the conic boundary. On an explicit non-GRS pencil a degree-eight quotient z classifies projective and monomial-code equivalence over odd fields and local-Clifford and local-unitary equivalence over odd prime fields. The Clebsch [6,3,4]₁₁ code gives a worked syndrome-geometric application. Fixed-copy scalar contractions are generically constant on the pencil, explaining why the operator-valued Weyl atlas retains classification data that bounded scalar invariants lose. Exact certificate replays cover the finite six-point computations; the all-length multiplier and group theorems are conceptual.
>
**Delivers.** A classification of the diagonal rescalings that make a code
match its dual, together with the logical operations that can then be performed
independently across its physical locations.

**Who cares.** Quantum coding theorists, finite geometers, and researchers
studying transversal gates and logical symmetries.

**Why it matters.** Transversal operations are valuable because they act
independently on separate physical systems.  The result identifies exactly
when the larger symmetry group is available and when only a smaller subgroup
survives.

---

#### Balanced Cuts of Conference Matrices: Squared-Spectrum Rigidity and Hermitian Holonomy

[PDF](https://github.com/tavisrudd/conference-cut-spectra/blob/main/conference_cut_spectra.pdf) · [Repository](https://github.com/tavisrudd/conference-cut-spectra) · [![DOI](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.21766747-blue.svg)](https://doi.org/10.5281/zenodo.21766747)

**Standout result.** Order six is the unique nontrivial symmetric conference
order whose normalized balanced cross-block Gram spectrum is independent of the
cut. In the Hermitian order-six problem, squared real triangle holonomy
parametrizes the complete degree-three Pareto frontier and quantitatively
controls rigidity relative to the real switching class.

> *Abstract* Let C be a symmetric conference matrix of order 2d, put q = 2d − 1, and for a balanced half Y write R = C[Y,Yᶜ]. We study the exchange spectrum spec(RRᵀ/q) and prove that it is independent of Y exactly when d ≤ 3. Since the order-two case is trivial and no symmetric conference matrix of order four exists, order six is the unique nontrivial case; its spectrum is {1/5, 4/5, 4/5}. For the associated diagonal-control transfer, the twenty balanced sign vectors in {±1}⁶ are exactly the maximizers of each degree-three Schur sector over [−1,1]⁶.
>
> For Hermitian conference matrices of order six, the conference identities fix the first two exchange moments, while squared real triangle holonomy parametrizes the complete Pareto frontier of the three degree-three sectors. Cutwise constancy of any one sector holds exactly for matrices equivalent, under switching and permutation, to a real symmetric conference matrix. An averaged squared-holonomy defect bounds the Frobenius distance from that class globally from below and locally from above. In arbitrary real dimension, singular values classify unframed port transfers; for invertible transfers, orientation adds exactly the determinant sign, and the determinant is the unique minimal-degree orientation-covariant polynomial up to scale. We interpret the order-six transfer through a conference interferometer, separating intrinsic, oriented, and calibrated observables and identifying the external resource required for direct three-fermion emulation. This is a theory and design-limit analysis, not a report of a built device.
>
**Delivers.** A classification of symmetric conference matrices with
cut-independent balanced cross-block spectrum; an exact continuous-control
optimum at order six; a Hermitian holonomy parametrization of the complete
degree-three Pareto frontier; and quantitative rigidity relative to the real
switching class. The conference interferometer is an application of these
matrix results.

**Who cares.** Matrix theorists, algebraic combinatorialists, frame theorists,
mathematical physicists, and quantum-information researchers studying
structured transfer spectra.

**Why it matters.** Uniformity over every balanced cut is rigid rather than a
generic conference-matrix phenomenon. At the exceptional order, triangle
holonomy becomes an exact deformation coordinate: it controls the exchange
tradeoff, detects the real switching class, and supplies a metric defect. The
interferometric model shows how the same hierarchy separates intrinsic,
oriented, and calibrated observables.

---


## Verification philosophy

Verification is claim-level, not a single project-wide badge. A paper may use
several evidence modes at once:

1. an ordinary prose proof;
2. a cited result checked against its hypotheses and conventions;
3. a Lean kernel-checked component;
4. a certificate-checked finite computation; or
5. a trusted program execution or symbolic experiment.

These categories support one another but do not collapse into one another. A
certificate checks an output, not necessarily search completeness; Lean checks
the formal statement, not automatically its correspondence with prose; and a
computation can discover a pattern without proving it. The individual paper
repositories state these boundaries and retain exact replay information where
finite computation is essential. [VERIFICATION.md](VERIFICATION.md) routes
readers to each repository's claim-level evidence map.

## Contact and disclosure

I am an independent researcher without institutional affiliation. Specialist
review would be especially valuable for literature checks, classical-priority
questions, technical corrections, and identifying suitable arXiv endorsers.
An endorsement would mean informed support for making a manuscript available
for public scrutiny, not a substitute for peer review. Contact is welcome via
[my GitHub profile](https://github.com/tavisrudd).

This project was developed with extensive assistance from OpenAI Codex and
Anthropic Claude. Under my direction, the systems assisted with proof
exploration, literature research, symbolic and finite computation, code and
formal-proof development, verification, and manuscript drafting and revision.
I checked the resulting arguments, computations, code, and cited sources,
reviewed and edited AI-assisted material, and assume responsibility for the
content.
