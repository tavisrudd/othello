# C491 — PRS(q−4) / redundancy-five deep-hole literature audit — recorded search log

Date: 2026-07-22. Author of log: forward-citation-closure audit agent (owns no verdict).
Purpose: forward-citation closure to decide whether the "forthcoming work" promised by
Zhang–Wan–Kaipa (arXiv:1901.05445), or any other work, has classified deep holes / determined
the covering radius of **PRS(q−4)** (redundancy five), or PRS(k) for k ≤ q−4 (redundancy ≥ 5),
or applied binary-quartic/apolar/catalecticant invariants to PRS deep holes.

## Opening summary

- **Sources read at full text: 4** — arXiv:2312.05534 (cached), arXiv:2509.08526 (cached),
  arXiv:2312.07118 (cached), and the even-characteristic WUJNS paper 10.1051/wujns/2023281015
  (fetched PDF, text-extracted). Two seeds read at abstract/metadata + task-provided final sentence.
- **One-line answer to the decisive question: NOT PRE-EMPTED** — with a load-bearing caveat.
  Across all three citation graphs of both seeds, the arXiv/S2 author streams of the named authors,
  and targeted screening, **no published or preprinted work classifies deep holes or determines the
  covering radius of PRS(q−4) / redundancy-five PRS**. Two independent 2023 sources
  (arXiv:2312.05534 §V and the even-characteristic WUJNS paper) explicitly state the PRS(k) covering
  radius / deep-hole problem is still **open for 2 ≤ k ≤ q−2**, and both cite ZWK's k=q−3 result as
  the current frontier. **Strongest single caveat:** Kaipa–Patanker–Pradhan, arXiv:2312.07118 (v3,
  Aug 2025) *does* classify **binary quartic forms over F_q into PGL₂(q)-orbits using apolar
  invariants** — precisely the invariant-theory machinery the redundancy-five case (syndrome space
  P(Sym⁴F²), automorphism group PGL₂(q)) requires — but applies it to lines of PG(3,q), with **zero**
  deep-hole/PRS/covering-radius content. This reads as groundwork for, not a classification of, the
  redundancy-five case. Present as evidence, not settled verdict.

## Seeds resolved (by pinned identifier)

| Seed | Identifier | DOI | OpenAlex | note |
|------|------------|-----|----------|------|
| SEED-A | arXiv:1901.05445 = IEEE TIT 66 (2020) 2392–2401 | 10.1109/TIT.2019.2940962 | W2973880421 | redundancy-four (k=q−3) classification; "k=q−4 … forthcoming work" |
| SEED-B | arXiv:1612.05447 = IEEE TIT 63(8) (2017) 4940–4948 | 10.1109/TIT.2017.2706677 | W2563545890 | redundancy-≤3 predecessor (ref [9]) |

Semantic Scholar resolves both by external id ARXIV:1901.05445 / ARXIV:1612.05447 (used directly in
the /citations endpoint; S2 numeric paperId not separately pinned since the external-id path succeeded).

## Per-seed three-graph forward-citation (cited-by) counts — recorded SEPARATELY

Counts are NOT aggregated. Disagreement across services is itself reported.

| Service | SEED-A citing count | SEED-B citing count | how empty distinguished from error |
|---------|--------------------:|--------------------:|------------------------------------|
| OpenAlex (`cites:` filter) | **21** | **20** | HTTP-200 JSON with `meta.count` int and a populated `results` array; an error returns a JSON `error` key / non-200 — both counts came with full result lists, so non-empty and non-error. |
| Crossref (`is-referenced-by-count`) | **19** | **16** | `/works/{doi}` returned HTTP-200 `message.is-referenced-by-count` integer; a bad DOI returns a top-level `list`/`failed` status (observed once on a malformed filter query). Count present ⇒ valid, not empty-error. |
| Semantic Scholar (`/citations`) | **24** | **28** | HTTP-200 body with a `data` array (len 24 / 28), `offset:0`, `next:null` ⇒ complete page, not truncated; a 429/error returns a body lacking `data` (observed later in run). Presence of populated `data` + `next:null` ⇒ genuinely empty-of-more, not an error. |

**Disagreement finding:** S2 > OpenAlex > Crossref for both seeds (S2 24/28, OA 21/20, Crossref 19/16).
Consistent with S2 indexing arXiv/ISIT preprints Crossref/OpenAlex miss, and Crossref counting only
DOI-registered citers. No single service is authoritative; the union was screened.

