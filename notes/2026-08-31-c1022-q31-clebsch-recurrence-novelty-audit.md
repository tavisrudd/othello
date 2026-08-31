# C1022 — Novelty and priority audit: is the q=11/q=31 "same structure" identification pre-empted?

**Lane**: `gem-mining` — see CLAUDE.md § Lane routing.
**Date**: 2026-08-31
**Status**: REPORTED. Provisional under the lane's vet gate
(`notes/handoffs/2026-07-14-gem-mining.md`): this is one mining session's reasoning and is not
load-bearing until a stronger reasoning model has vetted it. This session did not self-vet and did
not commission a vet.

**Binding conventions**: `notes/literature-audit-conventions.md`, read in full before any search. The
deliverable is a novelty verdict, so every requirement there applies — read depth on each named
source, screened-set records, three-index forward closure, the searched/unreachable split, caching,
and the "novelty text has one home" rule.

---

## 0. Opening summary

**Two sources were read at full text by this audit** — Dye 1991 and Blokhuis–Seress–Wilbrink 1992,
both from the user-supplied page scans, with every load-bearing passage verified against the
authoritative page images rather than the OCR. Six further sources were read at `partial` depth,
two at `abstract/metadata only`, one at `secondary only`, and three could not be accessed at all.

**Primary verdict: PARTIALLY PRE-EMPTED, and the pre-empted part is the larger part.**
R. H. Dye, "Hexagons, conics, A₅ and PSL₂(K)", *J. London Math. Soc.* (2) **44** (1991) 270–286,
proves that the six-arc-with-ten-Brianchon-points figure is a single projective figure over every
field where it exists, that each of its fifteen chords carries exactly two Brianchon points, and
that its stabiliser is A₅ — and gives the internal-versus-external point type as an explicit
congruence in q, from which the q=11 and q=31 cases fall out as substitutions. The C1020 finding is
therefore a rediscovery of Dye's theorems at two values of q, with one exception.

**The exception, and the only piece with no located predecessor**, is the bridge to Brouwer's
census: nobody has identified Blokhuis–Seress–Wilbrink's q=31 exceptional *complete exterior set*
with Dye's Clebsch hexagon together with its ten Brianchon points, nor read the q=11 and q=31
entries of that census as one figure at two completion levels. The two literatures are disjoint —
neither paper cites the other, and across OpenAlex, Crossref and Semantic Scholar **not one work
cites both**.

**The extraction pass returned more than the audit was asked for.** Combining Dye's congruences with
the fact that his figure has six vertices and ten Brianchon points at every q gives the mechanism
C1020's mystery ledger records as absent: the sizes are constant while the completion level (q+1)/2
grows, so 6 = (q+1)/2 forces q = 11 and 6 + 10 = (q+1)/2 forces q = 31, and Dye's point-type
congruence delivers internal Brianchon points at the first and external ones at the second. A₅
appears exactly twice in Brouwer's census because those two equations each have exactly one
solution. Details and the one conditional ingredient are in §6.

**Secondary verdict, "complete" means maximum-size: PRE-EMPTED by the primary source's own
definition.** BSW define a complete exterior set as a set of (q+1)/2 exterior points with pairwise
passant joins. The size is in the definition; maximality-under-inclusion was never the reading. What
C1020 §2 found is a defect in this lane's own record, not a fact about the literature.

**Secondary verdict, "18 = 12 + 6" is special to q=11: PRE-EMPTED.** Van de Voorde states it in
print in 2011.

---

## 1. The claim under audit

From `notes/2026-08-31-c1020-brouwer-exceptional-census.md` §1:

> The q=31 exceptional configuration is the same structure as the q=11 Clebsch hexagon: a six-arc
> together with its ten Brianchon points, each of the fifteen chords carrying two of them, with that
> chord graph being the Petersen graph, and stabilizer the alternating group on five letters in both
> cases. The two differ only in point type — the ten Brianchon points are internal at q=11 and
> external at q=31 — so they are one configuration appearing at two different completion levels
> (6 = (q+1)/2 at q=11; 6+10 = 16 = (q+1)/2 at q=31).

Decomposed into components an audit can test separately:

| # | Component claim |
|---|---|
| A | The q=11 and q=31 configurations are the **same** projective figure (six-arc plus ten Brianchon points). |
| B | Each of the fifteen chords of the six-arc carries **exactly two** Brianchon points. |
| C | The resulting chord graph on ten vertices is the **Petersen graph**, at both q. |
| D | The setwise stabiliser is **A₅** at both q. |
| E | The **only** difference is point type: the ten Brianchon points are internal at q=11, external at q=31. |
| F | Hence the two are one configuration at **two completion levels**: 6 = (q+1)/2 at q=11, 6+10 = 16 = (q+1)/2 at q=31 — i.e. BSW/Brouwer's q=31 exceptional complete exterior set **is** the Clebsch hexagon together with its Brianchon points. |

Secondary, definitional rather than novelty-bound:

| # | Component claim |
|---|---|
| G | "Complete exterior set" must mean maximum-size, not maximal-under-inclusion (sub-maximum maximal sets exist from q=9 up). |
| H | BSW's tangent-free reading `18 = 12 + 6` is special to q=11 and fails at q=31. |

---

## 2. The predecessor: Dye 1991

R. H. Dye, "Hexagons, conics, A₅ and PSL₂(K)", *J. London Math. Soc.* (2) **44** (1991) 270–286.
DOI `10.1112/jlms/s2-44.2.270` (resolved from Crossref, not from memory).

**Read depth: full text.** Accessed through the user-supplied page scans at
`/tmp/persistent/tavis/lit-search/dye-1991/` (`dye-270.png` … `dye-286.png`), reading the
page-preserving OCR reconstruction `dye-1991-reconstructed.txt` end to end for navigation, and
**verifying every load-bearing passage below directly against the authoritative page image** —
`dye-271.png`, `dye-275.png`, `dye-277.png`, `dye-279.png`, `dye-282.png`, `dye-284.png` were read
as images, not as OCR. Sections relied on: §§1.2–1.5, 2.2–2.9, 3.1–3.2, §4, and the reference list
on pp. 285–286. The scan set is covered by `/tmp/persistent/tavis/lit-search/SHA256SUMS` (38 rows
for `dye-1991/`); no cache key exists because `litcache.py` holds only PDFs.

