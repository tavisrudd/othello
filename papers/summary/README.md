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

The central Clebsch portfolio currently has five papers: four numbered papers
in *The Clebsch cubic* series and the companion *Diagonal Isoduality and
Transversal Clifford Groups of MDS–CSS Codes*. The MDS–CSS paper has its own
all-length theorem and uses the Clebsch code as a worked application; it is not
a fifth numbered installment. The Golden interferometer paper is a related
companion, not a sixth Clebsch paper. Every paper is intended to stand on its
own mathematically.

Many structural components have independent Lean formalizations; coverage is
claim-specific and generally not end-to-end. Each repository states which
parts are prose proofs, cited inputs, kernel-checked formalizations,
certificate-checked computations, or trusted executions. See
[VERIFICATION.md](VERIFICATION.md) for links to the detailed paper-level
evidence maps.

- [selected headline results](#selected-headline-results)
- [theorems over infinite families](#theorems-over-infinite-families)
- [papers and entry points](#papers-and-entry-points)
- [verification philosophy](#verification-philosophy)
- [contact and disclosure](#contact-and-disclosure)

## Selected headline results

These are selected headlines, not a ranking. They are grouped to show the
range of the programme and to avoid counting several facets of one theorem
complex as separate victories.

### Finite geometry and reconstruction

- **Universal secant-defect identity.** For every finite projective plane and
  prescribed hole set, the first two secant moments give an exact identity with
  a nonnegative remainder. Its equality criterion yields a quantitative lower
  bound, deletion stability, and exact small-field consequences for arcs
  avoiding a conic. [Arcs Complete Outside a Conic: A Prescribed-Hole Defect Identity and Matching-Design Rigidity](https://github.com/tavisrudd/arcs-complete-outside-conic/blob/main/arcs_complete_outside_conic.pdf).

- **Sparse data recover marked finite geometry.** In the Clebsch case, a
  conic-containing deep-hole syndrome locus recognizes the non-GRS
  `[6,3,4]₁₁` code and recovers its conic, polarity, and golden orientation;
  a companion classification proves that `q = 11` is the only field order
  admitting a conic-filling six-arc. In the q=13 case, weighted pair
  concurrences of the 364 minimum words recover the binary code and the marked
  plane `PG(2,13)`, including its conic and polarity. [Clebsch I](https://github.com/tavisrudd/clebsch-rigidity/blob/main/clebsch_rigidity.pdf),
  [q=13 reconstruction](https://github.com/tavisrudd/q13-passant-code/blob/main/passant_code_q13.pdf).

- **Quadratic trades recognize exceptional matching geometries.** Across full
  `PGL₂(q)`-orbits of perfect matchings over odd fields, the specified
  two-valued strength-two trade occurs only for the `B₃/F₇` and `H₃/F₁₁`
  geometries. A first nonzero signed cubic detects exchange of their two
  sheets. [Quadratic Trade Rigidity and Cubic Orientation](https://github.com/tavisrudd/clebsch-factorization/blob/main/clebsch_factorization.pdf).

- **Coarse fourth-order data reconstruct two-graphs.** For every two-graph on
  at least seven vertices, aligned four-sets reconstruct the object up to
  complement, and seven is sharp. In the conference-signing setting, a
  carefully selected family of only `O(n²)` fourth-order determinant tests
  gives a decoder from order ten onward. This is a reconstruction theorem for
  coarse, negation-invariant data—not an improvement claim over general
  principal-minor assignment algorithms. The same paper also identifies the
  rational twist `√(5J₀)` in Hitchin's harmonic-cubic incidence cover and
  relates the resulting cubic through holonomy, exterior algebra, Pfaffians,
  and determinants. [Golden Descent and Operator Realizations](https://github.com/tavisrudd/clebsch-passages/blob/main/clebsch_passages.pdf).

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
| Clebsch I | If an arc's uncovered locus is a nonsingular conic, then `q` is odd and `2k − 3 ≤ q ≤ (k(k − 1) + 3)/3`. | Every `k`-arc, over every field order `q`. |
| Clebsch I companion | `q = 11` is the only field order admitting a conic-filling six-arc. | Every field order. |
| Clebsch II | The one-dimensional two-valued strength-two trade occurs only for the `B₃/F₇` and `H₃/F₁₁` orbits. | Full `PGL₂(q)`-orbits of perfect matchings, all odd fields. |
| Clebsch III | Aligned four-sets reconstruct the two-graph up to complement, and seven is sharp. | Every two-graph on at least seven vertices. |
| Arcs complete outside a conic | The first two secant moments give an exact defect identity with nonnegative remainder. | Every finite projective plane and prescribed hole set. |
| Projective Reed–Solomon deep holes | Split-free directions, and deep holes wherever the covering-radius gate applies, are classified in the stated ranges. | R5–R6: every `q ≥ 7`; R7: split-free for every `q ≥ 7` and deep holes for `q ≥ 11`; R8–R10: `q ≥ 43, 53, 59`. |
| Projective Reed–Solomon cubic pencils | On the trivial-gcd separable stratum, `#Y = 6N + 3d₂ + d₃` in every characteristic. | Every field order and characteristic. |
| Stabilizer AME rigidity | Every product-unitary intertwiner between stabilizer `AME(2m,q)` states is Clifford on each party. | Every prime power `q = pᵉ` and `m ≥ 2`. |
| MDS–CSS transversal groups | The diagonal multiplier nullity fixes the transversal logical group. | All `[2m,m,m+1]q` MDS codes over odd prime fields. |
| Golden six-mode interferometer | Order six is the unique nontrivial order whose balanced exchange spectrum is cut-independent. | Every symmetric conference order. |

## Papers and entry points

Each link below points to the public PDF file and repository on GitHub. Each
repository README gives the paper's scope, current status, formalization
boundary, and reproducible entry points.

| Paper | Area | Central result | Public entry |
|---|---|---|---|
| *Reconstructing the Clebsch Code and Its Golden Orientation from Its Deep-Hole Syndrome Locus* | Finite geometry / coding | Deep-hole data recognize the Clebsch code and golden orientation. | [PDF](https://github.com/tavisrudd/clebsch-rigidity/blob/main/clebsch_rigidity.pdf) · [repo](https://github.com/tavisrudd/clebsch-rigidity) |
| *Diagonal Isoduality and Transversal Clifford Groups of MDS–CSS Codes* | Quantum coding / finite geometry | A diagonal-isoduality nullity test determines the projective transversal group. | [PDF](https://github.com/tavisrudd/mds-css-transversal-groups/blob/main/mds-css-transversal-groups.pdf) · [repo](https://github.com/tavisrudd/mds-css-transversal-groups) |
| *Quadratic Trade Rigidity and Cubic Orientation in Conic Matching Quotients* | Algebraic combinatorics | A two-valued quadratic trade classifies two exceptional matching geometries. | [PDF](https://github.com/tavisrudd/clebsch-factorization/blob/main/clebsch_factorization.pdf) · [repo](https://github.com/tavisrudd/clebsch-factorization) |
| *Golden Descent and Operator Realizations of the Clebsch Cubic* | Algebraic geometry / combinatorics | A rational golden twist and coarse fourth-order data organize the conference-signing reconstruction. | [PDF](https://github.com/tavisrudd/clebsch-passages/blob/main/clebsch_passages.pdf) · [repo](https://github.com/tavisrudd/clebsch-passages) |
| *Minimum-Word Reconstruction of PG(2,13) from a Binary Conic Code* | Coding / finite geometry | Minimum words recover a marked projective plane, conic, and polarity. | [PDF](https://github.com/tavisrudd/q13-passant-code/blob/main/passant_code_q13.pdf) · [repo](https://github.com/tavisrudd/q13-passant-code) |
| *Arcs Complete Outside a Conic: A Prescribed-Hole Defect Identity and Matching-Design Rigidity* | Finite geometry / designs | A universal defect identity gives bounds and equality structure. | [PDF](https://github.com/tavisrudd/arcs-complete-outside-conic/blob/main/arcs_complete_outside_conic.pdf) · [repo](https://github.com/tavisrudd/arcs-complete-outside-conic) |
| *Deep Holes of Projective Reed–Solomon Codes Beyond Redundancy Four: Recursive Carriers and Exact Classifications Through Redundancy Ten* | Coding theory | Deep-hole classifications extend through redundancy ten in stated ranges. | [PDF](https://github.com/tavisrudd/beyond4-prs/blob/main/prs-beyond-redundancy-four.pdf) · [repo](https://github.com/tavisrudd/beyond4-prs) |
| *Local-Unitary Rigidity and Quantitative Rounding for Stabilizer AME States* | Quantum information | Exact local-unitary rigidity has a separate quantitative rounding theorem. | [PDF](https://github.com/tavisrudd/ame-lu/blob/main/ame-lu.pdf) · [repo](https://github.com/tavisrudd/ame-lu) |
| *Exchange Landscapes, Orientation, and Rigidity in the Golden Six-Mode Conference Interferometer* | Quantum information / mathematical physics | Cut-independent exchange spectra and orientation-sensitive stability are unique at order six. | [PDF](https://github.com/tavisrudd/golden-quantum-statistics/blob/main/golden_quantum_statistics.pdf) · [repo](https://github.com/tavisrudd/golden-quantum-statistics) |

The Clebsch I repository also contains the computational companion *Computational
Strengthenings of Clebsch Syndrome Rigidity*. It supplies exact finite
classifications and replayable evidence for the first paper rather than a
separate numbered paper.

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
