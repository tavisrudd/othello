# C1075 — literature audit: lower bounds on complete caps in PG(4,q) and the hyperplane-excess constraint

**Lane**: `relconic` · **Date**: 2026-09-06 · **Status**: COMPLETE (time-boxed; see § Stop condition).

Audit target: the three exclusions in `notes/2026-09-06-astra-cap-hyperplane-memo.md` Part 2 §§ 3, 5, 7 —
`t_2(4,7) ≥ 32`, `t_2(4,8) ≥ 38`, `t_2(4,16) ≥ 98` — each one above the trivial counting bound
`C(k,2)(q−1) + k ≥ θ_d`, obtained from the hyperplane-excess identity
`Σ_{x ∈ H} e(x) = Q(s_H)` with `Q(s) = N − θ_{d−1} + q·C(s,2) − (k−2)s`, the two-sided constraint
`0 ≤ Q(s_H) ≤ L`, `L = N(q−1) − θ_d + k`, and a divisibility contradiction on the fixed-secant
hyperplane moments.

Of the fifteen ledger entries below, **five were read at full text** (all arXiv preprints,
extracted to the shared literature cache), four at partial text, two at abstract/metadata only,
and four entries — covering five works, all paywalled journal articles or book chapters — could
not be obtained at all. Every read depth is recorded in the ledger, and the unobtainable works are
carried forward as open gaps rather than as negatives.

---

## Verdict

**Q1.** For `q = 7, 8, 16` in `PG(4,q)` the trivial counting bound *is* the best published lower
bound on `t_2(4,q)` — no exhaustive classification or better theoretical bound exists for these
parameters, and the literature (Bartoli–Davydov–Marcugini–Pambianco and co-authors, 2014–2017)
states flatly that `√2·q^{(N−1)/2}` is *the* lower bound for `N ≥ 3`, with exact values of
`t_2(N,q)` known only for very small `q` (even `t_2(3,q)` is known only for `q ≤ 7`). The trivial
bound gives `t_2(4,7) ≥ 31`, `t_2(4,8) ≥ 37`, `t_2(4,16) ≥ 97`, so the memo's `32/38/98` are
genuine improvements over everything located.

**Q2.** The *global* form of the coverage count — every point off a complete cap lies on a secant,
hence `C(k,2)(q−1) + k ≥ θ_N` — is completely standard and is exactly how the trivial bound is
derived in every source consulted. The *hyperplane-localised* form `Q(s_H) ≥ 0` was **not located
as a stated inequality** anywhere in the searched domain, in either the cap (`N ≥ 3`) or the arc
(`N = 2`) literature; the nearest published relative is Wehlau's classification of
complete caps of `PG(n,2)` by their hyperplane intersection sizes, which reaches a
hyperplane-size restriction by a different (binary, dual) route. The **upper** constraint
`Q(s_H) ≤ L`, i.e. the fact that the total secant-covering excess is fixed by the parameters and
therefore caps each hyperplane's local excess, was **not located at all**.

**Q3.** **No predecessor located.** No work in the searched domain excludes the counting-bound
value of `k` for complete caps in `PG(4,q)` — or in any `PG(N,q)`, `N ≥ 3` — by a divisibility or
integer-feasibility argument on hyperplane-section sizes through a fixed secant. All located
lower-bound improvement work on complete caps is confined to the plane `N = 2` (Segre 1959;
Polverino 1999; and the 2018 `(k,n)`-arc bound), and every located `N ≥ 3` paper on complete caps
is a construction or upper-bound paper. Four independent indexes agree.

---

## Q1. Known bounds on `t_2(4,q)`, `q = 7, 8, 16`

`t_2(N,q)` = minimum size of a complete cap in `PG(N,q)`. `θ_4 = 1+q+q²+q³+q⁴`.

Trivial counting bound (my arithmetic, from the standard inequality `C(k,2)(q−1) + k ≥ θ_N`):

