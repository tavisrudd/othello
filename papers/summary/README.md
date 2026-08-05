# Reconstruction and Rigidity in Finite Geometry, Coding, and Quantum Information

This is a summary of my current AI-accelerated research in finite
geometry, coding theory, and quantum information.

- [top 11 results](#top-11-standout-results)
- [paper abstracts, links, and guides](#non-specialist-guide-to-the-papers) 
- [trust and verification map](#trust-and-verification)

The papers ask a common inverse question: how much of a mathematical object can
be recovered after most of the original information has been discarded?  The
remaining data may be the errors farthest from a code, the minimum-weight words
of another code, the local symmetries of an entangled state, or measurements
that hide an optical device's orientation.

Across the collection, sparse combinatorial, coding-theoretic, or symmetry data
repeatedly determine unexpectedly rich algebraic or geometric structure. The
recurring mechanism is rigidity: find an invariant that survives the loss of
information, then prove that few possibilities remain. 

The papers are intended to be read independently. They share ideas and
occasionally cite one another, but each is written to stand on its own
mathematically; no reader needs to work through the full collection before
approaching an individual paper.

> **Evidence and verification.** Every paper in the programme is being brought
> to a common audit standard: an exact inventory of its theorem-like statements
> and a claim-level map to structural proof, cited result, Lean-checked
> component, finite certificate, or reproducible computation. Most theorem and
> lemma claims are structural mathematical arguments, written for human readers
> and formalized in Lean 4; those formal components are checked by the Lean
> kernel. A smaller subset depends on finite classification or large
> computation, for which the repositories retain exact certificates,
> independently implemented checkers, or independent replays. Formal coverage
> is not generally end-to-end: each paper's evidence map states exactly what
> Lean checks and what remains a manuscript or computational argument. The
> same tooling and audit standard are used across the full collection, with
> each paper's release surface recording its current completion status. The
> immediate target is to bring every paper to the level already
> demonstrated by Papers I and II.

## A request for help

I am an independent researcher with no institutional affiliation. Much
of this work crosses fields in which I do not have formal training. I
have worked hard to check the literature, but I need specialists to
help me avoid claiming results that are already classical, and to
identify important citations or technical mistakes that I have
missed. I am also looking for appropriate experts who would be
willing, after evaluating the relevant manuscripts, to endorse
suitable submissions for release as arXiv preprints.  An endorsement
would not be a request to vouch for work unread or replace peer
review; it would be informed support for making the papers available
for public scrutiny. If you work in one of these areas and can help
with either the literature audit or the arXiv process, I would be
grateful to hear from you via [my GitHub
profile](https://github.com/tavisrudd).

## Top 11 standout results

These are the strongest expert-facing headlines selected from the papers'
abstracts, introductions, and conclusions. They are ranked by breadth,
mathematical sharpness, and likely interest to specialists—not by paper length
or computational volume. Each headline is linked to the paper's public PDF.

1. **Local-unitary equivalence of stabilizer AME states is necessarily local Clifford.** For every prime power q and m ≥ 2, a product-unitary intertwiner between stabilizer AME(2m,q) states is Clifford on every party, with the corresponding statement for the associated transversal code conversion. [Local-Unitary Rigidity and Quantitative Rounding for Stabilizer AME States](https://github.com/tavisrudd/ame-lu/blob/main/ame-lu.pdf).

2. **Projective Reed–Solomon deep holes are classified beyond redundancy four.** The paper gives exact classifications at redundancies five and six for every prime power q ≥ 7, then extends the classification through redundancy ten in explicit field ranges. [Deep Holes of Projective Reed–Solomon Codes Beyond Redundancy Four](https://github.com/tavisrudd/beyond4-prs/blob/main/prs-beyond-redundancy-four.pdf).

3. **A universal secant-defect identity gives a quantitative lower bound for arcs avoiding a conic.** An exact identity with nonnegative remainder yields a general lower bound, a matching-design equality criterion, and deletion stability for prescribed-hole covering problems; the paper also settles several small fields exactly. [Arcs Complete Outside a Conic](https://github.com/tavisrudd/arcs-complete-outside-conic/blob/main/arcs_complete_outside_conic.pdf).

4. **Deep-hole data reconstruct the non-GRS Clebsch code and its golden orientation.** In PG(2,11), a six-arc has its uncovered locus on a conic exactly when it is the Clebsch hexagon; the same data recover the conic, code, polarity, orientation torsor, and an operator satisfying B² = 5I. [Reconstructing the Clebsch Code and Its Golden Orientation from Its Deep-Hole Syndrome Locus](https://github.com/tavisrudd/clebsch-rigidity/blob/main/clebsch_rigidity.pdf).

5. **A nullity test determines the transversal logical group of MDS–CSS codes.** For odd-prime [2m,m,m+1]q MDS codes, a zero-or-one-dimensional multiplier space determines which projective transversal group occurs: Fq² ⋊ SL₂(q) or the smaller triangular branch. [Diagonal Isoduality and Transversal Clifford Groups of MDS–CSS Codes](https://github.com/tavisrudd/mds-css-transversal-groups/blob/main/mds-css-transversal-groups.pdf).

6. **Minimum-weight codewords reconstruct the marked projective plane PG(2,13).** A binary passant-line code has parameters [78,36,12]₂ and 364 minimum words; their weighted pair concurrences recover the code, its incidence geometry, the conic, and its polarity. [Minimum-Word Reconstruction of PG(2,13) from a Binary Conic Code](https://github.com/tavisrudd/q13-passant-code/blob/main/passant_code_q13.pdf).

7. **Approximate stabilizer-AME symmetries round quantitatively to exact Clifford symmetries.** A leakage-aware argument places sufficiently approximate local symmetries near exact Clifford ones, with explicit dimension- and field-dependent bounds. [Local-Unitary Rigidity and Quantitative Rounding for Stabilizer AME States](https://github.com/tavisrudd/ame-lu/blob/main/ame-lu.pdf).

8. **A quadratic trade recognizes exactly two exceptional conic-matching geometries.** Across full PGL₂(q)-orbits of perfect matchings over odd fields, the specified two-valued strength-two trade occurs only for the B₃/F₇ and H₃/F₁₁ geometries, with a cubic detecting sheet exchange. [Quadratic Trade Rigidity and Cubic Orientation in Conic Matching Quotients](https://github.com/tavisrudd/clebsch-factorization/blob/main/clebsch_factorization.pdf).

9. **Four-local data—and only quadratically many tests—reconstruct conference signings.** The natural full-data baseline is to materialize every aligned four-set, costing Θ(n⁴) tests. Against that baseline, Paper III proves that the two-graph parity constraint lowers the local threshold to four, with seven vertices sharp, and gives an explicit O(n²)-test decoder that recovers conference signings from order ten onward up to switching and global negation. Dammak, Lopez, Pouzet and Si Kaddour prove the corresponding four-local theorem for ordinary graphs, also sharp from seven vertices; the size-five threshold applies to the strictly larger class of arbitrary 3-uniform hypergraphs. The two-graph observable is coarser than a graph's, so neither statement implies the other, and no located result covered it. [Golden Descent and Operator Realizations of the Clebsch Cubic](https://github.com/tavisrudd/clebsch-passages/blob/main/clebsch_passages.pdf).

10. **The rational twist in Hitchin's harmonic-cubic incidence cover is √(5J₀).** The paper identifies the marked degree-two function-field extension and shows that the associated oriented cubic has equivalent descriptions through holonomy, exterior algebra, Pfaffians, and determinants. [Golden Descent and Operator Realizations of the Clebsch Cubic](https://github.com/tavisrudd/clebsch-passages/blob/main/clebsch_passages.pdf).

11. **Order six is the unique nontrivial symmetric conference order with cut-independent balanced exchange spectrum.** The paper proves the uniqueness theorem and derives corresponding extremality and stability statements for the golden six-mode interferometer model. [Exchange Landscapes, Orientation, and Rigidity in the Golden Six-Mode Conference Interferometer](https://github.com/tavisrudd/golden-quantum-statistics/blob/main/golden_quantum_statistics.pdf).

## Theorems that quantify over infinite families

Most of the results above are not statements about one distinguished object:
they range over all field orders, all code lengths, all finite projective
planes, or all orders of a matrix family, and the exceptional objects appear
as their answers rather than as their hypotheses.  The table records, for each
released paper, a theorem of that kind together with the exact range it covers.

| Paper                              | General theorem                                                                                              | Quantifier range                                                                  |
|------------------------------------|--------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------|
| Clebsch I                          | An arc whose uncovered locus is a nonsingular conic obeys 2k − 3 ≤ q ≤ (k(k − 1) + 3)/3, with q odd          | every k-arc, over every field order q                                             |
| Clebsch I companion                | q = 11 is the only field order admitting a conic-filling six-arc                                             | every field order q                                                               |
| Clebsch II                         | The one-dimensional two-valued strength-two trade occurs only for the B₃/F₇ and H₃/F₁₁ orbits                | full PGL₂(q)-orbits of perfect matchings, all odd fields                          |
| Clebsch III                        | The balanced exchange spectrum is the squared singular spectrum of the cut block                             | every symmetric conference matrix                                                 |
| Clebsch III                        | Aligned four-sets reconstruct the two-graph up to complement, and seven is sharp                             | every two-graph on at least seven vertices                                        |
| Arcs complete outside a conic      | The first two secant moments give an exact defect identity with nonnegative remainder                        | every finite projective plane, every prescribed hole set H                        |
| Projective Reed–Solomon deep holes | Split-free syndrome directions, and deep holes where the covering-radius gate applies, are classified        | every q ≥ 7 at redundancies five to seven; explicit ranges through redundancy ten |
| Stabilizer AME rigidity            | Every product-unitary intertwiner between stabilizer AME(2m,q) states is Clifford on each party              | every prime power q = pᵉ and every m ≥ 2                                          |
| MDS–CSS transversal groups         | The diagonal multiplier space has dimension zero or one, and its nullity fixes the transversal logical group | every length: all [2m,m,m+1]q MDS codes, group over odd prime fields              |
| Golden six-mode interferometer     | Order six is the unique nontrivial order whose balanced exchange spectrum is cut-independent                 | every symmetric conference order                                                  |

## Non-specialist guide to the papers

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

**Standout result.** A specified two-valued quadratic trade occurs only for
the exceptional B₃/F₇ and H₃/F₁₁ matching geometries, and its cubic detects
the exchange of their two sheets.

> *Abstract* Restriction to a conic forgets how its marked points were paired into secants. Among full PGL₂(q)-orbits of perfect matchings, we classify those for which the conic-quotient evaluation space has a one-dimensional strength-two trade—a signed relation annihilating all quadratic coordinate products—generated by a two-valued vector. The only examples are the balanced B₃/F₇ and H₃/F₁₁ orbits. The trade itself reconstructs their two complementary sheets, so neither self-association nor Gorensteinness is an input. Thus, within the full matching carrier, an intrinsic low-degree relation recognizes the two exceptional octahedral and icosahedral geometries uniformly over all odd finite fields.
>
> The matching hypothesis is sharp. For either surviving stabilizer, the fixed locus in the ambient conic-product fiber is an affine line with q pairwise nonconjugate rational points. Its completely reducible Chow locus consists of the matching point alone, yet q − 2 nonmatching orbits have the same exact two-valued trade. Thus the trade ceases to be faithful off the matching carrier, while complete reducibility restores faithfulness. The exceptional one-factorizations themselves are classical; this fixed-line and Chow-selection mechanism is the new boundary.
>
> For the two matching configurations, the first nonzero signed tensor moment is an anti-invariant cubic. Their 14- and 22-point homogenizations are self-associated and arithmetically Gorenstein, and maximal isotropy identifies this cubic with the inverse system of an Artinian reduction. General self-dual-code criteria already account for the Gorenstein conclusion from the Schur square; the orbit classification, sharp carrier boundary, and sheet-sign cubic are the configuration-specific results. The orienting cubic is simultaneously the first tensor that detects sheet exchange and the socle generator governing Gorenstein duality. A uniform modular argument excludes every other matching orbit without a field census. One alternating-cycle calculation and a Dickson recurrence then handle the two radial nonvanishing problems at once.
>
**Delivers.** A simple two-level balancing pattern forces a geometric
arrangement into one of two exceptional pairing patterns, then a signed cubic
invariant determines each arrangement’s orientation.

**Who cares.** Finite geometers, combinatorialists, and researchers studying
designs, matchings, or symmetry-breaking invariants.

**Why it matters.** Local counting rules can recover pairing information that
has been deliberately erased.  A signed cubic invariant supplies the missing
orientation information.

---

#### III — Golden Descent and Operator Realizations

[PDF](https://github.com/tavisrudd/clebsch-passages/blob/main/clebsch_passages.pdf) · [Repository](https://github.com/tavisrudd/clebsch-passages) · [![DOI](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.21682515-blue.svg)](https://doi.org/10.5281/zenodo.21682515)

**Standout results.** The rational twist in Hitchin's incidence cover is
√(5J₀). Separately, four-local data reconstruct two-graphs from seven
vertices onward, and only O(n²) selected determinant tests are needed for the
conference-signing reconstruction.

> *Abstract* The rational twist in Hitchin's degree-two incidence cover over the projective space P(H) of harmonic cubics is a discriminant rather than a fitted constant. The two conjugate Clebsch charts meet in a nonsplit two-branch singularity whose residue-field pinching has square class [5]; accordingly the cover's function field is Q(P(H))(√(5J₀)). A complete golden fibre over [xyz] evaluates that class, while the Clebsch chart satisfies ιₜ*J₀ = 16σ₃². Fixing the marked bridge datum attaches the chosen sign to an order-six conference operator C, with C² = 5I.
>
> Its oriented cubic, and likewise each of its six outer translates, is simultaneously a triangle holonomy, the diagonal of ⋆∧³C, a commutator Pfaffian, and a cross-golden determinant. The middle two agree for every symmetric matrix, and the last is a reformulation of the golden splitting; that the triangle holonomy joins them is a property of the conference class rather than a formal identity. The six outer translates are the signed Joubert coordinates on the Segre cubic; centered squares give the Segre–Igusa polar map, and a coordinate section gives the diagonal Clebsch cubic. For every symmetric conference matrix the balanced exchange spectrum is the squared singular spectrum of its cut block, and cut-independence singles out order six. Independently of the golden setting, the four-by-four principal minors of a Seidel matrix determine it up to switching and global negation once there are at least seven vertices, where seven is sharp; equivalently, aligned four-sets reconstruct every two-graph up to complement. Thus marked determinant-(−3) blocks recover every symmetric conference signing of order at least ten, by a decoder using quadratically many selected determinants.
>
> These sign comparisons are relative to the marked datum, not an identification of the ambient harmonic representations. With the same convention, the Petersen (−2)-eigenspace of coefficient vectors on the ten icosahedral face axes embeds as the Clebsch four-space in degree-six zonal harmonics, and the normalized spherical cubic restricts to the exact multiple −784000σ₃/1247103.
>
**Delivers.** The arithmetic behind the series’ golden orientation is connected
to a six-by-six conference matrix whose square is five times the identity.  The
paper organizes several appearances of the same cubic through conference
matrices, determinants, Pfaffians, exterior algebra, and related geometric
formulas.

**Who cares.** Algebraic geometers, representation theorists, finite
geometers, and mathematical physicists.

**Why it matters.** Complementary descriptions make different aspects of the
same structured calculation visible.  Their complete identification across the
series remains part of the continuing program.

---

#### IV — Minimum-Word Reconstruction of PG(2,13) from a Binary Conic Code

[PDF](https://github.com/tavisrudd/q13-passant-code/blob/main/passant_code_q13.pdf) · [Repository](https://github.com/tavisrudd/q13-passant-code) · [![DOI](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.21783971-blue.svg)](https://doi.org/10.5281/zenodo.21783971)

**Standout result.** The 364 minimum words of the [78,36,12]₂ passant-line
code reconstruct the marked projective plane PG(2,13), including its conic
and polarity.

> *Abstract* Let C be a nonsingular conic in PG(2,13), and form the binary incidence code on its 78 internal points using the 78 passant lines. We prove that the code has parameters [78,36,12]₂ and exactly 364 minimum words. Their weighted pair concurrences alone reconstruct the passant incidence matrix, the code, and the six-class elliptic association scheme. The resulting group action then reconstructs all points and lines of PG(2,13), the distinguished conic, and its polarity; no coordinates or triple concurrence are required. Equivalently, the weighted 2-section of the minimum-support hypergraph is a complete invariant of this marked conic-plane presentation. The four minimum-word families are one octahedral family and three chord-indexed punctured-conic families, and each spans the code. Structurally, the code is 12-dimensional over a canonical operator field F₈; this hidden scalar action explains why every minimum-word family spans. Exact positive-semidefinite and line-moment certificates exclude weights eight and ten, replacing the corresponding subset and syndrome searches.
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

**Further work.** Clebsch V is in preparation as a later addition to the
series.  The current intent is a short paper whose headline is a recognition
and round-trip statement: constructions defined independently in the earlier
papers are expected to transport onto a single oriented cubic, and that cubic
in turn to reconstruct the conference operator and its quadratic spectral
algebra, up to declared markings.  Its architecture is still open and nothing
here should be read as a proved theorem or a settled title; details will be
added when a public version is available.

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

#### Arcs Complete Outside a Conic

[PDF](https://github.com/tavisrudd/arcs-complete-outside-conic/blob/main/arcs_complete_outside_conic.pdf) · [Repository](https://github.com/tavisrudd/arcs-complete-outside-conic) · [![DOI](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.21682567-blue.svg)](https://doi.org/10.5281/zenodo.21682567)

**Standout result.** A universal secant-defect identity gives a quantitative
lower bound for arcs avoiding a conic, together with a matching-design equality
criterion and deletion stability.

> *Abstract* For a nonsingular conic C ⊂ PG(2,q), let ρC(q) be the least size of an arc disjoint from C whose secants cover every remaining point outside C. We prove ρC(q) ≥ √(2q) + 3/2 − 8/√(2q). We determine the possible zero-defect orders and classify zero defect in characteristic two: odd k gives an oval whose nucleus lies on C, while even k forces k = q + 2. A kernel-checked finite classification proves ρC(16) = 9. Separate exhaustive classifications, with kernel-checked attaining witnesses, give ρC(13) = 8, ρC(17) = 9, and ρC(19) = 10.
>
> The mechanism is a theorem for every finite projective plane and every prescribed hole set H: the first two secant moments combine into an exact identity with a pointwise nonnegative remainder. Its vanishing turns the canonical secant-concurrency decomposition of KG(k,2) into a simple MATCH(k,⌊k/2⌋,1) design; in a Desarguesian plane this design has a rank-three projective realization. Its total gives an explicit deletion bound away from equality. The defect identity, equality criterion, and deletion stability are independently formalized in Lean.
>
**Delivers.** An exact counting identity governs collections of points that
avoid a chosen curve while their connecting lines cover everything else.  It
gives a general lower bound and settles several small fields exactly.

**Who cares.** Finite geometers, design theorists, and researchers studying
projective planes or extremal configurations.

**Why it matters.** A visual covering problem becomes a sharp defect
calculation, with zero defect forcing rigid exceptional cases.  The
secant-moment identity proved here, valid in every finite projective plane and
for every prescribed hole set, is the general form of the chord-defect identity
that drives the rigidity theorem of Clebsch Paper I above; the Clebsch hexagon
is one instance of the equality case.

---

#### Deep Holes of Projective Reed–Solomon Codes Beyond Redundancy Four

[PDF](https://github.com/tavisrudd/beyond4-prs/blob/main/prs-beyond-redundancy-four.pdf) · [Repository](https://github.com/tavisrudd/beyond4-prs) · [![DOI](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.21682069-blue.svg)](https://doi.org/10.5281/zenodo.21682069)

**Standout result.** Exact projective Reed–Solomon deep-hole classifications
extend to redundancies five and six for every prime power q ≥ 7, with further
exact ranges through redundancy ten.

> *Abstract* We classify projective Reed–Solomon split-free syndrome directions from the first previously open case, redundancy five, through redundancy ten, and obtain deep-hole classifications wherever the covering-radius gate is available. A syndrome is split-free precisely when its two-row Hankel kernel contains no completely split squarefree form. Coherent polar contraction retains a removed root as a marker, allowing a lower split witness to lift without repetition.
>
> For every r ≥ 6, the reduced recursively contained locus is exactly the union of the catalecticant rank-two scheme and one maximal adjacent-zero Lucas carrier. Dense squarefree-marker contractions select one terminal component, while Pascal nesting merges all modular descendants into the maximal carrier. This geometric statement is unconditional. If the explicit pointed lower packages exist at every intermediate redundancy, then for q ≥ 6r − 15 + ⌊2√(6r − 17)⌋, every split-free syndrome lies in this carrier. Under the same hypothesis, when char Fq > r − 1, the Lucas carrier is empty; the radius theorem then gives exactly the tangent and conjugate-secant deep-hole families, with q(q + 1)²/2 projective directions.
>
> We discharge these packages at the fixed levels. Redundancies five and six are classified for every q ≥ 7; redundancy seven has a complete split-free classification for every q ≥ 7, which is a deep-hole classification for q ≥ 11; and redundancies eight, nine, and ten have exact deep-hole classifications for q ≥ 43, 53, 59, respectively. Certificates close the bounded R5–R7 residues, the full degree-nine Lucas carrier at q = 16, 32, and the invariant block at q = 64. With these closures, a final-pair Artin–Schreier argument proves that at redundancy ten the full degree-nine Lucas carrier is shallow over every F₂ᵐ, m ≥ 4.
>
**Delivers.** Exact classifications of the most misleading received words for
a major family of error-correcting codes, extending well beyond the first few
understood cases.

**Who cares.** Coding theorists working on Reed–Solomon codes, covering radius,
and polynomial interpolation.

**Why it matters.** “Deep holes” are maximally far from every codeword.  Their
classification clarifies the geometry of decoding failure and provides a
recursive way to organize many field sizes and redundancies.

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
## Use of AI

This project was developed with extensive assistance from OpenAI Codex
and Anthropic Claude. Under my direction, the systems assisted
throughout with proof exploration, literature research, symbolic and
finite computation, code and formal-proof development, verification,
and manuscript drafting and revision. I checked the resulting
arguments, computations, code, and cited sources, reviewed and edited
AI-assisted material, and assume responsibility for all content.

I was directly involved in every research/agent session. There were no
autonomous loops.  The models supplied most of the volume of work.  I
coordinated, pushed, and supplied some mathematical taste and
ambition.  I selected targets, chose which branches to deepen or kill,
maintained the definitions and conceptual links across subjects, and
decided what could enter a paper.  My often naive questions exposed a
hidden assumptions and unlocked potential gems the agents were going
to move past.

## Trust and verification

I've been very careful with the internal evidence chain and research
methodology but none of that internal process substitutes for
independent specialist review. To make the reviewer's job easier every
paper and every claim comes with automatically generated and audited
"trust metadata".

Every mathematical claim is tracked in a 'trust ledger' and assigned
a set of evidence types:

1. an ordinary prose mathematical proof;
2. a cited result, checked against its hypotheses and conventions;
3. a lean kernel-checked formal proof;
4. a certificate-checked finite computation; or
5. a trusted program execution or symbolic experiment.

The categories can support one another but do not collapse into one another.
A search may discover a pattern without proving it.  A certificate may verify
the reported output without proving that the search domain was complete.  Lean
may check a formal statement without establishing that it matches the prose
claim.  Each repository therefore states its own evidence boundary rather than
using “computer-verified” or “verified in Lean” as a blanket assurance.

I strived have strived to back as many claims as possible with fully
kernel-checked Lean 4 structural proofs. Computation and certificates
were used heavily for discovery and then retired as soon as possible.

For specialists who want to audit a claim, these are the useful entry points:

| Paper or group | Evidence and stated boundary |
|---|---|
| Clebsch I and its companion | The [verification surface](https://github.com/tavisrudd/clebsch-rigidity/tree/main/verification) separates the structural proof from the sharper finite censuses; the generated q=11 material is independently checked in the [certificate repository](https://github.com/tavisrudd/finitegeom-clebsch-q11-certificates). |
| Clebsch II | The [verification directory](https://github.com/tavisrudd/clebsch-factorization/tree/main/verification) records statement identity, proof mode, certificates, replays, and the aggregate release check. |
| Clebsch III | The repository separates the [artifact and trust boundary](https://github.com/tavisrudd/clebsch-passages/blob/main/ARTIFACT.md), [literature boundaries](https://github.com/tavisrudd/clebsch-passages/blob/main/literature-boundaries.md), and [release checks](https://github.com/tavisrudd/clebsch-passages/tree/main/verification). |
| Arcs complete outside a conic | The [public repository](https://github.com/tavisrudd/arcs-complete-outside-conic) distinguishes the general proofs and Lean-formalized identities from certificate-checked or trusted finite classifications, with exact replay commands. |
| Projective Reed--Solomon deep holes | The supplement gives [replay instructions](https://github.com/tavisrudd/beyond4-prs/blob/main/supplement/REPRODUCING.md), public classification records, and a [declaration-level Lean trust map](https://github.com/tavisrudd/beyond4-prs/blob/main/supplement/LEAN-STATEMENTS.md). |
| Stabilizer AME rigidity | The [formal boundary](https://github.com/tavisrudd/ame-lu#formal-boundary) names the kernel-checked cores and the quantitative and global arguments that remain manuscript proofs; the paper has no essential computational census. |
| MDS--CSS transversal groups | The [claim-level evidence report](https://github.com/tavisrudd/mds-css-transversal-groups/blob/main/supplement/EVIDENCE.md) separates all-length conceptual theorems, six-point certificates, and formal coverage. |
| Golden quantum statistics | The [evidence map](https://github.com/tavisrudd/golden-quantum-statistics/blob/main/verification/EVIDENCE.md) gives claim-level checks; the manuscript is a theory and design-limit analysis, not a report of a built device. |

For an essential finite computation, the retained bundle specifies the search
domain, completeness or termination argument, symmetry reduction,
deduplication, exact-arithmetic assumptions, acceptance criterion, inputs,
command, expected output, and hashes.  It includes an independent replay or
states why one is unavailable.  A negative result says “nothing was found in
this exhausted domain,” not “nothing exists” without a further argument.

The shared [`finitegeom`](https://github.com/tavisrudd/finitegeom)
repository currently contains > 300 Lean files and 83K Lean
lines. Generated certificates live in separate repositories.  It
measures the scale of the formal record, not the coverage of any
particular theorem; the paper-level maps above are the relevant
coverage claims.
