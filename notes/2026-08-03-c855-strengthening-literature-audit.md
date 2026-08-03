# C855 — literature audit for the Paper I strengthening claims

**Date:** 2026-08-03
**Lane:** `clebsch` (Paper I stream)
**Task:** C855 — bounded novelty/priority audit gating the Paper I manuscript-strengthening pass.
**Conventions:** `notes/literature-audit-conventions.md`.
**Status:** Resumed and the five-item resume checklist is discharged (see "Resume checklist —
disposition" below). Dye 1991 is now read at full text end to end (pages 270–286, all numbered
displays re-checked against the page-image PNGs). Blokhuis–Seress–Wilbrink 1992 is now read at full
text (pages 143–147, all formulas checked against the page-image PNGs). Forward citations of
Blokhuis–Seress–Wilbrink were enumerated independently in OpenAlex, Crossref, and Semantic Scholar
from the pinned DOI `10.1007/bf01204717`, and the six listed topical searches were run and recorded.
Three new candidate leads from later C855 work were also searched (see their own section). What
remains open is stated per-claim below and in the coverage ledger; MathSciNet stays NOT COVERED as
expected, and several of today's leads are themselves unread at full text and are marked as such.

**Full-text count.** Two sources read at full text this run: Dye 1991 (complete, pages 270–286) and
Blokhuis–Seress–Wilbrink 1992 (complete, pages 143–147). No other source named below was read beyond
abstract/metadata level.

## Sources consulted

### Dye 1991 — read depth: `full text`

R. H. Dye, "Hexagons, conics, A₅ and PSL₂(K)", pages 270–286 of the journal issue as scanned.
Bibliographic detail beyond what appears on the scanned pages is deliberately not asserted here; it
must be taken from a consulted bibliographic record before any citation is written into the
manuscript.

- **Access.** User-supplied page-image scan set in the shared literature cache at
  `/tmp/persistent/tavis/lit-search/dye-1991/`, not a `litcache` manifest key. The cache's
  `litcache.py list` entry `10.1007/BF02942548` ("R.H. Dye, The Plane Sextic Curve Fixed by A6") is
  a **different** Dye paper and is recorded there as `not-a-pdf`; it was not used.
- **Version.** Published version, as scanned. No preprint exists to confuse it with.
- **Sections relied on.** All of §§1.1–4 (pages 270–286): introduction (270–273); canonical
  coordinates and Theorem 1 (274–276); Theorem 2 (277); Theorem 3 (stabilizer, A₅ acting on the five
  triangles) and Corollaries 1–2 (278–279); Theorem 4 (conic-associated Clebsch hexagons) and
  Theorem 5 (A₅ < PSL₂(K) forces GF(4) ⊂ K, or the odd-characteristic existence conditions of
  Theorem 1) on pages 279–281; Theorem 6 (A₅-orbits on the conic) on page 281; Proposition 1 and
  Theorem 7 (finite-field hexagon counts) on pages 282–283; §3.1 and Theorem 8 (double-contact conic
  of the other five vertices through a fixed vertex) on page 283–284; §3.2 and Theorem 9 (v-lines,
  b-lines, self-duality, triple perspectivity of the five triangles) on pages 284–285; concluding
  remarks and references on page 285–286. Read to completion this run.
- **Correction to the resume checklist's own expectation.** The checklist (item 2) described
  Theorem 5 as "the stabilizer statement." That is Theorem 3 (page 278): the stabilizer of a Clebsch
  hexagon in PGL₃(K) is A₅ acting on its five triangles (Σ₅ in characteristic 5). Theorem 5 (page
  280) is a different, later result: if A₅ embeds properly in PSL₂(K) then either GF(4) ⊂ K or K
  satisfies the odd-characteristic/5-is-a-square/anisotropic-form conditions of Theorem 1. This is
  read directly off the page images, not inferred; the checklist's label was simply wrong and is
  corrected here rather than silently followed.
- **Theorem 9 and the spectrum claim's transitivity lemma — settled.** Theorem 9 (page 284) reads:
  "(i) There are six lines, called v-lines, that contain one vertex of each triangle of H, and 10
  lines, called b-lines, that contain one vertex from three triangles of H. (ii) The complete Clebsch
  hexagon consisting of six vertices, 10 Brianchon points, 15 edges, six v-lines, 10 b-lines and 15
  vertices of triangles is self-dual. (iii) Any two triangles of H are in perspective from one vertex
  of each of the other triangles, and these three centres of perspective lie on a b-line. If K has
  characteristic 5 then the triangles are also in perspective from a Brianchon point." Its proof (page
  285) is entirely internal to one already-maximal Clebsch hexagon H (10 Brianchon points, five
  triangles fixed by Theorem 2(ii)): it establishes collinearities among the *triangle vertices* of H,
  not a "double perspective forces triple perspective" statement about how many Brianchon points a
  general, possibly sub-maximal, hexagon can have. **Theorem 9 does not bear on the spectrum claim's
  transitivity lemma.** It is triple-perspectivity of the five triangles belonging to one maximal
  hexagon, not a lemma constraining the Brianchon-point count of an arbitrary hexagon short of ten.
  The caution raised at checkpoint time is resolved, not merely narrowed: nothing in Dye 1991
  §§1–4 (the whole paper) treats a hexagon with a Brianchon-point count strictly between 0 and 10, so
  the exclusion of 5, 7, 8, 9 remains unlocated in Dye on a complete read of the paper.