Dye's object, defined in §1.4 (p. 271, verified on `dye-271.png`):

> A non-vertex point through which pass three edges of a hexagon has been called a *Brianchon point*
> [8, pp. 393 et seq.]. Since Clebsch encountered [2, p. 336] such a hexagon in PG(2, ℝ) when
> considering the plane representation of the diagonal cubic surface, we shall call a hexagon with
> (exactly) 10 Brianchon points a *Clebsch hexagon*.

A hexagon for Dye is six points, no three collinear, in PG(2,K), with the fifteen pairwise joins as
its edges — this lane's six-arc with its fifteen chords, term for term. A **Clebsch hexagon of a
conic 𝒞** is one whose five triangles are self-polar for 𝒞 (§1.4; Theorem 2).

### What Dye proves, matched against the components

| Component | Dye's statement | Where | Image verified |
|---|---|---|---|
| A | **Theorem 1**: "(i) *Clebsch hexagons exist in* PG(2,K) *if and only if K is not of characteristic 2 and 5 is a square in K.* (ii) PGL₃(K) *is transitive on the Clebsch hexagons of* PG(2,K) *when they occur.*" **Theorem 4(ii)**: "*If 𝒞 has Clebsch hexagons then its group* PO₃(K) = PGL₂(K) *is transitive on them.*" | pp. 275, 279 | `dye-275.png`, `dye-279.png` |
| B | **Theorem 2(i)**: "*each edge of H contains two Brianchon points*" — for every K of characteristic ≠ 2, not per q | p. 277 | `dye-277.png` |
| C | **Not stated.** Dye gives the incidences that pin the graph's degrees — each Brianchon point on three of the fifteen edges (p. 275), each edge carrying two Brianchon points (Thm 2(i)) — but never names the resulting cubic graph on ten vertices. The strings "Petersen" and "exterior set" do not occur anywhere in the paper (term scan over both the reconstruction and the raw OCR: zero hits). | — | — |
| D | **Theorem 4(iii),(iv)**: stabiliser in PGL₂(K) is A₅, or Σ₅ in characteristic 5; in PSL₂(K) = PΩ₃(K) it is A₅ unless GF(5²) ⊆ K | p. 279 | `dye-279.png` |
| E | **§2.8, p. 282**, italicised in the original: "*when K is* GF(q) *the edges of H are chords if q ≡ 1* (mod 4), *and the Brianchon points are external points if q ≡ 1* (mod 3)." And **§3.1, p. 284**, also italicised: "*the vertices of Clebsch hexagons are external points of 𝒞 if q = 10R+1, and internal points if q = 10R−1*." | pp. 282, 284 | `dye-282.png`, `dye-284.png` |

Component E is what the C1020 report calls "the one discriminator", and Dye states it in a strictly
stronger form: not two observed data points but a congruence valid for every q. Substituting:

| q | q mod 10 → vertex type (Dye p. 284) | q mod 4 → edge type (Dye p. 282) | q mod 3 → Brianchon type (Dye p. 282) |
|---:|---|---|---|
| 11 | 1 → **external** | 3 → non-secant, i.e. passant | 2 → **internal** |
| 31 | 1 → **external** | 3 → non-secant, i.e. passant | 1 → **external** |

That reproduces the C1020 finding exactly, including the direction of the difference, from a 1991
theorem. Dye also identifies Edge's q=11 configuration as an instance of his own (§1.4, p. 271):
"If K is GF(11) then Edge [6, p. 380] has presented a hexagon whose vertices are external points, and
for which there are 10 internal points at which three edges concur; its stabilizer in PΩ₃(11) is A₅."

### What Dye does not do

Dye's subject is accounting for A₅ ≤ PSL₂(K) geometrically. The paper contains no notion of an
exterior set, no completeness or maximality condition, no size bound (q+1)/2, and no reference to
Blokhuis–Seress–Wilbrink or to Korchmáros. His reference list (pp. 285–286) is Adamson, Clebsch,
Dickson, Dieudonné, Dye 1988, Edge 1956, Hardy–Wright, Hirschfeld, Klein,
Miller–Blichfeldt–Dickson, Mitchell, Moore, Wagner, Wiman. He mentions q = 31 only once, as the
smallest non-trivial case of the triangle-sharing 5-valent graph of Theorem 7(iii) (§1.5, p. 272) —
nothing to do with exterior sets.

Symmetrically, BSW 1992's reference list (p. 147) is their own Giessen paper, Bruen, Bruen–Levinger,
Carlitz, Korchmáros, McConnel — no Edge, no Dye, no Clebsch hexagon. **The two literatures are
disjoint and neither cites the other.**

### Auditor's inference, marked as mine

Dye's three congruences also settle when the hexagon's *vertices* form an exterior set of this
lane's kind: vertices external exactly when q ≡ 1 (mod 10), their fifteen joins passants exactly
when q ≡ 3 (mod 4) — jointly q ≡ 11 (mod 20) — and the ten Brianchon points joining the external
side exactly when q ≡ 1 (mod 3). So q ≡ 11 (mod 60) gives the q=11 picture (six external vertices,
ten internal Brianchon points) and q ≡ 31 (mod 60) gives the q=31 picture (six external vertices,
ten external Brianchon points). Dye never assembles the three congruences into this case split,
because completion levels are not his subject; the assembly is mine. Its consequences are in §6.

---

## 3. The other side: Blokhuis–Seress–Wilbrink 1992

