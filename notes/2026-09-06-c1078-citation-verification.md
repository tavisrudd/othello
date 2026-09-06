# C1078 citation verification — complete caps in PG(d,q)

**Date**: 2026-09-06. **Status**: complete.

Scope: verify bibliographic details and locate two standard references for a short
finite-geometry preprint on complete caps in PG(d,q). Bound by
`notes/literature-audit-conventions.md`: every named source carries a read-depth field
and its access route; bibliographic detail comes only from a consulted source.

## Opening summary

**Full-text count: two sources were read at full text** — Farr–Lisoněk, *Large caps with free
pairs in dimensions five and six* (published version) and Hirschfeld–Thas, *Arcs, Caps and
Generalisations in a Finite Projective Space* (2025, open access, read to establish a
negative). Pavese arXiv:2305.13838v1 is marked `full text` for the preprint version but the
published version was not read; four further preprints were read `partial`; everything else is
`abstract/metadata only`, `review only` (zbMATH), or `secondary only`.

Verdicts, one line each:

1. **Farr–Lisoněk 2006** — every bibliographic detail confirmed, DOI `10.2140/iig.2006.4.69`.
   **The memo's definition of a free pair is wrong** and must be replaced by the paper's: a
   plane through the pair contains *at most one* further cap point. The term originates with
   these authors' own earlier paper, *Caps with free pairs of points*, J. Geom. 85 (2006),
   35–41, not with Edel–Bierbrauer.
2. **Pavese 2025** — journal details confirmed (J. Algebraic Combin. 61, no. 2, DOI
   `10.1007/s10801-025-01383-w`; page numbers unconfirmed). **The memo's "Pavese equality
   classification" is refuted**: Proposition 3.1 classifies only the 4-general sets attaining
   its counting *upper bound*, not all complete ones. Pavese's own Tables 1 and 2 list complete
   4-general sets of many other sizes and dimensions.
3. **Character equations** — **not** in the 2025 Hirschfeld–Thas survey (searched exhaustively;
   negative recorded with domain). Best candidate is *General Galois Geometries*, Ch. 27
   "Arcs and Caps", §27.1, but only the table of contents was accessible: **unconfirmed, open
   gap.** No published use of the equations restricted to hyperplanes through a fixed secant
   was found; the nearest relative is Thas, arXiv:1710.02512, which counts over hyperplanes
   through a fixed *plane*.
4. **Published versions** — arXiv:1610.09656 and arXiv:1706.01941 have **no journal version**
   located; arXiv:1406.5060 was published as Bartoli–Faina–Marcugini–Pambianco, *A construction
   of small complete caps in projective spaces*, J. Geom. 108 (2017), 215–246, DOI
   `10.1007/s00022-016-0335-1` (link confirmed by zbMATH, which carries the arXiv id). Segre's
   pages are **1–96, not 1–97**. Polverino, Davydov et al. 2009 confirmed. Two attributions in
   the task brief are wrong: arXiv:1706.01941 has **no Bartoli** (it is Davydov–Faina–
   Marcugini–Pambianco), and Segre's page range.
5. **Pre-emption** — nothing found in four recorded queries. Kurz's *Divisible Codes* survey is
   the adjacent general framework; Thas arXiv:1710.02512 is the nearest technique. Neither
   pre-empts.
6. **Pless 1963** — confirmed exactly as given, DOI `10.1016/S0019-9958(63)90189-X`,
   Inform. Control 6 (1963), no. 2, 147–152.
7. **Cap ↔ quasi-perfect code dictionary** — verbatim sentence found in arXiv:1706.01941 §1,
   with the two exceptional cases (5-cap in PG(3,2), 11-cap in PG(4,3)) stated there; a second
   phrasing in arXiv:1406.5060 §1. **None** of the three cached preprints states
   C(k,2)(q−1) + k ≥ θ_d explicitly — they quote only its consequence √2·q^{(N−1)/2}.

## 1. Farr–Lisoněk, "Large caps with free pairs in dimensions five and six"

**Verdict: all bibliographic details confirmed. The memo's paraphrase of "free pair" is
wrong and must be corrected.**

### Sources ledger

