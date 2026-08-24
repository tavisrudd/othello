# Literature audit

## Scope and bounded finding

This audit supports the literature positioning of *Integral Secant
Distributions and Improved Bounds for Complete (k,n)-Arcs*. It records 22
individually discussed sources: 15 were read at full-text depth and seven at
partial depth. It also records an exact eight-week arXiv title-and-abstract
screen through 24 August 2026.

The first and second incidence moments, their real spectral or variance
relaxation, tactical decompositions, the complement correspondence with
minimal multiple blocking sets, modular repair, and the projective-code
dictionary are classical. No inspected source states the combination used in
the manuscript: simultaneous sharp integer bounds for the two selected-block
degree sequences, the resulting divisor-indexed first-order bounds for
complete `(k,n)`-arcs, and the additional lower bound obtained by feeding the
support of a modular repair back through completeness. This is a bounded
finding about the searches and texts recorded below. It is not an exhaustive
priority claim.

## Claim boundaries

| Manuscript claim | Classical material credited | Search outcome |
|---|---|---|
| Exact integer incidence condition | Exact design moments, tactical decompositions, and real incidence bounds | No inspected source formulates the simultaneous integer-box overlap for an arbitrary selected block family. |
| Rational equality families | Bishnoi--Mattheus--Schillewaert's quadratic and the standard design incidence inequality | No inspected source derives the ordered-factorization classification and its stated linear integer correction. |
| Characteristic-three bound | Szőnyi--Weiner's `k mod p` multiset repair theorem | No inspected source applies repair support to the complete arc's full family of `n`-secants to obtain the displayed `2q/3+1` bound. |
| Characteristic-two bound | Szőnyi--Weiner's stability theorem for sets of even type and the established local-secant method | No inspected source combines that repair with the selected `n`-secant degree bounds to obtain the displayed coefficient. |

These rows govern the manuscript's positioning. They do not license “first,”
“new,” or an unqualified “to our knowledge.”

## Individually read sources

Each entry records the version and passages used. Cache keys identify the
retrieved bytes; SHA-256 values are included where the bytes were cached.

1. **Alabdullah--Hirschfeld, *A new lower bound for the smallest complete
   `(k,n)`-arc in `PG(2,q)`*.** **Full text.** Published-version PDF from the
   German National Library mirror; Theorem 2.1 and its proof were used. Cache
   key `10.1007/s10623-018-00592-8`; SHA-256
   `b70116f426fb6ca1e733fafc4d2f6434993c55006ba900344b7bfa4abbd32961`.
   The proof combines completeness with the pair-packing bound on the number
   of `n`-secants and uses the first external coverage moment.

2. **Bastioni--Micheli, *On complete m-arcs*.** **Partial.** arXiv
   `2303.13670v1`; abstract, introduction, and arc definitions. Cache key
   `arXiv:2303.13670`; SHA-256
   `f5eb03dab26f3cc701d9917db70d85409629174fc5ac279c59bbca1505517c40`.
   Used only to document curve-based construction work; no absence finding
   depends on unread sections.

3. **Korchmáros--Nagy--Szőnyi, *Algebraic approach to the completeness
   problem for `(k,n)`-arcs in planes over finite fields*.** **Partial.**
   arXiv `2302.10162v1`; abstract and introduction. Cache key
   `arXiv:2302.10162`; SHA-256
   `32cfd5b1cb4f28c171418f61d467fc0accee8adc269ae9cf36a517158917b6b7`.
   The later JCTA version was not read. Used for the standard maximal-secant
   coverage formulation and current construction context.

4. **Bartoli--Davydov--Giulietti--Marcugini--Pambianco, *On upper bounds on
   the smallest size of a saturating set in a projective plane*.**
   **Partial.** arXiv `1505.01426`; introduction and Definitions 1.1 and 1.5
   through Theorem 1.6. Cache key `arXiv:1505.01426`; SHA-256
   `e9040360a11f31d852dab3207a6db34fd31185ff244a72161cd36af3c039f55a`.
   Its weighted saturating multiplicity differs from the manuscript's count
   of distinct `n`-secants for higher arcs.

5. **Bartoli--Timpanella, *Complete `(k,q+1)`-arcs in
   `PG(2,F_{q^6})` from the Hermitian curve*.** **Partial.** arXiv
   `2306.01134v1`; abstract, introduction, main theorem, and preliminaries
   through Theorem 2.1. Cache key `arXiv:2306.01134`; SHA-256
   `753783a0178b7cbb0012ae4488e51f08e49d780cd865a1c5ed760fc33560385e`.
   The later published version was not read. Used only as construction-side
   context.

