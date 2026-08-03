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
Three new candidate leads from later C855 work were also searched (see their own section). Claims 4
and 5, the audit's last open items, are now closed by the definitional comparison in "Definitional
comparison: companion arc claims vs BSW complete exterior sets" below: the companion/discovery-note
arc quantities (no-three-collinear arcs, mixed or internal-only point type, maximum found by search)
are a strictly different object from BSW's complete exterior sets (exactly `(q+1)/2` exterior points,
collinearity permitted), so BSW's results neither pre-empt nor bound either figure. What remains open
is stated per-claim below and in the coverage ledger; MathSciNet stays NOT COVERED as expected, and
several of today's leads are themselves unread at full text and are marked as such.

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

### Van de Voorde 2011/2012 — read depth: `full text`

Geertrui Van de Voorde, "On sets without tangents and exterior sets of a conic," `arXiv:1201.0484`
(2012); published version Discrete Mathematics (2011/2012, exact volume/issue not independently
confirmed this run — the arXiv preprint is what was read). Fetched via the shared lit-search cache
workflow — already present as `arXiv:1201.0484` (checked with `litcache.py list` before any network
fetch), fetched 2026-07-20, SHA-256 `45891ed7688d6ab3677a57060ac69c876007104b7479944744724e69fc46f9a7`,
12 pages, extracted text at `/tmp/persistent/tavis/lit-search/text/arXiv_1201.0484.txt` (6,013 words,
`pdftotext`). Read complete this run.

