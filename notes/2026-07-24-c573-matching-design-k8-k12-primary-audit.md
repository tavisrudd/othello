# C573: primary-source audit for `MATCH(8,4,1)` and `MATCH(12,6,1)`

**Lane:** `relconic`

**Date:** 2026-07-24

**Status:** complete. The `MATCH(12,6,1)` exclusion survives as an arbitrary
matching-design theorem after inspection of the independently rerun search.
The `MATCH(8,4,1)` exclusion is consistently stated by the literature, but its
historical proof remains one primary-source access step short of the repository's
load-bearing standard.

## Result

Opening source summary: **0 sources were read at full text; 3 sources were read
partially at the load-bearing sections; 4 historical sources were available only
through abstracts or bibliographic metadata.**

The two advertised exclusions have different trust boundaries.

1. A `MATCH(12,6,1)` design is exactly an abstract hyperoval of order ten. The
   2020 Bright--Cheung--Stevens--Kotsireas--Ganesh rerun of the
   Lam--Thiel--Swiercz--McKay search reaches a contradiction using only the
   `66 x 99` edge--perfect-matching incidence matrix. Its SAT constraints say
   that two matching columns meet in at most one edge, every matching covers
   every vertex, every pair of disjoint edges occurs, and the matchings through
   a fixed edge form a one-factorization of the complementary `K_10`. These are
   necessary consequences of `MATCH(12,6,1)` itself; no incidence outside that
   matrix and no Desarguesian hypothesis enters the contradiction. Thus the
   published search excludes the abstract matching design, not merely an oval
   already embedded in a projective plane.
2. A `MATCH(8,4,1)` design is exactly an abstract hyperoval of order six. The
   exclusion is stated by Alspach--Heinrich, by the 2026
   Bamberg--Klawuhn paper, and by Faina's classification abstract. However,
   Bamberg--Klawuhn's self-contained symmetric-function argument starts at
   `n>=5`; its `n=4` base case still cites Cameron Theorem 7.6 and Mathon.
   Cameron's book and Mathon's Congressus Numerantium paper were not obtainable
   in full text in this audit, and Faina's full classification paper was likewise
   paywalled. The exclusion is highly corroborated but is not promoted here as
   a primary-text-verified manuscript dependency.

C558 already excludes zero-defect eight- and twelve-arcs in every Desarguesian
plane by its equality spectrum and prime-power order gate. The first conclusion
is genuinely stronger: it excludes the twelve-point zero-defect configuration
in an arbitrary projective plane because C558 turns such a configuration into a
`MATCH(12,6,1)` design. The second would give the analogous arbitrary-plane
eight-point statement, but the repository should not make that upgrade
load-bearing until one of the historical primary proofs is obtained and read.

## Exact `MATCH(12,6,1)` reduction

Let the twelve design vertices index the first twelve columns, and let the
`binom(12,2)=66` edges index rows. Each of the `10^2-1=99` blocks of a
`MATCH(12,6,1)` design is a perfect matching, hence a six-one column on those
rows. The defining condition that every pair of disjoint edges occurs exactly
once gives:

- two matching columns share at most one row;
- each row lies in nine matching columns;
- for each edge `e`, the nine matchings containing `e`, after deleting `e`,
  form a one-factorization of the complementary `K_10`;
- every two disjoint edge rows meet in exactly one matching column.

These are precisely the properties used in Bright et al. Sections 2.1, 3.1,
3.2, and 4. Their primary search needs only blocks 2--6, and all 396 possible
isomorphism types for block 2 lead to no completion through the searched
submatrix. Therefore a full `MATCH(12,6,1)` design would restrict to a forbidden
SAT assignment. The implication is one-way and sufficient: the SAT model need
not characterize full projective planes.

Bamberg--Klawuhn Example 4.3 independently supplies the vocabulary bridge:
abstract hyperovals of order `n`, `2-(2,n+2)` partition systems, and
`MATCH(n+2,(n+2)/2,1)` designs are equivalent.

