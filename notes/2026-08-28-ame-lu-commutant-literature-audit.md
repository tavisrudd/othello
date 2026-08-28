# Literature audit: the commutant-algebra and low-party AME results

**Date:** 2026-08-28  
**Object audited:** [`2026-08-28-ame-lu-commutant-algebra-theorem.md`](2026-08-28-ame-lu-commutant-algebra-theorem.md)  
**Manuscript status:** frozen for this audit; no paper, README, summary, snapshot, or claim ledger was edited

## Executive verdict

This audit names seventeen sources. Four were read at **full text** and thirteen
at **partial** depth. All seventeen PDFs are in the shared literature cache,
with cache keys and SHA-256 hashes recorded below.

The audit supports a real mathematical upgrade, but the five claims should not
be advertised at the same novelty level.

| result in the research note | literature verdict | recommended posture |
|---|---|---|
| Theorem A: the algebra of block-diagonal endomorphisms preserving the AME stabilizer label space is a common holonomy centralizer | no predecessor located at the stated AME-specific scope; close precursors give general stabilizer automorphism groups, local-Clifford equations, and graph-state algorithms | strong structural contribution, with “to our knowledge”; define the algebra descriptively before assigning notation |
| Corollary B: the five symmetry groups are the determinant-one units of the five possible subalgebras of `M_2(F_q)` | the underlying `2 x 2` centralizer classification is elementary and standard; no earlier AME packaging was located | present as the compression and conceptual payoff of Theorem A, not as a separate priority claim |
| Theorem C: all fundamental holonomies commute for four and six parties | no predecessor located; Tan computes the four-qutrit case, but not this uniform theorem; additive-MDS classifications do not state it | strongest standalone new theorem found by this audit; retain “to our knowledge” because MathSciNet and a reliable zbMATH search were not covered |
| Theorem D: a non-scalar symmetry algebra forces CSS, quadratic-field, dual-number, or multiplicity-space code linearity | the constituent code models are prior art; Van den Nest--Dehaene--De Moor already identify, for qubits, `GF(4)`-linearity with invariance under a uniform order-three local Clifford | claim only the unified converse from the intrinsic algebra and the resulting AME/MDS structure; explicitly concede the qubit field-linearity precursor and all standard code constructions |
| Proposition E and the `AME(8,7)` witness | no earlier AME symmetry-stratum or center-only witness was located; the Zariski-open argument itself is standard algebraic geometry | claim the exact eight-party witness and the conditional genericity statement, not an unconditional theorem that the center-only case is generic for every field or every component |

Theorem C is the cleanest novelty win. Theorem A is the best organizing win.
Theorem D is the best framing win, but it needs the most careful attribution.
Corollary B is valuable proof compression rather than an independent novelty
claim. Proposition E is a sharpness result: it shows that the low-party theorem
stops at six parties and that the center-only row is genuinely realized at
eight parties.

No source located the combined statement

> fixed-party stabilizer-AME symmetries are the determinant-one units of an
> intrinsic block-diagonal endomorphism algebra, whose algebra type both
> classifies the symmetry group and forces the corresponding extra code
> linearity.

That negative is limited by the coverage statement below.

## Claim-level audit

### A. Intrinsic endomorphism algebra and holonomy commutant

The closest general precedents are Wirthmüller's local automorphism group of a
binary stabilizer code, Englbrecht--Kraus's determination of all local
symmetries of qubit stabilizer states, and the local symplectic matrix equations
used in nonbinary graph-state equivalence by Bahramgiri--Beigi. These works
establish that local stabilizer symmetries are a natural group-theoretic and
algorithmic object. They do not, in the portions read, define the algebra of all
block-diagonal label-space endomorphisms preserving an AME Lagrangian, identify
it intrinsically with a common centralizer of half-set transports, or recover
the fixed-party group as its determinant-one units.

Theorem A is therefore a defensible contribution. Its novelty is the
AME-specific identification and its chart independence, not the elementary
fact that compatible block matrices satisfy intertwining equations.

Recommended first-use terminology:

> Let `End_loc(L)` be the algebra of block-diagonal endomorphisms of the local
> symplectic label spaces that preserve `L`.

“Local endomorphism algebra” may then be used as a short defined name. “Common
centralizer” or “commuting algebra” is standard; “intrinsic commutant theorem”
is best kept as an internal descriptive label rather than presented as an
established term of art.

### B. Five algebra types