| Source | Read depth | Access | Load-bearing detail |
|---|---|---|---|
| J. B. Farr, P. Lisoněk, *Large caps with free pairs in dimensions five and six*, Innovations in Incidence Geometry 4 (2006), 69–88 | **full text** (published version, publisher PDF; read: front matter, §1 Introduction, §2 statements, reference list; §§3–5 constructions skimmed) | `msp.org/iig/2006/4-1/iig-v4-n1-p06-p.pdf`, cached as key `10.2140/iig.2006.4.69`, sha256 `173768fae4d35f32b28882e5ccace52bc4f837e7f3eb761ecb5670b9d4adbf3f` | definition of free pair; Theorem 2.3 upper bound; reference list |
| Crossref record for DOI 10.2140/iig.2006.4.69 | abstract/metadata only | `api.crossref.org/works?query.bibliographic=Large+caps+with+free+pairs+in+dimensions+five+and+six` | container title, volume 4, pages 69–88, year 2006, DOI |
| J. B. Farr, P. Lisoněk, *Caps with free pairs of points*, J. Geom. 85 (2006), 35–41 | abstract/metadata only | Crossref record for DOI 10.1007/s00022-006-0040-6 | earliest located use of "free pair" for caps |
| Y. Edel, J. Bierbrauer, *Recursive constructions for large caps*, Bull. Belg. Math. Soc. Simon Stevin 6 (1999), 249–258 | **secondary only** — as cited by Farr–Lisoněk (ref [5], full text above) | not fetched | cited by Farr–Lisoněk only as the source of a product construction (their Theorem 2.1 = "Theorem 10 in [5]"), *not* for the term "free pair" |

### Confirmed citation

> J. B. Farr and P. Lisoněk, *Large caps with free pairs in dimensions five and six*,
> Innovations in Incidence Geometry **4** (2006), 69–88. DOI `10.2140/iig.2006.4.69`.

ISSN 1781-6475. Both authors at Simon Fraser University. MSC 2000: 51E22.
Crossref renders the container title as "Innovations in Incidence Geometry: Algebraic,
Topological and Combinatorial" (the journal's later MSP name); the paper's own title page
reads "Innovations in Incidence Geometry, Volume 4 (2006), Pages 69–88".

### Definition of a free pair — verbatim

From §1 (Introduction), p. 69, verbatim:

> We say that {x, y} ⊂ C is a free pair of points if for each z ∈ C \ {x, y} the plane xyz
> does not contain any other point of C.

And from the abstract, p. 69, verbatim:

> A cap in PG(N, q) is said to have a free pair of points if any plane containing that pair
> contains at most one other point from the cap.

**Correction required.** The wording the task quotes — "a pair of cap points such that no
plane through them contains a further cap point" — is **not** what the paper says, and is a
strictly stronger (and for a cap of size > 2, vacuous-or-impossible) condition. The paper's
condition is that a plane through x and y contains *at most one* further cap point, i.e. no
plane contains four cap points including x and y. Equivalently: {x,y} lies in no coplanar
quadruple of C. The paper's own gloss (p. 70) is "Pairs of points not participating in any
coplanar quadruple of points of C".

Related notation from the same paper (p. 70), useful if the preprint cites the bound:
`m₂⁺(N,q)` denotes the maximum size of a cap in PG(N,q) containing at least one free pair,
and Theorem 2.3 states `m₂⁺(N,q) ≤ q^{N−2} + q^{N−3} + ··· + q + 3`, attributed there to
reference [8] (the earlier Farr–Lisoněk J. Geom. paper) and stated to be sharp for N ≤ 4.

### Origin of the term "free pair"

The term does **not** originate with Edel–Bierbrauer. Farr–Lisoněk cite Edel–Bierbrauer
*Recursive constructions for large caps* (their ref [5]) only for a product construction,
and Bierbrauer's survey *Large caps*, J. Geom. 76 (2003), 16–51 (their ref [3]) only as "an
excellent survey of large caps". The Introduction says "In an earlier paper we determined
the largest size of caps with free pairs for N = 3 and 4", pointing to:

> J. B. Farr and P. Lisoněk, *Caps with free pairs of points*, J. Geom. **85** (2006), 35–41.
> DOI `10.1007/s00022-006-0040-6`.

That is the earliest use of the term for caps located here. The motivating literature named
by Farr–Lisoněk is statistical design of experiments — Wu–Hamada, *Experiments*, Wiley 2000,
and H. Wu, C. F. J. Wu, *Clear two-factor interactions and minimum aberration*, Ann. Statist.
30 (2002), 1496–1511 — where the relevant notion is a clear two-factor interaction, not a
"free pair" under that name. A third 2006 paper in the same family, Crossref record only:
*Binary caps with many free pairs of points*, J. Combin. Des. 14 (2006), 490–499,
DOI `10.1002/jcd.20117`.

Coverage limit: the J. Geom. 85 (2006) paper itself was **not** read, so "earliest use" is a
verdict at metadata depth. It is possible the term appears in the statistics literature
earlier under the same name; that was not searched exhaustively.

## 2. Pavese, "On 4-general sets in finite projective spaces"

**Verdict: bibliographic details confirmed. The memo's claimed "Pavese equality
classification" is REFUTED as stated — it misreads a sharpness case for the counting bound
as a classification of all complete caps with no four coplanar points.**

### Sources ledger

