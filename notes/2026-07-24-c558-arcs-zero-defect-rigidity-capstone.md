# C558: zero-defect rigidity capstone for the arcs paper

**Lane:** `relconic`

**Date:** 2026-07-24

**Status:** complete. The priority audit narrowed the capstone, the manuscript integration and
proof audit are complete, and the PDF build and cold-proof gates pass.

## Result

The paper now turns the local equality criterion in its prescribed-hole defect identity into a
global incidence theorem:

1. the concurrence points of every arc canonically decompose the edges of \(KG(k,2)\) into
   variable matching cliques;
2. zero defect forces a simple
   \(\operatorname{MATCH}(k,\lfloor k/2\rfloor,1)\) design represented by secant concurrence in
   one projective plane;
3. the exact counts of maximum-index centres and their occurrences on each secant follow from the
   second index equation;
4. at nonzero defect, at most \(m(m-1)\Delta_{\mathcal H}(A)/2\) Kneser edges lie in
   nonmaximum concurrence cliques;
5. a projective normalization classifies the six-point realization, while the seven-point
   abstract obstruction is credited to prior matching-design theory;
6. if \(Q\ge4\), \(q=Q^d\), and \(d\ge2\), no \((Q+2)\)-arc can attain zero relative defect,
   so scalar-extended hyperovals never supply equality over the larger field.

The abstract, introduction, theorem spine, bibliography, and proof audit have been revised around
this identity--rigidity--stability progression. The finite value \(\rho_{\mathcal C}(16)=9\)
remains an application rather than the sole co-headline.

## Priority audit

Opening summary: **0 sources were read at full text; 1 source was read partially at the exact
load-bearing sections.** No manuscript novelty claim rests on an absence of prior work.

### Load-bearing source

- Brian Alspach and Katherine Heinrich, *Matching Designs*, *Australasian Journal of
  Combinatorics* 2 (1990), 39--55.
  **Read depth: partial.** Read the abstract and Sections 1, 3.1, and the relevant parts of the
  reference list from the journal PDF
  `https://ajc.maths.uq.edu.au/pdf/2/ocr-ajc-v2-p39.pdf`. Cached as
  `dblp:journals/ajc/AlspachH90`, SHA-256
  `1a9dd6fb3f004d30fd24b6f531e8cd47c950b491768ec3d29b580c01761fedbb`.
  Section 1 defines a \(\operatorname{MATCH}(n,k,\lambda)\) design as a family of \(k\)-matchings
  in which every pair of independent edges occurs exactly \(\lambda\) times, identifies this with
  a clique decomposition of the complement of the line graph, records the hyperoval construction,
  and states that the \(\operatorname{MATCH}(6,3,1)\) design is unique. Theorem 3.1 proves that no
  \(\operatorname{MATCH}(7,3,1)\) design exists.

### Search coverage

The screened web result sets came from the following load-bearing queries, applied to titles,
snippets, and available full-text indexing:

- `"clique decomposition" "Kneser graph" matchings`
- `"triangle decomposition" "KG(7,2)"`
- `"large sets" one-factorizations Kneser graph decomposition maximum matchings`
- `six arc diagonal points collinear GF(4) hyperoval characterization`
- `duads synthemes 15 secants hyperoval PG(2,4) concurrency`
- `"matching design" perfect matchings every pair disjoint edges`
- `"Matching Designs" Alspach Heinrich 1990 DOI`
- `MATCH(7,3,1) design nonexistence later citation`

The promotion discriminator was an exact match to either (i) a partition of pairs of independent
edges by maximum matchings, (ii) the \(n=7,k=3,\lambda=1\) nonexistence result, or (iii) the
six-point hyperoval secant-concurrence configuration. The Alspach--Heinrich paper met (i) and (ii)
directly and was promoted to source reading. General Kneser coloring papers concerned vertex
partitions, not the edge partition used here, and were not used.

MathSciNet and Google Scholar were not covered. No “first,” “new,” or “to our knowledge” wording
has been added. The manuscript states only the paper-specific geometric implication and credits
the established abstract design theory.

## Exact pre-emption and bounded adjacent-crown extraction