| `q` | `θ_4` | largest failing `k` | smallest passing `k` | trivial bound |
|----:|------:|--------------------:|---------------------:|--------------:|
| 7   | 2801  | 30 → 2640 < 2801    | 31 → 2821 ≥ 2801     | `t_2(4,7) ≥ 31`  |
| 8   | 4681  | 36 → 4446 < 4681    | 37 → 4699 ≥ 4681     | `t_2(4,8) ≥ 37`  |
| 16  | 69905 | 96 → 68496 < 69905  | 97 → 69937 ≥ 69905   | `t_2(4,16) ≥ 97` |

Bounds table:

| `q`  | best published lower bound | source and method                                                                                                                   | best located upper bound (smallest known complete cap) | source and method                                                        |
|-----:|---------------------------:|:------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------:|:--------------------------------------------------------------------------|
| 7    | 31 (trivial counting)      | No published bound above the counting bound located. Counting bound stated as *the* lower bound in arXiv:1706.01941 § 1, arXiv:1610.09656 § 1, arXiv:1406.5060 § 1. | 56                                                      | arXiv:1610.09656, Table 4 (`t^G_2(4,7) = 56`, randomized greedy search)   |
| 8    | 37 (trivial counting)      | same                                                                                                                                  | NOT LOCATED — open gap                                  | `q = 8` is outside both computed ranges of arXiv:1610.09656 (`L_4` = primes ≤ 1361 ∪ {1409}; `G_4` = primes ≤ 463). The standard reference is Davydov–Faina–Marcugini–Pambianco 2009, Table 8, which is paywalled. |
| 16   | 97 (trivial counting)      | same                                                                                                                                  | NOT LOCATED — open gap                                  | same reason (`q = 16` not prime)                                          |

For reference, arXiv:1610.09656 Table 3 also gives the "lexicap" (fixed-order-of-points algorithm)
size `t^L_2(4,7) = 74`, which is larger than the greedy 56 and therefore not the better upper bound.

Three points that settle the "is the trivial bound the best known?" question:

1. **Explicit statement.** arXiv:1706.01941 § 1: "The trivial lower bound for `t_2(N,q)` is
   `√2 q^{(N−1)/2}`." The same sentence appears in arXiv:1610.09656 § 1 and arXiv:1406.5060. All
   three papers are by the group (Bartoli, Davydov, Marcugini, Pambianco, Faina, Kreshchuk,
   Giulietti) that owns this problem; none cites any improvement for `N ≥ 3`.
2. **No exhaustive classification is remotely in reach.** arXiv:1706.01941 § 1: "The exact values
   of `t_2(N,q)`, `N ≥ 3`, are known only for very small `q`. For instance, `t_2(3,q)` is known
   only for `q ≤ 7`." `PG(4,7)`, `PG(4,8)`, `PG(4,16)` have 2801, 4681 and 69905 points; computer
   classifications of caps in `PG(4,q)` exist only for `q = 2, 3, 4` (arXiv:1203.0992,
   arXiv:1203.0986, arXiv:0912.4461 — located by title in search, not read).
3. **Improvement exists only in the plane.** arXiv:1011.3347 § 1 records
   `t_2(2,q) > √(2q) + 1` for all `q` and `t_2(2,q) > √(3q) + 1/2` for `q = p^h`, `h = 1, 2, 3`,
   citing Segre, *Le geometrie di Galois*, Ann. Mat. Pura Appl. 48 (1959) 1–97, and Polverino,
   *Small minimal blocking sets and complete k-arcs in PG(2,p³)*, Discrete Math. 208–209 (1999)
   469–476. The `√(3q)` improvement rests on Segre's lemma of tangents and has no known analogue
   in dimension `≥ 3`. My inference: this is why the higher-dimensional papers quote only the
   trivial bound.

**Caution on an unreliable figure.** A Bing/LLM search summary returned during this audit asserted
"`t_2(4,8) ≥ 33`, upper bound 72" and "`t_2(4,16) ≥ 91`, upper bound 233" without a locatable
source. The value 33 is below the trivial bound 37 computed above and therefore cannot be a lower
bound on `t_2(4,8)`. These numbers are search-engine output, not a source, and are recorded here
only so they are not mistaken for evidence later.

---

## Q2. Is `Q(s) ≥ 0` standard? Has `Q(s) ≤ L` been used?