| Source | Read depth | Access | Load-bearing detail |
|---|---|---|---|
| F. Pavese, *On 4-general sets in finite projective spaces*, arXiv:2305.13838v1 [math.CO], 23 May 2023 | **full text** (preprint v1; read closely: abstract, §1, §3, §5 and Tables 1–2; §§2, 4 skimmed) | cached key `arXiv:2305.13838`, sha256 `a82825e55d28ed25fbaa4db712a34f5ef91e3609cfcff287c6dd132eddb46c88`, 19 pp., from `arxiv.org/pdf/2305.13838` | Proposition 3.1 and its equality cases; Tables 1 and 2 |
| Crossref record for DOI 10.1007/s10801-025-01383-w | abstract/metadata only | `api.crossref.org/works/10.1007/s10801-025-01383-w` | J. Algebraic Combin., vol 61, issue 2, published print 2025-03, online 2025-03-06 |

### Confirmed citation

> F. Pavese, *On 4-general sets in finite projective spaces*, Journal of Algebraic
> Combinatorics **61** (2025), no. 2. DOI `10.1007/s10801-025-01383-w`.

Crossref carries no page range for this record (`page: null`), so **page numbers are
unconfirmed**. ISSN 0925-9899 / 1572-9192. Sole author Francesco Pavese (ORCID
0000-0002-8763-5329). The arXiv copy read is v1 (May 2023); it carries no journal-ref, so
**the published version was not read** and everything quoted below is from the preprint.

### Definition, verbatim (preprint §1, p. 1)

> Here we focus on 4-general sets in PG(n, q), i.e., sets of points of PG(n, q) no four on a
> plane, spanning the whole PG(n, q). [...] Observe that a 4-general set with more than three
> points is also a cap of PG(n, q).

Two things the preprint's definition carries that the memo's phrase "cap with no four
coplanar points" does not: the set must **span** PG(n,q), and "complete" throughout the
paper means maximal as a 4-general set, not maximal as a cap. `M₃(n,q)` denotes the largest
and `T₃(n,q)` the smallest size of a complete 4-general set in PG(n,q).

### Proposition 3.1, verbatim (preprint §3, p. 5)

> **Proposition 3.1.** Let X be a 4-general set of PG(n, q), then
>
>   |X| ≤ ( √(8q^{n+1} + q² − 6q + 1) + q − 3 ) / ( 2(q − 1) ).
>
> Moreover equality occurs if and only if either (q, n) = (2, 3) and in this case X is
> projectively equivalent to an elliptic quadric of PG(3, q) or (q, n) = (3, 4) and X is
> projectively equivalent to the 11-cap of PG(4, 3).

The proof is a two-line count (each point off X lies on at most one secant of X, and there
are |X|(|X|−1)/2 secants) plus, in the equality case, the classification of perfect
2-error-correcting codes: the parity-check code has covering radius 2 and minimum distance
5, hence is the binary [5,1,5] repetition code or the ternary [11,6,5] Golay code.

### Confirm-or-refute of the memo's claim

The memo claims Pavese proves: *"every complete cap with no four coplanar points is one of:
five points in PG(3,2), eleven points in PG(4,3)."* **This is refuted.** Proposition 3.1
classifies only the 4-general sets that meet its counting upper bound **with equality** —
equivalently, the two perfect 2-error-correcting codes. It says nothing about complete
4-general sets that fall short of the bound, and the rest of the paper is precisely about
constructing and classifying those.

The direct counterexamples are in the preprint's own §5. Table 1 ("Complete 4-general sets
in PG(n, 2), n ∈ {3,4,5,6}") lists, by (n, size, |Aut|, description):

| n | size | \|Aut\| | description |
|---|---|---|---|
| 3 | 5  | 120  | an elliptic quadric (or a frame) |
| 4 | 6  | 720  | a frame |
| 5 | 7  | 120  | the union of an elliptic quadric in a solid Π and a point outside Π |
| 5 | 8  | 5040 | a Veronese variety (or a frame) |
| 6 | 11 | 144  | the union of two elliptic quadrics lying in two distinct solids, Π, Π′, and such that Π ∩ Π′ is a line secant to both quadrics |
| 6 | 11 | 48   | Example 5.2 |

Table 2 ("Complete 4-general sets in PG(n, q)") covers PG(3,q) for q ∈ {3,4,5,7,8} and
PG(4,3), by (n, q, size, |Aut|, description):

| n | q | size | \|Aut\| | description |
|---|---|---|---|---|
| 3 | 3 | 5  | 120  | a frame |
| 3 | 4 | 5  | 120  | a twisted cubic (or a frame) |
| 3 | 5 | 6  | 120  | a twisted cubic |
| 3 | 7 | 8  | 336  | a twisted cubic |
| 3 | 8 | 7  | 6    | {(1,t,t²,t³) \| t ∈ F_q \ {0,1}} ∪ {(0,1,1,0)} |
| 3 | 8 | 9  | 504  | a twisted cubic |
| 4 | 3 | 11 | 7920 | the 11-cap |

Preceding text, verbatim: "it is not difficult to obtain the sizes, the order of the relative
automorphism groups and a description of the projectively distinct complete 4-general sets in
PG(n, 2), n ≤ 6, which we provide in Table 1. In a similar way it can be seen that in
PG(3, q), q ∈ {3, 4, 5, 7, 8} and PG(4, 3) the complete 4-general sets are those described in
Table 2." These classifications are stated as Magma computations, not as proofs.