Once Theorem A reduces the problem to a subalgebra of `M_2(F_q)`, the five rows
follow from the standard classification of centralizers of `2 x 2` matrices:
full matrix algebra, scalars, split quadratic algebra, quadratic field, and the
dual numbers. The determinant-one groups are respectively `SL_2(q)`, its
center, a split norm-one torus, a nonsplit norm-one torus, and the
determinant-one units of the dual numbers.

This is an excellent replacement for a finite-subgroup classification and a
substantial improvement in proof architecture. It should be described as a
structural reduction or algebraic explanation. The audit does not support
claiming the elementary five-algebra list itself as new.

### C. Forced non-scalar commutant at four and six parties

No predecessor was located for the statement that every prime-dimensional
stabilizer `AME(4,q)` or `AME(6,q)` label space has endomorphism algebra of
dimension at least two. In particular:

- Tan determines the exact symmetry group of the unique `AME(4,3)` LU class
  and its associated qutrit code. This is an important special-case
  predecessor, but it neither states nor implies in its presentation the
  all-prime, four/six-party commuting-holonomy theorem.
- Danielsen classifies self-dual additive codes and their local-symplectic
  automorphisms over several small fields, including additive MDS cases. The
  classification is computational and code-by-code; no theorem forcing a
  non-scalar commutant for every length-four or length-six additive MDS code
  was located.
- General stabilizer symmetry papers allow finite groups with very small local
  images. They do not isolate maximal-distance/AME hypotheses that exclude the
  scalar commutant through six parties.

The right standalone statement is the algebra statement. The group corollary
must retain its small-field qualification: for prime `q >= 5` a quadratic
algebra forces a noncentral determinant-one symmetry, whereas at `q=3` the
split norm-one group can coincide with the center.

The strongest safe novelty sentence is:

> To our knowledge, no earlier result shows that the algebra of block-diagonal
> label-space endomorphisms of every four- or six-party prime-dimensional
> stabilizer AME state has dimension at least two.

### D. Symmetry-induced code linearity

The theorem's four outputs must be separated from the prior existence and
construction literature.

1. **Split algebra / CSS.** CSS constructions from paired classical codes are
   standard. The potentially new direction is that two global idempotents in
   the intrinsic symmetry algebra force a local axis splitting and hence two
   weighted-dual classical MDS codes.

2. **Quadratic field / Hermitian code.** The correspondence from an
   `F_{q^2}`-linear Hermitian self-orthogonal or self-dual MDS code to a
   nonbinary stabilizer code is standard in Ketkar--Klappenecker--Kumar--
   Sarvepalli and is used explicitly in recent AME constructions by
   Bevins--Bidav. Danielsen also distinguishes additive from field-linear
   self-dual codes. Most importantly, Van den Nest--Dehaene--De Moor,
   Theorem 2, characterize `GF(4)`-linear qubit stabilizer spaces by invariance
   under the same order-three local Clifford at every coordinate. Thus the
   `q=2` symmetry/field-linearity phenomenon is prior art. What appears new is
   the coordinate-framed, all-prime converse from the intrinsic algebra,
   together with the AME condition forcing MDS and weighted Hermitian
   self-duality.

3. **Dual numbers.** Linear and MDS codes over finite chain rings, including
   rings with a square-zero maximal ideal, are established subjects.
   Guenda--Gulliver prove, among other things, that MDS codes over finite
   principal ideal rings are free and relate them to residue-field MDS codes.
   No source located derives a dual-number module structure from local
   stabilizer symmetry. To avoid importing an unproved convention, the first
   paper statement should remain “a free rank-`m` code over
   `F_q[epsilon]/(epsilon^2)` for which every `m`-coordinate projection is an
   isomorphism.” It may be called MDS over the ring only after the chosen
   Hamming/Singleton convention and the distance consequence are stated.

4. **Full matrix algebra.** The decomposition into a simple `M_2(F_q)` module
   tensored with a multiplicity space is standard module theory. The new use is
   that AME half-set bijectivity turns the multiplicity space into a weighted
   self-dual classical MDS code.

Accordingly, the theorem title should emphasize **symmetry-induced module
structure** or **the code structures forced by the endomorphism algebra**.
“Exceptional symmetry is extra code linearity” is an effective explanatory
sentence, but “exceptional” should not be allowed to suggest that the four- and
six-party cases are rare: Theorem C says the opposite.

### E. Where the center-only case begins