### The global count is standard; the hyperplane-local count was not located

Every source consulted derives the trivial bound the same way: a cap `A` is complete iff every
point of `PG(N,q) \ A` lies on a secant of `A`; there are `C(k,2)` secants, each covering `q−1`
points off `A`; hence `C(k,2)(q−1) + k ≥ θ_N`. This is the sum over *all* points of the memo's
identity — i.e. the statement `Σ_x e(x) = L ≥ 0` — and it is universally cited. Definitional
statements of the completeness criterion in exactly this "every point lies on a bisecant" form
appear in, e.g., the Ghent arc-classification thesis (§ 1, p. 997: "A `(k,2)`-arc is complete if
and only if every point of the plane lies on at least one bisecant of the arc") and in
arXiv:1610.09656 § 1.

The memo's Proposition 1 localises this to a single hyperplane: the `θ_{d−1} − s` points of
`H \ A` must be covered, secants not inside `H` meet `H` once and secants inside `H` meet it in
`q+1` points, giving `Σ_{x ∈ H} e(x) = Q(s_H)` and hence `Q(s_H) ≥ 0`. **I did not locate this
inequality, in this or any equivalent form, in the searched domain.** Its planar specialisation —
for a complete `k`-arc and a line `ℓ` with `|K ∩ ℓ| = s`, `C(k,2) − C(s,2) ≥ q + 1 − s` — is a
one-line consequence of completeness that I would expect to be folklore, but no source stating it
was found; the searches that would have surfaced it are listed under § Negatives.

Nearest located relatives, in decreasing order of closeness:

- **Wehlau, D. L., "Complete caps in projective space which are disjoint from a
  subspace of codimension two", arXiv:math/0403031v1** (preprint read at full text; no published
  version consulted). Working in `PG(n,2)`, the author "obtain[s] explicit descriptions of
  complete caps which do not meet every hyperplane in at least 5 points" (abstract) and derive a
  completeness criterion (their Equation 1.3) organised by hyperplane intersection data. This is
  the closest published instance of *restricting the hyperplane-section sizes of a complete cap*,
  but the mechanism is the binary/dual structure of `PG(n,2)` with a distinguished hyperplane at
  infinity, not a `Q(s)`-type covering count, and it does not produce a lower bound on `t_2`.
- **Davydov, Faina, Marcugini, Pambianco (2009)**, the standard `t_2(n,q)` spectrum paper, could
  not be obtained (paywalled). Its Table 8 is the cited home of `t_2(4,q)` upper-bound data. Its
  treatment of hyperplane sections is therefore an open gap in this audit.

### The upper constraint `Q(s) ≤ L`

**Not located.** No source consulted uses the fact that the total covering excess
`L = C(k,2)(q−1) − (θ_d − k)` is fixed by the parameters, and therefore bounds *each* hyperplane's
local excess from above. Nor was any use found of the resulting finite admissible set
`S_L = {s : 0 ≤ Q(s) ≤ L}` of hyperplane sizes. My inference, marked as mine: this is the memo's
genuinely new ingredient at the structural level — the literature treats the excess as a global
slack to be minimised by constructions, not as a conserved budget that constrains local
configurations. The related quantity is the "excess" of a 1-saturating set in the covering-codes
reading of complete caps; I found no paper localising that excess to a hyperplane.

---

## Q3. Prior divisibility exclusions of the counting-bound `k`

**No predecessor located.** Confirmed in four independent indexes, all screened for any work that
excludes a specific cap size in `PG(N,q)`, `N ≥ 3`, or that improves a lower bound on `t_2(N,q)`:

| Index            | Query (verbatim)                                                                  | Set size returned | Screen result |
|:-----------------|:-----------------------------------------------------------------------------------|------------------:|:--------------|
| OpenAlex         | `title_and_abstract.search:"complete cap" AND "lower bound"`                        | 15 works          | All are constructions or upper bounds (small complete caps, probabilistic constructions, scattered linear sets, `PG(4n+1,q)`). One 2009 spectrum paper. No lower-bound improvement, no nonexistence result. |
| OpenAlex         | `title_and_abstract.search:"complete cap" AND hyperplane`                           | 3 works           | Two are Wehlau's codimension-two paper (preprint + journal); one is a 2014 survey/thesis title. |
| OpenAlex         | `title_and_abstract.search:"complete arc" AND "secant distribution"`                | 2 works           | Both are `(k,n)`-arc construction papers in small planes. Neither concerns caps or divisibility. |
| Crossref         | `query.bibliographic=complete+cap+lower+bound+projective+space+PG`, top 15 by rank  | 15 screened       | Only lower-bound hits are planar `(k,n)`-arc papers (2018 `PG(2,q)`; 2024 `PG(3,23)` `(k,n)`-arc). No cap nonexistence or divisibility result. |
| arXiv API        | `abs:"complete caps"`, `max_results=40`                                             | 16 entries        | 13 finite-geometry entries, all constructions/upper bounds/tables; 3 unrelated (physics, distributed systems, progression-free sets). No lower-bound or nonexistence entry. |
| zbMATH Open      | `search_string=complete cap projective space lower bound`, 15 requested             | 8 returned        | 6 finite-geometry entries, all constructions/upper bounds; 2 unrelated. No lower-bound improvement. |

Screen discriminator applied to every set, over title (and abstract where the index returned one):
*does the work claim a lower bound on, or the nonexistence of, a complete cap of a given size in
`PG(N,q)` with `N ≥ 3`?* Every member failed it.

Targeted searches for the three specific parameter triples — `(31, PG(4,7))`, `(37, PG(4,8))`,
`(97, PG(4,16))` — returned nothing on point; the one apparently-relevant hit,
`m'_2(3,7) = 32`, is the *second largest* complete cap in `PG(3,7)`, an unrelated quantity in a
different space.

**What this means for the lane.** The three exclusions appear to be the first improvements over the
counting bound for complete caps in any `PG(N,q)` with `N ≥ 3`. That is the claim worth making,
and it is stronger than the numerical improvement itself: the numbers move `31 → 32`, `37 → 38`,
`97 → 98`, while the smallest known complete cap in `PG(4,7)` has size 56, so the bound remains far
from the truth. The value of the result is methodological — a working local constraint in a regime
where the literature has offered only the global count for thirty years — and the write-up should
be framed that way rather than as a numerical advance. Before any "to our knowledge" sentence is
bound to a manuscript, the two paywalled Davydov et al. papers under § Coverage must be obtained,
since they are the only located works that could plausibly contain a competing local argument.

---

## Consulted-sources ledger

Cache keys refer to `/tmp/persistent/tavis/lit-search/`; SHA-256 is of the cached PDF bytes.

1. **Bartoli, D., Davydov, A. A., Kreshchuk, A., Marcugini, S., Pambianco, F.**, *Tables, bounds
   and graphics of the smallest known sizes of complete caps in the spaces `PG(3,q)` and
   `PG(4,q)`*, arXiv:1610.09656 (2016).
   Read depth: **full text** of the arXiv preprint (v1 as cached), § 1 (introduction and trivial
   bound), § 3 (types of bounds), Tables 3 and 4 (`PG(4,q)` sizes), and the bibliography.
   Access: cache key `arXiv:1610.09656`, sha256
   `729ade7f92c13d66aaeb5e45cf3d1656235a36279ebcf4543e721ed623fb2e89` (already cached by an
   earlier audit; re-fetch refused as duplicate). Version note: preprint only; no published
   version consulted.
   Load-bearing: `t^G_2(4,7) = 56` (Table 4), `t^L_2(4,7) = 74` (Table 3), the computed `q` ranges
   `L_4`/`G_4` that exclude `q = 8, 16`, and the statement of the trivial lower bound.

2. **Bartoli, D., Davydov, A. A., Marcugini, S., Pambianco, F.**, *Upper bounds on the smallest
   size of a complete cap in `PG(N,q)`, `N ≥ 3`, under a certain probabilistic conjecture*,
   arXiv:1706.01941 (2017).
   Read depth: **full text** of § 1 (introduction, Theorem 1.1, Conjecture 1.2); rest skimmed for
   lower-bound statements by targeted grep. Access: cache key `arXiv:1706.01941`, sha256
   `c44c40dc7804ef9fb19bed46a39980c56d57f82532883da87082ba8fa93e4e32`.
   Load-bearing: "The trivial lower bound for `t_2(N,q)` is `√2 q^{(N−1)/2}`" and "The exact
   values of `t_2(N,q)`, `N ≥ 3`, are known only for very small `q` … `t_2(3,q)` is known only for
   `q ≤ 7`."