- **Relation to BSW — restates and uses BSW's theorem and conjecture as background, does not extend
  the exceptional census.** §1.1 ("Exterior sets of conics," page 2 of the PDF) states, citing BSW as
  reference [4] (the same paper audited above): "Theorem 1. [4] Let S be a set of (q+1)/2 exterior
  points forming an exterior set of the conic C. If q ≡ 1 (mod 4), S consists of the (q+1)/2 exterior
  points on an external line of C. If q ≡ 3 (mod 4), there exist other examples (at least for q = 7,
  11, ..., 31)." — an exact restatement, and then: "It is conjectured by the authors of the same paper
  (and checked by computer for q < 131), that only for q = 7, 11, ..., 31, there exist other examples."
  §3 (page 8) sharpens this into a specialized corollary the audit note had not previously located:
  "In the same paper, Blokhuis, Seress and Wilbrink conjecture that if q > 31, there are no exterior
  sets consisting of (q + 1)/2 non-collinear exterior points in PG(2, q), and they found by computer
  that for 11 < q ≤ 31, all exterior sets consisting of (q + 1)/2 exterior points contain a line with
  at least 3 points of this set. Hence, the cases q = 7 and q = 11 are conjectured to be the only cases
  for which a conic C and (q + 1)/2 exterior points of C form a set without tangents." This last
  sentence is Van de Voorde's own inference from BSW's results (marked here as such, per the
  conventions' Attribution section — it is not a quotation from BSW 1992 itself), not a re-derivation
  or extension of BSW's exceptional census past q = 131; it recasts the same q ≤ 31 census into the
  "set without tangents" framing that is this paper's own object of study.
  The paper's own new result (Theorem 15, page 9) is a different, narrower question: whether a single
  point Q can extend the (q+1)/2 exterior points of one external line L to a strictly larger exterior
  set. Proved: if q ≡ 3 (mod 4), any such Q must lie on L (so no genuine extension exists off the
  line); if q ≡ 1 (mod 4), there is a unique such Q off the line, namely (in the paper's own
  coordinates) the point ⟨(1, 0, −a)⟩ where L has equation Z = aX for a fixed non-square a. This is a
  one-point local-extendability question, not a maximum-size or exceptional-census question, and it is
  a new result of this paper, not attributed to BSW.
- **Bearing on Claims 4–5, stated precisely.** Nothing in this paper addresses a "pairwise-passant arc"
  as a free-standing object independent of the (q+1)/2-sized complete-exterior-set or
  sets-without-tangents framings; q = 23 and q = 9 (the companion note's Claim 4 and Claim 5 orders) do
  not appear anywhere in this paper (checked over the full extracted text — the only q-values named
  are 3, 5, 7, 9, 11 for `u_q` sizes in §1.2, and the general q ≡ 1/3 (mod 4) theorems). This paper
  therefore does not pre-empt, extend, or otherwise bear on Claims 4 or 5 beyond restating the same BSW
  background already recorded above. It is not a lead requiring further reading for Claims 4–5; it is
  now a closed, fully-read source that turned out not to be on point for those two claims specifically.

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
  arXiv:1201.0484 2012), now read at full text in a follow-up pass (see the dedicated source entry
  above): it restates BSW's theorem and conjecture as background and proves a related but distinct
  single-point-extendability result, and does not extend BSW's exceptional census or bear on Claims
  4–5's specific orders (q = 23, q = 9). None of the remaining nine titles engages the exceptional
  census or
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

**Closed this run (definitional comparison performed).** Blokhuis–Seress–Wilbrink 1992 is read at
full text first-hand (see "Sources consulted" above); the exact companion/discovery-note statements
were extracted and compared side by side against BSW's own definitions. See
"Definitional comparison: companion arc claims vs BSW complete exterior sets" below for the full
evidence chain.

**Verdict: incomparable objects, not pre-empted, not itself a manuscript "to our knowledge" claim.**
The eight-point, order-twenty-three figure is not a statement in the `papers/clebsch-rigidity`
manuscript; it is an internal finding in
`notes/2026-08-03-c855-structural-exclusions.md:265-277`, used to show that the manuscript's actual
theorem (`clebsch_rigidity_computational_companion.tex:607-621`, the `q ∈ {13,17,19}` maximum-arc-six
statement) cannot be extended past `q = 19` by a uniform argument. Both this discovery-note figure and
the manuscript's own `q = 13,17,19` theorem concern *arcs* — sets with no three collinear
(`clebsch_rigidity_computational_companion.tex:63-64`, the paper's own `k`-arc definition) — of mixed
internal/exterior point type, of whatever size the search finds. BSW's "complete exterior set" is a
different object on every axis that matters: (a) it need not avoid three collinear points — their own
linear example *is* the full set of exterior points of one passant line, hence entirely collinear, and
their q = 19 and q = 23 exceptional census entries are Pasch configurations and "6 lines having four
points" configurations, both explicitly collinearity-rich, not arcs; (b) it consists exclusively of
exterior points, never internal ones, while the companion/discovery-note arcs are mixed type (the
quoted q = 23 eight-point witness has six internal and two exterior vertices,
`2026-08-03-c855-structural-exclusions.md:271-277`); (c) BSW's object has a fixed size of exactly
`(q+1)/2` (12 at q = 23), not a maximum search over all sizes. None of BSW's q = 23 census entries (two
non-linear complete exterior sets, both of size 12, both collinearity-rich) is the same object as, is
implied by, or contradicts the discovery note's eight-point arc; the two results answer genuinely
different combinatorial questions and cannot be compared as sharper/weaker versions of one claim.
This closes the load-bearing gap the checkpoint left open: the numbers 8 (arc) and 12, "two
Pasch/6-line configurations" (BSW's complete exterior sets) were never comparable quantities.

The forward-citation screen (see "Searches run" above) and the Van de Voorde 2011/2012 full-text read
remain as recorded at checkpoint time — no citing work extends BSW's census into the arc (no-3-collinear)
framing this comparison needed; that framing question is now closed directly against BSW's own text
rather than by a citation-graph negative. Korchmáros and Ughi remain unsearched by author name — an
open gap, but it no longer gates a verdict, since the object-level comparison above is decisive on its
own terms.

### Claim 5 — maximum pairwise-passant arc of size four at order nine

**Closed this run (definitional comparison performed).** The exact source of the "four" figure is
`notes/2026-08-03-c855-classical-transfer-proofs.md:497-499` and `:513` (restated in the reproducibility
script `notes/2026-08-03-c855-q9-sylvester-kernel.py`, referenced at `:508-509`): "the true maximum
pairwise-passant arc among **internal** points is four," contrasted there with the manuscript's own
cited clique value of five (`clebsch_rigidity_computational_companion.tex:764`, the `q = 9` Sylvester
polarity-graph clique-number-five result actually used in the manuscript to exclude q = 9 as a
six-arc-conic-filling candidate). Like Claim 4, this four-point figure is not itself a manuscript
statement; it is an internal discovery-note finding recorded as a "surprise" (an unexplained
two-unit gap between the cited clique bound and the true arc maximum), not a published or
"to our knowledge" sentence.

**Verdict: incomparable objects, not pre-empted, and doubly distinct from BSW's setting.** q = 9 ≡ 1
(mod 4), inside BSW's proved theorem's congruence class, but BSW's theorem and census concern
**exterior** points exclusively — nothing in the full-text-read paper (theorem, census, or conjecture;
see "Sources consulted" above) mentions internal points at any point. Claim 5's quantity is (a) an arc
(no three collinear, by the same `k`-arc definition at
`clebsch_rigidity_computational_companion.tex:63-64`) — which BSW's sets need not be, exactly as for
Claim 4 — and (b) restricted to **internal** points only, a point type BSW's paper never addresses.
There is no stated or implied duality in BSW 1992 between internal and exterior points that would let
their exterior-point census bound, or fail to bound, an internal-point-only arc quantity. BSW's
`(q+1)/2 = 5` complete-exterior-set size (q = 9) is therefore not the same quantity as, and does not
bound, the internal-only arc maximum of four; the two numbers being numerically close (5 vs. 4) is
coincidental, not a comparison of the same object under the two different definitions. This closes the
claim: BSW neither confirms, bounds, nor contradicts it, because BSW's paper does not treat the object
Claim 5 is about.

## Definitional comparison: companion arc claims vs BSW complete exterior sets (closing Claims 4–5)

This section performs the exact side-by-side comparison the checkpoint and the previous pass left
open, per the conventions' requirement that a novelty/pre-emption verdict rest on comparing the
deliverable's own object against the prior source's, not merely on citation counts.

**Step 1 — extract the companion's own claims verbatim, with file:line.**

- The manuscript's own maximum-arc theorem (`papers/clebsch-rigidity/clebsch_rigidity_computational_companion.tex:607-621`,
  `thm:small-k-conic-filling`), the part relevant here: "Moreover, for each `q∈{13,17,19}`, an arc all
  of whose chords are passant to a fixed nonsingular conic has at most six points, and this bound is
  attained" (`:618-621`). Proof mode: finite certificate, root-edge orbit DAG (`:685-715`; claim-map
  row "Maximum passant-arc size at q=13,17,19," `:784-785`).