- **Other results on pages 278–286, noted for completeness, not otherwise load-bearing on Claims
  1–3.** Corollary 2 (page 279) gives the exact count and existence congruence for Clebsch hexagons
  in PG(2,q). Theorem 4 (page 279) gives the existence/transitivity/stabilizer results for Clebsch
  hexagons of a fixed conic. Theorem 6 (page 281) gives A₅-orbit sizes on the conic under various
  square-class conditions. Theorem 7 (pages 282–283) gives exact hexagon counts and orbit/graph
  structure for PG(2,q). Theorem 8 (pages 283–284) is the double-contact-conic statement used in the
  proof of Theorem 9. None of these was searched against separately; they are recorded because they
  were read in the course of discharging item 2 of the resume checklist.
- **Verification against page images.** All eight previously flagged displays — (4), (5), (6), (7),
  (9), (10), (12), (17) — were re-checked directly against `dye-274.png` through `dye-277.png` this
  run and match the reconstructed text and the quotations used in the Claim 1–3 verdicts below
  verbatim, including the exact wording "No edge of a hexagon can contain three Brianchon points..."
  and "Each Brianchon point is on three of the 15 edges. Hence a hexagon can have at most 15 × 2/3 =
  10 Brianchon points" (both page 274–275), Theorem 1 (page 275), Theorem 2 (page 277), and the `j`
  discriminant-five definition (4) and vertex list (5) (page 274). No discrepancy between the OCR
  reconstruction and the page images was found for any of these eight displays. Pages 278–286 were
  read directly from the PNGs (`dye-278.png` through `dye-286.png`), not from the OCR reconstruction,
  so no separate re-check step applies to them.
- **SHA-256 of the bytes read (pages 274–277, previously recorded and re-verified; pages 270–273 and
  278–286 were read as page images this run and are not separately hashed here — the PNGs are the
  cache's authoritative artifact per the shared cache's own contract, and no textual claim above rests
  on the OCR of those pages).**
  - `dye-1991-reconstructed.txt` `6d48847949e2b37c3a87557df9fa4147c9b1305d8469c7c06965c62b99fcbf92`
  - `dye-274.png` `1e4eaacb78fbbbfa1396fa6f59c80b31b2edf0ab683a2154693d1787895e87d3`
  - `dye-275.png` `7ceb086b10c681ba4f6ed07f197cd07c074fde4fb4566b1dbfaac753631b7a86`
  - `dye-276.png` `6005a61f768239fe0c66b4a92dd71bd9b13393245d258dfdfb8c2b5f4a17c4e3`
  - `dye-277.png` `1701c1ff759f75560a132309f9f8075374df91affa2df1ccfe1d7b0c7937666e`

### Blokhuis–Seress–Wilbrink 1992 — read depth: `full text`

A. Blokhuis, Á. Seress, H. A. Wilbrink, "Characterization of complete exterior sets of conics,"
Combinatorica 12 (2) (1992), 143–147. DOI `10.1007/bf01204717` (confirmed via OpenAlex ID
`W2001379196`, matched on exact title and author list).

- **Access.** User-supplied page-image scan set in the shared literature cache at
  `/tmp/persistent/tavis/lit-search/bsw-1992/`, pages 143–147 (the complete article — it is a 5-page
  paper), read directly from the PNGs (`bsw-143.png` through `bsw-147.png`) this run.
- **Version.** Published version, as scanned.
- **Sections relied on.** The complete paper: abstract and §1 Introduction (page 143), the proof of
  the main Theorem including the passant cross-ratio characterization and the reduction to the
  Carlitz–McConnel-type Result (pages 144–145), the strongly-regular-graph counting argument closing
  the proof (page 146, top), and §3 Final Remarks — the exceptional census and the conjecture (page
  146, bottom) — and the reference list (page 147).
- **Verification against page images.** Read directly from the PNGs, not through OCR; no separate
  re-check step applies.
- **Theorem (verbatim, page 143–144).** "Let 𝓔 be a set of (q+1)/2 exterior points of a nondegenerate
  conic 𝓒 in the desarguesian plane PG(2, q), q ≡ 1 (mod 4) with the property that the line joining
  any 2 points in 𝓔 misses the conic. Then 𝓔 consists of the exterior points on a passant." The
  abstract (page 143) states the companion fact for the other congruence class: "If q ≡ 3 (mod 4)
  then other examples exist (at least for q = 7, 11, ..., 31)."
- **Exceptional census (verbatim, page 146, § Final Remarks).** "By computer search we found all such
  sets for q = 7, 11, 19, 23, 27, 31. It turns out that there are not that many. Andries Brouwer found
  that up to isomorphism there are the following possibilities: For q = 7 one configuration,
  consisting of 4 points, no 3 collinear. For q = 11 two configuration, one a 6-arc, the other a
  Pasch-configuration. For q = 19 a Pasch-configuration, with on one of the 2-secants 4 additional
  points. In PG(2,23) two configurations, one consists of two Pasch-configurations joined by three
  transversals... The other configuration consists of 6 lines having four points, such that in each
  of the 12 points 2 of the 4-lines meet. For q = 27 one configuration, consisting of 3
  Pasch-configuration on two points, with the further property that the have one further two-secant
  in common. Finally a configuration in PG(2,31) consisting of 6 points forming an arc, and 10 points
  forming a Petersen graph... Andries Brouwer showed, again by computer search that no other examples
  exist for q = 43, ..., 131."