6. **Van de Voorde--Zullo, *Weak arcs and applications to the DNA-based
   storage access problem*.** **Partial.** arXiv `2608.19550v1`; abstract,
   opening of Section 1, Section 2.1.1 around Theorem 1 and its extremal
   example, plus targeted full-text searches for `complete arc`, `maximal
   secant`, `blocking set`, `second moment`, `defect identity`, and
   `(k,n)`-arc. Cache key `arXiv:2608.19550`; SHA-256
   `74cba859eff90472e9e424c6356fb81c44c0c870a0e0d814f1f19550ab91727`.
   Its weak-arc condition concerns general hyperplanes avoiding specified
   fundamental points, not completeness through all `n`-secants.

7. **Ball, *Multiple blocking sets and arcs in finite planes*.**
   **Partial.** Author-hosted PDF; abstract, introduction, Theorems 1.1--1.4,
   and the complement formulation. Cache key `10.1112/jlms/54.3.581`;
   SHA-256
   `b0e5ee5e3bb2831fadc045ed1ecf9531730aa52084310542076a840fcbc14784`.
   Used for the classical complement language; no absence finding depends on
   unread sections.

8. **Bishnoi--Mattheus--Schillewaert, *Minimal multiple blocking sets*.**
   **Full text.** All Sections 1--9 of arXiv `1703.07843v3`, with Theorem 1.1,
   Sections 3--5, and Theorem 8.1 used directly. Cache key
   `arXiv:1703.07843`; SHA-256
   `4ca2ebf88bc90d94a88552092a9e69bcd0dcc9f234490994bfa4d5fa682694b9`.
   Theorem 8.1 is the manuscript's classical quadratic baseline with a
   prescribed number of minimal secants through every point.

9. **Schillewaert, *Solution to Bishnoi's conjecture on minimal `t`-fold
   blocking sets of maximal size*.** **Full text.** Both pages of arXiv
   `1705.03775v1`; the Main Theorem and its four-case arithmetic proof. Cache
   key `arXiv:1705.03775`; SHA-256
   `196f70d63ff3a8af0d7c61f6586c4f436fa555d37447fe82476bcc1e0b41ac2f`.
   It supplies the equality classification for the classical quadratic.

10. **Ramani, *Blocking Amalgamations, Maximal Arcs, and Generalized
    Crowns*.** **Full text.** All 17 pages of arXiv `2608.16035v1`. Cache key
    `arXiv:2608.16035`; SHA-256
    `bb2fc5ce5f4d1627a2b9608cf94b7064bb1ce595315f14a9395b0c1bdffbc4a8`.
    It gives a first-incidence slack identity for uniform intersecting linear
    hypergraphs and a design-theoretic equality analysis. It does not state
    the paired internal/external second-moment condition or the modular
    completeness argument used here.

11. **Ball--Fancsali, *Multiple blocking sets in finite projective spaces and
    improvements to the Griesmer bound for linear codes*.** **Full text.**
    All Sections 1--9 of the author-hosted prepublication manuscript dated
    27 February 2009. Cache key `10.1007/s10623-009-9298-7`; SHA-256
    `a452ff04053a8082d50953acf53f9cf64495b0c870a0cb6a3753283e86fdbba2`.
    Used for the higher-dimensional blocking-set and code dictionary.

12. **Kohnert, *`(l,s)`-Extension of Linear Codes*.** **Full text.** All
    eight pages of arXiv `cs/0701112v1`, especially Theorem 1, Corollary 2,
    and Lemma 5. Cache key `arXiv:cs/0701112`; SHA-256
    `8135a111fd72f29a478733b23fc884563f472293ad4724c5ef080b7b6093aace`.
    Used for the incidence criterion for projective code extension.

13. **Calderbank--Kantor, *The Geometry of Two-Weight Codes*.** **Full
    text.** All Sections 1--13 of the published article, especially Theorems
    3.1--3.2, Corollary 5.5, and Sections 8 and 12. Cache key
    `10.1112/blms/18.2.97`; SHA-256
    `986eeff4e7b4d259876242ee3659a627c28057abe5a087dcdd9e9bdb7181b05d`.
    Used for the exact two-character set/projective two-weight code
    correspondence and characteristic-power divisibility.

14. **Szőnyi--Weiner, *Stability of `k mod p` multisets and small weight
    codewords of the code generated by the lines of `PG(2,q)`*.** **Full
    text.** All Sections 1--4 of arXiv `1901.09649v1`, especially Theorems
    1.1--1.2 and 4.2--4.3. Cache key `arXiv:1901.09649`; SHA-256
    `4161216751349d453fc8e8fbf40df6132de24f8e83581e85eeeb33ec936c046f`.
    The manuscript imports Theorem 1.2.  Its use records (q=p^e>27),
    (e>1), the relevant exceptional-line threshold, and the exact repair
    support size `ceil(delta/(q+1))`; in the characteristic-three sequence,
    `delta=O(q)` and (e>2) eventually.

