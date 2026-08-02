# C788 — balanced-cut spectrum literature audit

**Date:** 2026-08-02

**Lane:** `golden`

**Scope:** conference block spectra, principal-submatrix singular spectra,
spectral monomorphy, inclusion-matrix descent, and four-cycle moment methods

## Verdict

Ten individually discussed sources were consulted: **four at full-text depth**,
five at partial depth, and one at abstract/metadata depth.  The design-literature
update found a direct predecessor for C788's reopened aligned-four-set design
theorem, as well as classical sources for its Johnson-harmonic interpretation.
It did not change the priority boundary of the original balanced-cut exchange
classification.

The literature boundary is sharp.

- Complementary principal-block spectral relations for symmetric orthogonal
  matrices are classical and are stated explicitly by Haemers--Parsaei Majd.
  The conference identity (RR^{\mathsf T}=qI-A^2) is therefore background,
  not a novelty claim.
- Exact and asymptotic spectral moments of conference-matrix principal
  subensembles are established territory.  Magsino--Mixon--Parshall organize
  them by signed closed walks and cycle products.
- The subset-sum descent used by C788 is an instance of the classical full-rank
  theorem for inclusion matrices.  Jolliffe proves the rank formula, while
  Attas--Boussaïri--Souktani use the same descent pattern to pass spectral
  monomorphy to smaller principal minors.
- Spectral monomorphy is the closest named framework.  Attas--Boussaïri--
  Souktani classify Hermitian matrices whose fixed-size principal blocks have
  equal characteristic polynomials.  Boussaïri--Souktani--Zouagui specialize
  the framework to two-graphs and show that, in the interior range, only
  trivial two-graphs are spectrally monomorphic.
- **Direct pre-emption of the reopened design crown:** Greaves--Suda,
  Example 2.3, proves that the determinant-(-3) four-subsets of every symmetric
  conference matrix of order (4n+2) form a
  (3\text{-}(4n+2,4,n-1)) design.  For a signed four-set in C788's
  normalization, (\det C[K]=3-2w(K)); hence determinant (-3) is exactly
  (w(K)=3).  Their design is therefore precisely C788's aligned-four-set
  design, with (d=2n+1) and (n-1=(d-3)/2), not merely a related construction.
- Gillespie's regular-two-graph parameters give a second classical route.
  C788's aligned blocks are the union of the coherent and incoherent
  four-sets.  In a conference two-graph the complementary parameters agree,
  so every triple lies in ((d-3)/2) blocks of the appropriate type.  Gillespie
  states the constituent regularity and proves the associated four-set
  2-designs; the union-to-3-design step is the audit's short specialization.
- Delsarte's Johnson-scheme characterization of block designs, as restated by
  Cho--Ding--Hyun, makes the centered block indicator orthogonal to degrees
  one through three.  Wilson's inclusion-eigenspace decomposition, restated by
  Ghareghani--Ghorbani--Mohammad-Noori, supplies the scalar of the inclusion
  operator on the remaining degree-four space.  Thus the “pure degree-four
  Johnson harmonic” language and C788's exact variance formula are best
  presented as classical machinery applied to the Greaves--Suda design, not as
  an independent novelty claim.

C788's original theorem asks a strictly weaker question: the principal blocks need only have the
same **singular** spectrum, equivalently the same characteristic polynomial
after squaring.  Opposite eigenvalue signs are forgotten.  None of the sources
consulted states that singular-spectral analogue, the exact exchange-operator
identification, the affine exchange-purity count of determinant-(-3) blocks, or
the (R(3,3)=6) exclusion showing that order six is the unique nontrivial
balanced-cut case.  Greaves--Suda does, however, own the global 3-design
structure of those blocks.

The resulting priority verdict is deliberately qualified:

> We have not located an earlier statement of the balanced-cut singular-
> spectral classification or its inclusion/Ramsey proof.  The result should be
> presented as a singular-spectral analogue of classical spectral monomorphy,
> with the conference block identity, inclusion rank, and closed-walk moment
> method credited as prior tools.  The aligned-block 3-design must be credited
> directly to Greaves--Suda, and its Johnson-harmonic mean/variance package
> treated as a convenient classical corollary.  This audit does not license
> “first” or an unqualified novelty claim.

## Source records

### Haemers--Parsaei Majd, *Spectral symmetry in conference matrices*