A. Blokhuis, Á. Seress, H. A. Wilbrink, "Characterization of complete exterior sets of conics",
*Combinatorica* **12** (2) (1992) 143–147, received July 11 1989. DOI `10.1007/BF01204717` (resolved
from Crossref).

**Read depth: full text.** Page scans at `/tmp/persistent/tavis/lit-search/bsw-1992/`
(`bsw-143.png` … `bsw-147.png`), reconstruction `bsw-1992-reconstructed.txt` read end to end, with
pp. 143 and 146 — the definition and the census — **verified against the page images**
(`bsw-143.png`, `bsw-146.png`). Sections relied on: the abstract, §1 Introduction, §2 The Theorem
and its proof, §3 Final Remarks, and the references. Scan set covered by
`/tmp/persistent/tavis/lit-search/SHA256SUMS` (rows for `bsw-1992/`, e.g. `bsw-143.png` =
`577c6d656a48d51caf831f1b215c54656b4d8ca1b0e3a35d8c89f7d5818faad4`).

The definition, p. 143, verified on `bsw-143.png`:

> Let 𝒮 be a set of (q + 1)/2 exterior points (with respect to a fixed nondegenerate conic in
> PG(2,q)) such that each pair determines a passing line (we call such a set a *complete exterior
> set*). Classify such sets.

The census, §3 Final Remarks, p. 146, verified on `bsw-146.png` — the q=31 entry in full:

> Finally a configuration in PG(2,31) consisting of 6 points forming an arc, and 10 points forming a
> Petersen graph, in the sense that every 2-secant of the 6-arc is also a 2-secant of the 10-set and
> the 15 pairs thus obtained yield the structure of a Petersen graph.

BSW never say that the 10-set consists of the Brianchon points of the 6-arc, never call the 6-arc a
Clebsch hexagon, never give a stabiliser, and never relate the q=31 entry to the q=11 one. Their
q=11 entry is "two configuration, one a 6-arc, the other a Pasch-configuration", with no further
description.

---

## 4. Verdicts

### 4.1 Primary — PARTIALLY PRE-EMPTED

| Component | Verdict | Predecessor |
|---|---|---|
| A — same projective figure at both q | **PRE-EMPTED, and in stronger form** | Dye 1991, Thm 1(ii) and Thm 4(ii): PGL₃(K) and PGL₂(K) are transitive on Clebsch hexagons over any admissible K, so all of them — at every q, not just 11 and 31 — are one figure |
| B — each chord carries two Brianchon points | **PRE-EMPTED** | Dye 1991, Thm 2(i), for every K of characteristic ≠ 2 |
| C — the chord graph is Petersen | **PRE-EMPTED at q=31; no predecessor located at q=11** | BSW 1992 §3 states it verbatim at q=31. At q=11 no source located names it; Dye's incidence data plus A₅ edge-transitivity force it, by an argument that is mine (below) |
| D — stabiliser A₅ | **PRE-EMPTED** | Dye 1991, Thm 4(iii),(iv); and for q=11 specifically already in Edge 1956 as relayed by Dye §1.4 |
| E — internal/external point type is the discriminator | **PRE-EMPTED, and in stronger form** | Dye 1991 §2.8 p. 282 gives it as a congruence in q, covering every q at once rather than two data points |
| F — one configuration at two completion levels; BSW's q=31 set is the hexagon plus its Brianchon points | **NO PREDECESSOR LOCATED** | — |

**On component C.** BSW own the Petersen naming at q=31. At q=11 the naming appears in no source
located here, but it is not an independent fact: Dye gives ten Brianchon points, each on three of
the fifteen edges, each edge carrying two, and A₅ transitive on both the ten points and the fifteen
edges (Corollary 1, p. 278). A connected cubic graph on ten vertices admitting an edge-transitive
group is the Petersen graph — the pentagonal prism, the only other cubic vertex-transitive graph on
ten vertices, has two edge orbits. That derivation is mine, not any source's, and it makes the q=11
Petersen naming a two-line corollary of Dye rather than a finding.

**On component F, which is what survives.** The identification runs: BSW/Brouwer's q=31 exceptional
complete exterior set, a 16-set, decomposes as a Clebsch hexagon of the conic in Dye's sense
together with its ten Brianchon points; the Brianchon points are external there and internal at
q=11, by Dye's congruence; so the two entries of Brouwer's census that carry an arc are the same
Dye figure at two completion levels, 6 = (q+1)/2 and 6 + 10 = 16 = (q+1)/2. Nothing in Dye supplies
the second half — he has no exterior sets, and in particular says nothing about whether the joins
*among* the ten Brianchon points, or from them to the six vertices, are passants, which is exactly
what makes the 16-set an exterior set at q=31. Nothing in BSW supplies the first half. The
coverage behind this negative is in §5.

### 4.2 Secondary — "complete exterior set" means maximum-size: PRE-EMPTED by the definition itself

BSW's own definition (p. 143, quoted above, image-verified) fixes the size at (q+1)/2. There is no
inclusion-maximality reading in the source to correct; the lane's record had drifted from the
primary text. Van de Voorde 2011 uses the same size-pinned form throughout — "a set of (q+1)/2
exterior points forming an exterior set of the conic C" — and does not use the word "complete" at
all, so the two sources that define the object agree.

What the literature does *not* appear to state is the positive fact behind C1020 §2: that exterior
sets that are maximal under inclusion but smaller than (q+1)/2 exist in quantity from q = 9 upward,
with the size histograms C1020 §4 records. Van de Voorde's §3 studies extendability of a specific
exterior set (Theorem 15), so the notion is live in the literature, but no enumeration of
sub-maximum maximal exterior sets was located. This is unclaimed and low-value; it is a property of
the search space, not of the object.

### 4.3 Secondary — the tangent-free "18 = 12 + 6" reading is special to q=11: PRE-EMPTED

Van de Voorde, "On sets without tangents and exterior sets of a conic", §3, states it:

> Hence, the cases q = 7 and q = 11 are conjectured to be the only cases for which a conic C and
> (q+1)/2 exterior points of C form a set without tangents.