- The manuscript's own arc definition, load-bearing for both this theorem and for Claims 4-5:
  "A `k`-arc is a set `A` of `k` points of `PG(2,q)` with no three collinear" (`:63-64`).
- The manuscript's own terminology note connecting this object to BSW, already present in the source:
  "In the terminology of Blokhuis, Seress, and Wilbrink, a set whose pairwise joins are passant is an
  exterior set of the conic [BSW1992, pp. 143,146]; its vertices may have either internal or exterior
  point type. Every conic-filling arc is such an exterior set" (`:663-669`). This is the companion's
  own acknowledgement that it borrows BSW's name loosely (allowing mixed point type), not a claim that
  its arcs are BSW's objects. A task-internal assessment written independently during this same C855
  effort reached the same conclusion from the formalization side:
  `notes/2026-08-03-c855-classical-transfer-proofs.md:480` records "Blokhuis–Seress–Wilbrink exterior
  sets | must import or audit | terminological only" in its dependency-disposition table — i.e. BSW is
  not load-bearing for any companion proof, only for a borrowed name. This is corroborating, not itself
  literature-audit evidence (it is a task note, not a source comparison), so it is recorded as
  supporting context rather than as the verdict's evidence.
- Claim 4's eight-point, order-twenty-three figure: `notes/2026-08-03-c855-structural-exclusions.md:256-277`,
  an exhaustive-search table of arc counts by size at `q=11,13,17,19,23` (no source in the published
  manuscript states this number). The `q=23` row gives 6,072 eight-point arcs, all chords passant, and a
  verified witness with "no three points... collinear" and "type profile... six internal and two
  exterior points" (`:271-277`). This finding's purpose in its own note is to show the manuscript's
  `q∈{13,17,19}` theorem cannot be extended uniformly to `q=23` (`:326-336`, "Verdict on Target 1").