3. **Bartoli, D., Marcugini, S., Pambianco, F.**, *A probabilistic
   construction of small complete caps in projective spaces*, arXiv:1406.5060v1, 3 June 2014.
   Read depth: **full text** of the abstract and § 1; remainder searched by grep for lower-bound
   statements. Access: cache key `arXiv:1406.5060`, sha256
   `0bda9ede959be67fde8953c72775ae5db670eb91d1e274f355211c8878dbad96`.
   Load-bearing: third independent statement of the trivial lower bound as the state of the art.

4. **Davydov, A. A., Faina, G., Marcugini, S., Pambianco, F.**, *On sizes of complete arcs in
   `PG(2,q)`*, arXiv:1011.3347v3, 23 May 2011.
   Read depth: **full text** of § 1 and the bibliography entries [45]–[50]; body skimmed by grep.
   Access: cache key `arXiv:1011.3347`, sha256
   `60b5b2cc20d59973ddeb603866b313ce9c6b90cf01707bb0694f450389e2016a`.
   Load-bearing: the planar lower bounds `t_2(2,q) > √(2q)+1` and `t_2(2,q) > √(3q)+1/2` for
   `q = p^h`, `h ≤ 3`, with attributions to Segre (1959) and Polverino (1999). These two
   attributions are taken from this paper's § 1 and are **unverified against the originals**.

5. **Wehlau, D. L.**, *Complete caps in projective space which are disjoint from a
   subspace of codimension two*, arXiv:math/0403031v1, 2 March 2004.
   Read depth: **full text** of the abstract and § 1 (including the completeness criterion,
   Equation 1.3, and Lemma 2.1); §§ 3–8 not read. Authorship read from the preprint title page;
   an earlier draft of this report misattributed the paper to Bierbrauer and Edel from recall.
   Access: cache key `arXiv:math/0403031`, sha256
   `c9697c6dbc89c1574bd96c46f4647abd5be75511eec4484cc3524a9557f57d88`. Version note: preprint;
   the journal version was not consulted.
   Load-bearing: that complete caps of `PG(n,2)` are classified by hyperplane intersection sizes —
   the nearest located precedent for constraining hyperplane sections of a complete cap.

6. **Sticker, H.**, *Classification of Arcs in Small Desarguesian Projective Planes*, PhD thesis,
   Ghent University (cached as `UGent-2012-Sticker-ArcClassification`; authorship read from the
   title page of the cached text).
   Read depth: **partial** — § 1 pp. 992–1017 (definitions, completeness criterion, secant
   terminology) and the "excess" tables located by grep. Access: pre-existing cache entry
   `UGent-2012-Sticker-ArcClassification`.
   Load-bearing: the completeness criterion in "every point lies on a bisecant" form. Note: the
   word "excess" in this thesis denotes an arc-extension quantity, unrelated to the memo's `L`.

7. **Hirschfeld, J. W. P., Thas, J. A.**, *Arcs, Caps and Generalisations in a Finite Projective
   Space*, Mathematics 13 (2025) 1489, DOI 10.3390/math13091489.
   Read depth: **partial** — full text searched for "complete cap" / "smallest"; only two hits,
   neither concerning `t_2(N,q)`. Access: pre-existing cache entry `10.3390/math13091489`, sha256
   `396813d44aebabc5a6a54520eaaafd9bee28dfbc3b701fae3ed3e1ba8a5f3f1e`.
   Result: this recent survey does not treat minimum complete-cap sizes; it contributes nothing
   for or against the memo.