**What can be cited at true strength.** Two separable statements:

1. *Equality in the counting bound.* Proposition 3.1: a 4-general set of PG(n,q) attaining
   |X| ≤ (√(8q^{n+1}+q²−6q+1)+q−3)/(2(q−1)) exists only for (q,n) = (2,3), where it is an
   elliptic quadric of PG(3,2) (5 points), and (q,n) = (3,4), where it is the 11-cap of
   PG(4,3). This is the statement whose two cases the memo has, and it is about
   **bound-attaining**, not **complete**, sets.
2. *Small-case classification.* §5, Tables 1 and 2: a Magma classification of the complete
   4-general sets in PG(n,2) for n ≤ 6 and in PG(3,q) for q ∈ {3,4,5,7,8} and PG(4,3). Cite
   as a computational classification in the listed cases only.

Neither supports a claim about all complete caps with no four coplanar points in general
PG(d,q).


## 3. Standard hyperplane-character equations for caps

**Verdict: NOT found in the cached Hirschfeld–Thas 2025 survey — negative, with the searched
domain recorded below. The best citable source located is Hirschfeld–Thas, *General Galois
Geometries*, Chapter 27 "Arcs and Caps", but only its table of contents was consulted, so
that the three identities appear there is UNCONFIRMED. No published use of the same equations
restricted to the hyperplanes through a fixed secant was located.**

The identities in question, for a k-cap in PG(d,q) with τ_i the number of hyperplanes meeting
it in exactly i points and θ_m = (q^{m+1} − 1)/(q − 1):

    Σ τ_i = θ_d,   Σ i τ_i = k θ_{d−1},   Σ C(i,2) τ_i = C(k,2) θ_{d−2}.

### Sources ledger

| Source | Read depth | Access | Load-bearing detail |
|---|---|---|---|
| J. W. P. Hirschfeld, J. A. Thas, *Arcs, Caps and Generalisations in a Finite Projective Space*, Mathematics 13 (2025), 1489 | **full text** (published open-access version, 17 pp.; searched exhaustively and read the cap sections §§4, 4.1, 4.2) | cached key `10.3390/math13091489`, sha256 `396813d44aebabc5a6a54520eaaafd9bee28dfbc3b701fae3ed3e1ba8a5f3f1e` | **does not contain** the character equations |
| J. W. P. Hirschfeld, J. A. Thas, *General Galois Geometries*, Oxford: Clarendon Press, 1991, xii+407 pp., ISBN 0-19-853537-6; 2nd ed. London: Springer, 2016, Springer Monographs in Mathematics, ISBN 978-1-4471-6788-4 (hbk) / 978-1-4471-6790-7 (ebook), DOI `10.1007/978-1-4471-6790-7` | **abstract/metadata only** — zbMATH book records plus the 1991 edition's scanned table of contents | zbMATH `api.zbmath.org` title query; TOC scan `gbv.de/dms/hebis-darmstadt/toc/25984624.pdf`, text-extracted with poppler | chapter/section structure only; **body not read** |
| J. A. Thas, *On k-caps in PG(n, q), with q even and n ≥ 4*, arXiv:1710.02512v1, 6 Oct 2017 | **partial** — abstract, §1, and the hyperplane-counting passages in §§2–3 | cached key `arXiv:1710.02512`, sha256 `5994772ace6a68f8164e0d68468270f17c7e4f53dd96b412352f138d4e790c8c` | nearest located published use of counting cap points over the hyperplanes through a fixed subspace |
| S. Ball, A. Blokhuis (et al.), *Complete caps in projective space which are disjoint from a subspace of codimension two*, arXiv:math/0403031 | **partial** — searched for τ / secant / hyperplane counting; read the matched passages | cached key `arXiv:math/0403031` | no character equations; the counting there is over secants through a point, not hyperplanes |

### The negative in the 2025 survey, with searched domain

Searched the full extracted text of the 17-page survey (`text/10.3390_math13091489.txt`, 10064
words) case-insensitively for `character`, `standard equation`, `secant`, `bisecant`,
`hyperplane`, `counting`, `equations`, `intersection number`, and for the glyph `τ`. The only
`hyperplane` hits are in the definition of a k-arc (§3), in Payne–Thas theorems on
pseudo-hyperovals and pseudo-ovoids (§§5, 7), and in a projection construction (§7.6). `τ`
occurs 15 times, none of them as a hyperplane-character symbol. `character` occurs only as
"characterise"/"characterisation" and, once, as "characteristic". The survey's section
structure is: 1 Introduction; 2 Arcs, Ovals and Hyperovals in PG(2,q); 3 Arcs in PG(n,q),
n ≥ 3; 4 Caps and Ovoids (4.1 Caps and Ovoids in PG(3,q), 4.2 Caps in PG(n,q), n ≥ 3);
5 Generalised Ovals; 6 Characterisations; 7 Generalised Ovoids; 8–11 pseudo-ovoids,
generalised quadrangles, Moufang quadrangles, weak generalised ovoids. It is a survey of
existence, classification and characterisation results, not of counting technique. **This is a
searched-and-found-nothing negative, not a could-not-access one.**