### Load-bearing query URLs (verbatim)

- SEED-A OpenAlex resolve: `https://api.openalex.org/works/https://doi.org/10.1109/TIT.2019.2940962`
- SEED-A OpenAlex cited-by: `https://api.openalex.org/works?filter=cites:W2973880421&per-page=50`
- SEED-B OpenAlex resolve: `https://api.openalex.org/works/https://doi.org/10.1109/TIT.2017.2706677`
- SEED-B OpenAlex cited-by: `https://api.openalex.org/works?filter=cites:W2563545890&per-page=50`
- SEED-A Crossref: `https://api.crossref.org/works/10.1109/TIT.2019.2940962`
- SEED-B Crossref: `https://api.crossref.org/works/10.1109/TIT.2017.2706677`
- SEED-A S2 citations: `https://api.semanticscholar.org/graph/v1/paper/ARXIV:1901.05445/citations?fields=title,year,externalIds&limit=100`
- SEED-B S2 citations: `https://api.semanticscholar.org/graph/v1/paper/ARXIV:1612.05447/citations?fields=title,year,externalIds&limit=100`

(All appended `&mailto=tavisrudd@damnsimple.com` on OpenAlex/Crossref for the polite pool.)

## Screened set record

- **Set screened:** the LARGEST citing set = S2 SEED-B, size **28**, provenance Semantic Scholar
  `/citations`. Cross-checked against S2 SEED-A (24), OpenAlex SEED-A (21) and SEED-B (20) to catch
  any DOI-registered citer S2 missed; the union adds nothing PRS-relevant beyond the S2 sets.
- **Fields screened:** title + year + externalIds (S2/OpenAlex). Abstracts pulled individually for
  every promoted candidate (below). Crossref gave counts only (no citer list — see Coverage).
- **Verbatim discriminator applied:** flag any title/abstract mentioning "q-4" / "q−4",
  "redundancy five/5", "PRS(q-4)", covering radius of PRS beyond redundancy four, deep holes of PRS
  for k ≤ q−4, or binary-quartic / apolar / catalecticant applied to PRS deep holes.
- **Screen outcome:** no citer title contains "q−4" or "redundancy five". Every PRS-, GRS-, or
  quartic-adjacent title was promoted for individual inspection (below). All non-PRS families
  (elliptic-curve codes, twisted/extended GRS, Cauchy codes, doubly-extended RS coset weight
  distributions, Reed–Muller covering radii, Gabidulin, non-GRS MDS) were screened out as
  different code families that do not address PRS(q−4); the two closest (twisted-RS k=q−4 and the
  binary-quartic orbit paper) were promoted and read.

## Promoted candidates — per-candidate read-depth entries

1. **On Deep Holes of Projective Reed-Solomon Codes over Finite Fields with Even Characteristic**
   (XU Xiaofan), Wuhan Univ. J. Nat. Sci. 28(1) 2023, 15–19, DOI 10.1051/wujns/2023281015.
   Read depth: **full text** (fetched PDF → pdftotext; cached key `10.1051/wujns/2023281015`,
   sha256 99669c72…0642c50). Relied on abstract + Main Theorem + intro. **Scope: obtains "two classes
   of deep holes" of PRS over even-characteristic fields — an existence/partial result, explicitly
   "partially solved an open problem."** Its intro cites ZWK as having "completely determined all the
   deep holes of PRS(F_q, q−3)" (redundancy four) and poses the general PRS(k) problem as open. **Does
   NOT reach k=q−4; does not even give a full redundancy-four classification — partial, redundancy
   ≤ q−3.** Not pre-empting.

2. **Extended codes and deep holes of MDS codes** (Wu, Ding, Chen), arXiv:2312.05534 v1 (9 Dec 2023).
   Read depth: **full text** (cached, sha256 ee5cec70…e49afb). Relied on abstract + §V.A "Covering
   radii of projective Reed-Solomon codes" (lines ~1814–1880). **States verbatim: "for 2 ≤ k ≤ q−2,
   the covering radius of PRS(k) is currently open" and restates it as a Conjecture (their Conj. 2,
   = [12] Conj. I.2). Theorem 17 gives only partial answers: k∈{2,q−2} settled, and a conditional
   necessary-condition statement for 3 ≤ k ≤ q−3; it notes Seroussi–Roth settle k ≥ (q−1)/2.** No
   deep-hole classification of PRS(q−4). Not pre-empting.