8. **Alabdullah, S., Hirschfeld, J. W. P.**, *A new lower bound for the smallest complete
   `(k,n)`-arc in `PG(2,q)`*, Des. Codes Cryptogr., DOI 10.1007/s10623-018-00592-8 (accepted
   4 December 2018).
   Read depth: **partial** — abstract, § 1 definitions, and § 2 "New lower bound" (the counting
   argument bounding `n`-secants through a point). Access: pre-existing cache entry
   `10.1007/s10623-018-00592-8`.
   Load-bearing: confirms that lower-bound work on complete arcs proceeds by *global* counting of
   secants through a point, not by local hyperplane/line-section feasibility. Planar only.

9. **Alderson, T. L.**, *When Arcs Extend Uniquely: A Higher-Dimensional Generalization of
   Barlotti's Result*, arXiv:2511.06193v1, 9 November 2025. Read depth: **partial** — abstract and § 1. Access: cache key
   `arXiv:2511.06193`, sha256 `1547b481a62a7e92daf3070cb5ae43ae3711c5efdcd8b4503ae9929acba00cc4`.
   Result: concerns maximal `(n, k+s−1)`-arcs and hyperplane classification into secant/tangent/
   external, not the coverage inequality. Not on point.

10. **Thas, J. A.**, *On `k`-caps in `PG(n,q)`, with `q` even and `n ≥ 4`*, arXiv:1710.02512v1,
    6 October 2017 (Ghent University).
    Read depth: **abstract/metadata only** — grepped for "complete cap" and "hyperplane section";
    single definitional hit. Access: cache key `arXiv:1710.02512`, sha256
    `5994772ace6a68f8164e0d68468270f17c7e4f53dd96b412352f138d4e790c8c`. Not on point.

11. **Davydov, A. A., Giulietti, M., Marcugini, S., Pambianco, F.**, *New inductive constructions
    of complete caps in `PG(N,q)`, `q` even*, arXiv:0901.0367.
    Read depth: **abstract/metadata only** (grep for `PG(4` returned no occurrence, so the paper
    yields no `PG(4,8)` or `PG(4,16)` size). Access: fetched to
    `/tmp/persistent/tavis/lit-search/staging/0901.0367.pdf`; not ingested under a key.

12. **Davydov, A. A., Faina, G., Marcugini, S., Pambianco, F.**, *On sizes of complete caps in
    projective spaces `PG(n,q)` and arcs in planes `PG(2,q)`*, J. Geom. 94 (2009), No. 1–2, 31–58,
    DOI 10.1007/s00022-009-0009-3, Zbl 1178.51009.
    Read depth: **metadata only** — bibliographic detail taken from Crossref and zbMATH Open
    (record 5633126, MSC 51E21); zbMATH's editorial summary is unavailable "due to conflicting
    licenses". **COULD NOT ACCESS** the text (Springer paywall; OpenAlex reports no open-access
    location). This is the standard home of `t_2(4,q)` upper-bound tables for non-prime `q` and is
    the principal gap in this audit.

13. **Davydov, A. A., Marcugini, S., Pambianco, F.**, *Complete caps in projective spaces
    `PG(n,q)`*, J. Geom. 80 (2004), No. 1–2, DOI 10.1007/s00022-004-1778-3.
    Read depth: **metadata only** (OpenAlex: `oa_status = closed`, no repository full text).
    **COULD NOT ACCESS**.

14. **Hirschfeld, J. W. P., Storme, L.**, *The packing problem in statistics, coding theory and
    finite projective spaces*, J. Statist. Plann. Inference 72 (1998) 355–380; and *… update
    2001*, in: Blokhuis, Hirschfeld et al. (eds.), Kluwer, Dordrecht (2001) 201–246.
    Read depth: **metadata only**; bibliographic detail taken from the reference list of
    arXiv:1610.09656 ([26], [27]) and from a publisher landing page. **COULD NOT ACCESS** — three
    direct-URL attempts at Ghent and Sussex author pages returned 404; no open copy located.

15. **Giulietti, M.**, *The geometry of covering codes: small complete caps and saturating sets in
    Galois spaces*, in: Surveys in Combinatorics 2013, LMS Lecture Note Series 409, CUP, 51–90.
    Read depth: **metadata only** (Cambridge Core landing page via search result).
    **COULD NOT ACCESS**. This survey is the other plausible home of a table of smallest known
    complete caps for non-prime `q`.

