# Literature check: exterior/interior sets of a conic with all joins external (Clebsch hexagon and kin)

**Date**: 2026-07-14
**Lane**: `clebsch` — see CLAUDE.md § Lane routing.

## Direct answers to (a)–(e)

**(a) Earliest citation.** **W. L. Edge, "Conics and orthogonal projectivities in a finite
plane," Canad. J. Math. 8 (1956), 362–382**, §§29–32. Edge constructs, for q=11, exactly the
6-point object (66 exterior points, 22 "Clebsch hexagons" ℋ split into two systems of 11, all
15 joins of a hexagon skew/external to the conic), and explicitly credits **A. Clebsch, "Über
die Anwendung der quadratischen Substitution…," Math. Ann. 4 (1871), 284–345** for the *real
projective plane* antecedent (hexagons of 6 real points, endowed 10-fold with the Brianchon
property, arising from sections of an icosahedron / Clebsch's diagonal cubic surface). Edge is
explicit that the finite-field (GF(11)) realization is his own contribution: "such hexagons
… when we encounter such hexagons again below with q = 11" (his hexagons at q=5 are a
different, degenerate case — see below). I read Edge's full text (§§1–32, all of the "third
section" the task asked for) via `pdftotext` extraction of the scanned PDF — this is a primary
read, not a summary. **Blokhuis, Seress, Wilbrink (Combinatorica 1992) rediscover the same
q=11 object 35–36 years later**, in a different vocabulary ("exterior set," not "Clebsch
hexagon"), with no indication — based on how the Van de Voorde 2010/2012 follow-up paper cites
the field (see below) — that they were aware of Edge. I could not obtain the BSW originals to
check their bibliography directly (see access notes); this non-citation is an inference from a
downstream source's silence, not a confirmed fact about BSW's own reference list.

**(b) Does anyone state the covering/missed-points property?** **Not found anywhere I could
read.** Edge's §§29–32 (read in full) states the concurrency/Brianchon property (the 15 joins
meet in threes at 10 points, all *internal* to the conic — he gives explicit coordinates,
§30.3) and the partition property (11 disjoint hexagons account for all 66 exterior points,
§31: "The vertices of the 11 ℋ account for all 66 e-points"). He never states, or gives any
formula that would imply, that the 15 joins' *other* points (beyond the 6 vertices and the 10
Brianchon points) cover the remaining 60 exterior points — i.e., he never says the points
missed by all 15 joins are exactly the conic. Van de Voorde (2010/2012), which is the only
substantive post-BSW treatment I could read in full, restates BSW's characterization theorem
(size-(q+1)/2 exterior sets) but likewise contains no covering/missed-points statement. This
is consistent with the claim being open territory for your paper, **conditioned on** the two
papers I could not obtain (BSW Giessen 1991, BSW Combinatorica 1992 — see access notes) not
containing it either. That residual risk should be named explicitly in the manuscript, not
suppressed.

**(c) Current status of the BSW conjecture.** Still open as far as any source I found
indicates, and there appear to be **two related but distinct BSW claims**, easy to conflate
(the task's lead 1 does conflate them):
- The **general "set without tangents" size problem** (Giessen 1991: lower bound
  q + ¼√(2q) + 2; sporadic small-q values u₃,u₅,u₇,… ) — this thread is *actively* worked
  today (Van de Voorde 2010/2012; Héger–Nagy 2024/2025 "k-avoiding sets"; Dover 2025
  "Untouchable sets of size 2q±1"), but these 2024–2025 papers cite only the *Giessen 1991*
  paper, never the *Combinatorica 1992* one, and never Edge.
- The **complete-exterior-set-of-a-conic conjecture** (Combinatorica 1992): for q≡3 (mod 4),
  q=7 and q=11 are conjectured the *only* q for which a (q+1)/2-point exterior set exists that
  is not simply the exterior points of an external line (passant). Van de Voorde's paper
  reports this BOTH as "checked by computer for q<131" (her own restatement, p.1) AND, in her
  §3 exposition citing the original paper, as "found by computer that for 11 < q ≤ 31, all
  exterior sets … contain a line with at least 3 points" (i.e. BSW's own original computer
  check reached q=31). I flag this q<131 vs q≤31 discrepancy verbatim below — I cannot
  resolve which is BSW's original claim vs. Van de Voorde's extension without the original.
  A citation-graph check (OpenAlex) shows **only 9 works cite the Combinatorica 1992 paper at
  all**, and of those, only Van de Voorde's two entries (arXiv 1201.0484 / EJC 17(1) 2010,
  R174) and a 2022 Blokhuis memorial survey engage with the exterior-set content — everything
  else cites it for an unrelated result. **No paper since 2012 appears to have advanced,
  extended the computation past that range, or resolved this specific conjecture.**