- **Conjecture (verbatim, page 146).** "So we conjecture that for q > 31 there are no other complete
  exterior sets then the linear ones. How to prove this we have no idea." — i.e. the conjecture is
  that for q ≡ 3 (mod 4), q > 31, the only complete exterior sets (pairwise-passant maximum arcs of
  size (q+1)/2) are the linear ones (exterior points of a single passant), exactly as for q ≡ 1 (mod
  4). This is an open conjecture as stated by the authors, not a theorem; the q = 43,...,131 range is
  a reported computer search by Brouwer, not independently re-verified here.
- **Bearing on Claims 4–5, stated precisely.** The BSW theorem and conjecture concern *complete
  exterior sets*: sets of exactly (q+1)/2 exterior points, pairwise joined only by passants, that
  cannot be extended. This is a different quantity from an arbitrary maximum pairwise-passant arc
  (which need not consist only of exterior points, and need not have size exactly (q+1)/2). Whether
  Claim 4 (eight points, q = 23) or Claim 5 (four points, q = 9) match a BSW "complete exterior set"
  in the technical sense, or a different clique/arc quantity, has **not** been checked against the
  companion note's exact definitions in this run — that comparison is still open and must be done
  before any pre-emption verdict is written for Claims 4 or 5.

## Searches run

### Forward-citation enumeration for Blokhuis–Seress–Wilbrink 1992 (resume checklist item 4)

Seed pinned by DOI `10.1007/bf01204717` (OpenAlex ID `W2001379196`), resolved by an exact-title,
exact-author-list match against the printed paper, not by title search at query time. Each service
queried independently on 2026-08-03:

- **OpenAlex.** `GET https://api.openalex.org/works/W2001379196` → `cited_by_count: 9`. Citing-works
  list obtained via `GET https://api.openalex.org/works?filter=cites:W2001379196&per-page=25` →
  9 results, years 1992–2022 (titles: "A property of sharply 3–transitive finite permutation sets"
  1992; "Maximal cliques in the Paley graph of square order" 1996; "A family of ovoids of the
  Hermitian Surface..." 2005 (arXiv companion of the next); "A Geometric Construction for Some Ovoids
  of the Hermitian Surface" 2006; "On sets without tangents and exterior sets of a conic" 2011/2012
  (arXiv + journal version both indexed); "Designs from Paley graphs and Peisert graphs" 2015;
  "Contributions by Aart Blokhuis to finite geometry, discrete mathematics, and combinatorics" 2022;
  "A strengthening of McConnel's theorem on permutations over finite fields" 2024; "Selected results
  in combinatorics and graph theory" 2024). An empty result would have returned `"count": 0` in the
  `meta` block with `results: []`; this did not occur, so the query is a genuine positive count, not
  an unresolved seed.
- **Crossref.** `GET https://api.crossref.org/works/10.1007/bf01204717` →
  `"is-referenced-by-count": 3`. Crossref's cited-by count depends on publisher-reported reference
  links (Cited-by Linking) and is known to undercount relative to OpenAlex/Semantic Scholar for
  older, non-open-access venues; no citing-works list is exposed by this endpoint for a plain
  `/works/{doi}` lookup, so only the count, not a title list, is recorded for Crossref.
- **Semantic Scholar.** `GET
  https://api.semanticscholar.org/graph/v1/paper/DOI:10.1007/bf01204717?fields=title,citationCount,externalIds`
  → `citationCount: 11`. Citing-works list obtained via
  `GET https://api.semanticscholar.org/graph/v1/paper/DOI:10.1007/bf01204717/citations?fields=title,year,externalIds`
  → 11 results: the same 9 OpenAlex titles above, plus two not indexed by OpenAlex as citing this
  work: "Extensions of the Carlitz-McConnel and Blokhuis-Sziklai theorems for unions of cyclotomic
  classes" (arXiv 2604.04126, 2026) and "Carlitz's Theorem" (2010, CorpusId only, no DOI/arXiv id
  resolved).
- **Disagreement, reportable per the conventions.** The three counts are 9 (OpenAlex), 3 (Crossref),
  11 (Semantic Scholar) — a genuine three-way disagreement, not merely a zero-vs-nonzero gap. Screen
  ran over: title and year only (no abstract fetched for any citing work in this pass). Screening
  discriminator applied to the union set (11 distinct works across the two list-returning services):
  none of the 11 titles is, by title alone, a direct re-derivation or extension of the BSW theorem or
  conjecture into the q ≡ 3 (mod 4), q > 31 exceptional-census question that Claims 4–5 touch. The
  closest by title is "On sets without tangents and exterior sets of a conic" (G. Van de Voorde,
  Discrete Mathematics 2011 / arXiv:1201.0484 2012), which by its abstract (retrieved via web search,
  not fetched at full text) extends the *sets-without-tangents* and single-point-extension question
  for exterior sets of a conic, and states that for q ≡ 3 (mod 4) an extension point of an external
  line's exterior set must lie on that same line, versus a unique off-line point for q ≡ 1 (mod 4).
  This is adjacent to, but is not shown here to directly re-derive or contradict, the BSW q ≡ 3
  (mod 4) exceptional-census conjecture; it is recorded as a lead, not a verdict, since it has not
  been read at full text. None of the remaining nine titles engages the exceptional census or
  conjecture by title. **This screen is title-only and does not discharge a full pre-emption check**
  for Claims 4–5; it only answers resume-checklist item 4 (the three-way count) and flags one lead
  for a possible future full-text read.

