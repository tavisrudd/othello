# Paper III aligned-design faithfulness: deeper priority search

**Date:** 2026-08-02

**Lane:** `clebsch`

## Verdict

This follow-up searched the reconstruction literature under vocabulary absent
from the first C794 audit: `hypomorphy up to complementation`, reconstruction of
colorings from homogeneous sets, switching-class decks, principal-minor
recovery, and conference-submatrix spectral reconstruction.

The closest conceptual predecessor is now sharper.  The aligned-family datum of
a two-graph is precisely its labelled four-vertex isomorphism type up to
complementation: on four vertices a two-graph contains zero, two, or four
triples, and the aligned family records the zero/four class versus the two class.
Thus aligned-design faithfulness is a **4-hypomorphy-up-to-complementation
theorem for the constrained class of two-graphs**.

Pouzet--Si Kaddour prove that arbitrary 3-uniform hypergraphs require local size
five in the corresponding eventual reconstruction problem: their formula
`s(h)=h+2^{floor(log_2 h)}` gives `s(3)=5`.  Dammak--Lopez--Pouzet--Si Kaddour
prove the graph case at local size four from six vertices onward.  Paper III's
theorem occupies the exact intermediate boundary: the two-graph parity axiom
lowers the arbitrary 3-uniform threshold from five to four, with global order
seven sharp.

No source located in this deeper pass states that every two-graph on at least
seven labelled vertices is determined up to global complementation by which
four-subsets contain zero or four coherent triples.  No source located states
the conference corollary that the marked determinant-`(-3)` design reconstructs
the conference two-graph, or the quadratic selected-query decoder.

This is a strengthened qualified novelty verdict, not priority closure.
MathSciNet, direct Google Scholar screening, DeepDyve full-text search, and a
subject-expert check remain external gaps.  The safe wording remains “we prove”
and, if absence is mentioned, “to our knowledge”; never “first.”

## Individually discussed sources

Eight sources are discussed in this follow-up: **one at full-text depth**, three
at partial depth, and four at abstract/metadata depth.  The earlier C794 audit's
five source records remain in force and are not recounted here.

### Duncan--Hoffman--Solazzo, *Numerical Measures for Two-Graphs*

- Identifier: arXiv `0810.3189`; published DOI
  `10.1216/RMJ-2011-41-1-133`.
- **Read depth: full text.**  Read the complete arXiv v1 extraction, Sections
  1--7 and Appendix A.  The published version's body was not read; the
  mathematical characterization below is of arXiv v1.
- Access: shared cache key `arXiv:0810.3189`; SHA-256
  `47b184d9e56da34cb24b7289b5a4ad54b4f922164e8831a367e1f79354f5f01e`.
- Boundary: proposes reconstruction of a switching-equivalence class from its
  vertex-deleted switching deck and from a family of real-valued erasure norms.
  The deck statement remains conjectural there and uses a different, much
  richer invariant than the binary aligned-four-set family.

### Pouzet--Si Kaddour, *Isomorphy up to complementation*

- Identifier: arXiv `1501.05181`; published in *Journal of Combinatorics* 7
  (2016), with publication metadata read on the journal page.
- **Read depth: partial.**  Read the abstract, Section 1, definitions in Section
  2.1, Theorem 7 and its proof boundary, and Theorems 8--10 surrounding the
  general threshold in arXiv v1.  The published version's body was not read.
- Access: shared cache key `arXiv:1501.05181`; SHA-256
  `cf9d5463dc97bafa9fc7038c65bf73d271bf1198f27c301ad9b7c768b60a85a7`.
- Boundary: for arbitrary `h`-uniform hypergraphs, proves eventual equality up
  to complementation from `k`-hypomorphy and identifies the least possible
  local size as `s(h)=h+2^{floor(log_2 h)}`.  Hence `s(3)=5`; it neither treats
  the two-graph parity subclass nor proves a four-local theorem for it.

### Dammak--Lopez--Pouzet--Si Kaddour, *Hypomorphy of graphs up to complementation*

- Identifiers: arXiv `math/0601118`; DOI
  `10.1016/j.jctb.2008.04.004`.
- **Read depth: partial.**  Read the abstract, introduction, main theorem
  statements, definitions, and the stated threshold boundary in the arXiv
  preprint; the full proof and the published version's body were not read.