- Identifier: arXiv `2004.05829`; published DOI
  `10.1007/s10623-021-00858-8`.
- **Read depth: full text.**  Read arXiv v3, 21 January 2021, all sections.
- Access: shared cache key `arXiv:2004.05829`, PDF and text extraction;
  SHA-256
  `559e1bf8561183ae65c2f6769fb44dd9d280ca8ac9446d68ba7477cae895892d`.
- Load-bearing content: Theorem 1 treats a block partition of a symmetric
  orthogonal matrix and relates the spectra of complementary principal blocks;
  Corollary 1 applies it to symmetric conference matrices.  The paper studies
  symmetric spectra of principal Seidel submatrices, not equality of their
  singular spectra over every balanced half and not cross-block exchange
  operators.

### Magsino--Mixon--Parshall, *Kesten--McKay law for random subensembles of
Paley equiangular tight frames*

- Identifier: arXiv `1905.04360`.
- **Read depth: full text.**  Read arXiv v1, 10 May 2019, all sections.
- Access: shared cache key `arXiv:1905.04360`, PDF and text extraction;
  SHA-256
  `781cf488f66ab8821e3a03cbda8ebbe782df11228fa95a78f5d3b293e979b415`.
- Load-bearing content: Theorem 1 gives the limiting empirical spectrum of
  random principal submatrices of redundancy-two conference ETFs.  Equations
  (3)--(4), Lemma 7, and Section 3 expand moments as signed closed-walk products
  and isolate cycle structure.  The result is asymptotic and random-subset;
  it does not impose exact balance, classify cutwise equality, or identify the
  second moment with one four-vertex pattern count.

### Jolliffe, *A short proof of the rank formula for inclusion matrices using
the representation theory of the symmetric group*

- Identifier: arXiv `2009.05202`.
- **Read depth: full text.**  Read arXiv v1, 11 September 2020, all sections.
- Access: shared cache key `arXiv:2009.05202`, PDF and text extraction;
  SHA-256
  `704ce59ca9808d05bd1405f71f651d05ae3b8b6692f3920d1336519190c05578`.
- Load-bearing content: Theorem 1 gives the rank of the subset-inclusion matrix
  and records Gottlieb's characteristic-zero full-rank theorem in the
  introduction.  At C788's parameters, it proves injectivity from functions on
  four-sets to their sums over balanced (d)-sets.  C788 includes its own
elementary swap induction, so no representation theory is load-bearing for
the proof.

### Greaves--Suda, *Constructions of (t)-designs from weighing matrices and
association schemes*

- Identifier: arXiv `2402.17528`, v2, 13 April 2026.
- **Read depth: partial.**  Read the introduction, Section 2.1 (especially
  Theorem 2.2), Section 2.2 through Examples 2.3--2.4 and Tables 1--4, and
  Section 5's concluding questions.
- Access: shared cache key `arXiv:2402.17528`, PDF and text extraction;
  SHA-256
  `230c4cb862cd51f0d51f20af91c56f2e7453f2e2472114bda6c42b3a5af99e32`.
- Load-bearing content: Example 2.3 states exactly that the determinant-(-3)
  principal four-subsets of a symmetric conference matrix of order (4n+2)
  form a (3\text{-}(4n+2,4,n-1)) design.  The identity
  (\det C[K]=3-2w(K)) identifies their blocks with C788's aligned four-sets.
  This directly pre-empts the reopened design theorem.  The paper does not
  study balanced-half block-count distributions, exchange operators, or the
  Ramsey cutoff.

### Gillespie, *Equiangular lines, incoherent sets and quasi-symmetric designs*

- Identifier: arXiv `1809.05739`, v3, 17 November 2018.
- **Read depth: partial.**  Read Section 2.2 and Section 4.1, including
  Proposition 4.1 and Theorem 4.2.
- Access: shared cache key `arXiv:1809.05739`, PDF and text extraction;
  SHA-256
  `3d8e2103efefaf7c24a75129584acb9c968248b53e307989f62c7cf4e6c1fa75`.
- Load-bearing content: Section 2.2 defines regular two-graph parameters
  ((n,a,b)), records that each coherent triple lies in (b) coherent
  four-sets, and gives the complementary parameters.  Proposition 4.1 proves
  that coherent, mixed, and incoherent four-set classes are 2-designs.  The
  audit infers the C788 3-design by taking the coherent/incoherent union in the
  self-complementary conference case.