### Topical web searches (resume checklist item 5)

All run 2026-08-03 via the WebSearch tool (Anthropic web-search backend, not a bibliographic
database); query text is verbatim as submitted. None of these is a citing-set enumeration, so the
three-graph width requirement does not apply to them individually.

1. `Edge 1956 hexagon conic A5 PSL(2,q) geometry` — no result naming a 1956 W. L. Edge paper on this
   subject; results were generic PSL(2,q)/A5 group-theory pages. **Searched, found nothing matching.**
2. `W.L. Edge 1956 "A5" conic PSL(2,q) hexagon geometry paper` — a follow-up with the author's full
   name spelled out. Surfaced Edge's 1958 "The Geometry of an Orthogonal Group in Six Variables" and
   a passing mention that Edge proved a Desargues-configuration result about the internal points of a
   conic in PG(2,5), but no 1956 paper matching the target citation was located, and the search
   engine's own summary recommended MathSciNet or an institutional bibliography for a positive
   identification. **Searched, found nothing matching; access-quality caveat noted below.**
3. `Brianchon points of hexagons concurrence spectrum projective plane` — returned only general
   expository material on Brianchon's theorem (concurrence of diagonals of a hexagon circumscribed
   about a conic) and Pascal-duality pages; nothing on a concurrence-count spectrum for the number of
   Brianchon points of a general (non-maximal) hexagon. **Searched, found nothing matching.**
4. `perspective triangles finite projective plane self-polar concurrence classification` — returned
   Desargues's-theorem background and a self-polar-triangle definition page, nothing specific to a
   transitivity lemma among sub-maximal hexagons' triangles. **Searched, found nothing matching.**
5. `one-factorization geometry six-arc hexagon edges triangles projective plane` — returned only
   generic hexagon/tessellation pages, nothing on a one-factorization-of-15-edges-into-5-triangles
   literature distinct from Dye's own construction. **Searched, found nothing matching.**
6. `golden ratio PG(2,q) projective plane finite field construction` — returned general PG(2,q)
   background (point/line counts, blocking sets, LDPC-code papers reusing PG(2,q)) with no hit
   connecting a golden-ratio parameter to a PG(2,q) construction outside the already-known Dye 1991
   route. **Searched, found nothing matching.**
7. `maximum size pairwise passant arc external points conic projective plane` — surfaced general
   maximal-arc literature (Ball, maximal-arc surveys, (15,3)-arc of PG(2,7)) and, notably,
   "Avoiding secants of given size in finite projective planes" (arXiv:2409.14213, 2024/2025) as a
   candidate adjacent to the passant/external-arc theme; not read at full text, flagged as a lead for
   Claims 4–5, not a pre-emption verdict.
8. `"exterior points" conic PG(2,9) maximum arc pairwise external lines` — surfaced BSW itself, the
   Van de Voorde 2011/2012 paper (see above), "Line partitions of internal points to a conic in
   PG(2,q)" (Combinatorica, Giulietti et al.), and a Segre/Korchmáros external-line characterization
   result, but nothing specifically naming a maximum pairwise-passant arc of size 4 at q = 9. **No
   direct hit on Claim 5's specific configuration; searched, found nothing matching that exact
   claim**, though the adjacent papers above are unread leads.

None of searches 1–8 is a database with a defined stop condition the way a citation-graph count is;
each is recorded as "searched and found nothing matching" only for the exact query string run, not
as a claim that the underlying literature is empty. A title/abstract-level web search is weaker
evidence than a screened citation-graph enumeration, and none of these eight negatives should be read
as discharging a claim's novelty language on its own.

### Coverage of databases

`litcache.py list` and directory listings of the two cached scan sets were also run (unchanged from
the checkpoint). OpenAlex, Crossref, and Semantic Scholar are now **COVERED** for the one
citation-graph enumeration the resume checklist required (Blokhuis–Seress–Wilbrink's own forward
citations). They are **NOT COVERED** as general bibliographic databases for Claims 1–3 (no systematic
title/keyword search of OpenAlex or Crossref was run for Edge 1956, perspective-triangle literature,
etc. — only the WebSearch tool was used for those, per the resume checklist's own item 5 wording).
MathSciNet remains **NOT COVERED** (institutional authentication, as before). zbMATH Open was **not
queried** this run either — it is reachable per the conventions but was not used; this is an open gap,
not recorded as a negative.

## Per-claim status

### Claim 1 — the concurrence-count spectrum {0,1,2,3,4,6,10}

Statement audited: `notes/2026-08-03-c855-structural-exclusions.md` § "Theorem (the concurrence
spectrum)".

**Split verdict, partial.**