- Claim 5's four-point, order-nine figure: `notes/2026-08-03-c855-classical-transfer-proofs.md:497-499`,
  "the `q = 9` obstruction has two units of slack: the true maximum pairwise-passant arc among
  **internal points** is four, while the cited clique value only excludes six" (restated at `:513` and
  in the replay script `2026-08-03-c855-q9-sylvester-kernel.py`, referenced at `:508-509`). The "cited
  clique value" is the manuscript's own `q=9` Sylvester-graph clique-number-five result
  (`clebsch_rigidity_computational_companion.tex:302-358`, claim-map row at `:764`), used there to
  exclude `q=9` as a six-arc-conic-filling candidate — a different, already-published-and-attributed
  claim, not itself part of Claim 5. Neither this note's title/heading nor its prose states a
  "to our knowledge" or priority sentence for the four-point figure; it is recorded as an open surprise,
  not a claim pressed into the manuscript.

**Step 2 — extract BSW's own objects verbatim, as already recorded first-hand above.** BSW's theorem
(q ≡ 1 mod 4) and census/conjecture (q ≡ 3 mod 4) both concern a **complete exterior set**: exactly
`(q+1)/2` points, every one an **exterior** point of the conic, pairwise joined only by passants, with
no constraint against three or more of them being collinear. The theorem's own linear example is the
full set of exterior points lying on a single passant line — i.e. the extremal example is maximally
collinear, not an arc. The exceptional census entries at q = 19, 23, 27, 31 (quoted verbatim under
"Sources consulted" above) are Pasch configurations, "6 lines having four points" configurations, and
similar structures that are explicitly collinearity-rich — none of BSW's own listed exceptional
configurations is a `k`-arc in the companion's sense.

**Step 3 — the comparison and its verdict, applied to each claim.**

| axis | companion (Claims 4-5) | BSW complete exterior set |
|---|---|---|
| collinearity | forbidden (`k`-arc, no 3 collinear) | permitted; extremal/exceptional examples are collinearity-rich |
| point type | mixed internal+exterior (Claim 4); internal-only (Claim 5) | exterior points exclusively |
| size | maximum found by search, any size (8 at q=23; 4 at q=9) | fixed at exactly `(q+1)/2` (12 at q=23; 5 at q=9) |
| status in this run | internal discovery-note findings, not manuscript "to our knowledge" sentences | published theorem + conjecture + reported computer census |

On every axis the two are different objects, not a sharper/weaker pair of statements about the same
quantity. Consequently: **BSW's results neither imply, nor are implied by, nor contradict, nor bound
either companion figure.** Both are **not pre-empted** — there is no prior-work absence claim to make
in the first place, because the companion's own arc quantities are not the quantity BSW's paper
addresses. This is a "strictly different object" verdict, not a "novel" one in the sense of an unclaimed
priority race over the same result: the manuscript's own load-bearing theorem
(`thm:small-k-conic-filling`, q = 13,17,19) already only cites BSW for borrowed terminology
(`:663-669`), never for the theorem's proof, and that citation practice is now confirmed correct by
this comparison rather than merely asserted.

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
- **Available but not read at full text (leads, not verdicts):** "Avoiding secants of given size in
  finite projective planes" (arXiv:2409.14213); "Line partitions of internal points to a conic in
  PG(2,q)" (Giulietti et al.); Wu 2010 ("Some p-ranks related to a conic in PG(2,q)",
  arXiv:1002.1138); "Determinantal representations of smooth cubic surfaces" (Buckley & Košir,
  Geometriae Dedicata 2007).
- **NOT COVERED:** MathSciNet (institutional authentication, as expected). zbMATH Open (reachable,
  simply not queried this run).
- **COVERED this run:** Dye 1991 (complete, full text). Blokhuis–Seress–Wilbrink 1992 (complete, full
  text). Van de Voorde 2011/2012 (complete, full text, follow-up pass — confirmed not to bear on
  Claims 4–5). Madison–Wu 2012 (complete, full text, follow-up pass — module decomposition of the F₂
  null space now fully recorded for candidate (a)). The three-graph forward-citation count for
  Blokhuis–Seress–Wilbrink (OpenAlex, Crossref, Semantic Scholar, from the pinned DOI). WebSearch for
  the six resume-checklist-item-5 topics plus two topics for the new candidates below.