Her word "conjectured" covers only q > 31; for 11 < q ≤ 31 it rests on BSW's own computer search
establishing that every complete exterior set there contains a line with at least three of its
points. BSW themselves flag the arc requirement at q = 7 in their opening paragraph (p. 143,
image-verified): "4 exterior points such that each pair determines a passing line and furthermore
no three of them are collinear."

The mechanism is a two-line incidence count and is mine, not a source's: each of the (q+1)/2 points
lies on (q−1)/2 passants, giving (q²−1)/4 point-passant incidences, while the (q²−1)/8 pairs need
at least that many incidences to be covered and need exactly that many precisely when every join
carries two points. So C ∪ S has no tangent if and only if S is an arc, and the single-hit passants
appear exactly when S has collinear triples. C1020's count of 120 single-hit passants at q=31 is
therefore a numerical instance of a published statement, arrived at independently.

---

## 5. Coverage

### 5.1 Forward-citation closure, three services independently

Every seed was resolved by pinned identifier obtained from a consulted service, never by title
search at query time. For each service, an empty or absent result was distinguished from an error by
a positive control: the OpenAlex and Semantic Scholar citation endpoints returned non-empty lists
for the same seeds; the arXiv API query was validated by a control query (below) that returns
exactly one known record.

**Seed: Dye 1991, DOI `10.1112/jlms/s2-44.2.270`, OpenAlex `W2026622256`.**

| Service | Query | Count | List enumerable? |
|---|---|---|---|
| OpenAlex | `https://api.openalex.org/works?filter=cites:W2026622256&per-page=50&select=id,display_name,publication_year,doi` | **13** | yes |
| Crossref | `https://api.crossref.org/works/10.1112/jlms/s2-44.2.270` → `is-referenced-by-count` | **10** | no — Crossref's open API exposes the count but not the citing list without a Cited-by subscription |
| Semantic Scholar | `https://api.semanticscholar.org/graph/v1/paper/DOI:10.1112/jlms/s2-44.2.270/citations?fields=title,year,externalIds&limit=100` | **14** | yes |

**Seed: BSW 1992, DOI `10.1007/BF01204717`, OpenAlex `W2001379196`.**

| Service | Query | Count | List enumerable? |
|---|---|---|---|
| OpenAlex | `https://api.openalex.org/works?filter=cites:W2001379196&per-page=50&select=id,display_name,publication_year,doi` | **9** | yes |
| Crossref | `https://api.crossref.org/works/10.1007/BF01204717` → `is-referenced-by-count` | **3** | no |
| Semantic Scholar | `https://api.semanticscholar.org/graph/v1/paper/DOI:10.1007/BF01204717/citations?fields=title,year,externalIds&limit=100` | **11** | yes |

**Seed: Edge 1956, DOI `10.4153/cjm-1956-041-6`, OpenAlex `W2319208930`.** OpenAlex **7**, Crossref
**6**, Semantic Scholar **10** (of which three are non-articles: two decade-index records and one
"Publications in Theoretical Computer Science").

**The disagreement between services is itself a finding, and it is worse than a count mismatch.**
The lane's earlier calibration (`notes/2026-07-15-c191-instrument-calibration.md`, per the handoff)
recorded three indexes disagreeing 7/3/7 with a union of 8 on Edge 1956. This audit reproduces
disagreement on all three seeds and adds a **verified false negative**: Dye 1991 cites Edge 1956 as
its reference [6] — verified on the page image `dye-286.png` — and yet Dye 1991 appears in *neither*
OpenAlex's nor Semantic Scholar's citing list for Edge 1956. A known, image-verified citation is
missing from both graphs. Any negative drawn from these graphs alone is therefore weaker than its
count suggests, which is precisely why the verdict in §4.1 rests on reading Dye and BSW rather than
on the graphs.

### 5.2 Screened set 1 — works citing Dye 1991

**Size and provenance.** 13 records from OpenAlex, 14 from Semantic Scholar, merging to 14 distinct
works after treating the two "2-Ranks of incidence matrices associated with conics in finite
projective planes" records (dated 2012 and 2014 by the two services) as one. Crossref supplies a
count only. Two service-level discrepancies are recorded rather than resolved: OpenAlex carries
"Assessing formal written ability in Mathematics" (2018), which Semantic Scholar does not and which
is almost certainly a metadata artefact; Semantic Scholar carries "Bring's curve: old and new"
(2022), which OpenAlex does not; and the two services title the 2013 *Linear Algebra Appl.* entry
"Conics arising from internal points…" and "Conics arising from external points…" respectively,
which may be two distinct papers.

**Fields screened.** Title for every member; full-text term scan for the discriminator terms on the
five members present in the shared cache.

**Discriminator, verbatim.** *"Does the work mention exterior sets of a conic — complete exterior
sets, or sets of (q+1)/2 exterior points — or the Petersen graph, in connection with Clebsch
hexagons or Brianchon points?"*

**Result: no member passes.** Members promoted out of the set for individual reading:

- **L. Storme, H. Van Maldeghem, "Primitive arcs in PG(2,q)"**, *J. Combin. Theory Ser. A*, DOI
  `10.1016/0097-3165(95)90051-9`. *Read depth: partial* — cached extraction
  `text/10.1016_0097-3165(95)90051-9.txt`; §4 Remark 2, §5 Proposition 13 and the reference list read
  directly, term scan over the whole extraction. It is the closest miss in the set: it names the
  Clebsch hexagon after Dye, states that it has exactly ten Brianchon points, that these are the
  internal points of the subconic when q = 5ʰ, and — new relative to Dye — that "the 10
  Brianchon-points constitute a 10-arc if q ≡ ±1 (mod 10) (Proposition 11)". It says nothing about
  exterior sets, passants, completeness, or the Petersen graph; zero hits for those terms.