## Computational trust boundary

Bright et al. reran the 1983 search independently. Their implementation is
described as open source; the run produced about 33 TB of DRUP output, trimmed
and compressed to about 3 TB, and the authors state that the archives are
available by request. Those archives were not obtained or replayed in C573.

The paper also explains that its modified `DRAT-trim` accepts trusted
programmatically generated clauses. The published rerun therefore gives much
stronger evidence than the uncertified 1983 computation, but it is not a
standalone proof object under this audit: confidence still includes the
symmetry-clause generator, its nauty use, and the authors' reported certificate
verification. The arbitrary-design scope above is a mathematical inspection of
the encoded constraints, not a fresh replay of the search.

## Source ledger

- Curtis Bright, Kevin K. H. Cheung, Brett Stevens, Ilias Kotsireas, and Vijay
  Ganesh, *Nonexistence Certificates for Ovals in a Projective Plane of Order
  Ten*, arXiv:2001.11974v3 (2020).
  **Read depth: partial.** Read the abstract, Sections 1, 2.1, 3, 4, and 5 from
  the arXiv PDF. Cached as `arXiv:2001.11974`, SHA-256
  `8ff8453d4338132d19a9071d404bfc6825cdc2e446aa2cef326313ea4c30817c`.
  These sections own the matrix reduction, exact SAT constraints, search
  decomposition, certificate mechanism, and conclusion.

- John Bamberg and Lukas Klawuhn, *On the association scheme of perfect
  matchings and their designs*, *Algebraic Combinatorics* 9 (2026), 789--809,
  DOI `10.5802/alco.490`.
  **Read depth: partial.** Read the abstract and introduction, Example 4.3,
  Corollaries 4.16--4.17, Example 4.18, the small-`n` discussion in Section 5,
  and the references from the published journal PDF. Cached as
  `10.5802/alco.490`, SHA-256
  `5df701c8787b11615ab597d836f291afd3d4e9922df800b11caf8e9d68e9b189`.
  The published paper supplies the exact abstract-hyperoval/matching-design
  equivalence and exposes where the `n=4` proof still depends on older sources.

- Brian Alspach and Katherine Heinrich, *Matching Designs*, *Australasian
  Journal of Combinatorics* 2 (1990), 39--55.
  **Read depth: partial.** Read the abstract, Section 1, Section 3.1, and the
  references from the journal PDF. Cached as
  `dblp:journals/ajc/AlspachH90`, SHA-256
  `1a9dd6fb3f004d30fd24b6f531e8cd47c950b491768ec3d29b580c01761fedbb`.
  Section 1 attributes the `MATCH(8,4,1)` and `MATCH(12,6,1)` exclusions to
  references 10--11.

- C. W. H. Lam, L. Thiel, S. Swiercz, and J. McKay, *The nonexistence of ovals
  in a projective plane of order 10*, *Discrete Mathematics* 45 (1983),
  319--321, DOI `10.1016/0012-365X(83)90049-3`.
  **Read depth: abstract/metadata only.** The official ScienceDirect abstract
  and bibliographic record were read. The publisher PDF returned HTTP 403 and
  OpenAlex reported no open repository copy. The 2020 independent rerun above,
  not an assumed reading of this paper, carries the search details used here.

- Peter J. Cameron, *Parallelisms of Complete Designs*, London Mathematical
  Society Lecture Note Series 23, Cambridge University Press, 1976.
  **Read depth: abstract/metadata only.** The Cambridge contents and
  bibliographic page were read; the available 15-page vendor preview did not
  contain Chapter 7 or Theorem 7.6. The theorem is characterized only through
  Bamberg--Klawuhn and is not treated as primary-text verified.