Claims 1–3 no longer need the caution about Dye's unread pages; their remaining hedge is only the
weaker-than-citation-graph strength of a title-level web-search negative (stated per claim above).
Claims 4 and 5 are now closed on the exact-quantity-match question: the definitional comparison above
found the companion/discovery-note arc quantities and BSW's complete exterior sets to be strictly
different objects (arc/no-collinearity vs. collinearity-permitted; mixed-or-internal point type vs.
exterior-only; search-maximum size vs. fixed size `(q+1)/2`), so neither figure is pre-empted, bounded,
or contradicted by BSW, and neither figure is itself a manuscript "to our knowledge" sentence requiring
further hedging — both are internal discovery-note findings, not published claims.

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
   the union of citing works found no direct extension of the exceptional census or conjecture; the
   closest lead, Van de Voorde 2011/2012, was subsequently read at full text in a follow-up pass and
   confirmed not to bear on Claims 4–5 (see its dedicated source entry above).
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

**Read depth upgraded to `full text` this follow-up (2026-08-03).** Adonus L. Madison and Junhua Wu,
"On Binary Codes from Conics in PG(2, q)," European Journal of Combinatorics 33 (2012). Fetched via
the shared lit-search cache workflow — already present as `arXiv:1104.0324` (checked with `litcache.py
list` before any network fetch, per the cache contract), fetched 2026-07-21, SHA-256
`f3edf20a2b63286164b3aced06a04a9039d7bbba2eb955a6461b7f7e793f6343`, 23 pages, extracted text at
`/tmp/persistent/tavis/lit-search/text/arXiv_1104.0324.txt` (12,883 words, `pdftotext`). Read complete
this run, front matter through the appendix character tables and reference list.

- **Exact statement of the null-space/2-rank result, all q cases (Theorem 6.1, page 20 of the PDF).**
  Let A be the incidence matrix of passant lines versus internal points of a conic in PG(2, q), q an
  odd prime power; let φ: F I → F I be the F H-module homomorphism with matrix A, where H ≅ PSL(2, q)
  is the index-2 subgroup of the conic's automorphism group G ≅ PGL(2, q), F is an algebraic closure of
  F₂, and I is the set of internal points (so F I has the internal points as a permutation basis).
  Verbatim: "(i) if q ≡ 1 (mod 4), then Ker(φ) = ⊕_{s=1}^{(q−1)/4} Mₛ, where Mₛ for 1 ≤ s ≤ (q−1)/4
  are pairwise non-isomorphic simple F H-modules of dimension q − 1; (ii) if q ≡ 3 (mod 4), then
  Ker(φ) = ⟨Ĵ⟩ ⊕ (⊕_{r=1}^{(q−3)/4} Mᵣ), where Mᵣ for 1 ≤ r ≤ (q−3)/4 are pairwise non-isomorphic
  simple F H-modules of dimension q + 1 and ⟨Ĵ⟩ is the trivial F H-module generated by the all-one
  column vector of length |I|." The dimension formula (Corollary 6.3, page 21) follows immediately:
  dim_{F₂}(L) = (q−1)²/4 in both congruence cases, where L is the F₂-null space of A — this is exactly
  Conjecture 1.1 of Droms–Mellinger–Meyer (2006), which the paper proves.
