# Reconstruction and Rigidity in Finite Geometry, Coding, and Quantum Information

This repository summarizes a collection of papers in finite geometry, coding
theory, algebraic combinatorics, and quantum information. They ask a common
inverse question: how much structure can be recovered after most of the
original information has been discarded?

The remaining data may be the errors farthest from a code, minimum-weight
words, local symmetries of an entangled state, low-order determinants, or
measurements that hide an optical device's orientation. Across the collection,
sparse data repeatedly force rich algebraic or geometric structure. The
recurring mechanism is rigidity: identify an invariant that survives the loss
of information, then prove that few possibilities remain.

The numbered five-paper series *Clebsch: Rigidity from Sparse Shadows* asks:
how much of a structured object can be reconstructed from its sparse shadows?
Papers I--III follow syndrome loci, quadratic trades, and arithmetic/operator
shadows toward a common marked cubic and golden operator. Paper IV is the
parallel minimum-word branch, reconstructing a marked conic plane and polarity
without asserting a cubic identification. Paper V will prove the exact
transports and reverse recognition that close the upper round trip.
*Diagonal Isoduality and Transversal Clifford Groups of MDS–CSS Codes* and the
Golden interferometer paper are related unnumbered companions. Every paper is
intended to stand on its own mathematically.

Many structural components have independent Lean formalizations; coverage is
claim-specific and generally not end-to-end. Each repository states which
parts are prose proofs, cited inputs, kernel-checked formalizations,
certificate-checked computations, or trusted executions. See
[VERIFICATION.md](VERIFICATION.md) for links to the detailed paper-level
evidence maps.