### Cho--Ding--Hyun, *A spectral characterisation of (t)-designs and its
applications*

- Identifier: arXiv `1706.00180`, v3, 9 June 2018.
- **Read depth: partial.**  Read the introduction and Appendix A.1--A.3,
  especially Theorem 41's restatement of Delsarte's Johnson-scheme
  characterization.
- Access: shared cache key `arXiv:1706.00180`, PDF and text extraction;
  SHA-256
  `64258db22bf7caaddded14392ea823e2d4a77caffbace6e617349b91b340b60f`.
- Load-bearing content: a (t)-design is characterized by vanishing of its
  first (t) Johnson dual components.  Applied at block size four and (t=3),
  this is the standard association-scheme basis for calling the centered
  aligned-block indicator a pure degree-four harmonic.

### Ghareghani--Ghorbani--Mohammad-Noori, *Intersection matrices revisited*

- Identifier: arXiv `0902.4367`, v4, 13 November 2011; published DOI
  `10.1002/jcd.21308`.
- **Read depth: partial.**  Read the introduction, the inclusion/intersection
  matrix definitions, and Section 8 through Lemma 8 and its Johnson-eigenspace
  decomposition.
- Access: shared cache key `arXiv:0902.4367`, PDF and text extraction;
  SHA-256
  `2842e1c7849367dc2594c99f34521a6ed9f3b62dc9f4bf1c038bc7142107af09`.
- Load-bearing content: Section 8 restates Wilson's orthogonal decomposition
  of subset functions by inclusion degree and gives the inclusion-related
  eigenvalues.  At degree four this yields the
  (\binom{2d-8}{d-4}) squared inclusion singular value used in C788's
  variance calculation.  The paper does not specialize that calculation to
  conference designs or balanced cuts.

### Bahmanian--Suda, *Hadamard hypercubes*

- Identifier: arXiv `2605.16722`, v1, 16 May 2026.
- **Read depth: abstract/metadata only.**  Read the arXiv title, author,
  identifier, version, abstract, and subject metadata returned while screening
  the sole Semantic Scholar forward citation of Greaves--Suda.
- Access: arXiv HTML; no cached bytes because the work was screened out at
  abstract depth.
- Screening result: the paper uses conference matrices and association schemes
  on triples to construct higher-dimensional Hadamard arrays.  Its abstract
  does not concern principal-four-set designs, balanced-half block counts,
  Johnson harmonics, or exchange spectra, so it was not promoted to full-text
  review.

### Attas--Boussaïri--Souktani, *Characterization of (k)-spectrally
monomorphic Hermitian matrices*

- Identifier: arXiv `1907.05817`; later published DOI
  `10.1142/S1793830925500399`.
- **Read depth: full text.**  Read arXiv v2, 27 July 2021, all sections.  The
  later published version was not accessible at full text and is not
  characterized beyond its matching abstract and bibliographic metadata.
- Access: shared cache key `arXiv:1907.05817`, PDF and text extraction;
  SHA-256
  `a51abeb59f39129514f87c4f28ace738c256679bc866ad3aeb7335662993afe0`.
- Load-bearing content: Proposition 2.2 proves downward spectral monomorphy by
  an inclusion-sum lemma; Theorem 3.2 and Corollary 3.5 classify the interior
  Hermitian cases.  Section 4 uses four-by-four principal determinants and the
  same subset-sum mechanism in a conference setting.  These statements require
  equality of characteristic polynomials of the principal matrices themselves;
  they do not cover equality only after (A\mapsto A^2).

### Boussaïri--Souktani--Zouagui, *Characterization of
(k)-spectrally monomorphic two-graphs*

- Identifier: DOI `10.1016/j.laa.2024.04.026`.
- **Read depth: partial.**  Read the publisher HTML abstract, introduction,
  Proposition 4, Theorem 3 statement, and Theorem 5 statement.  The full text
  was paywalled and no author manuscript was located.
- Access: ScienceDirect publisher HTML and Crossref/OpenAlex metadata; no
  cached bytes because no PDF was reachable.
- Load-bearing content: for (n\ge6) and (3\le k\le n-3), the introduction
  states that a (k)-spectrally monomorphic two-graph is trivial; Theorem 5
  treats the distinct (k=n-2) regular case.  This is the closest direct
  predecessor.  It concerns the Seidel characteristic polynomial, whereas
  C788 concerns its even part, or squared spectrum.