15. **Szőnyi--Weiner, *On the stability of sets of even type*.** **Full
    text.** All sections of the published article, especially Theorem 1.1 and
    the spectrum discussion. Cache key `10.1016/j.aim.2014.09.007`; SHA-256
    `84a1c7a75e344fa9fa9479daa10de11e3f0509c79aac99f41d516ca6a9c7a9e9`.
    The characteristic-two proof imports Theorem 1.1, including its threshold
    `(floor(sqrt(q))+1)(q+1-floor(sqrt(q)))` and exact repair size
    `ceil(delta/(q+1))`.

16. **Csajbók--Weiner, *Generalizing Korchmáros--Mazzocca Arcs*.** **Full
    text.** All Sections 1--7 of the author manuscript, especially Definition
    2.1, Theorems 2.6 and 6.9--6.10, and Section 6. Cache key
    `10.1007/s00493-020-4419-z`; SHA-256
    `f087fb4b39df1a08a86f268f1ed5bee88085c5f17b74f0c6e404b7e20464c1ab`.
    Used to delimit the relation with generalized KM-arcs and their modular
    stability arguments.

17. **Csajbók, *On bisecants of Rédei type blocking sets and
    applications*.** **Full text.** All Sections 1--6 of arXiv
    `1504.06748v2`, especially Theorem 5.1, Corollary 5.3, and Lemma 6.9
    through Theorem 6.11. Cache key `arXiv:1504.06748v2`; SHA-256
    `aa276cb2184cfa2dd279a362de55b5d9e48a9ca1541c5523fd07db94e5d099b5`.
    It establishes the existing pattern of repairing odd secants and then
    applying local secant geometry.

18. **Adriaensen--Szőnyi--Weiner, *Multisets with few special directions and
    small weight codewords in Desarguesian planes*.** **Full text.** All
    Sections 1--7 of arXiv `2411.19201v3`, especially Theorems 1.7--1.9,
    Corollary 3.8, Result 1.14, and Section 1.3. Cache key
    `arXiv:2411.19201`; SHA-256
    `0fc810af52d3d70424f72c82878b69d55fa4abb285c344934dfac65587c86c19`.
    Used for the current modular-polynomial and small-weight-codeword context.

19. **Lund--Saraf, *Incidence Bounds for Block Designs*.** **Full text.**
    All sections and the appendix of arXiv `1407.7513v2`, especially Theorem 1
    and the expander-mixing calculation. Cache key `arXiv:1407.7513v2`;
    SHA-256
    `9a9e657663d1b310d9272c9e8e0dcae12a966ac44c8524f1e9b0929cb614efc9`.
    Used for the real incidence baseline and its attribution to Haemers.

20. **Murphy--Petridis, *A Point-Line Incidence Identity in Finite Fields,
    and Applications*.** **Full text.** All sections of arXiv `1601.03981`,
    especially Lemma 1, the higher-dimensional section, and the block-design
    variance lemma. Cache key `arXiv:1601.03981`; SHA-256
    `0e40611ca753f297025e8d6f8997d2a4f002f45d8ec3c15c3b2ca68cbd466c14`.
    Used for the classical second-moment/variance formulation.

21. **Beker--Mitchell--Piper, *Tactical decompositions of designs*.** **Full
    text.** All eleven sections of the 30-page survey, read from a forced-OCR
    extraction of the Göttingen digitization, especially Sections 2--5 and
    Theorem 4.4. Load-bearing passages were checked against the page images.
    Cache key `10.1007/BF02189612`; source-PDF SHA-256
    `70fbeb318aa1281da9b14e93c8875d9963f754c671106d9e33050aa97f84d6ea`.
    Used to make exact quotient arithmetic for tactical partitions classical.

22. **Li--Pott, *Intersection distribution, non-hitting index and Kakeya
    sets in affine planes*.** **Partial.** arXiv `2003.06678v2`; abstract,
    Section 2 definitions and Proposition 2.4, the extremal-bound discussion,
    and the related-work/open-problem section. Cache key
    `arXiv:2003.06678v2`; source-bundle SHA-256
    `78ed05e1df8be325518cd75e8213f29221bf04008249b0cab93e3b774ee085e8`.
    Its line-intersection distribution is adjacent terminology but is not the
    selected-block degree sequence used in the manuscript.

### Published-metadata refresh, 24 August 2026

Official publisher records were checked to replace preprint-only or incomplete
bibliography fields.  The records consulted were Springer Nature for
Alabdullah--Hirschfeld, Ball--Fancsali, Csajbók--Weiner, and
Bartoli--Timpanella; Elsevier for Bastioni--Micheli,
Korchmáros--Nagy--Szőnyi, and both Szőnyi--Weiner papers; the Electronic
Journal of Combinatorics for Bishnoi--Mattheus--Schillewaert; and SIAM for
Lund--Saraf.  The author publication record for Murphy--Petridis supplied the
Moscow Journal volume and pages.  This pass changed bibliographic metadata
only; it made no negative literature inference and did not promote any partial
full-text read.