**(d) Internal-points version.** **Not studied, as far as I can find** — this looks like a
real gap, matching your hypothesis. Everything in this literature (Edge, BSW, Van de Voorde,
the untouchable-sets thread) is keyed to *external* points only for the "arc with all joins
missing the conic" object. The one internal-point object that does appear in the literature —
Van de Voorde's Lemma 13, and the separate "line partitions of internal points to a conic"
paper (Korchmáros et al., Combinatorica 2009, math/0607118) — is a **different structure**: the
set of *all* q(q−1)/2 internal points (or a partition of them by lines), which is emphatically
not an arc (it has many 3-collinear triples; it's only required to avoid *tangent* lines, the
much weaker "set without tangents" property). I found no source treating a *no-3-collinear arc
of internal points whose joins are all external to the conic* — the exact all-internal analogue
of the Clebsch hexagon that your q=3, 5, 19 computation finds. This appears unclaimed.

**(e) Coding-theory connection.** Partially anticipated, not in the form you want. Van de
Voorde's paper (2010/2012) already frames "sets without tangents" as exactly the **stopping
sets of the LDPC code derived from the incidence matrix of PG(2,q)** (her §1.4, citing Kou–Lin–
Fossorier 2001 and Di–Proietti–Telatar–Richardson–Urbanke 2002) — a real, citable coding
connection, but to LDPC stopping-set theory, not to MDS codes / deep holes / covering radius.
Separately, "exterior set" is reused as a term of art in a *different, higher-dimensional*
sense in recent MRD-code papers (Durante–Grimaldi–Longobardi, arXiv:2305.19027, "Non-linear MRD
codes from cones over exterior sets") — "exterior set with respect to an h-secant variety" in
PG(n−1,q^n) — which is a generalization of the same base concept but is not about conics in
PG(2,q) and does not cite BSW or Edge. **I found no source connecting the conic exterior-set /
Clebsch-hexagon object specifically to MDS codes, covering radius, or deep holes.** That
reading does appear to be unclaimed territory.

## Access notes (say plainly, not guessed)

- **A. Blokhuis, Á. Seress, H. A. Wilbrink, "On sets of points in PG(2,q) without tangents,"
  Mitt. Math. Sem. Giessen 201 (1991), 39–44** — could not obtain. No open-access copy found
  (OpenAlex: closed, no repository fulltext); this is an obscure conference-proceedings
  journal and likely needs ILL. All content attributed to it here is via secondary citation
  (Van de Voorde 2010/2012, and one 2025 paper's one-paragraph description), never read
  directly.
- **A. Blokhuis, Á. Seress, H. A. Wilbrink, "Characterization of complete exterior sets of
  conics," Combinatorica 12 (1992), 143–147**, DOI 10.1007/BF01204717 — could not obtain.
  Springer paywall (redirects to institutional-login page); OpenAlex confirms closed access,
  no repository fulltext. All content here is via Van de Voorde's close paraphrase/direct
  quotation of their Theorem 1 and the surrounding exposition, which I did read in full — but
  this is a secondary source, not the original.
- **W. L. Edge (1956)** — obtained and read in full (§§1–32; the pdftotext extraction of the
  scanned PDF at https://webhomes.maths.ed.ac.uk/~icheltso/edge2016/pdf/1956a.pdf worked
  cleanly, unlike WebFetch's own binary handling). This is a primary read.
- **G. Van de Voorde, "On sets without tangents and exterior sets of a conic"** — obtained and
  read in full (arXiv:1201.0484, 12pp, journal version Electron. J. Combin. 17(1) (2010),
  #R174). Primary read. **Correction to the task's lead 3: this paper's sole author is
  Geertrui Van de Voorde, not M. De Boeck** — I could find no paper on this exact topic by De
  Boeck; the task's attribution appears to be mistaken (possibly conflated with De Boeck's
  other, unrelated finite-geometry work). I flag this so the citation doesn't ship wrong.
- **arXiv:2505.08551** (Dover, "Untouchable sets of size 2q±1 in PG(2,q)") — obtained and read
  (pdftotext of the WebFetch-cached binary). Cites only the Giessen 1991 BSW paper and the
  Blokhuis–Szőnyi–Weiner even-order paper; no mention of Edge or the Combinatorica 1992 paper.
- Innamorati & Zannetti, "The Shape of the (15,3)-Arc of PG(2,7)," Mathematics 9(5) (2021),
  486 — obtained and read in full via a semanticscholar PDF mirror (MDPI blocked direct
  fetch/curl with 403). Confirmed it independently describes the q=7 analogue ("complete
  external quadrangle" whose 6 joins are all external to a conic, unioned with the conic to
  build the unique maximum (15,3)-arc) **without citing Edge or BSW at all** — a clean example
  of the vocabulary/citation fragmentation this task set out to find.

## The object, cross-checked against Edge's own definitions

Edge's §§4–8 (read in full) define, for conic χ: **e-points** = external points (2 tangents
through them, polar is a secant/"c-line"); **i-points** = internal points (0 tangents, polar is
skew/"s-line"). This is the *same* external/internal split as the task's framing, term for
term. His q=11 hexagon ℋ (§30, explicit coordinates given, e.g. vertex set
`(±3,1,0), (1,0,±3), (0,3,1), (1,0,-3)` up to the exact list in §30.1) has:
- 6 vertices, all e-points (external), no 3 collinear (an arc) — matches "the object."
- All 15 joins are s-lines (skew to χ, i.e. external lines) — matches "all joins external."
- The 15 joins concur in threes at 10 points, **all internal** (§30.3 gives coordinates) — the
  10 Brianchon points, all internal, is the closest Edge comes to a "missed points" statement,
  and it is about internal points, not a covering claim over the external points.
- 11 disjoint such hexagons partition all 66 e-points (§31); a second, distinct system of 11
  (§32, obtained by transposing y,z) gives 22 total, with each e-point on exactly one hexagon
  from each system — **yes, Edge explicitly partitions the 66 external points of PG(2,11) into
  11 hexagons**, in fact into two different such partitions.

BSW's Combinatorica 1992 theorem, as quoted by Van de Voorde, is stated for a set of **(q+1)/2**
exterior points — at q=11 that is exactly size 6, i.e. **BSW's "complete exterior set" at q=11
is Edge's Clebsch hexagon**, under a different name and 35–36 years later. At q=7, (q+1)/2=4,
matching the task's stated quadrangle. This identification (same object, two names, same size
formula) is the single strongest fact this search turned up, and is worth stating plainly in
the manuscript's related-work section.

## Vocabulary search results (what hit, what didn't)

| Vocabulary tried                                          | Hit?  | Notes                                                          |
| ----------------------------------------------------------| ----- | --------------------------------------------------------------|
| "exterior set of a conic" / "complete exterior set"        | Yes   | BSW 1992; Van de Voorde 2010/2012; primary vocabulary in use   |
| "set without tangents" / "untouchable set"                 | Yes   | BSW 1991 (Giessen); active thread (Van de Voorde, Héger-Nagy, Dover); broader/weaker property |
| "tangent-free set"                                          | No    | Not used as a term of art in what I found                     |
| "arc complete outside a conic" (Segre/Italian school)       | Partial | Innamorati-Zannetti use "complete external quadrangle" independently; no direct hit on this exact phrase |
| "0-bisecant" / "bisecant-free"                              | No    | Not found as terminology for this object                      |
| "skew to the conic" / "joins skew"                          | Yes   | This is literally Edge's own phrase ("all skew to χ")          |
| "external lines" + "clique"                                 | No    | No hit combining these                                         |
| "(k,n)-arcs" + conic                                        | Partial | Adjacent literature (arc classification) exists but not this specific object |
| "blocking sets" + conic                                     | Partial | Large adjacent literature (blocking sets of external/nonsecant lines to a conic) exists but is a dual/different question, not chased further here |
| German/Italian-school sources                               | Partial | Giessen 1991 is German-hosted but written in English; Innamorati-Zannetti (Italian school) independently rediscovers the q=7 case |
| Hirschfeld, *Projective Geometries over Finite Fields* 2nd ed. | Inconclusive | Could not get inside the book's text via search; Innamorati-Zannetti cite Hirschfeld 1998 generically (arcs background) but I could not confirm whether Ch. 8/14 discuss exterior sets or cite Edge/BSW specifically — worth a direct library check if it matters to the manuscript |
| MDPI (15,3)-arc PG(2,7) thread                              | Yes   | Confirmed q=7 quadrangle used as a building block, independent of Edge/BSW citation |

## What I did not chase to ground

- Hirschfeld's book itself (only searched/fetched web pages about it, never got inside the
  actual chapter text) — if the manuscript leans on "does Hirschfeld cite Edge/BSW," that
  needs a direct look at a physical or scanned copy, which these tools could not reach.
- The exact q-list "7, 11, …, 31" for the Combinatorica 1992 sporadic examples — Van de
  Voorde's paper never spells out the full list (only "at least for q = 7, 11, . . . , 31"
  verbatim, ellipsis and all, in two places) — I could not determine from any source which
  q ∈ {19, 23, 27, 31} actually carry sporadic examples versus just being checked-and-found-none.
  This needs the original Combinatorica paper.
- Blocking-sets-of-external-lines-to-a-conic literature (Aguglia, Korchmáros, and others) is a
  large adjacent body of work I flagged but did not fully chase — it studies a dual question
  (lines, not point-arcs) and seemed a lower-priority thread given the task's scope.

## Cross-reference

A sibling literature check in this same session,
[`2026-07-14-gem-lit-hexad.md`](2026-07-14-gem-lit-hexad.md), independently verified the same
Edge §§29–32 passage (via the same `pdftotext` extraction) while ruling out a *different*
candidate theorem (an on-conic, not off-conic, hexad characterization). Its Edge quotes and
mine agree; cite either as needed.