The conditional genericity statement is a standard closed-condition argument:
inside any irreducible AME family containing one point with two noncommuting
holonomies, noncommutation is a nonempty open condition. The mathematical
content specific to this project is therefore the exact `AME(8,7)` witness and
the conjunction with Theorem C.

No earlier paper located in the AME, stabilizer-symmetry, or additive-MDS
searches states that the center-only fixed-party stratum is impossible through
six parties but realized at eight. The safe claim is:

> The six-party bound is sharp in party number: an exact stabilizer
> `AME(8,7)` example has two noncommuting fundamental holonomies and hence only
> the central linear image.

The word “generic” must always retain the proposition's hypotheses. The witness
does not by itself show density in every AME component or existence over every
prime field.

## Relationship to the current paper

The existing AME-LU manuscript already contains the common-centralizer group
calculation and the five group orders. The new audit changes the best framing,
not the validity of the printed theorem:

- Theorem A upgrades the group calculation to an intrinsic algebra statement.
- Corollary B replaces the current ad hoc five-case proof paragraph by one
  algebra classification.
- Theorem C is genuinely additional mathematics and changes the six-party
  interpretation.
- Theorem D explains what each non-scalar algebra means in coding theory.
- Proposition E shows that the scalar row is nevertheless realized at eight
  parties.

These additions do not weaken the paper's all-prime-power LU-rigidity theorem.
The group and algebra identifications A--D are deliberately prime-dimensional.
For `q=p^e`, the intrinsic algebra and centralizer description survive over
`F_p`, but the symmetry group must preserve the entire transported family of
alternating forms; it is not simply the symplectic units of one evaluated
copy. The audit found no literature basis for suppressing that extension-field
qualification.

## Search and screening record

### arXiv API sets

The following sets were obtained from the arXiv API on 2026-08-28. The screen
ran over **titles** returned by the API. The discriminator was:

> promote a result if its title concerns local symmetries or automorphisms of
> stabilizer/AME states, self-dual additive MDS codes, Hermitian self-dual MDS
> codes, or codes over the dual numbers/finite chain rings.

| exact query | returned set size | disposition |
|---|---:|---|
| `all:"absolutely maximally entangled" AND all:symmetry` | 10 | Tan and Bevins--Bidav promoted; the remaining eight titles concerned channels, broad entanglement classification, field theory, or holographic constructions rather than the audited algebraic claim |
| `all:"stabilizer state" AND all:"local symmetries"` | 2 | Englbrecht--Kraus promoted; the other item concerned classical-spin mappings |
| `all:"self-dual additive" AND all:MDS` | 1 | Danielsen promoted |
| `all:"Hermitian self-dual" AND all:MDS` | 11 | the set establishes an active construction literature; Bevins--Bidav and the stabilizer-construction sources were promoted for the quantum/AME boundary |
| `all:"dual numbers" AND all:code` | 11 | all eleven titles concerned automatic differentiation, numerical algebra, or language benchmarks; none concerned coding theory |
| `all:"finite chain rings" AND all:MDS AND all:code` | 9 | Guenda--Gulliver promoted; the other eight were construction or weight-distribution papers not connecting ring linearity to stabilizer symmetry |

Narrow control queries returned zero results for `"local endomorphism
algebra" AND stabilizer`, zero for `AME AND stabilizer AND "local symmetry"`,
one for `AME AND stabilizer AND automorphism` (Bevins--Bidav), and zero for
`"dual numbers" AND "MDS code"`. These zeros are keyword controls only; they
are not treated as exhaustive absence proofs.

### OpenAlex sets

OpenAlex keyword searches were run on 2026-08-28. For each query, up to the
first 50 records were screened over **title, publication year, type, and DOI**.
The same discriminator as above was applied.

| exact search string | OpenAlex count | screening result |
|---|---:|---|
| `"local endomorphism algebra" stabilizer state` | 1 | unrelated category theory |
| `AME stabilizer holonomy commutant symmetry` | 23 | returned records were false positives for geometric or gauge-theoretic holonomy |
| `stabilizer AME local automorphism group MDS` | 15 | Bevins--Bidav was the only AME construction promoted; no local-commutant theorem appeared |
| `dual numbers MDS code stabilizer` | 258 | broad quantum-code and ring-code noise; Ketkar et al. and ring-code literature promoted through targeted follow-up, not from an assumption that all 258 records were relevant |
| `Hermitian self-dual MDS stabilizer AME symmetry` | 6 | Bevins--Bidav promoted; the other records were unrelated or duplicate/construction records |

