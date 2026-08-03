# C855 — literature audit for the Paper I strengthening claims (CHECKPOINT, INCOMPLETE)

**Date:** 2026-08-03
**Lane:** `clebsch` (Paper I stream)
**Task:** C855 — bounded novelty/priority audit gating the Paper I manuscript-strengthening pass.
**Conventions:** `notes/literature-audit-conventions.md`.
**Status:** **CHECKPOINT — paused on user request part-way through.** Claims 1, 2 and 3 have a
verdict resting on one source read at full text (Dye 1991, the cached page scans). Claims 4 and 5
are **unaudited**: no query was run for them. No web search, no citation-graph query, and no fetch
of any kind was performed in this run. The three-graph citation-negative requirement of the
conventions (§ "Negatives from citation graphs") has **not** been discharged for any claim, so no
verdict below may be used to support a bare "to our knowledge" sentence yet.

**Full-text count.** One source was read at full text (Dye 1991). No other source was consulted at
any depth in this run.

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
- **Sections relied on.** §1.1–1.7 (introduction, pages 270–273), §2.1–2.3 (canonical coordinates
  and Theorem 1, pages 274–276), §2.4 (Theorem 2, page 277). Pages 278–286 (Theorems 3–9,
  Corollaries 1–2, references) were **not** read in this run; the stabilizer statement (Theorem 5)
  and the triple-perspective statement (Theorem 9) are known only from their summaries in §1.4–1.6.
- **Verification against page images.** Every load-bearing passage quoted or paraphrased below was
  read in `dye-1991-reconstructed.txt` and the OCR is legible for the prose; the displayed formulas
  in the OCR are unreliable per the scan set's own `NOTES.md`, and the numbered displays relied on
  here ((4), (5), (6), (7), (9), (10), (12), (17)) were **not yet re-checked against the adjacent
  PNG images**. That check is an open item before any of these findings is cited.
- **SHA-256 of the bytes read.**
  - `dye-1991-reconstructed.txt` `6d48847949e2b37c3a87557df9fa4147c9b1305d8469c7c06965c62b99fcbf92`
  - `dye-274.png` `1e4eaacb78fbbbfa1396fa6f59c80b31b2edf0ab683a2154693d1787895e87d3`
  - `dye-275.png` `7ceb086b10c681ba4f6ed07f197cd07c074fde4fb4566b1dbfaac753631b7a86`
  - `dye-276.png` `6005a61f768239fe0c66b4a92dd71bd9b13393245d258dfdfb8c2b5f4a17c4e3`
  - `dye-277.png` `1701c1ff759f75560a132309f9f8075374df91affa2df1ccfe1d7b0c7937666e`

### Blokhuis–Seress–Wilbrink 1992 — read depth: `not read in this run`

The scan set is present in the cache at `/tmp/persistent/tavis/lit-search/bsw-1992/` (pages 143–147,
with a page map in its `NOTES.md` naming page 146 as the location of the exceptional census and the
conjecture). It was **not opened** in this run. It is available, so this is an open item, not an
access failure.

## Searches run

**None.** No database query, web search, or citation-graph lookup was issued in this run. The only
retrieval operations were local: `litcache.py list` against the shared cache, and directory listings
of the two cached scan sets. Consequently the conventions' width requirement — independent counts
from OpenAlex, Crossref, and Semantic Scholar for any verdict resting on an enumerated citing set —
is **NOT COVERED**, and MathSciNet and zbMATH Open are likewise **NOT COVERED**.

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
  have short of ten. One caution: Dye's Theorem 9 (summarized §1.6, page 273) *is* a triple-
  perspective statement — "Any two triangles of a Clebsch hexagon H are in triple perspective from
  three collinear centres" — but it is a statement about the maximal configuration, not the
  transitivity lemma used to derive the spectrum. Theorem 9's full text on pages 284–285 has not
  been read and must be before this distinction is asserted in print.
- **Open before a verdict:** Edge 1956, the Brianchon-point-of-hexagons literature, perspective-
  triangle literature, and one-factorization-geometry literature were not searched at all.

**Provisional recommendation:** state the bound-ten half with a Dye citation and no novelty
language; hold the spectrum claim's novelty language until the outstanding searches are run.

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

**UNAUDITED.** No query was run. The intended targets — Blokhuis–Seress–Wilbrink 1992 (cached,
unopened) and its forward citations across OpenAlex, Crossref, and Semantic Scholar, plus
Korchmáros, Ughi, and passant/external-arc work from 2010 onward — all remain outstanding. The
companion note already records the BSW conjecture second-hand from an earlier reading; that
characterization is not re-verified here.

### Claim 5 — maximum pairwise-passant arc of size four at order nine

**UNAUDITED.** No query was run. The distinction the task flags — that the cited clique value five
for distance-two cliques is a different quantity from the maximum pairwise-passant arc size — has
not been checked against any source.

## Coverage statement

- **Searched and found nothing:** nothing. No search was run, so this report licenses no negative.
- **Available but not consulted:** Blokhuis–Seress–Wilbrink 1992 page scans (cached locally); Dye
  1991 pages 278–286.
- **NOT COVERED:** OpenAlex, Crossref, Semantic Scholar, zbMATH Open, MathSciNet, and general web
  search. MathSciNet requires institutional authentication and is expected to stay uncovered; the
  others are reachable and their absence here is solely the pause, not an access failure.

Every claim above therefore keeps "to our knowledge" hedging, and none of the provisional
recommendations may be treated as a discharged novelty verdict until the outstanding searches are
run and recorded here.

## Resume checklist

1. Re-check Dye displays (4), (5), (6), (7), (9), (10), (12), (17) against `dye-274.png` through
   `dye-277.png` before quoting any of them.
2. Read Dye pages 278–286, especially Theorem 5 (stabilizer) and Theorem 9 (triple perspective and
   self-duality), and settle whether Theorem 9 bears on the spectrum claim's transitivity lemma.
3. Read the Blokhuis–Seress–Wilbrink page scans 143–147, verifying formulas against the PNGs, and
   record the theorem, the exceptional census, and the conjecture at first hand.
4. Run forward-citation enumeration for Blokhuis–Seress–Wilbrink independently in OpenAlex,
   Crossref, and Semantic Scholar, from a pinned identifier, recording each count separately.
5. Search for Edge 1956, Brianchon points of hexagons, perspective triangles, one-factorization
   geometry of six-arcs, golden ratio in PG(2, q), and maximum passant/external arcs, recording each
   query verbatim with its database and date.