- Rudolf Mathon, *The partial geometries `pg(5,7,3)`*, *Congressus
  Numerantium* 31 (1981), 129--139.
  **Read depth: abstract/metadata only.** Bibliographic records from zbMATH,
  the Congressus Numerantium archive, and later papers were consulted. Volume
  31 is listed by the publisher but is not digitized there, and no open full
  text was located. No load-bearing assertion is attributed directly to unread
  prose.

- Giorgio Faina, *The B-ovals of order `q<=8`*, *Journal of Combinatorial
  Theory, Series A* 36 (1984), 307--314, DOI
  `10.1016/0097-3165(84)90038-4`.
  **Read depth: abstract/metadata only.** The official abstract states that the
  paper classifies all Buekenhout ovals of order at most eight and records the
  connection with the relevant partial geometries. The full text was not
  accessible, so the exact order-six classification proof was not verified.

## Search coverage and access gaps

Load-bearing web queries, run over titles, abstracts, snippets, and available
full-text indexing, were:

- `"The nonexistence of ovals in a projective plane of order 10" PDF`
- `R Mathon "The partial geometries pg(5,7,3)" PDF`
- `"MATCH(8,4,1)" matching design`
- `"MATCH(12,6,1)" matching design`
- `"abstract hyperoval of order 10"`
- `P. J. Cameron Parallelisms of Complete Designs Theorem 7.6 pdf`
- `"The B-ovals of order q <= 8" PDF`

The shared cache was queried before every attempted fetch. OpenAlex was used to
check open-access locations for the Lam and Mathon records; the Congressus
Numerantium publisher archive was checked directly through volume 31.
MathSciNet and Google Scholar were not covered. Google Books exposed metadata
but no load-bearing pages. The intended but unreachable full texts are Cameron
Chapter 7, Mathon 1981, Lam et al. 1983, and Faina 1984.

This report makes no novelty or priority negative. Its negative source finding
is narrower: no open full text for the historical `MATCH(8,4,1)` proof was
located in the named services and searches.

## Recommended manuscript boundary

A future C558-owned manuscript edit may safely state the arbitrary-plane
`k=12` consequence with explicit attribution to the Lam search and the
Bright et al. certified rerun, while explaining that the contradiction is
already in the abstract matching matrix. Do not import the arbitrary-plane
`k=8` consequence as a load-bearing citation until Cameron Theorem 7.6,
Mathon's relevant argument, or Faina's order-six classification is read from
the primary full text.

## `ej` + Tao closeout

The cheap upgrade was the scope audit of the SAT model itself. Reading only the
paper title would have left Lam's result at projective ovals; matching every SAT
constraint to the `MATCH(12,6,1)` axioms recovers the stronger abstract theorem
without extending the search or claiming a new computation.

The Tao-style stress test separated three propositions that the citation chain
often compresses:

1. a projective oval gives an abstract hyperoval;
2. an abstract hyperoval is a matching design;
3. the reported search contradicts axioms already present at level 2.

Only the third implication licenses the arbitrary-plane import. The same test
prevents Bamberg--Klawuhn's general-looking Corollary 4.17 from being mistaken
for a self-contained proof of its `n=4` base case.

## Mystery ledger

- **Why a projective-oval paper proves an abstract exclusion:** settled. Its
  contradiction uses only the edge--matching matrix and axioms forced by
  `MATCH(12,6,1)`.
- **`MATCH(12,6,1)` computational replay:** open evidence gap. The 3 TB archive
  was not obtained, and trusted programmatic clauses keep the published rerun
  from being a standalone checked certificate in this repository. No successor
  is warranted unless the manuscript chooses to make computational replay an
  acceptance gate.
- **`MATCH(8,4,1)` primary proof:** open evidence gap. Exact missing evidence is
  Cameron Theorem 7.6, Mathon's relevant argument, or Faina's order-six
  classification in full text. The result is corroborated but not imported.
- **A single uniform proof of both small exclusions:** no such verified proof
  emerged. Bamberg--Klawuhn's independent Krein-parameter argument starts at
  `n>=5`; treating it as an `n=4` proof would erase its cited base case.