The OpenAlex counts are discovery counts, not citing-works counts. This audit
does not rely on an exhaustive forward-citation set, so the three-graph
OpenAlex/Crossref/Semantic-Scholar rule for citation negatives is not invoked.

### Backward chains

Reference lists and explicit prior-work sections were screened in the four
full-text papers and in the targeted sections of Ketkar et al., Danielsen,
Englbrecht--Kraus, Tan, Huber--Grassl, and the 2025 AME review. This promoted
the minimum-support LU--LC papers, nonbinary graph-state equivalence,
nonbinary stabilizer/additive-code foundations, and code-over-rings work.
This was a title-and-context backward screen, not a claim that every cited
paper was individually read.

## Coverage gaps and strength of the negative

- **MathSciNet: NOT COVERED.** Institutional authentication was unavailable.
  This is the main reason every absence claim must retain “to our knowledge.”
- **zbMATH Open: NOT RELIABLY COVERED.** The public REST endpoint was reached,
  but the load-bearing free-text queries returned inconsistent `404`/empty
  responses after the API's terms gate. No negative is inferred from those
  responses.
- **Google Scholar: NOT COVERED.** Automated access was not available.
- **Very recent work:** August 2026 arXiv material was included, especially
  Bevins--Bidav v2, but indexing lag means the 2026 frontier cannot be treated
  as closed.
- **Non-English and ring-coding literature:** one directly relevant Chinese
  paper on quantum codes over `F_q+uF_q` was located at abstract/full-page
  preview level but was not needed for a load-bearing conclusion and is not
  individually characterized here. The ring-code negative is therefore only
  about a symmetry-forces-linearity predecessor, not about the existence of
  dual-number or chain-ring MDS codes.
- **No forward-citation closure:** this was a keyword, backward-chain, and
  close-source audit, not an exhaustive forward-citation audit of any seed.
- **Extension fields:** the search did not locate a theorem matching the
  transported-multiple-form constraint for additive `q=p^e` stabilizers. That
  absence does not license a simple higher-`e` group formula.

The resulting negative is reasonably strong for arXiv-indexed quantum
information and coding-theory literature, moderate for the older coding
literature, and weak outside English-language and subscription-indexed sources.

## Source ledger

“Version” below is the cached arXiv version, not a claim that a separately
published journal version was checked.