- *The bound ten and its Fano mechanism are pre-empted by Dye 1991 §2.2 and the proof of Theorem 1.*
  Dye argues on page 274 that "No edge of a hexagon can contain three Brianchon points. For if there
  were such an edge then the three Brianchon points would have to be collinear diagonal points of
  the quadrangle whose vertices are the four vertices of the hexagon not on that edge, and
  quadrangles in characteristic not 2 have non-collinear diagonal points", and concludes on page 275
  "Each Brianchon point is on three of the 15 edges. Hence a hexagon can have at most 15 × 2/3 = 10
  Brianchon points." That is the same argument as the companion note's edge-bound lemma plus the
  double count. **The companion note's own framing already says it "reproves" Dye's bound, so this
  costs nothing; it does mean the bound and its mechanism must be attributed to Dye, not presented
  as new.**
- *The equality structure is likewise Dye's.* Page 275, fourth paragraph of the proof of Theorem 1,
  derives that at equality each edge has exactly two Brianchon points and that there are exactly
  five triangles whose sides are edges of the hexagon; that is the one-factorization statement.
- *The spectrum itself — the exclusion of the values five, seven, eight, and nine, via the
  transitivity lemma (double perspective forces triple perspective) applied to sub-maximal
  hexagons — was NOT found in Dye 1991.* Dye's paper is about hexagons with exactly ten Brianchon
  points; §1.1 defines the object and §1.4 fixes the name "Clebsch hexagon" for the ten-point case,
  and nothing read in §§1.1–1.7, 2.1–2.4 considers how many Brianchon points a general hexagon may
  have short of ten. **Resolved on the complete read (resume checklist item 2):** Dye's Theorem 9
  (full text, page 284, quoted in full above under "Sources consulted") is a statement about the five
  triangles of one already-maximal Clebsch hexagon — perspectivity and collinearity of the triangle
  vertices — proved from Theorem 2(ii)'s fixed five-triangle decomposition. It is not a lemma about
  how many Brianchon points a general or sub-maximal hexagon can have, and nothing else in the
  now-completely-read paper (pages 270–286) treats that question. The transitivity lemma (double
  perspective forces triple perspective, applied to exclude 5, 7, 8, 9) is not in Dye 1991 at any
  point in the paper, not merely in the pages read at checkpoint time.
- **Searched, found nothing matching (resume checklist item 5).** The topical web searches for Edge
  1956, Brianchon-point-of-hexagons literature, perspective-triangle literature, and
  one-factorization-geometry literature were run (verbatim queries and results in "Searches run"
  above) and located no candidate source; a title-level web search is weaker evidence than a screened
  database enumeration, so this does not license as strong a negative as a citation-graph screen
  would.

**Provisional recommendation, updated.** State the bound-ten half with a Dye citation and no novelty
language (unchanged). The spectrum claim's exclusion of 5, 7, 8, 9 via the transitivity lemma is now
supported by a complete read of Dye 1991 finding no such treatment, plus eight negative topical web
searches; it is not supported by any citation-graph screen (this claim has no natural single seed
paper to pin one to), so "to our knowledge" hedging should remain, but the specific caution about
Theorem 9 raised at checkpoint time is resolved rather than open.

### Claim 2 — the golden normal form and one-orbit rigidity

Statement audited: `notes/2026-08-03-c855-dye-orbit-uniqueness.md` § "The golden normal form" and
the theorem following it.

**Pre-empted in substance by Dye 1991 Theorem 1, on the reading so far.** Dye's §2.2 (page 274)
introduces `j` with `j² = j + 1` — explicitly deriving it as a root of the discriminant-five
quadratic, "Suppose, also, that 5 is a square in K. The discriminant of t² − t − 1 is 5" — and
defines the canonical hexagon `H*` with vertices of the shape `(1, ±j, 0)`, `(0, 1, ±j)`,
`(±j, 0, 1)`. **So a golden normal form for the equality class is Dye's, not new.** Theorem 1
(page 275) states: "(i) Clebsch hexagons exist in PG(2, K) if and only if K is not of characteristic
2 and 5 is a square in K. (ii) PGL₃(K) is transitive on the Clebsch hexagons of PG(2, K) when they
occur." That is the existence condition and the one-orbit rigidity over every field of odd
characteristic. The companion note already presents these as reproofs rather than as new results,
which is consistent.

What is *not* the same: the specific vertex list `(1:0:0), (φ:1:1), (0:1:0), (1:φ:1), (0:0:1),
(1:1:2−φ)` is a different (triple-perspective-normalized) presentation of the same projective class,
and the forced factorization `(x−1)(x²−x−1) = 0` is a different derivation from Dye's, which reaches
`(λμν)² − 4(λμν) − 1 = 0`, hence `λμν = 2 ± √5` (page 276, display (10)). Whether the alternate
normal form and the cleaner factorization carry any novelty worth claiming is a judgement for the
manuscript, but it is a presentational novelty at most, not a new theorem.

**Provisional recommendation:** state without novelty claim, citing Dye Theorem 1 for existence and
transitivity. Do not describe the golden parameter as a new discovery.

### Claim 3 — the unique associated polarity

Statement audited: `notes/2026-08-03-c855-dye-orbit-uniqueness.md` § "The polarity, explicitly".