### The metadata-level candidate

Chapter 27 of *General Galois Geometries* is titled "Arcs and Caps". Its section list, read
off the scanned table of contents of the 1991 Oxford edition (page numbers from that edition):

| § | title | p. |
|---|---|---|
| 27.1 | Introduction | 285 |
| 27.2 | Caps and codes | 287 |
| 27.3 | The maximum size of a cap for q odd | 293 |
| 27.4 | The maximum size of a cap for q even | 299 |
| 27.5 | General properties of k-arcs and normal rational curves | 307 |
| 27.6 | The maximum size of an arc and the characterization of such arcs | — |
| 27.7 | Arcs and primals | — |
| 27.8 | Notes and references | — |

§27.1 (pp. 285–287) is where the elementary counting for caps would sit, but **the body was
not accessed** (Springer redirects to an authentication gateway; no open copy located). Any
citation to it must be made without having verified the equations are stated there, or the
book consulted in a library. Recorded as an open gap.

### "Hyperplanes through a secant" — negative

Searched: arXiv API full-text-metadata search `all:"hyperplanes through a secant"` — **0
results**; `abs:"complete cap" AND abs:"hyperplane"` — **1 result** (arXiv:math/0403031, read
partially, does not use the technique); OpenAlex `hyperplanes through a bisecant of a cap
counting complete cap size` — **6 results**, screened on title and publication year, none about
hyperplane counting through a fixed secant of a cap (they are: *On the size of complete caps in
PG(3,2^h)*, 2003; *On the Largest Caps Contained in the Klein Quadric of PG(5,q), q Odd*, 1999;
*Linear codes over finite fields and finite projective geometries*, 2000; *Complete Arcs and
Caps in Galois Spaces*, 2014; *On Almost Complete Caps in PG(N,q)*, 2018; a 1991 thesis on
n-covers of PG(3,q)).

The nearest located relative is Thas, arXiv:1710.02512, which repeatedly counts the points of a
cap K over the hyperplanes containing a **fixed plane π** of PG(4,q) — e.g. "Counting points of
K in hyperplanes containing π gives ...". That is the same shape of argument with a plane in
place of a secant line, applied to bound the largest cap m₂(n,q) for q even, not to exclude
complete caps.

## 4. Published-version details

**Verdict: two of the three arXiv preprints have no journal version recorded; the third does,
under a changed title and with an extra author. Segre's page range in the memo (1–97) is wrong;
two independent services give 1–96. Everything else confirmed. The Davydov–Faina–Marcugini–
Pambianco 2009 full text could not be accessed.**

Note a **misattribution in the task brief**: arXiv:1706.01941 is by Davydov, Faina, Marcugini
and Pambianco — **not** Bartoli–Davydov–Marcugini–Pambianco. Bartoli is not an author.

### Sources ledger

| Source | Read depth | Access | Load-bearing detail |
|---|---|---|---|
| arXiv Atom metadata for 1610.09656, 1706.01941, 1406.5060 | abstract/metadata only | `export.arxiv.org/api/query?id_list=<id>` | title, authors, `published`, absence of `journal_ref` and `doi` fields |
| Crossref records (DOIs listed below) | abstract/metadata only | `api.crossref.org/works/<doi>` and `?query.bibliographic=` | journal, volume, issue, pages, year, authors |
| zbMATH Open records (Segre 1959; J. Geom. 108) | review only (zbMATH Open) | `api.zbmath.org/v1/document/_search` | Segre page range; the arXiv↔DOI link for the J. Geom. 108 paper |
| Davydov–Faina–Marcugini–Pambianco, J. Geom. 94 (2009) 31–58 | abstract/metadata only | Crossref; one full-text fetch attempt to `link.springer.com/content/pdf/10.1007/s00022-009-0009-3.pdf` returned HTML (`<!DO`, 399 kB), i.e. a paywall page, not a PDF | metadata only |

### Item by item

**arXiv:1610.09656** — Bartoli, Davydov, Kreshchuk, Marcugini, Pambianco, *Tables, bounds and
graphics of the smallest known sizes of complete caps in the spaces PG(3,q) and PG(4,q)*,
submitted 2016-10-30, v1 only, comment "26 pages, 34 references, 5 figures, 4 tables".
**No journal version located.** The arXiv record carries no `journal_ref` and no `doi`, and a
Crossref bibliographic query on the title returned no matching work (top hits were an unrelated
1972 museum paper and a 2021 SIAM J. Discrete Math. paper on generalized caps in AG(n,q)).
Cite as a preprint.

