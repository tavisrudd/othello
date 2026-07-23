# C498 Literature Audit — Axis A (coding-theoretic): redundancy-SIX pre-emption check

**Date:** 2026-07-22
**Task:** C498, decide whether any published/preprinted work classifies deep holes, or
determines the covering radius, of PRS(q−5) / redundancy-SIX PRS, or PRS(k) for k ≤ q−5
(redundancy ≥ 6). PRS(k) has length n = q+1, redundancy r = q+1−k; redundancy six ⇔ k = q−5.

## Opening summary

**Full-text sources this audit: 2** (Wu–Ding–Chen arXiv:2312.05534; Xu even-char wujns
10.1051/wujns/2023281015), **plus 2 reused at full text from the C491 audit** (ZWK
arXiv:1901.05445; Kaipa arXiv:1612.05447). No new PDFs were fetched, so no new cache keys.

**One-line verdict:** NOT PRE-EMPTED — no source classifies deep holes of PRS(q−5) or of any
PRS(k) with k ≤ q−5; every relevant source states the general PRS(k) covering-radius/deep-hole
problem OPEN for 2 ≤ k ≤ q−2 (which contains k=q−5). Sole caveat: the covering-radius *value*
(not the orbit classification) of PRS(q−5) is settled for q ≥ 11 by Seroussi–Roth — see caveat.

## Per-seed three-graph forward-citation counts (recorded separately; never aggregated)

| Seed | Identifier | OpenAlex | Crossref | Semantic Scholar |
|------|-----------------------------------------------|:--------:|:--------:|:----------------:|
| A (ZWK 2020, redundancy 4)   | W2973880421 / 10.1109/TIT.2019.2940962 | 21 | 19 | 24 |
| B (Kaipa 2017, redundancy ≤3)| W2563545890 / 10.1109/TIT.2017.2706677 | 20 | 16 | 28 |

**Verbatim query URLs**
- OpenAlex A: `https://api.openalex.org/works?filter=cites:W2973880421&per-page=1&mailto=tavisrudd@damnsimple.com`
- OpenAlex B: `https://api.openalex.org/works?filter=cites:W2563545890&per-page=1&mailto=tavisrudd@damnsimple.com`
- Crossref A: `https://api.crossref.org/works/10.1109/TIT.2019.2940962?mailto=tavisrudd@damnsimple.com` (field `is-referenced-by-count`)
- Crossref B: `https://api.crossref.org/works/10.1109/TIT.2017.2706677?mailto=tavisrudd@damnsimple.com` (field `is-referenced-by-count`)
- S2 A: `https://api.semanticscholar.org/graph/v1/paper/DOI:10.1109/TIT.2019.2940962?fields=citationCount` (and `/citations?fields=title,year,externalIds&limit=100`)
- S2 B: `https://api.semanticscholar.org/graph/v1/paper/DOI:10.1109/TIT.2017.2706677/citations?fields=title,year,externalIds&limit=100`

**Empty vs error discrimination**
- OpenAlex/Crossref: valid JSON with a numeric `meta.count` / `is-referenced-by-count` = genuine
  count, not an error page.
- S2: the first `ARXIV:` lookup returned `{"code":"429","message":"Too Many Requests"}` — an
  ERROR (rate limit), not an empty result. Re-issued via `DOI:` form after a delay and got valid
  JSON with `citationCount` and a populated `data` array (24 / 28 rows) = genuine.
- Service disagreement (OpenAlex/Crossref/S2 differ by up to 12 on seed B) is expected from
  differing citation-graph coverage and is itself recorded; none of the discrepancy hides a
  redundancy-six citer (largest set fully enumerated below).

## Screened set

**Screened set = the two S2 citing lists (largest retrievable: 24 for A, 28 for B), enumerated in
full via the `/citations` endpoint; cross-checked against OpenAlex (21/20).** Discriminator applied
verbatim: title/abstract mentioning "q-5"/"q−5", "redundancy six/6", "PRS(q-5)", covering radius of
PRS beyond redundancy five, deep holes of PRS for k ≤ q−5, or a general PRS(k) covering-radius
classification reaching k=q−5.