**Pre-empted by Dye 1991 Theorem 2.** Theorem 2 (page 277) reads in part: "(ii) there are five
triangles whose three sides contain, in pairs, the six vertices of H, each edge being the side of
one triangle; (iii) there is a unique orthogonal polarity P with respect to which these triangles
are self-polar; (iv) P corresponds to a conic 𝒞 unless K has characteristic 0 and the quadratic
form x² + y² + z² is anisotropic." Dye's own proof is the same shape as the companion note's — he
imposes self-polarity of the triangles on a quadratic form and eliminates, reaching `Q(x) =
x² + y² + z²` (display (17)) as the only possibility, then verifies all five triangles are self-
polar for it. The companion note's matrix `S` over `ℤ[φ]` with `det S = 4φ` is the same polarity in
the different coordinate normalization.

The "any two of the five triangles already determine the polarity" refinement was not located in the
part of Dye read; the note itself attributes the underlying fact to the classical statement that two
triangles in general position have a unique common self-polar conic, which is standard and should be
cited as such rather than claimed.

**Provisional recommendation:** state without novelty claim, citing Dye Theorem 2(iii); keep the
`ℤ[φ]`-exact rederivation as a formalization-facing remark, not a priority claim.

### Claim 4 — eight-point pairwise-passant arcs at order twenty-three (sharpness)

**Partially audited; still short of a verdict.** Blokhuis–Seress–Wilbrink 1992 is now read at full
text first-hand (see "Sources consulted" above), its forward citations are enumerated independently
in OpenAlex (9), Crossref (3), and Semantic Scholar (11) from the pinned DOI, and the topical web
searches of resume checklist item 5 are run.

- BSW's own theorem and conjecture are about q ≡ 1 (mod 4) (proved: complete exterior sets are
  exactly the exterior points of a passant) and q ≡ 3 (mod 4) (conjectured, on computer evidence up
  to q = 131, for q > 31: same conclusion; exceptions catalogued for q = 7, 11, 19, 23, 27, 31 as
  quoted verbatim above). q = 23 is inside BSW's own exceptional range, not covered by their proved
  theorem or their conjecture's asserted range (q > 31): BSW's page 146 census explicitly records
  *two* non-linear configurations for PG(2, 23) as an exception, not a sharpness statement about an
  eight-point pairwise-passant arc.
- **Open, and the load-bearing gap:** whether the companion note's "eight-point pairwise-passant arc"
  quantity at q = 23 is the same object as either of BSW's two catalogued q = 23 exceptional
  configurations, or a different quantity (a general pairwise-passant arc need not consist solely of
  exterior points, and need not have size exactly (q+1)/2 = 12 as BSW's complete-exterior-set
  definition requires — 8 ≠ 12). This comparison has **not** been done in this run; it requires
  reading the companion note's exact claim statement and definitions side by side with BSW's page 146
  configurations, which is outside this run's scope (a literature audit, not a definitional
  reconciliation).
- The forward-citation screen (see "Searches run" above) found no citing work, by title, that
  directly extends BSW's exceptional census past q = 131 or restates it in the pairwise-passant-arc
  framing the companion note uses; the closest lead, Van de Voorde 2011/2012, is unread at full text.
  "Avoiding secants of given size in finite projective planes" (arXiv:2409.14213) surfaced in the
  topical web search and is also an unread lead in the same territory.
- Korchmáros and Ughi were not searched by name this run; that remains an open gap from the
  checkpoint, since resume checklist item 5 named only the six queries actually run, not this pair of
  authors.

**Provisional status:** still cannot be scored novel or pre-empted. BSW itself constrains the q = 23
picture (an exception exists, on their own computer search) but the exact-quantity match to the
companion note's Claim 4 is unverified, so no verdict is licensed either way.

### Claim 5 — maximum pairwise-passant arc of size four at order nine

**Still unaudited on the specific point.** No source located in this run states a maximum
pairwise-passant arc size of four for q = 9 specifically; q = 9 is even further from BSW's exceptional
census (q = 7, 11, 19, 23, 27, 31) and their (q+1)/2 = 5 complete-exterior-set size does not match the
claim's "four." The task's own flagged distinction — that a cited clique value of five for
distance-two cliques is a different quantity from the maximum pairwise-passant arc size — is
consistent with, but not confirmed by, anything read this run: no source naming a distance-two-clique
value of five at q = 9 was located or checked. This remains open.

## Coverage statement

- **Searched and found nothing (licenses a negative, scoped to the exact query/domain stated):** the
  eight topical web searches under "Searches run" item 5, each for its own exact query string, via
  the WebSearch tool, on 2026-08-03 (see that section for the per-query domain and stop condition —
  each is "no matching result in the returned result set for that query," not an exhaustive-database
  claim). The two new-candidate topical searches for candidate (b) (cross-ratio level-set low-weight
  codewords) likewise found nothing matching, scoped the same way (see "New candidates" below).
- **Could not access / not consulted (licenses nothing, open gap):** Korchmáros and Ughi's
  passant/external-arc work were not searched by author name this run. zbMATH Open was not queried
  this run despite being reachable. A systematic OpenAlex/Crossref *keyword* search (as opposed to the
  one citation-graph enumeration run for BSW specifically) was not run for Claims 1–3's topics — only
  WebSearch was used for those, per the resume checklist's own item 5 wording.