- **H. W. Braden, L. Disney-Hogg, "Bring's curve: old and new"**, arXiv:2208.13692 (also *Eur. J.
  Math.*). *Read depth: partial* — PDF fetched, `pdftotext` extraction read at the Clebsch-hexagon
  passages (§§ around the Dye construction) plus a term scan of the whole. It reproduces Dye's
  canonical hexagon and its ten Brianchon points in the characteristic-0 setting for Bring's curve.
  Zero hits for "exterior set" or "Petersen". It also names a further Dye paper this lane's record
  does not carry — R. H. Dye, "A plane sextic curve of genus 4 with A₅ for collineation group",
  *J. London Math. Soc.* **52** (1995) 97–110 — cited there as [Dye95].
- **R. H. Dye, "Double-sixers of hexagons, A₆ and PSL₃(K)"**, *Abh. Math. Semin. Univ. Hamburg* **66**
  (1996) 203–222, DOI `10.1007/BF02940804`. *Read depth: abstract/metadata only* — and there is no
  abstract: Crossref and OpenAlex both return bibliographic metadata with a null abstract, and the
  Springer full text is paywalled. **This is the sequel Dye 1991 §1.6 promises and the lane's
  handoff records as unlocated; it is now located bibliographically but remains unread.** Dye's own
  advance description (§1.6, p. 273, read at full text) is about double-sixers of Clebsch hexagons
  and A₆ ≤ PSL₃(K), with no exterior-set content, but that is the author's forecast, not the paper.
- **G. Korchmáros, G. P. Nagy, M. Pace (attribution from the cache title record), "One-factorisations
  of complete graphs arising from ovals in finite planes"**, DOI `10.1016/j.jcta.2018.06.006`.
  *Read depth: partial* — cached extraction term-scanned; zero hits for all four discriminator terms.
- **The binary-codes-from-conics cluster**, screened through the two members in the cache —
  arXiv:1104.0324 "On Binary Codes from Conics in PG(2,q)" and DOI `10.1016/j.laa.2013.04.004`.
  *Read depth: partial* — cached extractions term-scanned; zero hits for all four terms. These cite
  Dye 1991 for conic geometry background.

The remaining members are Dye's own later papers on sextic curves and A₇ (1997, 1998, 1999) and the
rest of the binary-codes cluster, covered by the set record above; none has a title or venue
consistent with exterior-set content.

### 5.3 Screened set 2 — works citing BSW 1992

**Size and provenance.** 9 records from OpenAlex, 11 from Semantic Scholar, merging to 12 distinct
works after treating Van de Voorde's journal and arXiv records as one. Crossref supplies a count
only (3).

**Fields screened.** Title for every member; full-text term scan on the one member in the cache.

**Discriminator, verbatim.** *"Does the work discuss the exceptional configurations of BSW §3
(q = 7, 11, 19, 23, 27, 31) — in particular the q=31 one — or connect them to Clebsch hexagons,
Brianchon points, or Dye's work?"*

**Result: exactly one member engages with the exterior-set content, and it does not bridge.**

- **G. Van de Voorde, "On sets without tangents and exterior sets of a conic"**, *Discrete Math.*
  **311**(20) (2011) 2253–2258; version read: **arXiv:1201.0484v1** (2 Jan 2012), cached as
  `arXiv:1201.0484`. *Read depth: partial* — abstract, §1.1 Exterior sets of conics, §1.2 Sets
  without tangents, and §3 Exterior sets in PG(2,q) including Theorem 15 and most of its proof, read
  directly from the cached extraction; term scan for "complete exterior", "Clebsch", "Brianchon",
  "Petersen" over the whole extraction returned **zero hits**. The verdict about the published
  *Discrete Math.* version is made from this preprint and is marked as such. Note the recorded
  citation trap: arXiv's own journal-ref for 1201.0484 points at a different Van de Voorde paper;
  the journal reference above comes from the lane's earlier consulted record, not from arXiv.

The other members — a 1992 note on sharply 3-transitive permutation sets, "Maximal cliques in the
Paley graph of square order" (1996), two papers on ovoids of the Hermitian surface (2005, 2006),
"Carlitz's Theorem" (2010), "Designs from Paley graphs and Peisert graphs" (2015), "Selected results
in combinatorics and graph theory", the 2022 Blokhuis memorial survey, "A strengthening of
McConnel's theorem on permutations over finite fields" (2024), and a 2026 extension of
Carlitz–McConnel — cite BSW predominantly for the Carlitz–McConnel permutation result used in their
proof, not for §3. The Blokhuis memorial survey (*Des. Codes Cryptogr.*, DOI
`10.1007/s10623-022-01072-w`) is the one that might survey the exceptional list; it is
**could not access** (Springer redirects to institutional login).

### 5.4 Intersection of the two citing sets

**Empty, in every index.** No work in OpenAlex's, Crossref's (by count, since no list is available)
or Semantic Scholar's citing sets for Dye 1991 appears in the corresponding set for BSW 1992. Since
the bridge in component F requires putting the two objects side by side, and neither paper cites the
other, a predecessor would have to be a work citing both — and no such work is indexed.

### 5.5 Direct searches

Recorded verbatim; all returned nothing on the bridge.

| Service | Query | Result |
|---|---|---|
| arXiv API | `all:"complete exterior set"` | 0 records |
| arXiv API | `all:"Clebsch hexagon"` | 0 records |
| arXiv API | `all:"exterior sets of a conic"` (positive control) | 1 record — Van de Voorde 1201.0484v1; confirms the empty results above are genuine zeros, not errors |
| web search | `"Clebsch hexagon" "Petersen graph" Brianchon points conic` | no relevant hit |
| web search | `"complete exterior set" conic "Clebsch hexagon" PG(2,31)` | returns BSW and Van de Voorde separately; nothing linking them |
| web search | `"exterior set" conic "Brianchon points" arc PG(2,q) A5 stabilizer` | no relevant hit |
| web search | `"PG(2,31)" exterior set conic Petersen graph 6-arc 10 points Brouwer` | no relevant hit |
| web search | `Dye Clebsch hexagon "10 Brianchon points" graph cubic ten vertices fifteen edges` | surfaces Braden–Disney-Hogg only |