Alspach--Heinrich pre-empts three claims from C554 as independent crowns: the matching-design
formalism, the hyperoval source of perfect-matching designs, and the
\(\operatorname{MATCH}(7,3,1)\) nonexistence theorem. C554's independent exact-cover certificate
is therefore not used in the manuscript.

The surviving capstone is the bridge from the paper's defect identity to that theory, together
with the rank-three secant realization, prescribed-hole constraints, quantitative bad-edge
stability, and the self-contained six-point normalization.

One bounded extraction pass considered:

1. importing the known \(\operatorname{MATCH}(8,4,1)\) and
   \(\operatorname{MATCH}(12,6,1)\) nonexistence results;
2. using the two abstract \(\operatorname{MATCH}(10,5,1)\) classes as a projective-realizability
   test;
3. coupling the matching design to the conic chord/tangent graph;
4. extracting modular rank exclusions from the incidence Gram matrix.

Cheap tests rejected (1) for this task because Alspach--Heinrich reports it through earlier
primary sources not yet read, and rejected (2) because it opens a new rank-three realization
classification rather than strengthening the present proof for free. Candidates (3)--(4) are
exactly the mixed invariant gate already left unmet by C555. No additional task was allocated.

## Validation

The repository paper target passes:

```text
make -C papers arcs
```

The final build produced the 23-page tracked PDF. The scoped log audit found no undefined
references, undefined citations, or overfull boxes. Its two messages are the pre-existing XeLaTeX
`inputenc` notice and one underfull bibliography paragraph.

The cold-proof pass checked the new theorem statements and rendered pages 1 and 6--7. It verified:

- the \(k\ge4\) boundary before division by \(\binom m2\);
- the distinction between arbitrary projective planes and the Desarguesian six-point
  normalization;
- the unique-intersection argument behind simplicity and \(\lambda=1\);
- the per-secant count \(\binom{k-2}{2}/(m-1)\);
- the separate off-hole and hole weights in the bad-edge estimate;
- the characteristic-two diagonal-line bridge and the \(\mathbf F_4\) equation;
- the exact placement of the Alspach--Heinrich attribution.

The required `ej`+`tt` closeout promoted one cheap conceptual upgrade: the text now states the dual
rank-three star--matching pairwise-balanced design explicitly. It rejected a raw higher-moment
excursion, because C555 proves that such moments are subordinate to the existing defect and would
weaken the paper's hierarchy.

## Post-completion `ej` upgrade

The explicit user-requested `ej` pass combined the hyperoval matching-design family with the conic
equality count. For \(k=Q+2\), zero defect would force

\[
2|Z\cap\mathcal C|
 =-2q^2+(Q^2+3Q+2)q-Q^3-Q^2+2.
\]

For every scalar extension \(q=Q^d\), \(Q\ge4\), \(d\ge2\), this is already negative at
\(q=Q^2\) and decreases thereafter. The manuscript now records the stronger conclusion that no
\(\mathcal C\)-complete \((Q+2)\)-arc attains zero defect in this range; the statement does not
assume the arc itself is a scalar-extended hyperoval.

An independent exact-integer substitution into the original centre-count formula agrees with the
closed polynomial and gives \(s=-55,-1503,-28543\) for
\((Q,q)=(4,16),(8,64),(16,256)\), respectively. The manuscript rebuild still passes with the same
two non-blocking log messages, and rendered pages 8--9 show the new corollary and proof cleanly.

## Mystery ledger

- **Priority:** settled for the matching-design name, hyperoval construction, and \(k=7\)
  obstruction by Alspach--Heinrich. The six-point normalization is retained as a self-contained
  geometric proof without a novelty claim.
- **Theorem hierarchy:** settled by the `ej`+`tt` pass. The capstone is the defect-to-design
  implication and its dual rank-three realization; \(\rho_{\mathcal C}(16)=9\) remains a finite
  application.
- **Higher even sizes:** known abstract nonexistence at \(k=8,12\) may yield later corollaries,
  but primary-source verification is outside this bounded integration.
- **Scalar extension:** settled by the post-completion `ej` pass at the equality level. The
  matching design survives field extension, but the required number of maximum-index conic
  centres becomes negative for every \(Q\ge4\), \(d\ge2\).
- **Mixed rank-three invariant:** still open and remains the unmet C556 gate; C558 makes no claim
  beyond the exact equality and stability consequences already proved.