- [selected headline results](#selected-headline-results)
- [theorems over infinite families](#theorems-over-infinite-families)
- [papers and entry points](#papers-and-entry-points)
- [abstracts and non-specialist guides](#abstracts-and-non-specialist-guides)
- [verification philosophy](#verification-philosophy)
- [contact and disclosure](#contact-and-disclosure)

## Selected headline results

These are selected headlines, not a ranking. They are grouped to show the
range of the programme and to avoid counting several facets of one theorem
complex as separate victories.

### Finite geometry and reconstruction

- **Universal secant-defect identity.** For every finite projective plane and
  prescribed hole set, the first two secant moments give an exact identity with
  a pointwise nonnegative remainder. Zero defect forces a simple maximum-matching
  design, while the remainder gives deletion stability. For `q + 1` holes this
  yields a universal lower bound and exact small-field consequences for arcs
  complete outside a conic. [Arcs Complete Outside a Conic: A Prescribed-Hole Defect Identity and Matching-Design Rigidity](https://github.com/tavisrudd/arcs-complete-outside-conic/blob/main/arcs_complete_outside_conic.pdf).

- **Sparse data recover marked finite geometry.** In the Clebsch case, a
  conic-containing deep-hole syndrome locus recognizes the non-GRS
  `[6,3,4]₁₁` code and recovers its conic, polarity, and golden orientation;
  a companion classification proves that `q = 11` is the only field order
  admitting a conic-filling six-arc. In the q=13 case, weighted pair
  concurrences of the 364 minimum words recover the binary code and the marked
  plane `PG(2,13)`, including its conic and polarity. [Clebsch I](https://github.com/tavisrudd/clebsch-rigidity/blob/main/clebsch_rigidity.pdf),
  [q=13 reconstruction](https://github.com/tavisrudd/q13-passant-code/blob/main/passant_code_q13.pdf).

- **Quadratic trades recognize exceptional matching geometries.** Within full
  `PGL₂(q)`-orbits of perfect matchings over odd fields, a two-valued
  strength-two trade occurs only for the `B₃/F₇` and `H₃/F₁₁` geometries.
  The trade recovers their unordered sheets, and the first nonzero signed
  cubic orients them. This carrier condition is sharp: off the matching locus,
  `q − 2` nonmatching orbits retain the same trade.
  [Quadratic Trade Rigidity and Cubic Orientation](https://github.com/tavisrudd/clebsch-factorization/blob/main/clebsch_factorization.pdf).

- **Golden descent fixes a conference source and its cubic shadows.** Hitchin's
  harmonic-cubic incidence cover has function field `Q(P(H))(√(5J₀))` and
  finite Stein equation `z² = 5J₀`. After a marked bridge datum is fixed, a
  chosen sheet selects a conference source whose cubic has four exact operator
  descriptions and returns as the exact degree-six Gaunt multiple
  `−784000σ₃/1247103`. The same carrier independently yields exchange-spectrum
  rigidity and sharp reconstruction of two-graphs from aligned four-sets.
  [Golden Descent and Operator Realizations](https://github.com/tavisrudd/clebsch-passages/blob/main/clebsch_passages.pdf).

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

- **Order six is the unique nontrivial balanced conference order.** For a
  symmetric conference matrix, split the modes into two equal parts and take
  the singular-value spectrum of the corresponding cut block. Order six is
  the unique nontrivial order at which this spectrum is independent of the
  balanced split. The Golden six-mode analysis adds orientation-sensitive
  determinant data and stability bounds, while explicitly treating the device
  as a theory and design-limit model rather than a report of a built
  experiment. [Exchange Landscapes, Orientation, and Rigidity](https://github.com/tavisrudd/golden-quantum-statistics/blob/main/golden_quantum_statistics.pdf).

## Theorems over infinite families

The exceptional Clebsch, `q = 13`, and `q = 11` objects arise as answers to
general questions rather than as assumptions. The following table records
selected infinite-family statements from the major papers.

| Paper | General theorem | Quantifier range |
|---|---|---|
| Clebsch I | If an arc's uncovered locus is a nonsingular conic, then `q` is odd and `2k − 3 ≤ q ≤ (k(k − 1) + 3)/3`. | Every `k`-arc with `k ≥ 4`, over every finite field order `q`. |
| Clebsch I companion | `q = 11` is the only field order admitting a conic-filling six-arc. | Every field order. |
| Clebsch II | The strength-two trade space is one-dimensional and generated by a two-valued vector if and only if the orbit is `B₃/F₇` or `H₃/F₁₁`. | Full `PGL₂(q)`-orbits of perfect matchings, for every odd prime power `q`. |
| Clebsch III | Aligned four-sets reconstruct the two-graph up to complement, and seven is sharp. | Every two-graph on at least seven vertices. |
| Arcs complete outside a conic | The first two secant moments give an exact defect identity with pointwise nonnegative remainder. | Every `k`-arc with `k ≥ 3` in every finite projective plane, and every prescribed hole set disjoint from the arc. |
| Projective Reed–Solomon deep holes | Split-free directions, and deep holes wherever the covering-radius gate applies, are classified in the stated ranges. | R5–R6: every `q ≥ 7`; R7: split-free for every `q ≥ 7` and deep holes for `q ≥ 11`; R8–R10: `q ≥ 43, 53, 59`. |
| Projective Reed–Solomon cubic pencils | On the trivial-gcd separable stratum, `#Y = 6N + 3d₂ + d₃` in every characteristic. | Every field order and characteristic. |
| Stabilizer AME rigidity | Every product-unitary intertwiner between stabilizer `AME(2m,q)` states is Clifford on each party. | Every prime power `q = pᵉ` and `m ≥ 2`. |
| MDS–CSS transversal groups | The diagonal multiplier nullity fixes the transversal logical group. | All `[2m,m,m+1]q` MDS codes over odd prime fields. |
| Golden six-mode interferometer | Order six is the unique nontrivial realized symmetric conference order whose balanced-half exchange spectrum is cut-independent. | Every symmetric conference matrix and every balanced half. |

## Papers and entry points

Each link below points to the public PDF file and repository on GitHub. Each
repository README gives the paper's scope, current status, formalization
boundary, and reproducible entry points.

| Paper | Area | Central result | Public entry |
|---|---|---|---|
| *Reconstructing the Clebsch Code and Its Golden Orientation from Its Deep-Hole Syndrome Locus* | Finite geometry / coding | Deep-hole data recognize the Clebsch code and golden orientation. | [PDF](https://github.com/tavisrudd/clebsch-rigidity/blob/main/clebsch_rigidity.pdf) · [repo](https://github.com/tavisrudd/clebsch-rigidity) |
| *Diagonal Isoduality and Transversal Clifford Groups of MDS–CSS Codes* | Quantum coding / finite geometry | A diagonal-isoduality nullity test determines the projective transversal group. | [PDF](https://github.com/tavisrudd/mds-css-transversal-groups/blob/main/mds-css-transversal-groups.pdf) · [repo](https://github.com/tavisrudd/mds-css-transversal-groups) |
| *Quadratic Trade Rigidity and Cubic Orientation in Conic Matching Quotients* | Algebraic combinatorics | On the matching carrier, a two-valued quadratic trade classifies two exceptional geometries and a cubic orients their sheets. | [PDF](https://github.com/tavisrudd/clebsch-factorization/blob/main/clebsch_factorization.pdf) · [repo](https://github.com/tavisrudd/clebsch-factorization) |
| *Golden Descent and Operator Realizations of the Clebsch Cubic* | Algebraic geometry / combinatorics | An exact arithmetic incidence cover selects a marked conference source whose cubic shadows return in degree-six harmonics; exchange rigidity and two-graph reconstruction follow independently. | [PDF](https://github.com/tavisrudd/clebsch-passages/blob/main/clebsch_passages.pdf) · [repo](https://github.com/tavisrudd/clebsch-passages) |
| *Reconstructing PG(2,13), Its Conic, and Polarity from the Minimum Words of a Binary Conic Code* | Coding / finite geometry | Weighted pair data on minimum words recover a marked projective plane, conic, and polarity. | [PDF](https://github.com/tavisrudd/q13-passant-code/blob/main/passant_code_q13.pdf) · [repo](https://github.com/tavisrudd/q13-passant-code) |
| *Arcs Complete Outside a Conic: A Prescribed-Hole Defect Identity and Matching-Design Rigidity* | Finite geometry / designs | A universal pointwise defect identity gives matching-design rigidity, stability, and conic-relative bounds. | [PDF](https://github.com/tavisrudd/arcs-complete-outside-conic/blob/main/arcs_complete_outside_conic.pdf) · [repo](https://github.com/tavisrudd/arcs-complete-outside-conic) |
| *Deep Holes of Projective Reed–Solomon Codes Beyond Redundancy Four: Recursive Carriers and Exact Classifications Through Redundancy Ten* | Coding theory | Deep-hole classifications extend through redundancy ten in stated ranges. | [PDF](https://github.com/tavisrudd/beyond4-prs/blob/main/prs-beyond-redundancy-four.pdf) · [repo](https://github.com/tavisrudd/beyond4-prs) |
| *Local-Unitary Rigidity and Quantitative Rounding for Stabilizer AME States* | Quantum information | Exact local-unitary rigidity has a separate quantitative rounding theorem. | [PDF](https://github.com/tavisrudd/ame-lu/blob/main/ame-lu.pdf) · [repo](https://github.com/tavisrudd/ame-lu) |
| *Exchange Landscapes, Orientation, and Rigidity in the Golden Six-Mode Conference Interferometer* | Quantum information / mathematical physics | Cut-independent exchange spectra and orientation-sensitive stability are unique at order six. | [PDF](https://github.com/tavisrudd/golden-quantum-statistics/blob/main/golden_quantum_statistics.pdf) · [repo](https://github.com/tavisrudd/golden-quantum-statistics) |

The Clebsch I repository also contains the computational companion *Computational
Strengthenings of Clebsch Syndrome Rigidity*. It supplies exact finite
classifications and replayable evidence for the first paper rather than a
separate numbered paper.

## Abstracts and non-specialist guides

The abstracts below are the papers' own abstract text, with local LaTeX macros
rendered in plain Markdown notation. Each is followed by a non-specialist
guide: what the paper delivers, who may care, and why it matters. If you are
new to the subject, use those three guide paragraphs as the orientation and
then read the abstract for the paper's technical statement.

### Clebsch Series

#### I — Reconstructing the Clebsch Code and Its Golden Orientation

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

**Why it matters.** Error-pattern data can expose a code’s underlying geometry
even when the code is not given directly.  The result turns indirect evidence
into a complete reconstruction theorem, and it is not confined to one field:
the same chord-defect argument gives a field window for every k-arc, and the
companion shows that eleven is the only field order where a conic-filling
six-arc exists.  The chord-defect identity used here is the special case, for
one arc in PG(2,q), of the all-planes secant-moment identity proved in Arcs
Complete Outside a Conic below.

---

#### II — Quadratic Trade Rigidity and Cubic Orientation

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

#### III — Golden Descent and Operator Realizations

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
same structured calculation visible.  Their complete identification across the
series remains part of the continuing program.

---

#### IV — Reconstructing PG(2,13), Its Conic, and Polarity from the Minimum Words of a Binary Conic Code

[PDF](https://github.com/tavisrudd/q13-passant-code/blob/main/passant_code_q13.pdf) · [Repository](https://github.com/tavisrudd/q13-passant-code) · [![DOI](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.21783971-blue.svg)](https://doi.org/10.5281/zenodo.21783971)

**Standout result.** The 364 minimum words of the [78,36,12]₂ passant-line
code reconstruct the marked projective plane PG(2,13), including its conic
and polarity.

> *Abstract* Let C be a nonsingular conic in PG(2,13), and let K be the binary column nullspace of its passant-by-internal incidence matrix: vectors on internal points annihilated by that matrix. We prove that the code has parameters [78,36,12]₂ and exactly 364 minimum words. Their weighted pair concurrences alone reconstruct the passant incidence matrix, the code, and the six-class elliptic association scheme. The resulting group action then reconstructs all points and lines of PG(2,13), the distinguished conic, and its polarity; no coordinates or triple concurrence are required. Equivalently, the weighted 2-section of the minimum-support hypergraph is a complete invariant of this marked conic-plane presentation. The four minimum-word families are one octahedral family and three chord-indexed punctured-conic families, and each spans the code. The binary relation algebra acts on the code through a scalar field F₈, making it twelve-dimensional over that field; the four orbit Grams are nonzero scalars. This marked action is recovered from pair data. An exact positive semidefinite certificate excludes weight eight; a line moment followed by exact stabilizer exhaustion excludes weight ten.
>
**Delivers.** The minimum-weight codewords of a binary code built from the
passant lines of a conic over the field with thirteen elements reconstruct the
code and the marked projective plane that produced it.  The paper also
determines the code’s minimum distance and coordinate symmetries.

**Who cares.** Coding theorists and finite geometers interested in inverse
problems, minimum-weight structure, and the information retained by a code.

**Why it matters.** A small layer of codewords retains enough incidence data to
recover a much richer geometric object.  The result supplies a q=13
reconstruction counterpart to the earlier Clebsch recognition work.

---

#### Computational Strengthenings of Clebsch Syndrome Rigidity — companion

[PDF](https://github.com/tavisrudd/clebsch-rigidity/blob/main/clebsch_rigidity_computational_companion.pdf) · [Repository](https://github.com/tavisrudd/clebsch-rigidity) · [![DOI](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.21652792-blue.svg)](https://doi.org/10.5281/zenodo.21652792)

**Standout result.** An exact finite classification finds only the F₅
four-frame and the F₁₁ Clebsch six-arc among conic-filling arcs through eight
points.

**Delivers.** Exact finite computations and strengthened census results support
the first Clebsch paper, with reproducible verification material.

**Who cares.** Readers checking finite classifications, computational
geometers, and anyone who wants independently replayable evidence.

**Why it matters.** The companion separates structural arguments from
exhaustive checks and makes delicate finite claims inspectable.

It is housed in the `clebsch-rigidity` repository rather than in a separate
public mirror.

*Companion abstract.* For a projective arc A ⊂ PG(2,q), let U(A) be the points on no chord of A. The geometric paper proves, without an exhaustive classification of six-arcs over F₁₁, that a six-arc in PG(2,11) whose uncovered locus lies on a conic is the Clebsch hexagon. Here exact finite computation sharpens and extends that result. There are fifteen projective classes of six-arcs over F₁₁; the Clebsch class is the unique one whose uncovered locus is contained in a cubic, and it is separated from every other class by a four-point gap in uncovered-set size. A Sylvester-graph obstruction shows that q = 11 is the only field order admitting a conic-filling six-arc. Exhaustive orbit searches then classify all conic-filling arcs through eight points: only the projective four-frame over F₅ and the Clebsch six-arc over F₁₁ occur. The companion also preserves the original q = 13 computations underlying forthcoming Paper IV, which gives the passant-code reconstruction theorem a standalone structural and reproducible account. The finite claims are accompanied by exact replay routes and a claim-by-claim trust ledger.

---

### Other papers

#### Arcs Complete Outside a Conic: A Prescribed-Hole Defect Identity and Matching-Design Rigidity

[PDF](https://github.com/tavisrudd/arcs-complete-outside-conic/blob/main/arcs_complete_outside_conic.pdf) · [Repository](https://github.com/tavisrudd/arcs-complete-outside-conic) · [![DOI](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.21682567-blue.svg)](https://doi.org/10.5281/zenodo.21682567)

**Standout result.** A universal pointwise secant-defect identity turns zero
defect into maximum-matching-design rigidity and gives explicit stability; its
principal conic application yields a quantitative lower bound and exact small
orders.

> *Abstract* An arc is a point set with no three collinear; its secants are the lines joining pairs of its points. For an arc in any finite projective plane and any prescribed set of points allowed to remain uncovered, we combine the first two moments of the number of secants through an external point into an exact identity with a pointwise nonnegative remainder. Its vanishing turns the canonical secant-concurrency decomposition of the pairs of secants with disjoint endpoint pairs into maximum-matching cliques. Equivalently, it produces a simple MATCH(k,⌊k/2⌋,1) design in which every pair of independent edges occurs once. In a Desarguesian plane, its matching blocks are realized by concurrent chord families of the planar k-arc. The same remainder gives explicit edge and deletion stability away from equality.
>
> As the principal application, for a nonsingular conic C ⊂ PG(2,q), let ρC(q) be the least size of an arc disjoint from C whose secants cover every remaining point outside C. We prove ρC(q) ≥ √(2q) + 3/2 − 8/√(2q). We determine the possible zero-defect orders and classify zero defect in characteristic two: for odd k ≥ 7, equality gives an oval whose nucleus lies on C, while for even k ≥ 6, it forces k = q + 2. A kernel-checked finite classification proves ρC(16) = 9. Separate exhaustive classifications, with kernel-checked attaining witnesses, give ρC(13) = 8, ρC(17) = 9, and ρC(19) = 10. The defect identity, equality criterion, and deletion stability are independently formalized in Lean.
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
used in the rigidity theorem of Clebsch Paper I above.  That relationship is a
specialization of the identity, not a claim that the Clebsch hexagon has zero
defect in the present paper's matching-design sense.

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
entangled quantum states must come from the code’s discrete symmetry group;
approximate changes are quantitatively close to that group.

**Who cares.** Quantum-information theorists, stabilizer-code researchers, and
people studying robust classifications of entangled states.

**Why it matters.** The result gives both an exact classification and a
noise-tolerant version, which is essential when experiments and numerical
models produce near-symmetries rather than perfect ones.

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

#### Exchange Landscapes, Orientation, and Rigidity in the Golden Six-Mode Conference Interferometer

[PDF](https://github.com/tavisrudd/golden-quantum-statistics/blob/main/golden_quantum_statistics.pdf) · [Repository](https://github.com/tavisrudd/golden-quantum-statistics) · [![DOI](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.21766747-blue.svg)](https://doi.org/10.5281/zenodo.21766747)

**Standout result.** Order six is the unique nontrivial symmetric conference
order whose balanced exchange spectrum is independent of the cut, with
corresponding extremality and stability results for the golden interferometer.

> *Abstract* We study a six-mode interferometer built from a real symmetric conference matrix C of order six. Since C² = 5I, its mode space splits into two three-dimensional eigenspaces with eigenvalues +√5 and −√5. We call this the Golden realization because φ = (1+√5)/2 is the golden ratio. A diagonal control couples the two eigenspaces through a three-by-three transfer. Singular values classify this transfer when its ports are unframed. Orienting the ports adds the sign of the top exterior amplitude; up to scale, the determinant is the unique minimal-degree polynomial carrying this relative orientation. Fully calibrated frames expose matrix-dependent amplitudes such as the permanent.
>
> For symmetric conference matrices, the balanced exchange spectrum is a normalized cross-Gram spectrum; order six is the unique nontrivial order at which it is independent of the balanced cut. In the Golden order-six transfer, the balanced Boolean controls are precisely the joint maximizers of all degree-three Schur sectors over the real control cube. Hermitian conference phase gives a transverse deformation. Triangle holonomy fixes the first two exchange moments and moves the degree-three sectors along an exact Pareto segment. Constancy of any one sector characterizes the real switching class. An averaged squared-holonomy defect controls the Frobenius distance to the real conference orbit globally from below and locally from above.
>
> The Golden realization retains a calibrated determinant-sign code and a photonic design boundary. Common-reference tomography and ordinary-photon controls test its one-particle carrier and bosonic shadow, whereas direct three-fermion emulation needs an additional antisymmetric three-qutrit source. This is a theory and design-limit analysis, not a report of a built device.
>
**Delivers.** An analysis of a six-channel optical device whose hidden modes
are governed by a golden conference matrix.  Singular-value measurements see
the unoriented device; calibrated ports recover its handedness, while balanced
exchanges single out the six-channel case.

**Who cares.** Quantum-optics researchers, mathematical physicists, and people
designing or analyzing multi-mode interferometers.

**Why it matters.** Abstract matrix symmetry becomes a set of experimentally
meaningful signatures, including a quantitative measure of departure from the
real switching class.

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