**arXiv:1706.01941** — **Davydov, Faina, Marcugini, Pambianco**, *Upper bounds on the smallest
size of a complete cap in PG(N,q), N ≥ 3, under a certain probabilistic conjecture*, submitted
2017-06-06, v1 only, comment "22 pages, 42 references, 3 figures". **No journal version of this
paper located.** The arXiv record carries no `journal_ref` and no `doi`. Crossref returns a
closely related but distinct short paper — Bartoli, Davydov, Faina, Marcugini, Pambianco,
*Conjectural upper bounds on the smallest size of a complete cap in PG(N,q), N ≥ 3*, Electronic
Notes in Discrete Mathematics **57** (2017), 15–20, DOI `10.1016/j.endm.2017.02.004` — five
authors, six pages, conference-proceedings venue. It is plausibly a short companion, but nothing
consulted links it to arXiv:1706.01941, so **that identification is unconfirmed**. Cite
arXiv:1706.01941 as a preprint.

**arXiv:1406.5060** — Bartoli, Marcugini, Pambianco, *A probabilistic construction of small
complete caps in projective spaces*, submitted 2014-06-03, v1 only, "32 Pages". **A journal
version exists**, under a changed title and with Giorgio Faina added:

> D. Bartoli, G. Faina, S. Marcugini, F. Pambianco, *A construction of small complete caps in
> projective spaces*, Journal of Geometry **108** (2017), no. 1, 215–246.
> DOI `10.1007/s00022-016-0335-1`.

The link is not a guess: the zbMATH Open record for that article carries an explicit
`{"identifier": "1406.5060", "type": "arxiv"}` link alongside the DOI. Crossref gives the
issued date as 2016-06-06 (online first) with volume 108, issue 1, pages 215–246.

**Segre 1959.** Confirmed by Crossref *and* zbMATH, which agree:

> B. Segre, *Le geometrie di Galois*, Annali di Matematica Pura ed Applicata **48** (1959),
> 1–96. DOI `10.1007/BF02410658`.

Crossref: volume 48, issue 1, pages **1-96**, issued 1959-12. zbMATH (record 3152682): pages
"1-96". **The memo's "1–97" is not supported by either service** — use 1–96. Crossref renders
the series without the "(4)" that the classical citation style attaches; the DOI resolves the
ambiguity. A separate Segre item of the same year and title exists — *Le geometrie di Galois.
I: Archi ed ovali. II: Calotte ed ovaloidi*, Conf. Semin. Mat. Univ. Bari 43/44, 29 pp. (1959),
zbMATH record 3177202 — do not conflate the two.

**Polverino 1999.** Confirmed by Crossref:

> O. Polverino, *Small minimal blocking sets and complete k-arcs in PG(2,p³)*, Discrete
> Mathematics **208–209** (1999), 469–476. DOI `10.1016/S0012-365X(99)00090-4`.

Issued 1999-10. Note the DOI ends `...00090-4`; the neighbouring DOI `...00089-8` is a different
paper in the same double issue (*A class of complete k-caps of small cardinality in projective
spaces*, Discrete Math. 208–209 (1999), 463–468).

**Davydov–Faina–Marcugini–Pambianco 2009.** Confirmed by Crossref:

> A. A. Davydov, G. Faina, S. Marcugini, F. Pambianco, *On sizes of complete caps in projective
> spaces PG(n,q) and arcs in planes PG(2,q)*, Journal of Geometry **94** (2009), no. 1–2, 31–58.
> DOI `10.1007/s00022-009-0009-3`.

Issued 2009-07-18. **Full text could not be accessed**: one fetch of the Springer PDF endpoint
returned an HTML paywall page rather than a PDF, and no open author preprint was located within
the attempt budget. Whether this paper states the standard character equations or the trivial
bound C(k,2)(q−1) + k ≥ θ_d explicitly is therefore **unresolved**, and it remains the most
likely open candidate for the task-3 citation.

## 5. Pre-emption query — bounding complete caps by hyperplane sections through a secant

**Verdict: no pre-empting work located. Nothing found that bounds or excludes complete caps in
PG(d,q), d ≥ 3, using the sizes of hyperplane sections through a fixed secant, or using a
divisibility argument on hyperplane-section counts.**

Four queries were run; each is recorded verbatim with its set size and the discriminator.

| # | Service | Query verbatim | Set size | Outcome |
|---|---|---|---|---|
| 1 | arXiv API | `all:"complete cap" AND all:"hyperplane" AND all:"divisibility"` | **0** | empty distinguished from error by the API returning a well-formed feed with zero `<entry>` elements (other queries in the same script returned entries) |
| 2 | OpenAlex | `complete caps hyperplane sections nonexistence projective space` | **106** (top 8 screened) | no hit |
| 3 | OpenAlex | `cap PG(n,q) hyperplane intersection numbers nonexistence divisibility` | **15** (top 8 screened) | no hit |
| 4 | arXiv API | `abs:"complete cap" AND abs:"hyperplane"` | **1** | promoted and read partially (below) |