- Access: shared cache key `arXiv:math/0601118`; SHA-256
  `95dacb0ed74c3c09f37857201dfbf9b6e72e4502c0f396baf3c705d38bde4f29`.
- Boundary: proves the graph (`h=2`) four-local reconstruction result, including
  equality up to complementation for the stable range.  It is a direct
  conceptual predecessor, but not the two-graph theorem.

### Dammak--Lopez--Pouzet--Si Kaddour, *Boolean sum of graphs and reconstruction up to complementation*

- Published metadata: *Advances in Pure and Applied Mathematics* 4(3),
  315--349 (2013), as displayed in the accessible full-text index.
- **Read depth: abstract/metadata only.**  Read the indexed introduction and
  theorem statements, including the four-hypomorphy threshold and the
  three-homogeneous-set reduction; no stable PDF bytes were cached.
- Boundary: strengthens and organizes graph reconstruction up to
  complementation.  Its Boolean-sum and homogeneous-triple language explains
  the anchor step used in Paper III, but it does not add the away-from-anchor
  aligned four-set data or state the two-graph conclusion.

### Piña--Uzcátegui, *Reconstruction of a Coloring from its Homogeneous Sets*

- Identifier: arXiv `2009.12611`; DOI `10.1007/s00373-022-02597-6`.
- **Read depth: abstract/metadata only.**  Read the publisher abstract,
  introduction, stated reconstruction definition, and displayed local-to-global
  criterion; the proof body was not read.
- Boundary: asks when a graph/two-coloring is recovered from its entire family
  of cliques and independent sets.  This is adjacent reconstruction language,
  but the observable and class differ from Paper III's aligned four-subsets of
  a ternary two-graph.

### Gamboa--Uzcátegui-Aylwin, *Minimal Reconstructions of a Coloring from its Homogeneous Sets*

- Identifier: arXiv `2403.08104`; DOI `10.1007/s00373-025-02967-w`.
- **Read depth: abstract/metadata only.**  Read the publisher abstract,
  introduction, definitions, and displayed principal theorem summary.
- Boundary: classifies minimal edge changes preserving all graph homogeneous
  sets; it does not treat two-graphs or the aligned-four-set observable.

### Brunel--Urschel, *Recovering a Magnitude-Symmetric Matrix from its Principal Minors*

- Identifier: arXiv `2404.06302`.
- **Read depth: abstract/metadata only.**  Read the arXiv abstract and indexed
  result summary.
- Boundary: reconstructs broad matrix classes from numerical principal-minor
  data, with quadratic-query algorithms.  For a Seidel matrix, full third-order
  minors already reveal triangle signs; Paper III instead reconstructs from one
  binary class of fourth-order minors.  The input model is therefore strictly
  different.

### Greaves--Suda, *Symmetric and skew-symmetric {0, +/-1}-matrices with large determinants*

- Identifier: arXiv `1601.02769`; DOI `10.1002/JCD.21567`.
- **Read depth: partial.**  Inherited from the focused C729 audit: read arXiv
  v3, Section 4, especially Theorems 4.3 and 4.5.  This follow-up also rechecked
  the arXiv abstract, introduction's description of the submatrix problem, and
  indexed theorem statements.  The complete paper and the published version's
  body were not read.
- Access: shared cache key `arXiv:1601.02769`, PDF and text extraction;
  SHA-256
  `40cde5eff1bbd514c2952cb6ab36ad130116f7432ce6fb250cadb9c1eec093cf`.
  The prior durable source record is
  `notes/2026-07-31-c729-conference-cut-moments.md`, section “Focused
  literature audit.”
- Boundary: characterizes conference matrices from prescribed spectra of
  principal submatrices whose orders are close to the ambient order.  It does
  not reconstruct from the binary determinant-`(-3)` pattern on all
  four-subsets.

## Search record

Web result pages were screened over titles, snippets, abstracts, and accessible
indexed theorem text.  The load-bearing additional queries were:

1. `"two-graph" reconstruction "4-subsets"`
2. `"two-graph" "homogeneous sets" reconstruction`
3. `"two-graphs" "hypomorphic up to complementation"`
4. `"two-graph" "4-hypomorphic"`
5. `"switching class" reconstruction "two-graph"`
6. `"switching classes" "hypomorphy" reconstruction`
7. `graphs reconstructible up to complementation 3-homogeneous subsets Pouzet`
8. `"k-hypomorphic up to complementation" graph reconstruction`
9. `"same homogeneous subsets" graph reconstruction complement`
10. `Seidel matrix reconstruction from principal minors determinants switching equivalence`
11. `signed complete graph reconstruct switching class from principal minors`
12. `conference matrix reconstruction principal 4x4 determinants`
13. `Greaves Suda determinant design reconstruct conference matrix`
14. `"determinant -3" "switching class" conference`
15. `"3-(4n+2,4,n-1)" reconstruction conference`

No exact two-graph predecessor was promoted.  The search did promote the
hypomorphy-up-to-complementation lineage, the switching-deck conjecture, the
coloring-from-homogeneous-sets branch, and principal-minor recovery as necessary
related-work boundaries.

This was a discovery screen, not an exhaustive database screen: the web search
interface exposed no stable total result counts.  The screened fields were
title, snippet, abstract, and accessible indexed theorem text.  The discriminator
was: `recover the labelled two-graph from only the binary zero/four-versus-two
type of every four-subset`.  Sources using all triangle signs, numerical
principal minors, vertex-deleted decks, or full induced isomorphism types were
classified as adjacent rather than pre-emptive.

## Coverage gaps

- **Google Scholar: NOT COVERED.**  Automated access was unavailable; the
  manual queries below are supplied for the user-facing browser pass.
- **DeepDyve: NOT COVERED.**  No authenticated interactive account was
  available in the agent session; the manual queries below are supplied for
  that pass.
- **MathSciNet: NOT COVERED.**  Institutional authentication was unavailable.
- **Subject-expert check: NOT COVERED.**  No expert response was solicited.
- **zbMATH Open: NOT EXHAUSTIVELY COVERED.**  General web discovery exposed
  indexed records, but no bounded MSC or author-result set was enumerated.

These are access or coverage gaps and license no negative.  The negative in the
verdict is limited to the explicitly recorded web discovery queries and the
individually read sources above.

## External manual-search queries

For Google Scholar, use quotes as written and inspect both “Cited by” and
“Related articles.”  DeepDyve may ignore operators, so repeat the short variants
without quotes if necessary.

Highest-value exact queries:

1. `"two-graph" "4-hypomorphic"`
2. `"two-graphs" "hypomorphy up to complementation"`
3. `"two-graph" "isomorphy up to complementation"`
4. `"two-graph" reconstruction "coherent four-sets"`
5. `"two-graph" reconstruction "incoherent four-sets"`
6. `"two-graph" reconstruction "homogeneous 4-subsets"`
7. `"switching class" reconstruction "homogeneous subsets"`
8. `"conference matrix" reconstruction "principal minors"`
9. `"conference matrix" "determinant -3" design reconstruction`
10. `"Seidel matrix" reconstruction "4x4 principal minors"`

Vocabulary-bridge queries:

11. `"3-uniform hypergraph" "4-hypomorphic up to complementation"`
12. `"ternary relation" reconstruction up to complementation four subsets`
13. `"Boolean sum" two-graphs reconstruction`
14. `"signed complete graph" reconstruction triangle signs four vertices`
15. `"switching equivalence" reconstruction determinant pattern`
16. `"coherent quadruples" two-graph reconstruction`
17. `"cliques and cocliques" two-graph reconstruction`
18. `"aligned four-set" two-graph`

Author/forward-chain queries:

19. `"Isomorphy up to complementation" two-graph`
20. `"Claw-freeness, 3-homogeneous subsets" two-graph`
21. `"Constructions of t-designs from weighing matrices" reconstruction`
22. `"Constructions of t-designs from weighing matrices" "Cited by"`
23. `author:"Maurice Pouzet" two-graph reconstruction complementation`
24. `author:"Sho Suda" conference design reconstruction`

The manual screen should record result counts, exact queries, and any source
opened beyond title/abstract depth.  A hit matters only if it reconstructs the
labelled two-graph from the **binary zero/four-versus-two type of every
four-subset**; reconstruction from all triangle signs, all principal-minor
values, a vertex-deleted deck, or full induced isomorphism types is adjacent but
not pre-emptive.