**Discriminator hits: NONE.** No title in either citing set mentions q−5, redundancy six, or a
PRS(k) classification reaching k=q−5. Every PRS/GRS-adjacent citer was promoted for abstract
inspection (below).

**Citers NEW since the C491 audit (2026-07-22, same date) — 2026 entries:** "Weight distributions
of cosets of weight 2 of the generalized doubly extended RS codes" (2026); "3-Designs from
GL₂(𝔽_q)-Invariant Subspaces" (2026); "Non-GRS type MDS and AMDS codes from extended TGRS codes"
(2026); "A framework for constructing non-GRS MDS-NMDS codes from deep holes and its application"
(2026). All are weight-distribution / TGRS-construction / design papers — none is a PRS(k)
covering-radius classification, none reaches redundancy six.

## Promoted candidates (abstract-or-deeper inspection, with read depth)

- **Wu–Ding–Chen, "Extended codes and deep holes of MDS codes," arXiv:2312.05534** — READ DEPTH:
  full text (cache key `arXiv:2312.05534`, sha256 `9fe687…f76000`; pdftotext, §V "Covering radius
  of projective Reed-Solomon codes" lines 1816–1905 + reference list). Its §V is the governing
  statement (see Verbatim). Reaches only k∈{2,q−2} (endpoints, Thm 17) plus a conditional criterion
  for 3≤k≤q−3; does NOT classify k=q−5. Its ref [12] = ZWK (seed A), confirmed at line 2027.
- **Xu, "On Deep Holes of PRS Codes over Finite Fields with Even Characteristic,"
  10.1051/wujns/2023281015** — READ DEPTH: full text (cache key `10.1051/wujns/2023281015`,
  sha256 `99669c…642c50`; pdftotext). Handles the even-characteristic endpoints k∈{2,q−2} and
  works with PRS(q−3); confirms Conjecture 2 at the endpoints for even q. Does NOT reach k=q−5.
- **ZWK, "Deep Holes of PRS Codes," arXiv:1901.05445 (SEED-A)** — READ DEPTH: full text (reused
  from C491; cache key `arXiv:1901.05445`, sha256 `5c2b9e…41caf24`; this audit re-verified only
  metadata + citation role). Classifies redundancy four (k=q−3); explicitly defers k=q−4 to
  "forthcoming work." Does not address k=q−5.
- **Kaipa, "Deep Holes and MDS Extensions of RS Codes," arXiv:1612.05447 (SEED-B)** — READ DEPTH:
  full text (reused from C491; cache key `arXiv:1612.05447`, sha256 `1fe8de…968178a4`). Redundancy
  ≤ 3. Does not address k=q−5.
- **Gu–Wang–Zhang, "Deep holes of a class of twisted RS codes," arXiv:2509.08526** — READ DEPTH:
  abstract/metadata only this audit (cache key `arXiv:2509.08526`, full text held by C491). k=q−4
  there is the TWISTED dimension, not PRS; not a PRS(q−5) result.
- Twisted-RS / elliptic-curve / local-ring / Roth–Lempel / Cauchy-code deep-hole citers ("Deep
  Holes of Twisted RS Codes" 2024/2025, "On Deep Holes of Elliptic Curve Codes" 2022, "Finite
  Geometry and Deep Holes of RS Codes over Finite Local Rings" 2022, "New MDS and self-dual
  generalized Roth–Lempel codes … deep holes" 2025, "On the deep holes of a class of Cauchy codes"
  2025) — READ DEPTH: title + WebSearch snippet (abstract/metadata only). All treat a different
  code family or evaluation set; none is a PRS(k=q−5) classification.
- **"Covering in Hamming and Grassmann Spaces: New Bounds and RS-Based Constructions,"
  arXiv:2512.22911 (Dec 2025)** — READ DEPTH: title/metadata only (WebSearch). Covering-code bounds
  and constructions, not a PRS deep-hole/covering-radius classification; does not reach redundancy
  six. Not fetched.

## Verbatim open-problem statements (these cover k = q−5)

Wu–Ding–Chen, arXiv:2312.05534, §V (full text, pdftotext lines 1837–1846):

> "However, for 2 ≤ k ≤ q − 2, the covering radius of PRS(k) is currently open and conjectured as
> follows. **Conjecture 2. [12, Conjecture I.2]** For 2 ≤ k ≤ q − 2, the covering radius of PRS(k)
> is: q − k + 1 if q is even and k ∈ {2, q − 2}, q − k otherwise."

The stated range 2 ≤ k ≤ q−2 **contains k = q−5** (for q ≥ 7). No source narrows this range away
from k=q−5 or specifically resolves the deep-hole *classification* at k=q−5. WDC's own advances
(Thm 17) reach only the endpoints k∈{2,q−2} and a conditional 3≤k≤q−3 criterion — not a k=q−5
classification.

**Covering-radius-VALUE caveat (kept separate from the classification verdict):** WDC lines
1848–1886 note Conjecture 2 (the covering-radius *value* = q−k) "is true if k ≥ ⌈(q−1)/2⌉ from the
work of Seroussi and Roth [8]" (Seroussi–Roth, "On MDS extensions of GRS codes," IEEE TIT 1986).
Since q−5 ≥ ⌈(q−1)/2⌉ for q ≥ 11, the covering-radius **value** of PRS(q−5) is already known for
q ≥ 11. This does NOT pre-empt C498: the deep-hole PGL₂(q)-orbit **classification** (which vectors
achieve the radius, and their orbit structure) is the C498 crown and remains open — exactly the ZWK
redundancy-four / C491 redundancy-five situation, where the value was likewise Seroussi–Roth-known
yet the orbit classification was novel.

## Author-stream checks (READ DEPTH: WebSearch snippets, abstract/metadata only)

- **Kaipa** — no post-2020 preprint reaching redundancy five/six surfaced; the k=q−4 case ZWK
  deferred was closed internally as C491, not by a Kaipa publication. arXiv:2312.07118 (Kaipa,
  Patanker, Pradhan) is on lines in projective 3-space, unrelated.
- **Jun Zhang** — recent stream is twisted-RS (arXiv:2509.08526, twisted dimension k=q−4, not PRS).
  No PRS(q−5) result.
- **Daqing Wan** — cited as proposer of the even-char open problem (Wan 2020); no redundancy-six
  resolution found.
- **Patanker / Pradhan** — no deep-hole/covering-radius PRS paper reaching redundancy six indexed.
- Targeted WebSearches for "PRS(q-5)", "redundancy six projective Reed-Solomon deep holes",
  "covering radius PRS k=q-5" returned only the redundancy-≤four literature and the open-conjecture
  statement; searched web index, stop condition = no result mentions redundancy five or six as
  resolved.

## Coverage statement

- **OpenAlex, Crossref, Semantic Scholar:** COVERED (both seeds, counts + full enumeration of the
  largest set). Empty-vs-error explicitly distinguished (S2 429 handled).
- **WebSearch / author streams:** COVERED (Kaipa, Zhang, Wan, Patanker, Pradhan; deliverable terms).
- **Lit cache full-text corpus:** COVERED for the four load-bearing PRS papers.
- **MathSciNet:** NOT COVERED (unreachable). Any "to our knowledge" sentence C498 writes must stay
  qualified accordingly. "Searched and found nothing" (licenses the negative) is confined to the
  three citation graphs + WebSearch above; MathSciNet is an "could not access" gap carried forward,
  licensing nothing.
- No new PDFs fetched → no new cache keys or sha256s to register.

## VERDICT

**NOT PRE-EMPTED for redundancy six (k = q−5).** No published or preprinted work classifies the
deep holes, or gives the PGL₂(q)-orbit / covering-radius deep-hole classification, of PRS(q−5) or of
any PRS(k) with k ≤ q−5. Multiple independent sources (Wu–Ding–Chen 2023 §V; even-char Xu 2023;
WebSearch corpus) state the general problem OPEN for 2 ≤ k ≤ q−2, a range containing k=q−5.

**Caveats:** (1) The covering-radius *value* of PRS(q−5) is settled for q ≥ 11 by Seroussi–Roth
(1986) — a C498 novelty claim must be scoped to the deep-hole/orbit **classification**, not the
scalar radius. (2) MathSciNet unreachable — keep any "to our knowledge" sentence qualified.