3. **Deep holes of a class of twisted Reed-Solomon codes** (Gu, Wang, Zhang), arXiv:2509.08526 v1
   (10 Sep 2025). Read depth: **full text** (cached, sha256 66eebba8…6ebdb9). Relied on abstract +
   the k=q−2/q−3/q−4 theorem (near line 3457) + main range theorem. **Classifies deep holes of the
   TWISTED RS codes TRS_k(F*_q, k−1, η), a different code family (different syndrome structure,
   different automorphism group), for a k=q−4 case and for ranges up to k ≤ q−5 (odd q) /
   q−4 ≤ k ≤ q−2 (even q).** The "q−4" here is the twisted-RS dimension, **not** projective RS.
   Jun Zhang (a SEED-A coauthor) is an author, so this is where part of that group's current
   deep-hole effort sits — but it is TRS, not PRS(q−4). Not pre-empting; flag as the nearest-family
   active work by an overlapping author.

4. **On the PGL₂(q)-orbits of lines of PG(3,q) and binary quartic forms** (Kaipa, Patanker, Pradhan),
   arXiv:2312.07118 v3 (9 Aug 2025), math.CO. Read depth: **full text** (cached, sha256
   d88edd66…6702d494). Relied on abstract + intro. **Classifies binary quartic forms over F_q into
   PGL₂(q)-orbits using the apolar invariant (square-of-apolar condition for polar-dual line pairs),
   then classifies the generic lines of PG(3,q) w.r.t. the twisted cubic.** grep for
   deep-hole/PRS/redundancy/covering-radius returns **nothing** — no coding-theory content.
   **This is the strongest caveat in the whole audit:** it is exactly the binary-quartic / apolar /
   PGL₂(q)-orbit invariant machinery flagged in the task, produced by three of the named target
   authors (incl. Kaipa, the SEED-A coauthor), and a PGL₂(q)-orbit classification of binary quartics
   is a load-bearing ingredient for classifying PRS(q−4) deep holes (syndrome space P(Sym⁴F²)). It
   does not itself classify PRS(q−4) deep holes. Reads as foundational/adjacent, not pre-emptive.
   A future redundancy-five PRS task should cite it for the binary-quartic orbit classification.

5. **On deep holes of primitive projective Reed-Solomon codes** (2018), DOI 10.1360/N012017-00064.
   Read depth: **abstract/metadata only** (OpenAlex abstract). Obtains "a class of deep holes of
   PPRS_q(F*_q, k)" — an existence result for general k via Vandermonde arguments, not a
   classification, and predates SEED-A's frontier. Not pre-empting.

6. **Covering Radii and Deep Holes of Two Classes of Extended Twisted GRS Codes** (2025),
   DOI 10.1109/TIT.2025.3541799. Read depth: **abstract/metadata only** (OpenAlex abstract).
   Non-GRS MDS / extended twisted GRS family — determines covering radii/deep holes for two specific
   ETGRS classes, not PRS(q−4). Not pre-empting.

7. **On deep holes of non-Reed-Solomon codes** (2026), DOI 10.1016/j.ffa.2026.102882. Read depth:
   **metadata only** (no abstract in OpenAlex or S2). Title places it in the non-RS-code family;
   nothing indicates PRS(q−4). Screened out on title; abstract **could not be obtained — minor open
   gap**, but low relevance (non-RS by title).

8. Screened-out families (title-level, not promoted): elliptic-curve codes (arXiv:2207.12584);
   Deep Holes of Twisted RS (arXiv:2403.11436) and "Deep holes of twisted RS" (FFA
   10.1016/j.ffa.2025.102680); Cauchy codes; "The deep hole problem of GRS codes" (2023); Gabidulin;
   Reed–Muller covering radii; doubly-extended RS coset weight distributions; non-GRS self-dual /
   Roth–Lempel codes. None address projective RS at redundancy five.

## Author-listing checks (2019–2026)