| source | read depth and portions relied on | cache record |
|---|---|---|
| M. Van den Nest, J. Dehaene, B. De Moor, *Local unitary versus local Clifford equivalence of stabilizer states* | **full text**; arXiv `quant-ph/0411115v2`; all sections and appendices. Relied on Theorem 1/Corollary 1 (minimum support and LU=LC) and especially Theorem 2 (the `GF(4)`-linearity/uniform local-Clifford criterion). | key `arXiv:quant-ph/0411115`; SHA-256 `c0f8e192552369d5af9304ebf08995f59b6917e243a570f37ff1b29f3b4cb735` |
| M. Bahramgiri, S. Beigi, *Graph States Under the Action of Local Clifford Group in Non-Binary Case* | **full text**; arXiv `quant-ph/0610267v2`; all sections. Relied on the nonbinary graph-state normal form, local symplectic equations, graph operations, and equivalence algorithm. | key `arXiv:quant-ph/0610267`; SHA-256 `c3f8ae13be712936fd823c96d070d0afddf48b1f18ddf879441a8c4512f0b4db` |
| K. Wirthmüller, *Automorphisms of Stabilizer Codes* | **full text**; arXiv `1102.5715v1`; all sections. Relied on Theorem 3/Corollaries 4--5 (local automorphism restrictions) and Theorem 7/Corollary 11 (connected component and projective finiteness). | key `arXiv:1102.5715`; SHA-256 `5cfd43e7f314056c7c7f61e6da6599a56252a759c11552a7b2c4d50d736d8164` |
| S. Bevins, Y. Bidav, *Symmetry-guided construction and exact certification of absolutely maximally entangled states* | **full text**; arXiv `2608.05781v2`; all four pages. Relied on the Hermitian self-dual MDS-to-AME construction, scope disclaimer, and automorphism-assisted search. | key `arXiv:2608.05781`; SHA-256 `7700fbd512507281d77332c4dbf7af6ebdd83f379f11915e3f3089c64a1c6da8` |
| M. Englbrecht, B. Kraus, *Symmetries and entanglement of stabilizer states* | **partial**; arXiv `2001.07106v1`; abstract, Introduction, Section III theorem/algorithm statements, Sections V.A and VI, conclusion. Relied on the scope of the complete qubit local-symmetry characterization and its transversal-gate application. | key `arXiv:2001.07106`; SHA-256 `fecef9717dbf5807c3d6d7890c16c7bc2c89ac60c85003c14355929b1ffc1cac` |
| B. Zeng, H. Chung, A. Cross, I. Chuang, *Local unitary versus local Clifford equivalence of stabilizer and graph states* | **partial**; arXiv `quant-ph/0611214v2`; abstract, Introduction, Main Theorem and proof map, Theorem 2, conclusion. Relied on the post-minimum-support LU--LC scope. | key `arXiv:quant-ph/0611214`; SHA-256 `ee703ee6f3552af34a9497b6dfc57b977c99431c1963cc9b26ec334ffbb062fd` |
| A. Ketkar, A. Klappenecker, S. Kumar, P. K. Sarvepalli, *Nonbinary Stabilizer Codes over Finite Fields* | **partial**; arXiv `quant-ph/0508070v2`; Introduction, Sections 2--4, Hermitian/CSS construction results in Section 5, MDS discussion in Section 13, and relevant construction statements. Relied on the additive trace-symplectic and `F_{q^2}`-linear Hermitian stabilizer correspondences. | key `arXiv:quant-ph/0508070`; SHA-256 `138154de23946d0d6344ba19e1f42b9313b14b02b4ff348ccbe0d7781ca34a4c` |
| L. E. Danielsen, *Graph-Based Classification of Self-Dual Additive Codes over Finite Fields* | **partial**; arXiv `0801.3773v3`; abstract, Sections 1--3, automorphism and mass-formula discussion in Section 3, Sections 4--6, and MDS classification discussion. Relied on additive-code equivalence, local symplectic automorphisms, field-linearity as an extra condition, and small-field MDS classifications. | key `arXiv:0801.3773`; SHA-256 `cb105940244bdbb83c222ac0876cb7040bd388dafc715daff4213e40e03050d7` |
| I. Tan, *Transversal gates of the ((3,3,2)) qutrit code and local symmetries of the absolutely maximally entangled state of four qutrits* | **partial**; arXiv `2601.19677v2`; abstract, Introduction, Sections 2--3, Sections 4.5--6. Relied on Theorems 3.5--3.6 (AME/code orbit and symmetry dictionary), Theorems 5.1 and 5.3 (qutrit transversal/local symmetry groups), and the conclusion. | key `arXiv:2601.19677`; SHA-256 `460f398f1fe63aa347f2457e44c0fe12d1164bdc33a25ee3f44ce3805d4f48e6` |
| K. Guenda, T. A. Gulliver, *MDS and Self-dual Codes over Rings* | **partial**; arXiv `1207.3384v1`; abstract, Introduction, Proposition 2.3, Theorems 2.12--2.13, 3.1--3.3, Section 5, conclusion. Relied on freeness of MDS codes over finite principal ideal rings, residue-field structure, and established self-dual MDS ring-code terminology. | key `arXiv:1207.3384`; SHA-256 `9230f432126a4ffa6e0c6cd222f00e64f7220d99666556333f8a8f4218bde26c` |
| W. Helwig, *Absolutely Maximally Entangled Qudit Graph States* | **partial**; arXiv `1306.2879v1`; abstract, Sections 2--4, MDS construction in Section 5, conclusion. Relied on the graph-state/AME/MDS construction boundary. | key `arXiv:1306.2879`; SHA-256 `56b80b1e7d007388219d2c44d1b0921f3d4e0cf50fe360759ed22641c9655a3f` |
| F. Huber, M. Grassl, *Quantum Codes of Maximal Distance and Highly Entangled Subspaces* | **partial**; arXiv `1907.07733v2`; abstract, Sections 1--8, Theorems 8--10, Appendix C stabilizer-MDS correspondence, conclusion/tables context. Relied on the QMDS/AME family and weight-distribution boundary, not on a symmetry claim. | key `arXiv:1907.07733`; SHA-256 `c4e5dfba9f8ccbb3f496c956c96cc83cc9bb2c117f23e0a05be639153d444e94` |
| S. A. Rather, N. Ramadas, V. Kodiyalam, A. Lakshminarayan, *Absolutely maximally entangled state equivalence and the construction of infinite quantum solutions to the problem of 36 officers of Euler* | **partial**; arXiv `2212.06737v2`; abstract, Introduction, the `AME(4,3)` uniqueness theorem, LU-invariant sections, main infinite-class theorem, conclusion. Relied on the distinction between general AME LU classification and stabilizer-specific symmetry. | key `arXiv:2212.06737`; SHA-256 `740ee6e03fcd77f320ff03233f6b9ab0a7fba32781aa0cac40b5e88ed0465655` |
| N. Ramadas, A. Lakshminarayan, *Local unitary equivalence of absolutely maximally entangled states constructed from orthogonal arrays* | **partial**; arXiv `2411.04096v1`; abstract, Introduction, Sections 2--5 theorem statements, AME applications in Section 6, conclusion. Relied on infinite LU classes outside the stabilizer-specific setting. | key `arXiv:2411.04096`; SHA-256 `a73e8c2c48c2d55f07b1e34bc75ba0d18c7115ec4e65d412605f52bf7430c647` |
| N. Claudet, S. Perdrix, *Local equivalence of stabilizer states: a graphical characterisation* | **partial**; arXiv `2409.20183v4`; abstract, Introduction, principal graphical-characterization theorem statements, and conclusion. Relied on the modern qubit LU-equivalence boundary. | key `arXiv:2409.20183`; SHA-256 `48bd8f73a887a8ef3c36f5310184169a9c2ce630c85b45d3774bfe03644a9475` |
| N. Claudet, S. Perdrix, *Deciding Local Unitary Equivalence of Graph States in Quasi-Polynomial Time* | **partial**; arXiv `2502.06566v3`; abstract, Introduction, Section 3 algorithm, main complexity theorem, conclusion. Relied on the algorithmic state of the qubit problem. | key `arXiv:2502.06566`; SHA-256 `e31c2b6f31a62bc8e8c9e1da5a3ad092772a18f3c9d24055c0eb89d9e5c8a379` |
| G. Rajchel-Mieldzioć, R. Bistroń, A. Rico, A. Lakshminarayan, K. Życzkowski, *Absolutely maximally entangled pure states of multipartite quantum systems* | **partial**; arXiv `2508.04777v3`; Introduction, Sections III--IV, Section VII on local equivalence, Section VIII on codes, conclusion/open problems. This is a review article read directly, not a review service; relied on it only to map AME equivalence and construction topics, with primary sources checked for load-bearing claims. | key `arXiv:2508.04777`; SHA-256 `bc8ee8fc5648b574dc8e994eb7d27b7ef213e1873a2204e4060cc3613e15760b` |