- **Available but not read at full text (leads, not verdicts):** Van de Voorde 2011/2012 ("On sets
  without tangents and exterior sets of a conic"); "Avoiding secants of given size in finite
  projective planes" (arXiv:2409.14213); "Line partitions of internal points to a conic in PG(2,q)"
  (Giulietti et al.); Madison–Wu 2012 ("On Binary Codes from Conics in PG(2,q)," European Journal of
  Combinatorics, arXiv:1104.0324); Wu 2010 ("Some p-ranks related to a conic in PG(2,q)",
  arXiv:1002.1138); "Determinantal representations of smooth cubic surfaces" (Buckley & Košir,
  Geometriae Dedicata 2007).
- **NOT COVERED:** MathSciNet (institutional authentication, as expected). zbMATH Open (reachable,
  simply not queried this run).
- **COVERED this run:** Dye 1991 (complete, full text). Blokhuis–Seress–Wilbrink 1992 (complete, full
  text). The three-graph forward-citation count for Blokhuis–Seress–Wilbrink (OpenAlex, Crossref,
  Semantic Scholar, from the pinned DOI). WebSearch for the six resume-checklist-item-5 topics plus
  two topics for the new candidates below.

Claims 1–3 no longer need the caution about Dye's unread pages; their remaining hedge is only the
weaker-than-citation-graph strength of a title-level web-search negative (stated per claim above).
Claims 4 and 5 remain unresolved on the exact-quantity-match question and keep full "to our knowledge"
hedging, now for a narrower and more precisely stated reason than at checkpoint time.

## Resume checklist — disposition

1. **Done.** All eight previously flagged Dye displays — (4), (5), (6), (7), (9), (10), (12), (17) —
   re-checked against `dye-274.png` through `dye-277.png`; all match the reconstructed text and the
   quotations used in Claims 1–3 verbatim. No discrepancy found.
2. **Done.** Dye 1991 pages 278–286 read in full. The resume checklist itself mis-labeled Theorem 5
   as "the stabilizer" statement — that is Theorem 3 (page 278); Theorem 5 (page 280) is the
   A₅ < PSL₂(K) embedding-forces-GF(4)-or-Theorem-1-conditions result, corrected in "Sources
   consulted" above. Theorem 9 (page 284) is settled: it does **not** bear on the spectrum claim's
   transitivity lemma — it is a triple-perspectivity statement about the five triangles of one
   already-maximal Clebsch hexagon, not a lemma constraining sub-maximal hexagons' Brianchon-point
   counts. See Claim 1 above for the full disposition.
3. **Done.** Blokhuis–Seress–Wilbrink pages 143–147 read in full, all formulas checked directly
   against the page-image PNGs (not OCR). Theorem, exceptional census (q = 7, 11, 19, 23, 27, 31), and
   conjecture (q > 31, linear-only) recorded verbatim in "Sources consulted" above.
4. **Done.** Forward citations of Blokhuis–Seress–Wilbrink enumerated independently: OpenAlex 9,
   Crossref 3, Semantic Scholar 11, from the pinned DOI `10.1007/bf01204717`. The three-way
   disagreement is itself recorded as a reportable finding per the conventions. A title-only screen of
   the union of citing works found no direct extension of the exceptional census or conjecture; one
   adjacent, unread lead (Van de Voorde 2011/2012) was flagged.
5. **Done.** All six named searches run, verbatim queries, database (WebSearch), and date
   (2026-08-03) recorded under "Searches run" above; each returned no matching result for its own
   query text, with the domain/stop-condition caveats stated there.

## New candidates from later C855 work (search only, no verdict)

Three additional candidates were named for a bounded search pass, extending the scope beyond the
original five claims. Per the conventions, these are recorded as searches with read-depth markers on
every named source, not as pre-emption verdicts — none of the three has had its exact target claim
compared side-by-side against the source found, the way Claims 1–3 were compared against Dye.

### (a) F₂ kernel of the passant-line incidence matrix of a conic in PG(2, 13): irreducibility as an
F₂[PGL(2, 13)]-module / 2-rank formulas

**Directly relevant prior work located, not yet read at full text.** Adonus L. Madison and Junhua Wu,
"On Binary Codes from Conics in PG(2, q)," European Journal of Combinatorics 33 (2012); also on arXiv
as `arXiv:1104.0324` (2011). Abstract (retrieved via WebFetch of the arXiv abstract page, 2026-08-03,
`abstract/metadata only` read depth): "Let A be the incidence matrix of passant lines and internal
points with respect to a conic in PG(2, q), where q is an odd prime power. In this article, we study
both geometric and algebraic properties of the column null space L of A over the finite field of 2
elements. In particular, using methods from both finite geometry and modular presentation theory, we
manage to compute the dimension of L, which provides a proof for the conjecture on the dimension of
the binary code generated by L." This is the same matrix (passant lines vs. a conic's points, F₂
null-space) named in the new candidate, and it computes the dimension (i.e. the 2-rank via the
null-space dimension) for general odd q, which includes q = 13. **What the abstract does not state:**
whether the null space is shown to be an *irreducible* F₂[PGL(2, q)]-module, as opposed to merely
having its dimension computed; that is a finer structural question the abstract does not address, and
the full text was not fetched this run to check. A companion paper, Junhua Wu, "Some p-ranks related
to a conic in PG(2, q)" (`arXiv:1002.1138`, 2010), was also located; its abstract (same read depth)
concerns p-ranks for the odd defining characteristic, not the F₂ (2-rank) case, so it is adjacent but
not the same question. **Search domain and stop condition:** two WebSearch queries (`2-rank passant
incidence matrix conic PG(2,q) binary code irreducible module PGL(2,q)`; `Madison Wu 2-rank incidence
matrix conic finite geometry`) plus one WebFetch of each arXiv abstract page, run 2026-08-03; stopped
once the Madison–Wu paper's exact scope (passant-line/internal-point incidence matrix, F₂ null space,
dimension computed for general odd q) was confirmed as matching the candidate's stated matrix. This is
a strong lead for at least the dimension/2-rank half of candidate (a); the irreducibility-as-a-module
question is open and requires the full text.

