# C1110: terminology, notation and accessibility audit

**Lane:** continuation. **Date:** 2026-09-07.

## Findings and disposition

The audit distinguishes standard terms, useful explicitly defined local names,
and unnecessary or misleading labels. It does not infer authorship from prose or
claim that a term's absence from a bounded search proves it was invented.

| Item | Disposition and reason |
|---|---|
| Projective frame, arc, tangent, secant, collineation | Retained: native finite-geometry vocabulary with operational definitions. |
| Pencil | Corrected: all lines through a point, not just its tangents. Nonempty tangent traces induce the associated partition of continuation points. |
| Projectivity versus semilinear collineation | Both explicitly defined; stabilizers are setwise, explaining the frame permutation group. |
| Continuation graph; legal continuation | Retained as the paper's explicitly defined object and vertex convention. No claim that these are universal finite-geometry names. Renaming them would not clarify the construction. |
| Tangent trace; class with centre t | Retained as transparent local descriptions, with line, trace, and partition distinguished. |
| Four-pencil resolution | Replaced by resolution into four parallel classes. The definition identifies a clique decomposition together with its resolution; these are different data at q=5. |
| Parallel class | Defined as a partition of graph vertices into the prescribed cliques. Parallelism means disjoint vertex sets, not an assertion that projective lines fail to meet. |
| Centre-resolved argument | Replaced by “argument using the four centre classes”; the former reads as a named method without a definition. |
| Punctured multiplicative isotopy; shifted isotopy forces Frobenius | Replaced lemma captions with “Relabelling a punctured division table” and “Compatibility with translation”. Isotopy is established algebra terminology, but the extra name does not help this proof's reader. Semantic labels remain stable. |
| Trace seeds; five-seed enumeration | Replaced with common-neighbour recovery and enumeration of four-vertex subsets/five-cliques. Random relabelling seeds remain: that use is standard and operational. |
| Transport tests; coordinate transport | Replaced with isomorphism tests/coordinate isomorphism in public prose. |
| Canonical digests | Replaced by sorting and comparing hashes in the manuscript. This states the computational comparison directly. |
| Exact vertex covers | Corrected the verification README to “exact covers of the vertex set”; a graph vertex cover is a different object. |
| Hamming distance, nonlinear code, alphabet, fibre, Frobenius, orbit, coset | Retained: established terms with explicit local roles. “Power of Frobenius” is now precise where the exponent may vary. |

## Symbols

Retained the conventional q=p^e, k for arc size, PG(2,q), PΓL(3,q),
G_K, V_K, B_l, Sigma_t, Omega and coordinate alphabet D. The disjointness graph
D_K is distinguished from D by subscript and definition; another renaming would
not improve comprehension. N_G(v) is now defined as the open neighbourhood,
with the subscript omitted only when clear. The finite-table parallel-class
count is now a instead of p, preserving p for characteristic; its vertex-count
heading is explicitly |V(G_K)|. Multiplicative groups consistently use F_q^×.
Unused calligraphic macros were removed. Semantic statement identifiers and
all computational data keys are preserved.

## What most improves accessibility now

1. Local precision: line versus trace versus partition; projectivity versus
   semilinear map; exact cover versus vertex cover. These remove actual decoding
   ambiguities, rather than merely making the prose less technical.
2. Consistent object levels: the geometric pencils induce graph partitions;
   a graph resolution need not be geometric. The exceptional-order statement now
   uses design-theory language that makes this distinction visible.
3. Notation at first use: neighbourhoods and stabilizer convention are no longer
   left for an adjacent reader to infer.
4. Preserve the existing hierarchy: concrete puzzle, main theorem, worked frame,
   recovery mechanism, proof, recognition, finite boundary, optional background.
   Another reordering or overview would offer less value than these local fixes.

## Bounded usage checks

This is a terminology audit, not a priority audit. No additional theorem was
imported and no source was newly read in full. Primary usage checks:

- Mohr–Triggs, *Projective Geometry for Computer Vision*, “Cross Ratios of Pencils
  of Lines”: university-hosted author exposition, section read on the web, using
  pencil/centre and the complete linear family of concurrent lines.
  https://homepages.inf.ed.ac.uk/rbf/CVonline/LOCAL_COPIES/MOHR_TRIGGS/node30.html
- Milici–Tuza, *Uniformly resolvable decompositions of K_v into P_3 and K_3
  graphs*, arXiv:1312.2113: title and abstract only; published research search
  extracts additionally show parallel-class terminology. No classification
  result from this source is claimed or used.
  https://arxiv.org/abs/1312.2113
- Falcón, *The set of autotopisms of partial Latin squares*, arXiv:1107.3248:
  title/abstract only, confirming that isotopism/autotopism belongs to the
  literature on partial Latin squares. No assertion about its classification
  theorem enters this manuscript.
  https://arxiv.org/abs/1107.3248
- Existing BGMS and Dyshko readings support the hypergraph/code vocabulary;
  their exact read-depth and hash records remain in the motivation report.

Queries concerned pencils of lines, resolvable clique decompositions and parallel
classes, and partial-Latin-square isotopisms. Wikipedia and general aggregators
were returned but not used as authorities. ArXiv HTML and publisher-page access
failures were not treated as source readings. No new PDF was fetched for this pass.

## Validation and ej+tt closeout / Mystery ledger

Four changed statement bodies were reviewed before digest refresh: thm:triangle
and lem:isotopy change multiplicative-group notation, rem:small-order changes
local lemma wording, and prop:boundary changes count labels/resolution terminology.
The numeric table and mathematical domains are unchanged. The boundary claim-map
caution now specifies that resolutions include the decomposition and parallel
classes. Public README prose is synchronized. No algorithm or finite certificate
was modified.

The useful extra-value finding is the exact-cover/vertex-cover ambiguity in the
verification README; correcting it helps reproduction as well as prose. The
q=5 pair of resolutions on identical blocks shows why “decomposition” alone
would have been an incorrect replacement for “resolution”. No new mathematical
mystery emerged; q=7,8 explanations and the publication citation remain open.

Authority validation passed: `nix develop path:/home/tavis/src/othello/papers/continuation-graph-rigidity --command make -C papers/continuation-graph-rigidity check pdf`. The deterministic PDF is 336758 bytes. The changed finite-boundary page was visually inspected: definition and table fit cleanly. Scoped whitespace checks pass.