Screen fields: title and publication year for OpenAlex (the API's `display_name`,
`publication_year`, `doi`); title for arXiv. Discriminator applied: *does the work bound or
exclude complete caps in PG(d,q), d ≥ 3, by counting cap points over hyperplane sections through
a fixed secant or subspace, or by a divisibility condition on hyperplane-section counts?*

Query 2's top 8 were p-ranks of orthogonal spaces (1995), codes and projective multisets (1998),
Griesmer-bound codes via minihypers (1993), nonexistence of an additive quaternary [15,5,9] code
(2015), strongly regular graphs and partial geometries (2001), optimal point distributions on
spheres (2006), linear codes and finite projective geometries (2000), and a thesis on dualities
of polar spaces (2010). None concerns complete caps.

Query 3's top 8 were three records of Kurz's *Divisible Codes* survey (arXiv:2112.11763 and two
later versions), a 1980 four-dimensional topology survey, a ring-geometry history, a thesis on
buildings and Kneser graphs, the polar-space dualities thesis again, and a 2007 thesis on
hyperovals and Laguerre planes. **The adjacent framework worth naming is Kurz, *Divisible
Codes***: it develops divisibility conditions on the hyperplane intersection numbers of point
multisets in PG, which is the general machinery our argument would be a special case of. It is
not a cap-nonexistence result, and it was **not read** (metadata only, from the OpenAlex record).

Query 4's single result, promoted: S. Ball et al., *Complete caps in projective space which are
disjoint from a subspace of codimension two*, arXiv:math/0403031 (cached). Read partially —
searched for `τ`, `secant`, `hyperplanes through`, `standard equation` and read the matched
passages. Its counting is over the secants through a point (completeness: every outside point
lies on a secant), in the affine/binary setting, not over hyperplanes through a secant. Not a
pre-emption.

Separately noted, from the task-3 search rather than these four: Thas, arXiv:1710.02512, counts
cap points over the hyperplanes through a fixed **plane** to improve upper bounds on m₂(n,q) for
q even, n ≥ 4. It is the closest published technique located. It bounds the largest cap, does not
use a secant line as the fixed subspace, and proves no nonexistence for complete caps. It is a
prior-art citation to make, not a pre-emption.

## 6. Pless, "Power moment identities on weight distributions in error correcting codes"

**Verdict: confirmed exactly as given, including the DOI.**

### Sources ledger

| Source | Read depth | Access | Load-bearing detail |
|---|---|---|---|
| Crossref record for DOI 10.1016/S0019-9958(63)90189-X | abstract/metadata only | `api.crossref.org/works/10.1016/S0019-9958(63)90189-X` | title, author, journal, volume, issue, pages, date |

> V. Pless, *Power moment identities on weight distributions in error correcting codes*,
> Information and Control **6** (1963), no. 2, 147–152. DOI `10.1016/S0019-9958(63)90189-X`.

Crossref: sole author "Vera Pless", container title "Information and Control", volume 6, issue 2,
pages 147-152, issued 1963-06. One fetch attempt was made and it succeeded; no full text was
sought. The substantive claim the preprint attaches to this citation — that the first two moments
of a linear code's weight distribution are determined by length, dimension, and the numbers of
dual codewords of weight 1 and 2 — is **not verified against the paper**, which was not read.
Mark that use as resting on metadata plus background, or read the paper before relying on it.

## 7. The complete-cap ↔ quasi-perfect-code dictionary

**Verdict: found, with a verbatim sentence, in the introduction of arXiv:1706.01941. A second,
independently phrased statement is in arXiv:1406.5060 §1. Neither states the trivial bound
C(k,2)(q−1) + k ≥ θ_d explicitly — all three cached preprints quote only its consequence,
√2·q^{(N−1)/2}.**

### Sources ledger

| Source | Read depth | Access | Load-bearing detail |
|---|---|---|---|
| Davydov, Faina, Marcugini, Pambianco, arXiv:1706.01941v1 | **partial** — §1 Introduction read in full; rest searched only | cached key `arXiv:1706.01941` | the dictionary sentence; the trivial lower bound as quoted |
| Bartoli, Marcugini, Pambianco, arXiv:1406.5060v1 | **partial** — §1 Introduction read in full; rest searched only | cached key `arXiv:1406.5060` | second phrasing of the dictionary; trivial lower bound as equation (1) |
| Bartoli, Davydov, Kreshchuk, Marcugini, Pambianco, arXiv:1610.09656v1 | **partial** — introduction passages matched on `quasi-perfect`, `covering radius 2`, `parity check` and read | cached key `arXiv:1610.09656` | third phrasing; trivial lower bound quoted without derivation |

### Verbatim statements

From **arXiv:1706.01941, §1 (Introduction), p. 2**, verbatim (this is the cleanest one to cite —
it gives the code parameters explicitly):