- **Specialized to q = 13 (≡ 1 mod 4, the candidate's exact case).** (q−1)/4 = 3, so Ker(φ) =
  M₁ ⊕ M₂ ⊕ M₃, a direct sum of exactly three pairwise non-isomorphic simple F H-modules, each of
  dimension q − 1 = 12; total dimension 36 = (13−1)²/4, matching Corollary 6.3.
- **Proof mechanism.** Hybrid, and character-theoretic/modular-representation-theoretic in its
  culminating step, not purely combinatorial. The paper first establishes purely geometric/combinatorial
  parity lemmas (Theorem 2.12, page 6: the number of internal points on a passant line's "internal
  neighbourhood" is always even; Lemmas 3.5–3.6, pages 8–11: parity of conjugacy-class intersections
  with point-stabilizer double cosets), which are used to prove the matrix identity A³ ≡ A (mod 2)
  (Lemma 2.13, page 6). It then switches to Brauer's modular representation theory: the 2-blocks of
  H ≅ PSL(2, q) and their block idempotents (§4, following the character tables of Jordan and Schur and
  the companion paper Sin–Wu–Xiang, J. Combin. Theory (A) 118 (2011), 853–878 — reference [17]), and
  uses the block-idempotent action on Ker(φ) (Lemma 6.2, page 19) to identify each simple summand with
  a specific 2-block of defect 0 (Corollary 5.3, page 17, combined with the Frobenius-reciprocity
  induced-character decomposition of Lemma 5.2, pages 16–17). The dimension formula is thus proved by
  exhibiting the *exact* module decomposition, not merely counted combinatorially.
- **Decisive finding for the novelty ledger, stated precisely.** The F₂ null space is **not**
  irreducible as an F H-module for H ≅ PSL(2, q) — Madison–Wu's own Theorem 6.1 gives its exact
  composition into (q−1)/4 (or 1 + (q−3)/4) pairwise non-isomorphic simple summands, each of a single
  fixed dimension (q − 1, or q + 1). This is a *stronger* result than irreducibility: it is the complete
  list of composition factors (with multiplicity one each, all distinct), not merely a dimension count.
  **One precision the candidate's own framing should be corrected for:** Madison–Wu's module structure
  theorem is stated for the group H ≅ PSL(2, q) (index 2 in G ≅ PGL(2, q)) over F, the algebraic closure
  of F₂ — not literally "F₂[PGL(2, q)]" as the candidate names it. Whether the same decomposition
  descends to an F₂[PGL(2, q)]-module statement (as opposed to F[PSL(2, q)]) is a distinct question the
  paper does not itself address in these terms; the endomorphism-ring/field-of-definition question the
  candidate also names (does each simple summand's endomorphism ring equal F, i.e. is F a splitting
  field for these summands) is likewise not stated by the paper in that language, though "pairwise
  non-isomorphic simple F H-modules" is consistent with, but does not by itself establish, absolute
  irreducibility over a smaller field.
- **Minimum weight, minimum-word counts, and the weight-12 layer at q = 13: not treated.** The word
  "minimum weight" does not occur anywhere in the paper (checked over the full extracted text); the
  paper's entire content is the dimension (2-rank) of the null space and its exact module
  decomposition, not the weight distribution or minimum weight of the resulting code, and it makes no
  statement about q = 13 specifically or about a weight-12 layer. This is a clean, full-text-confirmed
  gap, not merely an abstract-level absence.
- A companion paper, Junhua Wu, "Some p-ranks related to a conic in PG(2, q)" (`arXiv:1002.1138`,
  2010), remains at `abstract/metadata only` read depth (not upgraded this run); its abstract concerns
  p-ranks for the odd defining characteristic p, not the F₂ (2-rank) case, so it stays adjacent but
  distinct.

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

## Two full-text follow-ups (2026-08-03, second pass)

Madison–Wu 2012 and Van de Voorde 2011/2012 were both upgraded to `full text` read depth in a second
follow-up pass the same day; see their dedicated "Sources consulted" entries above (Madison–Wu:
candidate (a) section; Van de Voorde: immediately before "Searches run"). Both were already present in
the shared lit-search cache (checked with `litcache.py list` before any fetch, per the cache's own
contract) — no new network fetch of either paper's bytes was needed, only the already-cached extracted
text was read.

**Closed this run:** the exact-quantity comparison between the companion/discovery notes' Claims 4 and
5 and BSW's complete-exterior-set definitions and census — see "Definitional comparison: companion arc
claims vs BSW complete exterior sets" above. Both claims are closed as strictly-different-object, not
pre-empted.

**Still open for a future pass:** Korchmáros/Ughi author-name searches; zbMATH Open; full-text reads of
"Avoiding secants of given size
in finite projective planes" (arXiv:2409.14213), "Line partitions of internal points to a conic in
PG(2,q)" (Giulietti et al.), Wu 2010 (`arXiv:1002.1138`, candidate (a)'s p-rank companion, still only
`abstract/metadata only`), and Buckley–Košir 2007 / Dolgachev for candidate (c). The
F₂[PGL(2,13)]-versus-F[PSL(2,13)] precision noted in candidate (a)'s writeup, and whether the simple
summands are absolutely irreducible over F₂ itself (splitting-field question), remain open and would
need Madison–Wu's cited companion paper (Sin–Wu–Xiang 2011) or direct calculation to close.