The arXiv API `all:` field searches metadata — title, abstract, authors, comments — not full text,
so those two zeros are **metadata-level** negatives, not full-text negatives.

### 5.6 Not covered

Kept strictly apart from "searched and found nothing":

| Intended source or service | Outcome | Consequence |
|---|---|---|
| **MathSciNet** | **NOT COVERED** — requires institutional authentication, unreachable from an agent session | "to our knowledge" stays on every claim it would have gated, including the component F negative |
| **zbMATH Open** | **COULD NOT ACCESS** — the web interface returned HTTP 403 to `https://zbmath.org/?q=%22complete+exterior+set%22`, and the API endpoints tried (`api.zbmath.org/v1/document/_search`) returned 502 then 404 | A reachable review service was expected here and was not obtained; reviews of Dye 1988, Dye 1996 and Korchmáros 1981 remain unread |
| **Google Scholar** | **NOT COVERED** — blocks automated access | — |
| **Korchmáros 1981**, "Example of a chain of circles on an Elliptic Quadric of PG(3,q), q = 7, 11", *J. Combin. Theory Ser. A* **31** (1981) 98–100 (bibliographic detail from BSW's reference [5], image-verified on `bsw-147.png` region of the reconstruction) | **COULD NOT ACCESS** — ScienceDirect returned HTTP 403 | Its title pins q ∈ {7, 11}, so it cannot state a q=31 identification, but that is an inference from the title and is marked as mine. It remains the true first appearance of the q=7 and q=11 configurations and is still absent from the lane's record |
| **BSW, "On sets of points without tangents"**, *Mitt. Math. Sem. Giessen* **201** (1991) 39–44 (bibliographic detail from BSW 1992's reference [1], image-verified) | **COULD NOT ACCESS** — ILL only; unchanged since the 2026-07-14 sweep | It is the sets-without-tangents paper. Question H's negative would be stronger with it read; the positive predecessor found in Van de Voorde makes that moot for the verdict, but the source stays on the unread ledger |
| **Dye 1988**, "Twelve Hexagons Associated with the 10-Point Conic and the Isomorphism PSL₂(9) ≅ A₆", *J. London Math. Soc.* (2) **37** (1988) 437–446, DOI `10.1112/jlms/s2-37.3.437` | **COULD NOT ACCESS** — closed access, no open-access copy located; Semantic Scholar reports the abstract elided by the publisher. *Read depth: secondary only*, through Dye 1991 §1.4 (p. 271, read at full text and image-verified), which reports twelve hexagons with internal vertices, two PΩ₃(9)-orbits of six, A₆ acting inequivalently on each, and A₅ as the stabiliser of one | q = 9 ≡ −1 (mod 10), so Dye 1991's p. 284 congruence predicts internal vertices there, consistent with the 1988 result. Nothing in the secondary account touches exterior sets |
| **Dye 1996**, the sequel | **COULD NOT ACCESS** (see §5.2) | Located, unread; goes on the unread ledger |
| **Blokhuis memorial survey**, *Des. Codes Cryptogr.* (2022), DOI `10.1007/s10623-022-01072-w` | **COULD NOT ACCESS** — Springer institutional-login redirect | The one member of BSW's citing set that might restate §3 |

---

## 6. What survives, and what it is worth

The lane's adjacent-crown extraction rule applies: the geometry claim is pre-empted, and this is the
bounded extraction pass.

1. **The bridge is the surviving finding.** That Brouwer's q=31 exceptional complete exterior set is
   Dye's Clebsch hexagon together with its ten Brianchon points, and that the two arc-carrying
   entries of that census are one Dye figure at two completion levels, has no located predecessor.
   Stated that way it is a *connection between two disjoint literatures*, not a new geometric fact —
   which is the honest framing and also the defensible one, since every geometric ingredient is
   Dye's or BSW's.

2. **Dye's congruences supply the mechanism C1020 said was missing, and it closes two of its
   mysteries outright.** C1020's ledger asks why A₅ appears at exactly q = 11 and q = 31 and nowhere
   else in Brouwer's census, and why the sizes land on (q+1)/2 twice; both are recorded there as
   open with no argument in sight. Dye's theorems settle them, because **the figure's sizes are
   constant in q while the completion level (q+1)/2 grows**. The hexagon always has six vertices and
   always has ten Brianchon points, over every field where it exists (Thm 1, Thm 2(i)). Layering the
   congruences (my assembly, §2) on top:

   - The six vertices are external and their fifteen joins are passants exactly when q ≡ 1 (mod 10)
     and q ≡ 3 (mod 4), i.e. q ≡ 11 (mod 20). Only then is the hexagon an exterior set at all.
   - Within that class, the Brianchon points are internal when q ≡ 2 (mod 3) and external when
     q ≡ 1 (mod 3) (Dye p. 282).
   - If they are internal, the exterior set is the six vertices, and it is *complete* only if
     6 = (q+1)/2, which forces **q = 11** — and 11 ≡ 2 (mod 3), so the type condition is satisfied
     at exactly that q.
   - If they are external, the exterior set is the sixteen points, and it is complete only if
     16 = (q+1)/2, which forces **q = 31** — and 31 ≡ 1 (mod 3), so again the type condition holds
     at exactly that q.

   There is no third case and no larger q to search: the two completion levels each have a unique
   solution, and the two solutions are precisely the two A₅ entries of Brouwer's census. The
   apparent coincidence in C1020 §1 — "one configuration appearing at two different completion
   levels" — is therefore forced, not accidental, and the mystery-ledger items asking why it happens
   twice and only twice are answered. **This derivation is mine, not Dye's and not BSW's**, and it
   is complete except for one ingredient it does not supply: that at q = 31 the joins *among* the
   ten Brianchon points, and from them to the six vertices, are all passants. That is exactly what
   C1020's computation verifies, so no new run is needed — but the argument is conditional on it and
   should be stated that way. A corrected earlier draft of this item proposed q = 151 as a further
   candidate; that was wrong, because (q+1)/2 = 76 there and a sixteen-point exterior set cannot be
   complete.

3. **The q=11 Petersen naming is a two-line corollary of Dye, not a finding** (§4.1, component C).
   It should be stated that way wherever the lane records it.

4. **Two incidental items, logged with provenance.** Dye's sequel is located: "Double-sixers of
   hexagons, A₆ and PSL₃(K)", *Abh. Math. Semin. Univ. Hamburg* **66** (1996) 203–222, DOI
   `10.1007/BF02940804` — resolved from Crossref, confirmed against Dye 1991 §1.6's own description
   of the promised sequel. And a further Dye paper the lane does not carry: "A plane sextic curve of
   genus 4 with A₅ for collineation group", *J. London Math. Soc.* **52** (1995) 97–110, cited as
   [Dye95] in Braden–Disney-Hogg's bibliography (read there, not consulted directly).

5. **One correction to the lane's own record, flagged not applied.** The consolidated sweep and the
   novelty tables characterise Halbeisen–Hungerbühler, *J. Geometry* 2024, as studying "the same
   15-chord construction over ℝ/ℚ" where no-accidental-concurrency is generic. The paper that
   resolves to that citation is "Twins of conic hexagons", *J. Geom.* **115** (2024), article 36
   (DOI `10.1007/s00022-024-00731-8`), and its subject is six points *on* a conic, the 45 pairwise
   intersections of their fifteen connecting lines, and which six-tuples among those 45 lie on a
   conic — Pascal twins, not concurrency. The setups overlap (the 45 points are the off-conic
   intersections of the fifteen chords) but the paper's organising notion is not concurrency and it
   never uses the words Brianchon, Clebsch, or exterior set. The lane's characterisation should be
   re-checked against the paper by whoever owns that row.

---

## 7. Sources, with read depth

Read depth is recorded for every source named above, including those named only to be dismissed.

| Source | Depth | Access, version, sections |
|---|---|---|
| **Dye 1991**, "Hexagons, conics, A₅ and PSL₂(K)", *J. London Math. Soc.* (2) **44** (1991) 270–286, DOI `10.1112/jlms/s2-44.2.270` | **full text** | User-supplied page scans `/tmp/persistent/tavis/lit-search/dye-1991/dye-270.png`…`dye-286.png`, covered by that directory's rows in `/tmp/persistent/tavis/lit-search/SHA256SUMS`; reconstruction `dye-1991-reconstructed.txt` read end to end; pp. 271, 275, 277, 279, 282, 284 read as images and used for every quoted passage. Published version. §§1.2–1.5, 2.2–2.9, 3.1–3.2, §4, references |
| **Blokhuis–Seress–Wilbrink 1992**, "Characterization of complete exterior sets of conics", *Combinatorica* **12** (2) (1992) 143–147, DOI `10.1007/BF01204717` | **full text** | Page scans `/tmp/persistent/tavis/lit-search/bsw-1992/bsw-143.png`…`bsw-147.png` (sha256 in `SHA256SUMS`, e.g. `bsw-143.png` = `577c6d656a48d51caf831f1b215c54656b4d8ca1b0e3a35d8c89f7d5818faad4`); reconstruction read end to end; pp. 143 and 146 read as images and used for every quoted passage. Published version. Abstract, §1, §2 and proof, §3, references |
| **Van de Voorde 2011**, "On sets without tangents and exterior sets of a conic", *Discrete Math.* **311**(20) (2011) 2253–2258 | **partial** | Version read: **arXiv:1201.0484v1**, cache key `arXiv:1201.0484`, extraction `text/arXiv_1201.0484.txt`. Abstract, §1.1, §1.2, §3 including Theorem 15 and most of its proof read directly; term scan over the whole extraction. Verdicts about the published version are made from the preprint |
| **Edge 1956**, "Conics and Orthogonal Projectivities In a Finite Plane", *Canad. J. Math.* **8** (1956) 362–382, DOI `10.4153/cjm-1956-041-6` | **partial** | Cache key `10.4153/CJM-1956-041-6`, sha256 `07149c0f963d2b31016a0ad992ff6f0af6a77775a574a6c76aa3621b68e189ef`, extraction `text/10.4153_CJM-1956-041-6.txt`. §§29–30 read directly (22 Clebsch hexagons at q=11, vertices e-points, joins s-lines, concurrencies at i-points); term scan over the whole extraction — zero hits for "Petersen" and "exterior set", and no q=31 content. Read at full text by the 2026-07-14 sweep (`notes/2026-07-14-gem-lit-exterior-sets.md`) |
| **Storme–Van Maldeghem 1995**, "Primitive arcs in PG(2,q)", DOI `10.1016/0097-3165(95)90051-9` | **partial** | Cache key `10.1016/0097-3165(95)90051-9`, extraction `text/10.1016_0097-3165(95)90051-9.txt`. §4 Remark 2, §5 Proposition 13, references read directly; term scan over the whole |
| **Braden–Disney-Hogg**, "Bring's curve: old and new", arXiv:2208.13692 | **partial** | PDF fetched from arXiv, `pdftotext` extraction; Clebsch-hexagon passages and bibliography read directly; term scan over the whole. Not added to the shared cache (fetched to the session scratchpad) |
| **Halbeisen–Hungerbühler 2024**, "Twins of conic hexagons", *J. Geometry* **115** (2024), article 36, DOI `10.1007/s00022-024-00731-8` | **partial** | Author copy fetched from `people.math.ethz.ch/~halorenz/publications/pdf/Twin_Conics.pdf` and **added to the shared cache** under key `10.1007/s00022-024-00731-8`, sha256 `10941bcb1a23652fbea02434f199b222e097ef3f09a8fe835dd83ad71ad79e36`. Abstract and §1 read directly; term scan over all 14 pages — zero hits for exterior/Brianchon/Petersen/Clebsch/GF |
| **Korchmáros–Nagy–Pace 2018** (attribution from the cache record), "One-factorisations of complete graphs arising from ovals in finite planes", DOI `10.1016/j.jcta.2018.06.006` | **partial** | Cached extraction term-scanned for the four discriminator terms; zero hits |
| **"On Binary Codes from Conics in PG(2,q)"**, arXiv:1104.0324 | **partial** | Cached extraction term-scanned; zero hits |
| **"Conics arising from internal points and their binary codes"**, DOI `10.1016/j.laa.2013.04.004` | **partial** | Cached extraction term-scanned; zero hits. Service records disagree on whether the title reads "internal" or "external" points |
| **Cameron–Omidi–Tayfeh-Rezaie 2006**, "3-Designs from PGL(2,q)", *Electron. J. Combin.* **13** (2006) #R50 | **secondary only** | Not opened by this audit. Characterised through `notes/2026-07-14-gem-lit-orbit-classification.md` (read here in full), whose own depth is a full-text read of the EJC PDF with the orbit table re-derived by hand. Named as a seed; its subject is PGL(2,q)-orbits on k-subsets of the projective line, with no exterior-set content in the secondary account |
| **Dye 1988**, "Twelve Hexagons Associated with the 10-Point Conic and the Isomorphism PSL₂(9) ≅ A₆", *J. London Math. Soc.* (2) **37** (1988) 437–446, DOI `10.1112/jlms/s2-37.3.437` | **secondary only** | Closed access; abstract elided by the publisher on Semantic Scholar. Characterised through Dye 1991 §1.4, read at full text and image-verified |
| **Dye 1996**, "Double-sixers of hexagons, A₆ and PSL₃(K)", *Abh. Math. Semin. Univ. Hamburg* **66** (1996) 203–222, DOI `10.1007/BF02940804` | **abstract/metadata only** | Crossref and OpenAlex metadata retrieved (both return a null abstract); Springer full text paywalled |
| **Blokhuis memorial survey**, *Des. Codes Cryptogr.* (2022), DOI `10.1007/s10623-022-01072-w` | **abstract/metadata only** | Title and venue from the OpenAlex and Semantic Scholar citing lists; Springer redirects to institutional login |
| **Korchmáros 1981**, "Example of a chain of circles on an Elliptic Quadric of PG(3,q), q = 7, 11", *J. Combin. Theory Ser. A* **31** (1981) 98–100 | **secondary only** | Not obtained (ScienceDirect 403). Bibliographic detail and content description taken from BSW 1992 §3 and its reference [5], read at full text and image-verified |
| **BSW Giessen 1991**, "On sets of points without tangents", *Mitt. Math. Sem. Giessen* **201** (1991) 39–44 | **could not access** | ILL only. Bibliographic detail from BSW 1992's reference [1], image-verified |
| **Dye 1995**, "A plane sextic curve of genus 4 with A₅ for collineation group", *J. London Math. Soc.* **52** (1995) 97–110 | **secondary only** | Not obtained. Bibliographic detail read from Braden–Disney-Hogg's bibliography |

Bibliographic detail throughout comes from a consulted source — Crossref, OpenAlex, the page scans,
or a bibliography read in this session — and never from recall. Where a service and a page image
disagree, the image governs.

---

## 8. Recommendations, and the surfaces that carry the claim

Per the "novelty text has one home" rule, this audit writes nothing outside this file. What follows
is a recommendation list, not an action log.

**There is no ledger row for this claim, and by the rule there cannot be one anywhere else until
there is.** `papers/clebsch-rigidity/` carries no claim–proof–novelty ledger. If the surviving
finding (§6 item 1) is promoted, the row comes first, in the ledger of whichever manuscript takes
it — `clebsch` owns the Clebsch hexagon — and every other surface then quotes that row. Until then
the C1020 and C1022 reports are the only homes.

Surfaces that repeat or depend on the audited claim, and would need updating if the verdicts stand.
Each is listed with what it would need; none was touched.

| Surface | What it would need |
|---|---|
| `notes/2026-08-31-c1020-brouwer-exceptional-census.md` §1 and §8 | Scope the verdict: components A, B, D, E are Dye 1991's; the surviving claim is the bridge to Brouwer's census. The two mystery-ledger entries — why A₅ appears exactly twice, and why the sizes land on (q+1)/2 twice — move from open to settled, carrying the derivation in §6 item 2 and its one conditional ingredient |
| `notes/handoffs/2026-07-14-gem-mining.md` § Dye 1991/1988 warning | The standing warning is now realised for a specific finding; add the pointer, and record that Dye's sequel is located (DOI `10.1007/BF02940804`) |
| `notes/2026-07-14-novelty-status-review-summary-tables.md` §3 | A new row: "the q=11/q=31 six-arc-plus-Brianchon identification is ours" → it is Dye 1991 Thms 1, 2(i), 4, §2.8 p. 282, §3.1 p. 284 |
| `notes/2026-07-15-c193-bsw-exceptional-census.md` § The Petersen echo | Its lead is resolved, and the resolution is that the echo is real but published |
| `notes/2026-07-14-literature-sweep-consolidated.md` § unread ledger | Add Dye 1996, Dye 1995, Korchmáros 1981; Giessen 1991 stays |
| `notes/2026-07-15-gem-discovery-track.md` | Two genuinely incidental items, neither of which this audit was looking for: the further Dye paper of 1995 named in Braden–Disney-Hogg's bibliography, and Storme–Van Maldeghem's Proposition 11 that the ten Brianchon points form a 10-arc when q ≡ ±1 (mod 10). The completion-level mechanism in §6 item 2 is **not** a discovery-track item — it is the product of the extraction pass this task owns and belongs in the task reports |

Nothing here should be copied into a manuscript, a results snapshot, or another lane's handoff
before the lane's vet, which the user launches.