> If a parity-check matrix of a linear q-ary code is obtained by taking as columns the
> homogeneous coordinates of the points of a cap in PG(N, q), then the code has minimum distance
> 4 (with the exceptions of the complete 5-cap in PG(3, 2) and 11-cap in PG(4, 3) giving rise to
> the [5, 1, 5]₂ and [11, 6, 5]₃ codes). Complete n-caps in PG(N, q) correspond to non-extendable
> [n, n − N − 1, 4]_q quasi-perfect codes of covering radius 2 [17, 19].

Two things to carry over into the preprint. First, the **two exceptions**: the complete 5-cap in
PG(3,2) and the complete 11-cap in PG(4,3) give distance-5 perfect codes, not distance-4
quasi-perfect ones — the same two objects that appear as Pavese's equality cases in task 2, and a
reminder that the dictionary as usually stated has exactly these two exceptional entries. Second,
the internal citations [17, 19] are where the paper itself sources the correspondence; they were
not resolved here.

From **arXiv:1406.5060, §1, p. 2–3**, verbatim (converse direction, and the source of the
covering-density framing):

> In the case R = 2 and d = 4, that is, for quasi-perfect linear codes that are both 1-error
> correcting and 2-error detecting, the columns of a parity check matrix of an [n, n−m, 4]_q
> 2-code can be considered as points of a complete n-cap in the finite projective space
> P G(m − 1, q).

From **arXiv:1610.09656, §1**: "Complete caps correspond to quasi-perfect [codes] ... and
covering radius 2; see also [13–17]" and "small complete caps in projective Galois spaces
correspond to quasi-perfect linear codes with small covering density".

### The trivial bound: which paper states it, and how

**None of the three states C(k,2)(q−1) + k ≥ θ_d as an inequality.** Each quotes only the
resulting size bound, without the counting step:

- arXiv:1406.5060, §1, as displayed equation (1): "For the size of the smallest complete cap in
  the projective space PG(N, q) of dimension N over F_q, the trivial lower bound is
  √2 · q^{(N−1)/2}."  ← this is the one to cite if you want a numbered display.
- arXiv:1706.01941, §1: "The trivial lower bound for t₂(N, q) is √2 q^{(N−1)/2}."
- arXiv:1610.09656, §1: "Whereas the trivial lower bound for t₂(N, q) is √2 q^{(N−1)/2}, ..."

The nearest thing to the inequality itself in anything read at full text here is the **dual**
form in Pavese, Proposition 3.1 (see task 2): for a 4-general set every outside point lies on
**at most** one secant, giving (q − 1)|X|(|X| − 1)/2 + |X| ≤ θ_n. The complete-cap bound is the
same count with the inequality reversed (every outside point lies on **at least** one secant).
That symmetry is worth a sentence in the preprint, and Pavese is a citable source for the "≤"
half. For the "≥" half, Davydov–Faina–Marcugini–Pambianco 2009 (J. Geom. 94, 31–58) remains the
most likely explicit source and was not accessible.

## Negatives and coverage

**Searched and found nothing** (these license negatives):

- The standard hyperplane-character equations for caps are **not** in Hirschfeld–Thas,
  *Arcs, Caps and Generalisations in a Finite Projective Space*, Mathematics 13 (2025), 1489,
  read at full text and searched exhaustively (domain recorded in task 3).
- No paper bounding or excluding complete caps in PG(d,q) by hyperplane sections through a fixed
  secant, or by divisibility of hyperplane-section counts, in the four recorded queries over
  arXiv and OpenAlex (task 5).
- No phrase "hyperplanes through a secant" anywhere in arXiv full-text-metadata search.
- No journal version of arXiv:1610.09656 or of arXiv:1706.01941 in arXiv metadata or Crossref
  title queries.

**Could not access** (these license nothing and are carried forward as open gaps):

- **Hirschfeld–Thas, *General Galois Geometries*, Chapter 27 §27.1** — table of contents only.
  Springer redirects to an authentication gateway. Needed to confirm the three character
  equations are stated there. This is the main open gap.
- **Davydov–Faina–Marcugini–Pambianco, J. Geom. 94 (2009), 31–58** — one fetch attempt returned
  a Springer paywall page. The second permitted attempt was not spent. Likely to settle both the
  explicit trivial bound and possibly the character equations.
- **Farr–Lisoněk, *Caps with free pairs of points*, J. Geom. 85 (2006), 35–41** — not fetched.
  The "origin of the term free pair" verdict is therefore at metadata depth.
- **Pavese, published version**, J. Algebraic Combin. 61 (2025), no. 2 — not fetched; everything
  quoted in task 2 is from arXiv:2305.13838v1. Page numbers are unconfirmed (Crossref carries
  none).
- **Pless 1963** — metadata only; the moment-identity claim attached to it is unverified against
  the paper.
- **MathSciNet** — NOT COVERED (institutional authentication). Every "to our knowledge" this
  report would gate stays gated.
- **Semantic Scholar** — not queried. No verdict here rests on an enumerated citing set, so the
  three-service width requirement of the conventions was not triggered.