## Search and screening record

### Discovery queries

The following web queries were used to identify candidate primary sources;
they were discovery aids, not the sole basis for the negative verdict:

```text
"conference matrix" "principal submatrices" spectrum
"conference matrix" "cross block" singular values
Seidel matrix all principal submatrices cospectral k-subsets
signed complete graph four cycle Ramsey conference matrix
site:arxiv.org "Kesten–McKay law for random subensembles"
site:arxiv.org conference equiangular tight frame random principal submatrix spectral distribution
"balanced" "conference matrix" submatrix spectrum
"all principal submatrices" "same spectrum" Seidel matrix
Gottlieb rank inclusion matrix subsets theorem 1966
rank of inclusion matrix k-subsets t-subsets Gottlieb primary paper PDF
Wilson diagonal form inclusion matrices subsets rank theorem
"inclusion matrix" "full column rank" subsets
spectrally monomorphic matrices all principal submatrices same characteristic polynomial symmetric
k-spectrally monomorphic graphs Seidel matrices principal submatrices
"spectrally monomorphic" Seidel
"principal submatrices" cospectral "conference matrix"
"principal submatrices" "same singular values" symmetric matrix
"singular values" "all principal submatrices" Seidel
"singularly monomorphic" matrix
"same squared spectrum" principal submatrices
two involutions commutator singular values principal angles projections CS decomposition
orthogonal projections commutator singular values principal angles theorem
conference matrix commutator diagonal sign matrix singular values
Seidel matrix diagonal sign commutator spectrum cut
regular two-graph 3-design four subsets conference matrix coherent quadruples
"coherent triple" "coherent quadruples" two-graph
"coherent 4-set" regular two-graph design
conference two-graph coherent 4-sets 3-design
constructions t-designs conference matrices principal minors
"3-(4n + 2, 4, n - 1)"
"principal minors" "symmetric conference matrix" "3-design"
Delsarte harmonic characterization t-design Johnson scheme
inclusion matrix subsets singular values Johnson scheme eigenvalues
block count random subset t-design variance
```

The promotion discriminator was: a result had to discuss at least one of
(i) symmetric conference matrices partitioned into principal/cross blocks,
(ii) equality or distribution of singular spectra of fixed-size submatrices,
(iii) spectral monomorphy of Seidel matrices/two-graphs, or
(iv) inclusion descent for fixed-size principal invariants.  The five source
records from the original pass were promoted; generic interlacing, unrelated uses of “balanced,”
skew-conference tournament results, and numerical singular-value papers were
discarded at title/abstract level.

For the design update, promotion required at least one of (i) a block design
formed from four-by-four principal minors of a symmetric conference matrix,
(ii) coherent/incoherent four-set designs of regular two-graphs, or (iii) the
Johnson eigenspace or inclusion-operator statement needed for the cut-count
variance.  Greaves--Suda, Gillespie, Cho--Ding--Hyun, and
Ghareghani--Ghorbani--Mohammad-Noori were promoted.  Generic design-existence,
experimental-design variance, skew-conference-only constructions, and
unrelated uses of harmonic analysis were discarded at title/abstract level.

### Crossref and OpenAlex screened sets

- Crossref query
  `query.bibliographic=balanced cut conference matrix spectrum singular values`,
  `rows=10`: the top ten title/DOI metadata records were screened; none was
  about mathematical conference matrices.
- Crossref query
  `query.title=conference matrices principal submatrices spectral symmetry`,
  `rows=10`: all ten title/DOI records were screened; Haemers--Parsaei Majd was
  promoted, while the remaining records were general principal-submatrix work.
- Crossref query
  `query.title=spectrally monomorphic two-graphs Hermitian matrices`,
  `rows=10`: all ten title/DOI records were screened; the Attas and Boussaïri
  papers were promoted.
- OpenAlex search
  `"conference matrix" "principal submatrix" spectrum`, `per-page=10`:
  five total records, all five title/DOI records screened; Haemers--Parsaei
  Majd was the only promoted source.
- OpenAlex search
  `"conference matrix" "balanced cut" singular spectrum`, `per-page=10`:
  zero total records.  HTTP success and a valid JSON response with count zero
  distinguished the empty result from an error.