### (b) Cross-ratio level-set constructions of low-weight words in conic-related binary codes

**Searched, found nothing matching.** Two WebSearch queries run 2026-08-03: `cross-ratio level sets
low-weight codewords binary code conic finite geometry` and `minimum weight codewords conic PG(2,q)
binary code cross ratio construction`. Results were generic minimum-weight-codeword literature for
Reed–Muller and PG(n,q)-incidence codes (McGuire–Ward-type interval theorems, functional codes on
quadrics) with no hit combining a cross-ratio-level-set construction method with low-weight words in a
conic-related code. This is a title/abstract-level web-search negative only, for the exact two query
strings run; it does not rule out that such a construction exists in a paper using different
terminology (e.g. inside the Madison–Wu or Wu papers found for candidate (a), which were not checked
for this specific construction).

### (c) The six-node/determinantal-cubic statement of Hassett–Tschinkel Proposition 10 over general
fields containing a golden root

**Adjacent prior field-general determinantal-representation results located; the exact Proposition-10
generalization not confirmed either way.** Two WebSearch queries run 2026-08-03: `Hassett Tschinkel
Proposition 10 six nodes determinantal cubic surface` and `Segre cubic determinantal representation
general field golden ratio icosahedral`.

- The first surfaced Hassett–Tschinkel, "Flops on holomorphic symplectic fourfolds and determinantal
  cubic hypersurfaces" (arXiv:0805.4162), with a search-engine summary stating Proposition 10
  establishes that "any cubic hypersurface with six ordinary double points in linear general position
  is determinantal" — this is a paraphrase from the search engine, not a verified quotation from the
  paper's own text, and is marked as such (unverified against the source per the conventions'
  Attribution section).
- The second surfaced "Determinantal representations of smooth cubic surfaces" (A. Buckley & T.
  Košir, Geometriae Dedicata 2007), whose search-engine summary states it treats determinantal
  representations of *smooth* cubic surfaces over *arbitrary fields*, with existence tied to a
  rational point and a Galois-stable sextuple of skew lines. This is the closest located analogue of a
  field-general determinantal statement, but it is about smooth cubic surfaces (no nodes), not the
  six-ordinary-double-point (nodal) case Proposition 10 and the new candidate concern, so it is
  adjacent, not a direct predecessor. Also surfaced: Dolgachev, "Corrado Segre and Nodal Cubic
  Threefolds," which by title concerns nodal cubic threefolds classically, but was not read even at
  abstract level this run.
- **No source located states the six-node determinantal fact specifically over a general field
  containing a golden root** (i.e. a root of `t² − t − 1`, as the manuscript's context requires); this
  absence is recorded at the strength of two title-level web searches only, not a database screen, and
  should not be read as a stronger negative than that.
- **Search domain and stop condition:** stopped once the two queries above returned no source
  combining "six nodes"/nodal + determinantal cubic + general/arbitrary field + a golden-ratio or
  icosahedral connection; the Buckley–Košir smooth-case paper and the Dolgachev nodal-threefold survey
  were flagged as the nearest adjacent leads for a follow-up full-text read, not read further this run.

## Resume checklist

1. Re-check Dye displays (4), (5), (6), (7), (9), (10), (12), (17) against `dye-274.png` through
   `dye-277.png` before quoting any of them. **Done — see "Resume checklist — disposition."**
2. Read Dye pages 278–286, especially Theorem 5 (stabilizer) and Theorem 9 (triple perspective and
   self-duality), and settle whether Theorem 9 bears on the spectrum claim's transitivity lemma.
   **Done — see "Resume checklist — disposition."**
3. Read the Blokhuis–Seress–Wilbrink page scans 143–147, verifying formulas against the PNGs, and
   record the theorem, the exceptional census, and the conjecture at first hand. **Done — see
   "Resume checklist — disposition."**
4. Run forward-citation enumeration for Blokhuis–Seress–Wilbrink independently in OpenAlex,
   Crossref, and Semantic Scholar, from a pinned identifier, recording each count separately.
   **Done — see "Resume checklist — disposition."**
5. Search for Edge 1956, Brianchon points of hexagons, perspective triangles, one-factorization
   geometry of six-arcs, golden ratio in PG(2, q), and maximum passant/external arcs, recording each
   query verbatim with its database and date. **Done — see "Resume checklist — disposition."**

**Still open for a future pass:** the exact-quantity comparison between the companion notes' Claims 4
and 5 and BSW's complete-exterior-set definitions and census (needed before any Claim 4/5 verdict);
Korchmáros/Ughi author-name searches; zbMATH Open; full-text reads of the leads named above
(Van de Voorde 2011/2012; Madison–Wu 2012 and Wu 2010 for candidate (a)'s irreducibility question;
Buckley–Košir 2007 and Dolgachev for candidate (c)).