## Claim-ledger wording and surface checklist

The current AME-LU claim--proof--novelty ledger has no row owning Theorems
A--E. Before any manuscript or public-summary integration, add three rows, not
five:

1. **Intrinsic block-diagonal endomorphism algebra and five algebra types.**
   Own A and B together; no separate novelty claim for the elementary algebra
   list.
2. **Low-party non-scalar commutant and eight-party sharpness.** Own C and the
   exact part of E; keep the genericity hypothesis explicit.
3. **Symmetry-induced code module structures.** Own D; concede all standard
   CSS/Hermitian/ring-MDS constructions and the Van den Nest--Dehaene--De Moor
   qubit field-linearity criterion.

Suggested ledger posture for row 2:

> To our knowledge, no earlier result proves that every four- or six-party
> prime-dimensional stabilizer AME state has a non-scalar algebra of
> block-diagonal label-space endomorphisms. An exact `AME(8,7)` witness shows
> that the conclusion is sharp in party number. This audit did not cover
> MathSciNet or a reliable zbMATH free-text search.

Because this audit creates verdicts for mathematics not yet integrated, it
does **not** change an existing ledger verdict. Surface status is therefore:

| surface | contains A--E novelty wording? | updated by this audit? |
|---|---|---|
| AME-LU manuscript | no | no; intentionally frozen |
| AME-LU claim--proof--novelty ledger | no owning row yet | no; rows proposed above |
| results-summary snapshot | no | no |
| public papers summary | no | no |
| AME-LU README | no | no |
| commutant-algebra research note | yes: “new low-party theorem” and evaluative wording | no; this audit is now the authority for those novelty descriptions |

The next integration pass should update the ledger first and make every other
surface point back to it. Until then, no new “first” or unqualified novelty
sentence is ready for the manuscript.