The screen ran over title and DOI metadata because those APIs supplied no
uniform abstracts.  It is a bounded top-result screen, not an exhaustive
subject-class search.

### Forward-citation checks

The two closest seeds were resolved by DOI before querying.

1. Haemers--Parsaei Majd, DOI `10.1007/s10623-021-00858-8`:
   Crossref reported 1 citing work, OpenAlex 0, and Semantic Scholar 4.
   The largest set, all four Semantic Scholar records, was screened over title,
   abstract, year, and external identifiers.  The mechanical discriminator was
   the occurrence of `conference`, `balanced`, `principal submat`,
   `singular value`, or `cut` in title plus abstract.  None passed.  The API
   returned four records and `next=None`, distinguishing exhaustion from an
   error.
2. Boussaïri--Souktani--Zouagui, DOI
   `10.1016/j.laa.2024.04.026`: Crossref reported 1 citing work, OpenAlex 1,
   and Semantic Scholar 0.  The sole OpenAlex record was the later published
   version of Attas--Boussaïri--Souktani, whose arXiv v2 was read in full.
   Semantic Scholar returned a valid zero count.
3. Greaves--Suda, pinned arXiv `2402.17528` and DataCite DOI
   `10.48550/arXiv.2402.17528`: OpenAlex reported zero citing works;
   Semantic Scholar reported one, *Hadamard hypercubes*; and Crossref returned
   HTTP 404 for the pinned DOI rather than a valid zero-count record.  The sole
   Semantic Scholar record was screened over title, abstract, year, and arXiv
   identifier and is recorded above at abstract/metadata depth.  OpenAlex's
   `cited_by_count=0` in a valid work response distinguished exhaustion from an
   error.  The exact endpoints were
   `api.openalex.org/works/https://doi.org/10.48550/arXiv.2402.17528`,
   `api.semanticscholar.org/graph/v1/paper/ARXIV:2402.17528` with title,
   citation-count, citation-title/year/external-ID fields, and
   `api.crossref.org/works/10.48550/arXiv.2402.17528`.

The disagreement in citation counts is retained rather than collapsed.  These
checks close only the indexed forward sets of the three seeds on 2026-08-02; they
do not replace a subject search.

### Database coverage and access gaps

- **zbMATH Open: covered at web-search level.**  Exact title/domain queries
  surfaced the Haemers--Parsaei Majd record (`Zbl 1496.05014`).  No exact
  balanced-cut singular-spectrum result surfaced.
- **MathSciNet: NOT COVERED.**  Institutional authentication was unavailable.
- **Google Scholar: NOT COVERED.**  Automated access was not used.
- **Published Boussaïri--Souktani--Zouagui full text: NOT REACHABLE.**  The
  publisher page exposed only partial HTML and the author-copy searches found
  no downloadable manuscript.
- **Published Attas--Boussaïri--Souktani full text: NOT REACHABLE.**  The arXiv
  v2 was read fully; the later journal version was checked only at abstract and
  metadata depth.
- **Subject-expert check: NOT COVERED.**

Because MathSciNet, Google Scholar, two published full texts, and a subject-
expert check remain open, any future manuscript sentence must retain “we have
not located” or “to our knowledge.”

Those gaps still qualify the surviving singular-spectral and exchange claims,
but they do not weaken the design pre-emption: Greaves--Suda's accessible v2
states the exact determinant-four-set design theorem.

## Recommended attribution boundary

A paper-facing version should cite Haemers--Parsaei Majd for complementary
conference-block spectra, Jolliffe or the original inclusion-rank theorem for
the subset-sum injectivity, Magsino--Mixon--Parshall for conference-ETF spectral
moments, and Attas--Boussaïri--Souktani plus Boussaïri--Souktani--Zouagui for
spectral monomorphy.  It should cite Greaves--Suda directly for the
determinant-(-3) 3-design, Gillespie for the regular-two-graph four-set
framework, and Delsarte/Wilson or the audited modern restatements for the
Johnson-harmonic inclusion calculation.  The exact mean/variance formulas may
be presented as convenient corollaries, not novelty claims.  The surviving
C788 statement is the balanced singular-spectral analogue, with the qualified
novelty boundary attached only to the combination of exchange identification,
the affine exchange-purity reading of the known determinant design, and the
Ramsey cutoff.