## Recorded searches

### Claim-specific locator searches

The following exact strings were issued on 24 August 2026:

```text
"2q/3+1" complete arc PG(2,q)
"q^2/3" "complete (k,n)-arc"
"t_n(2,q)" "2q/3"
"q/3-fold blocking set" minimal projective plane
"minimal multiple blocking sets" integer bound secants
"complete (k,n)-arc" "lower bound" secants
"t_n(2,q)" lower bound
"maximal secants" "minimal t-fold blocking"
```

They recovered the Alabdullah--Hirschfeld,
Bishnoi--Mattheus--Schillewaert, Korchmáros--Nagy--Szőnyi, and Schillewaert
papers discussed above. No returned title or abstract stated the manuscript's
characteristic-three bound. This was a locator pass, not an exhaustive
bibliographic negative.

OpenAlex was queried with `per-page=10` and exact `search` values

```text
block design integer degree sequence incidence bound
finite projective plane secant distribution integer programming blocking set
symmetric design tactical decomposition integer feasibility
```

Titles were screened for an exact integral degree-sequence,
secant-distribution, or tactical-decomposition obstruction for a selected
block family. The second query promoted Li--Pott; the other title hits did not
meet that discriminator.

The zbMATH Open API was queried with `page_size=20` and exact `search_string`
values

```text
"tactical decompositions" design
"incidence bounds" "block designs"
"secant distribution" projective plane
"degree sequence" "symmetric design"
```

The first returned 20 records and promoted Beker--Mitchell--Piper; the second
returned Lund--Saraf; the third returned a unital paper outside the selected
family discriminator; the fourth returned an explicit no-results response.
This is targeted zbMATH coverage, not an exhaustive MSC screen.

### Recent-weeks screen through 24 August 2026

The arXiv `math.CO` Atom API was queried with

```text
search_query=cat:math.CO AND submittedDate:[202607010000 TO 202608242359]
start=0
max_results=2000
sortBy=submittedDate
sortOrder=descending
```

It returned 1,792 records. Titles were mechanically screened for the literal
strings `arc`, `blocking`, `projective`, `secant`, `finite geometr`, and
`design`. All 30 title hits then received a title-and-abstract relevance
screen. The discriminator was a finite-projective arc, blocking, or secant
result, or an exact selected-design incidence obstruction capable of implying
one of the manuscript's four claim families. The current arXiv page
`https://arxiv.org/list/math.CO/recent?skip=0&show=2000` was screened
separately; it contained 267 entries when accessed and used the same fields
and discriminator.

Ramani (`2608.16035v1`, submitted 17 August 2026) was promoted to a full-text
read. Van de Voorde--Zullo (`2608.19550v1`, submitted 20 August 2026) was
promoted to the targeted partial read recorded above. The remaining 28 hits
concerned other design constructions, Euclidean or spherical incidence
problems, graph/digraph uses of “arc,” or different finite-projective
questions. This is an exact eight-week `math.CO` title-and-abstract screen,
not an all-subject arXiv negative.

OpenAlex supplied an independent indexed check with
`from_publication_date:2026-06-15` and exact searches

```text
"complete arc" finite projective plane
"multiple blocking set" projective
"(k,n)-arc" completeness finite field
"minimal t-fold blocking" projective plane
```

The respective result counts were 3, 1, 0, and 0. The four returned titles
were false positives under the same discriminator.

## Citation-graph and database coverage

The forward-citation seed was DOI `10.1007/s10623-018-00592-8`. OpenAlex
resolved it as `W2905644805` and reported 12 citing works with
`filter=cites:W2905644805` and `per-page=20`; all title/year/DOI records were
screened. Crossref reported `is-referenced-by-count = 12`. Semantic Scholar's
graph API returned HTTP 429. Because the exact original request strings for
that three-service pass were not preserved, it is non-closing under the
citation-graph convention and supports no forward-citation negative.

Semantic Scholar remains **not covered** because repeated graph/search API
requests returned HTTP 429. MathSciNet remains **not covered** because
authenticated access was unavailable. Google Scholar automated coverage was
not attempted. zbMATH received the targeted searches above but not an
exhaustive `05B05/51E15` screen. These are access or scope gaps, not empty
results, and they prevent a global priority statement.

## Surface ownership

The claim--proof--novelty ledger owns the bounded positioning language. The
manuscript states mathematical comparisons and credits imported results but
does not assert a historical priority. The README and verification metadata
contain no independent novelty sentence.