- **arXiv native API (export.arxiv.org):** attempted `au:Kaipa_K`, `au:Patanker_N`,
  `au:Pradhan_P`, and abstract full-text queries. **HTTP 429 "Rate exceeded" throughout the
  session; zero-byte bodies. Could not access via the arXiv API — open gap for that specific method
  (licenses nothing).** Substituted the Semantic Scholar author endpoint and WebFetch/WebSearch.
- **Krishna Kaipa** (S2 author 2273649755, `/author/{id}/papers`): recent coding/geometry stream is
  2312.07118 (binary quartics, above); 2024–2025 "Higher weight spectra of ternary codes associated
  to the quartic …"; 2025 "Incidence of lines, points, and planes in PG(3,q) …"; 2025 "On the
  PGL₂(q)-orbits of lines of PG(3,q) …". **No paper titled/abstracted as a PRS(q−4) or
  redundancy-five deep-hole / covering-radius classification.** The binary-quartic orbit work is the
  visible continuation thread, but stops short of the deep-hole application.
- **Jun Zhang** (Capital Normal Univ.): appears as coauthor on arXiv:2509.08526 (twisted RS, above).
  No PRS(q−4) paper surfaced in the citation sets or that preprint.
- **Nupur Patanker, Puspendu Pradhan:** appear as Kaipa's coauthors on arXiv:2312.07118 (binary
  quartics). No separate redundancy-five PRS deep-hole paper surfaced.
- **Daqing Wan:** covered via the SEED-A/SEED-B cited-by union; no PRS(q−4) deep-hole paper appears.
  A dedicated arXiv author listing was not obtainable (arXiv API 429) — method gap, not a positive.
- **WebSearch** (targeted "PRS(q−4) / redundancy-five deep holes classification"): returned only the
  redundancy-≤4 corpus (ZWK 2019, Kaipa 2017, the even-char paper) and characterized redundancy-five
  as an open problem; no hit for a k=q−4 classification.

## Even-characteristic and twisted-RS / extended-MDS findings (summary)

- Even-characteristic PRS paper (WUJNS 2023): **redundancy ≤ q−3, partial (two classes), does not
  reach q−4.**
- arXiv:2509.08526 (twisted RS): treats a k=q−4 case but for **twisted RS, not projective RS.**
- arXiv:2312.05534 (extended MDS): explicitly leaves **PRS(k) covering radius open for 2 ≤ k ≤ q−2**;
  no PRS(q−4) deep-hole classification.

## Coverage statement (intended sources not reached, and why)

- **MathSciNet: NOT COVERED** (no institutional access from this environment) — recorded as expected.
- **arXiv native API author/full-text listings: NOT COVERED** — HTTP 429 rate-limited all session;
  substituted Semantic Scholar author endpoint + WebFetch + WebSearch. This is a *method* gap; it
  licenses no negative on its own, but the substitute channels cover the same author space.
- **Crossref forward-citation LIST: NOT COVERED** — the public Crossref API exposes only
  `is-referenced-by-count`, not the citer list (that requires Cited-by/Event-Data/Metadata-Plus).
  Counts (19 / 16) were recorded; citer screening relied on OpenAlex + S2 lists.
- **arXiv author page arxiv.org/a/kaipa_k_1: HTTP 404** — not reachable; S2 author endpoint used
  instead.
- **"On deep holes of non-Reed-Solomon codes" (2026) abstract: could not access** — no abstract in
  OpenAlex/S2; screened out on title only (non-RS family). Minor open gap.
- IEEE Xplore / ScienceDirect full texts of paywalled citers beyond the four read at full text were
  not opened; screened at title/abstract via OpenAlex/S2.

## Load-bearing artifact hashes

| Source | key / path | sha256 |
|--------|-----------|--------|
| arXiv:2509.08526 (twisted RS) | lit-search text cache | 66eebba8d031a7ffdf3901ba19b8f26bb62800c3efb39a552ed15513c16ebdb9 |
| arXiv:2312.05534 (extended MDS) | lit-search text cache | ee5cec7b0189a1c3d350b7e2f5e01c80e969b3e7731f663ce3af6db413e49afb |
| arXiv:2312.07118 (binary quartics) | lit-search text cache | d88edd669ec9dbfa8c8b9359d2b3e68121c149bf510c74417a6792fc6702d494 |
| WUJNS even-char PDF | litcache `10.1051/wujns/2023281015` | 99669c720334c145854d2a0ca4d677aa6a3d715239c16763eba592c1f0642c50 |