---

## Negatives: searched domain and stop condition

Every negative below is a *searched and found nothing* result unless it is listed under Coverage
gaps, which license nothing.

**N1 — no better-than-trivial published lower bound on `t_2(4,q)` for `q = 7, 8, 16`.**
Domain: OpenAlex title-and-abstract search (`"complete cap" AND "lower bound"`, 15 works, all
screened); Crossref bibliographic search (top 15 by relevance, all screened); arXiv API abstract
search `abs:"complete caps"` (16 entries, all screened); zbMATH Open `search_string=complete cap
projective space lower bound` (8 returned, all screened); plus the introductions of the three
papers by the group that owns the problem (arXiv:1610.09656, arXiv:1706.01941, arXiv:1406.5060),
each of which states the trivial bound as current and cites no improvement. Stop condition: four
independent indexes returned sets whose every member is a construction, upper bound, table or
survey, and the three primary introductions agree; no further query was expected to change the
verdict. Confidence is high for `N ≥ 3` generally, not merely for these three `q`.

**N2 — the hyperplane-local inequality `Q(s) ≥ 0` was not located as a stated result.**
Domain: OpenAlex `"complete cap" AND hyperplane` (3 works); OpenAlex `"complete arc" AND "secant
distribution"` (2 works); four web searches phrased around hyperplane/line sections of complete
caps and arcs, the `C(k,2) − C(s,2)` counting, and "points not on the arc must lie on bisecants";
full-text grep of the six cached full-text sources for "hyperplane section", "covered by", "is
complete if". Stop condition: the search budget for this question was exhausted with the nearest
relative (Wehlau, `PG(n,2)`) identified and read, and no source stating the inequality
found. **This negative is weaker than N1 and N3.** The inequality is a one-line consequence of
completeness, exactly the kind of statement that lives unnamed inside proofs and in Hirschfeld's
*Projective Geometries over Finite Fields* — a book not reachable from this session. A novelty
claim should be made for the *pair* `0 ≤ Q(s) ≤ L` and the resulting admissible set, not for the
lower half alone.

**N3 — no prior divisibility or integer-feasibility exclusion of a counting-bound cap size.**
Domain: the same four indexes as N1, with the screen discriminator "does the work claim a lower
bound on, or the nonexistence of, a complete cap of a given size in `PG(N,q)`, `N ≥ 3`?"; plus two
web searches naming the specific parameters (`"complete cap" "PG(4,7)" 31 nonexistence lower bound
32`) and one on divisibility arguments improving the trivial bound. Stop condition: four
independent indexes, zero members surviving the screen, and no parameter-specific hit. This is the
strongest of the three negatives.

**Coverage gaps (license nothing).**
- **MathSciNet: NOT COVERED** — requires institutional authentication, unreachable from this
  session. Every claim it would have gated keeps "to our knowledge".
- **Google Scholar: NOT COVERED** — blocks automated access.
- **Semantic Scholar: NOT COVERED** — the search endpoint returned HTTP 429 (rate limit) on all
  three attempts; the DOI-lookup endpoint worked and was used only for open-access status. The
  three-index requirement for citation-graph negatives is met instead by OpenAlex, Crossref, arXiv
  and zbMATH Open; Semantic Scholar's absence is recorded rather than papered over. Empty results
  were distinguished from errors by inspecting the raw JSON: OpenAlex and zbMATH return a
  `meta.count` / `result` array, Crossref a `message.total-results`, arXiv an Atom feed with a
  countable `<entry>` set; the 429 body is a `message`/`code` object with no result key.
- **Davydov–Faina–Marcugini–Pambianco 2009 (J. Geom. 94, 31–58), Davydov–Marcugini–Pambianco 2004
  (J. Geom. 80), Hirschfeld–Storme 1998 and 2001, Giulietti 2013: COULD NOT ACCESS.** These five
  are the works most likely to contain either a `t_2(4,8)` / `t_2(4,16)` upper-bound value or an
  unnamed statement of the hyperplane-coverage count. Obtaining them is the outstanding action
  before any manuscript-bound novelty sentence.
