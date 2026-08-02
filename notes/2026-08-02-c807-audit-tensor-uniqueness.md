# C807 literature audit, tensor-uniqueness half: attribution for the axis-recovery lemma

**Date:** 2026-08-02
**Lane:** `ame-lu`
**Task:** C807 (tensor-decomposition-uniqueness and multipartite-entanglement-classification
side; the stabilizer-code side is audited separately).
**Conventions:** `notes/literature-audit-conventions.md`.
**Status:** COMPLETE for the scope below, with named gaps in the coverage statement.

## Opening summary

**Full-text count, stated first as the conventions require: none of the sources named in this
report were read at `full text`.** Seven were read at `partial` (S1 Kolda-Bader, S6 Harshman 1970,
S8 Landsberg, S9 ten Berge-Sidiropoulos, S10 Lovitz-Petrov, S15 Chang-Jing, S16
Chang-Jing-Zhang), one at `secondary only` (S2, Kruskal 1977 itself, which could not be obtained),
and every remaining named source at `abstract/metadata only`. Within the `partial` sources the passages that carry the verdicts were
read completely, including proofs where a proof is load-bearing; the marker is `partial` because
the surrounding papers were not.

The headline results, per claim:

- **The axis-recovery lemma is not ours.** It is Jennrich's uniqueness theorem, published in
  Harshman's 1970 UCLA working paper, whose statement — permutation matrix times diagonal matrices,
  i.e. monomial — is our conclusion and whose hypothesis — every factor matrix of full column rank —
  is our hypothesis. Cite it. Our proof is a different proof from Jennrich's, but I could not
  establish that our proof route is new either, so claim nothing about the proof.
- **The sharpness claim needs one correction.** The `r >= 3` floor is the Kruskal /
  Sidiropoulos-Bro boundary as the C804 note says, and the two-party failure under repeated
  singular values is textbook. But the surviving `r = 2, N = 2` case of Theorem P is *outside*
  Kruskal's condition, which fails at `r = 2` for every `N`; it survives on unitarity plus the
  pinned identity term. "Exactly the Kruskal boundary" is therefore too strong as written.
- **The escape route has a name and a literature.** Repeated or linearly dependent columns are the
  PARALIND model class, with partial-uniqueness results by Guo, Miron, Brie and Stegeman, and the
  current best tool for going below the k-rank threshold is Lovitz and Petrov's rank-based
  generalization of Kruskal's theorem. Nothing located treats repeats organised as cosets of a
  subgroup.
- **The collision risk is real but partial.** Chang and Jing (2022) already apply CP-decomposition
  uniqueness with Kruskal's condition to the Pauli-basis coefficient tensor of a multi-qubit state
  to characterise local-unitary equivalence. The method is theirs. The conclusion we draw — that
  the local factors must permute the projective Weyl axes, hence be Clifford — does not appear in
  their work and is vacuous in their qubit setting, and no located work draws it. Cite them and
  scope the novelty sentence to the conclusion.
- **Adjacent literature to acknowledge, not to fear.** Gour, Kraus and Wallach's generic
  trivial-stabilizer theorem is the measure-theoretic counterpart of our finiteness corollary;
  Linden, Popescu and Wootters is the closest "rigidity from marginals" result and determines the
  state rather than its symmetries. Neither pre-empts Theorem P.

## The claims audited

Verbatim from `notes/2026-08-02-c804-recognition-group-criterion.md` and
`papers/ame_lu/sections/03-lu-rigidity.tex`.

**Lemma `diagonal-axes` (manuscript, Lemma "Diagonal-tensor axes"), as written:**

> Let `r >= 3`, let `E_1,...,E_r` be `N`-dimensional complex inner product spaces, and
> choose orthonormal bases `{e_ij : 1 <= j <= N}`. If
> `T = sum_{j=1}^N lambda_j e_{1j} tensor ... tensor e_{rj}`, `lambda_j != 0`,
> then the coordinate axes in every `E_i` are intrinsic to `T`. Consequently, a product of
> invertible linear maps carrying one tensor of the form (3.1) to another is monomial in the
> displayed bases.

Manuscript proof: contract factor 1 against a dual vector `x`, flatten `E_2` against
`E_3 tensor ... tensor E_r`, observe the flattening has rank `#{j : x_j != 0}`, so rank-one
contractions locate the dual coordinate axes; product equivalence preserves that projective
locus.

Claims:

1. **C807-A (attribution of the axis-recovery lemma).** Correct earliest/sharpest citation;
   whether the contract-and-flatten proof is known; what Kruskal's condition gives beyond it.
2. **C807-B (sharpness boundary).** `r >= 3` with `N >= 2`, failure at `r = 2` for `N >= 3`
   with equal coefficient moduli, is exactly the Kruskal boundary.
3. **C807-C (escape route).** Published uniqueness results when some factor matrices have
   repeated columns; what they give when repeats are cosets of a subgroup.
4. **C807-D (collision risk).** Has anyone applied tensor-decomposition uniqueness to derive
   that local unitaries preserving a multipartite state normalize a Weyl/Pauli operator basis?
5. **C807-E (adjacent).** SLOCC / local-unitary invariant literature and "rigidity from
   marginals".

## Sources, with read depth

### S1. Kolda and Bader, *Tensor Decompositions and Applications*, SIAM Review 51 (2009) 455-500

- Pinned identifier: DOI `10.1137/07070111X` (Crossref record consulted; container `SIAM Review`,
  vol 51, pages 455-500, published-print 2009-08-06, authors Kolda and Bader, Crossref
  `is-referenced-by-count` 8300 as of 2026-08-02).
- **Read depth: `partial`.** Author-hosted PDF `https://www.kolda.net/publication/TensorReview.pdf`,
  46 pages, cached as key `10.1137/07070111X`,
  sha256 `c32859e65947e43ccbb929c8055585b71157dcccb679affa38b925333572bada`. Sections relied on:
  §3.2 "Uniqueness" read in full from the `pdftotext` extraction; the reference list consulted for
  bibliographic pins. The rest of the survey was searched but not read.
- Version note: this is the author's copy of the published SIAM Review article; page headers in the
  extraction match the journal pagination (e.g. "468 TAMARA G. KOLDA AND BRETT W. BADER"), so it is
  the published version, not a preprint.

### S2. Kruskal, *Three-way arrays: rank and uniqueness of trilinear decompositions, with application to arithmetic complexity and statistics*, Linear Algebra and its Applications 18 (1977) 95-138

- Pinned identifier: DOI `10.1016/0024-3795(77)90069-6`. Bibliographic detail taken from the
  Crossref record consulted on 2026-08-02: container "Linear Algebra and its Applications",
  volume 18, issue 2, pages 95-138, year 1977, sole author Joseph B. Kruskal.
  Crossref `is-referenced-by-count` 1230; Semantic Scholar `citationCount` 1780
  (paperId `d87b35774d1641bff1f4867e736b108c69fcf9ce`, CorpusId 121354144, MAG 2057503509).
- **Read depth: `secondary only`** at time of writing. Unpaywall reports `is_oa: true` with a single
  BRONZE location, the Elsevier ScienceDirect PDF; Semantic Scholar reports the same single
  `openAccessPdf` URL. Both direct fetches returned HTTP 403 with an HTML bot-protection body, so
  the bytes could not be cached. The standing-in secondary is S1 (Kolda and Bader), read at
  `partial` as above, §3.2, which states the k-rank definition and the condition
  `k_A + k_B + k_C >= 2R + 2`. See the coverage statement.

### S3. Sidiropoulos and Bro, *On the uniqueness of multilinear decomposition of N-way arrays*, Journal of Chemometrics 14 (2000) 229-239

- Pinned identifier: DOI `10.1002/1099-128X(200005/06)14:3<229::AID-CEM587>3.0.CO;2-N`, resolved
  through a Crossref bibliographic query (not a title guess); the returned record gives container
  "Journal of Chemometrics", volume 14, pages 229-239, published-print 2000-05.
- **Read depth: `abstract/metadata only`** — the Crossref record was retrieved; the paper was not
  fetched. Its `r`-factor condition `sum_n k_{A^(n)} >= 2R + (N-1)` is quoted here from S1 §3.2, so
  that specific attribution stands at `secondary only` strength through Kolda and Bader.

### S4. Stegeman and Sidiropoulos, *On Kruskal's uniqueness condition for the Candecomp/Parafac decomposition*, Linear Algebra and its Applications 420 (2007) 540-552

- Pinned identifier: DOI `10.1016/j.laa.2006.08.010` (Crossref record consulted: volume 420,
  pages 540-552, published-print 2007-01, authors Stegeman and Sidiropoulos,
  `is-referenced-by-count` 194).
- **Read depth: `abstract/metadata only`** — Crossref record only; not fetched. Named because it is
  a seed and because S1 §3.2 lists it among the works that reprove and analyse Kruskal's result.
  Nothing below rests on its contents.

### S5. Rains, *Polynomial invariants of quantum codes*, IEEE Transactions on Information Theory 46 (2000) 54-59

- Pinned identifier: DOI `10.1109/18.817508` (Crossref record consulted: volume 46, pages 54-59,
  year 2000, sole author Rains, `is-referenced-by-count` 72).
- **Read depth: `abstract/metadata only`** — Crossref record only. Rains was a named seed for this
  half of C807 but the paper was not read; see the coverage statement. The manuscript's existing
  citation to Rains is untouched and unverified by this audit.

## Search log (verbatim queries)

Recorded in the order run. Crossref and Semantic Scholar were reached through their public REST
APIs with `curl`; an empty result is distinguished from an error by the presence of a
well-formed JSON envelope with `message.total-results: 0` (Crossref) or `total: 0` (Semantic
Scholar), versus a non-JSON body or non-200 status, which is recorded as an error.

1. `https://api.crossref.org/works/10.1016/0024-3795(77)90069-6` — seed pin, 200, one record.
2. `https://api.crossref.org/works/10.1137/07070111X`, `.../10.1016/j.laa.2006.08.010`,
   `.../10.1109/18.817508` — seed pins, all 200, one record each.
3. `https://api.crossref.org/works?query.bibliographic=uniqueness+multilinear+decomposition+N-way+arrays+Sidiropoulos+Bro&rows=3`
   — top hit is the Sidiropoulos-Bro paper; DOI taken from that record.
4. `https://api.unpaywall.org/v2/10.1016/0024-3795(77)90069-6?email=<redacted>` — `is_oa: true`,
   one BRONZE publisher location.
5. `https://api.semanticscholar.org/graph/v1/paper/DOI:10.1016/0024-3795(77)90069-6?fields=title,year,venue,citationCount,openAccessPdf,externalIds`
   — 200, citationCount 1780.
6. WebSearch: `Kruskal 1977 "Three-way arrays: rank and uniqueness of trilinear decompositions" pdf`
   — no reachable copy of the original; used only to confirm no obvious open mirror.

### S6. Harshman, *Foundations of the PARAFAC procedure*, UCLA Working Papers in Phonetics 16 (1970) 1-84 — containing **Jennrich's Basic Uniqueness Theorem**

- No DOI. Cited by Kolda and Bader as their reference [90] with the URL
  `http://publish.uwo.ca/~harshman/wpppfac0.pdf`; the live copy is at
  `https://www.psychology.uwo.ca/faculty/harshman/wpppfac0.pdf`.
- **Read depth: `partial`.** Author-hosted scanned-and-reset reproduction, 84 pages, cached as key
  `harshman-1970-ucla-wppp-16`,
  sha256 `1230f83e855fdc5b7294df7bc170aab4b23604b53f134b46bd5474f6a61052fc`. Sections relied on:
  the acknowledgements (which credit "Robert Jennrich for the proof of uniqueness"), and
  Section V "A uniqueness theorem for PP factor analysis", pp. 61-63 of the reproduction, read in
  full including the proof. The rest was searched, not read.
- Version note: the file's own first page states "This manuscript was originally published in 1970
  and is reproduced here to make it more accessible to interested scholars", giving the original
  reference as UCLA Working Papers in Phonetics 16, 1-84, University Microfilms No. 10,085. This is
  a re-typeset reproduction, not a scan of the 1970 original; load-bearing quotations below are
  from the reproduction and are **not** verified against a 1970 physical copy.

### S7. Harshman, *Determination and proof of minimum uniqueness conditions for PARAFAC1*, UCLA Working Papers in Phonetics 22 (1972) 111-117

- No DOI; Kolda and Bader reference [91].
- **Read depth: `abstract/metadata only`.** Fetched from
  `https://www.psychology.uwo.ca/faculty/harshman/wpppfac1.pdf`, cached as key
  `harshman-1972-ucla-wppp-22`,
  sha256 `a94de3ff48d05279176f14725eda77b91ff3fe527d98f8891f6367569af2b1e6`, 7 pages. Named here
  because Kolda and Bader identify it as the strengthening of the 1970 result; its content was not
  read for this audit.

### S8. Landsberg, *Kruskal's theorem* (short note, geometric proof)

- No DOI; author-hosted note at `https://people.tamu.edu/~jml/kruskal09.pdf`, NSF grant
  DMS-0805782 acknowledged, 4 pages.
- **Read depth: `partial`.** Cached as key `landsberg-kruskal-theorem-note`,
  sha256 `bcd0ddd660c5a3ae1dbe6410b062817c7c7a918d1b0725909c7a09873efc8e98`. Read: the introductory
  page in full (statement of essential uniqueness, the two-factor obstruction, the definition of
  Kruskal rank via general linear position, and Proposition 1 on concision). The remainder of the
  proof was skimmed only.
- Version note: undated author note; the filename suggests 2009. No published version was located
  or read, so no claim is made about a journal version.

### S9. ten Berge and Sidiropoulos, *On uniqueness in Candecomp/Parafac*, Psychometrika 67 (2002) 399-409

- Pinned identifier: DOI `10.1007/BF02294992`, resolved through a Crossref bibliographic query;
  record gives Psychometrika, volume 67, pages 399-409, published-print 2002-09.
- **Read depth: `partial`.** Copy hosted at
  `https://three-mode.leidenuniv.nl/pdf/t/tenberge2002a_pmet.pdf`, 11 pages, cached as key
  `10.1007/BF02294992`,
  sha256 `89a4ea0fd5acac90534285eabf3e132150d8d3467db396d959926b1e52d9feb0`. Read: the abstract and
  introduction, and the section headed "Necessity of Kruskal's condition for R = 3". The OCR of
  this scan is poor in places (for example "have famed" for "have failed", "k a = ke = 2" for
  k-rank subscripts); no formula from it is quoted verbatim below as load-bearing.
- Version note: this is a scan of the published Psychometrika article.

### S10. Lovitz and Petrov, *A generalization of Kruskal's theorem on tensor decomposition*, Forum of Mathematics Sigma 11 (2023) e27

- Pinned identifiers: arXiv `2103.15633`; DOI `10.1017/fms.2023.20`; journal reference
  "Forum of Mathematics, Sigma, Volume 11, 2023, e27" — all three taken from the arXiv API record
  for `2103.15633` (`arxiv:doi` and `arxiv:journal_ref` fields).
- **Read depth: `partial`.** The published open-access version was fetched from Cambridge Core
  (`https://www.cambridge.org/core/services/aop-cambridge-core/content/view/S2050509423000208`),
  40 pages, cached as key `10.1017/fms.2023.20`,
  sha256 `77dc0b0370db488d49e6d18cfa2073b2bea5899a3bee9642580653f7d169e7b8`.
  Read: the abstract (via the arXiv API record), and §6.1.2 including Corollary 20,
  Corollary 21 and the closing remarks on quantum-information applications, read in full;
  the opening of §6.2 on non-rank decompositions. The main proof machinery (splitting theorem,
  §§2-5) was not read.
- The arXiv v4 PDF endpoint returned an HTML interstitial; the Cambridge Core copy is the one read.

### S11-S14. Pinned but not yet read

These are named for the escape-route and sharpest-condition questions. Bibliographic detail is
from the Crossref records returned by the queries logged below.

- **Domanov and De Lathauwer**, *On the uniqueness of the canonical polyadic decomposition of
  third-order tensors*, Part I: DOI `10.1137/120877234`, SIAM J. Matrix Anal. Appl. 34 (2013)
  855-875; Part II: DOI `10.1137/120877258`, same journal and volume, 876-903.
  **Read depth: `abstract/metadata only`** (Crossref record).
- **Bro, Harshman, Sidiropoulos and Lundy**, *Modeling multi-way data with linearly dependent
  loadings*, DOI `10.1002/cem.1206`, Journal of Chemometrics 23 (2009) 324-340.
  **Read depth: `abstract/metadata only`** (Crossref record).
- **Guo, Miron, Brie and Stegeman**, *Uni-mode and partial uniqueness conditions for
  Candecomp/Parafac of three-way arrays with linearly dependent loadings*, DOI
  `10.1137/110825765`, SIAM J. Matrix Anal. Appl. 33 (2012) 111-129.
  **Read depth: `abstract/metadata only`** (Crossref record).

### S15. Chang and Jing, *Local unitary equivalence of generic multi-qubits based on the CP decomposition*, International Journal of Theoretical Physics (2022)

- Pinned identifiers: arXiv `2205.06422` (v1, 13 May 2022, quant-ph); DOI `10.1007/s10773-022-05106-w`;
  venue "International Journal of Theoretical Physics", publication year 2022, from the OpenAlex
  record.
- **Read depth: `partial`.** arXiv v1 PDF fetched from `https://arxiv.org/pdf/2205.06422`, cached
  as key `arXiv:2205.06422`,
  sha256 `9992cbc626ebef380bd5b393aa3289eaa45b601c2cdf1a0a5da07bde7f2cbce9`. Read in
  full: the abstract, the introduction, the CP-uniqueness recapitulation (essential uniqueness,
  permutation and scaling indeterminacy, definitions of rank and k-rank, Kruskal's condition
  `k_A + k_B + k_C >= 2R + 2` as their equation (10)), and the opening of §III where the 3-qubit
  state is expanded in the Pauli basis and Lemma 1 (`U sigma_i U^dagger = sum_j O_{ji} sigma_j`
  with `O in SO(3)`) and Lemma 2 are stated. Their later invariant constructions were not read.
- Version note: preprint version v1 read; the published IJTP version was not read, so no claim is
  made about differences.

### S16. Chang, Jing and Zhang, *Criteria for SLOCC and LU equivalence of generic multi-qudit states*, International Journal of Theoretical Physics (2022)

- Pinned identifiers: arXiv `2212.12870` (v1, 25 Dec 2022, quant-ph); DOI
  `10.1007/s10773-022-05267-8`; venue from the OpenAlex record.
- **Read depth: `partial`.** arXiv v1 PDF fetched from `https://arxiv.org/pdf/2212.12870`, cached
  as key `arXiv:2212.12870`,
  sha256 `3a7ff5ed1f4a0f6cd4f3522d5ebf3619d64322b3d969bc24e3cf870228e2886a`. Read:
  abstract and introduction; the bibliography and a keyword sweep of the body for
  `Kruskal|monomial|Pauli|stabilizer|Weyl|Heisenberg|k-rank`. Their theorem statements were not
  read line by line.

### S17. Gour, Kraus and Wallach, *Almost all multipartite qubit quantum states have trivial stabilizer*, Journal of Mathematical Physics 58, 092204 (2017)

- Pinned identifiers: arXiv `1609.01327`; DOI `10.1063/1.5003015`; the arXiv `journal_ref` field
  gives "Journal of Mathematical Physics 58, 092204 (2017)".
- **Read depth: `abstract/metadata only`** (arXiv API abstract, plus the OpenAlex record).

### S18. Kraus, *Local unitary equivalence and entanglement of multipartite pure states*, Physical Review A 82, 032121 (2010)

- Pinned identifiers: arXiv `1005.5295`; DOI `10.1103/PhysRevA.82.032121`; arXiv `journal_ref`
  "Phys. Rev. A 82, 032121 (2010)". The companion referred to in its own abstract is
  B. Kraus, Phys. Rev. Lett. 104, 020504 (2010) — that reference is **quoted from the abstract of
  S18** and was not independently verified.
- **Read depth: `abstract/metadata only`** (arXiv API abstract).

### S19. Linden, Popescu and Wootters, *Almost every pure state of three qubits is completely determined by its two-particle reduced density matrices*, Physical Review Letters 89, 207901 (2002)

- Pinned identifier: DOI `10.1103/PhysRevLett.89.207901`; OpenAlex record gives Physical Review
  Letters, volume 89, first page 207901, year 2002.
- **Read depth: `abstract/metadata only`** (OpenAlex record; the OpenAlex entry reported no open
  access location and no full text was fetched).

### S20. Leurgans, Ross and Abel, *A decomposition for three-way arrays*, SIAM J. Matrix Anal. Appl. 14 (1993) 1064-1083

- Pinned identifier: DOI `10.1137/0614071`, from a Crossref bibliographic query; volume 14,
  pages 1064-1083, published-print 1993-10.
- **Read depth: `abstract/metadata only`** (Crossref record). Named because it is the standard
  citation for the simultaneous-diagonalization route to Jennrich-type uniqueness; nothing below
  rests on its contents.

## Verdicts

### C807-A — attribution of the axis-recovery lemma: **PRE-EMPTED. The lemma is Jennrich's uniqueness theorem (1970). Cite it; do not present it as ours.**

The manuscript's Lemma "Diagonal-tensor axes" is the case `r = 3` of the following, quoted
verbatim from S6 (Harshman 1970, Section V, "Jennrich's Basic Uniqueness Theorem"), read at
`partial` depth including the proof:

> **Theorem:** If `sum_l O_il P_jl T_kl = sum_l O'_il P'_jl T'_kl` and if the matrices `O`, `P`, `T`
> each have rank `L <= I, J, K`, then `O' = O R D_1`, `P' = P R D_2`, `T' = T R D_3` where `R` is a
> permutation matrix and `D_1, D_2, D_3` are diagonal matrices with `D_1 D_2 D_3 = I`.

"Permutation matrix times diagonal matrices" is exactly "monomial in the displayed bases". Our
hypotheses (orthonormal bases, so each factor matrix is the identity and has full column rank `N`;
nonzero `lambda_j`) are the special case `O = P = T = I_N`, and our conclusion is the conclusion of
this theorem. Harshman's own framing of it in the same section is that it "requires that the factor
loading matrices of each mode have a rank equal to or greater than the number of factors", and his
acknowledgements credit "Robert Jennrich for the proof of uniqueness".

The correct attribution chain, with S1 (Kolda and Bader, §3.2, `partial`) as the source for the
chain itself: "The earliest uniqueness result is due to Harshman in 1970 [90], which he in turn
credits to Dr. Robert Jennich [sic]. Harshman's result is a special case of the more general results
presented here." So the **earliest** citation is Harshman 1970 / Jennrich; the **sharpest** general
statement covering it is Kruskal's k-rank condition (S2) for three factors and Sidiropoulos-Bro
(S3) for `r` factors.

Recommended citation form for the manuscript, given the above: attribute the lemma to Jennrich's
theorem as published in Harshman 1970, and note that it is the full-column-rank special case of
Kruskal's condition, extended to `r` factors by Sidiropoulos and Bro.

**Is our proof known?** Jennrich's proof (read at full text in S6, pp. 62-63) is *not* our proof.
He writes each new factor column in terms of the old (`O'_l = sum_r a_lr O_r`, similarly for `P`
and `T`), derives `sum_l a_lr b_ls c_lt = delta_rs delta_st` from the linear independence of the
product basis, and concludes that `(a_lr)`, `(b_ls)`, `(c_lt)` each have exactly one nonzero entry
per column, in matching positions. Our proof instead identifies the coordinate axes as the
rank-one locus of the one-factor contraction. **Auditor's inference, flagged as mine:** the
contraction-and-flatten route is the same idea that underlies the standard
simultaneous-diagonalization proof of this theorem (S20, Leurgans-Ross-Abel, read at
`abstract/metadata only`) and the geometric treatment in S8 (Landsberg, `partial`), but I did not
locate a source presenting exactly the rank-one-contraction-locus argument, and I did not read S20
or the body of S8. This is a gap, not a negative: **do not claim the proof is new**, and do not
claim it is standard either; cite the statement to Jennrich/Harshman and present the proof as a
short self-contained argument without a novelty claim.

**What Kruskal's condition gives that ours does not.** Ours needs every factor family to be
linearly independent, i.e. k-rank exactly `N` in every mode. Kruskal needs only
`k_1 + k_2 + k_3 >= 2N + 2` (S1 §3.2; S15 eq. (10)), and Sidiropoulos-Bro
`sum_{n=1}^{r} k_n >= 2N + (r-1)` (S1 §3.2). So Kruskal admits factors that are not linearly
independent, provided the deficit is paid elsewhere — that is precisely the escape route in
C807-C below, and it is the only thing Kruskal buys here. In the regime our lemma actually uses
(all k-ranks `= N`), Kruskal's condition reduces to `N >= 2` and adds nothing.

### C807-B — the sharpness boundary: **partially confirmed, with one correction that matters.**

Confirmed:

- **The `r >= 3, N >= 2` side is right, and it is the Kruskal/Sidiropoulos-Bro boundary.** With all
  k-ranks `= N`, `sum_n k_n >= 2N + (r-1)` reads `rN >= 2N + r - 1`, i.e. `N(r-2) >= r-1`. For
  `r = 3` this is `N >= 2`; for every `r >= 3` it is `N >= 2`. Source for the condition: S1 §3.2
  and S15 eq. (10) (both `partial`).
- **The two-party failure with repeated singular values is standard.** S1 §3.2 states it directly:
  a rank decomposition of a matrix `X = A B^T` may be replaced by `A W`, `B W^{-T}` for any
  invertible `W`, and "the SVD of a matrix is unique (assuming all the singular values are
  distinct) only because of the addition of orthogonality constraints". S8 states the same in the
  sharper form: "For the tensor product of two vector spaces, an expression as a sum of `r`
  elements is never unique unless `r = 1`." So both the general two-factor failure and the
  repeated-singular-value refinement are textbook, and neither should be presented as ours.

**Correction (auditor's inference, flagged as mine).** The claim in
`2026-08-02-c804-recognition-group-criterion.md` that our two boundaries are "exactly" Kruskal's is
not accurate, and the mismatch is in our favour rather than against us. The Kruskal /
Sidiropoulos-Bro inequality `rN >= 2N + r - 1` fails at `r = 2` for **every** `N >= 2`, including
`N = 2`. Our Theorem P nonetheless holds at `r = 2, N = 2`. The reason is that Theorem P is not a
bare tensor-uniqueness statement: it fixes one index at the identity (`f_i(0) = 0`) and restricts
the equivalence to *unitary* conjugation. That extra structure is what pins the `N = 2` case, and
it lies outside what Kruskal's condition can see.

The same distinction resolves the apparent tension with S8's "never unique unless `r = 1`":

- In the **general-linear** setting, which is what the manuscript's Lemma "Diagonal-tensor axes"
  actually asserts ("a product of invertible linear maps"), `r = 2` fails for all `N >= 2` — the
  literature boundary is exact and the manuscript's `r >= 3` is not improvable.
- In the **unitary** setting of Theorem P, the `r = 2` case survives for `N = 2` unconditionally,
  and for `N >= 3` it degrades to the repeated-singular-value question. The stabilizer case has all
  `|lambda_v|` equal, hence maximal degeneracy, hence failure — which is what the sharpness section
  of the C804 note argues, and that argument is correct.

Recommended wording change for any manuscript adoption: say that `r >= 3` is the tensor-uniqueness
boundary for equivalences by invertible maps, and that the surviving `r = 2, N = 2` case comes from
unitarity plus the pinned identity term, not from tensor uniqueness. Do not write "exactly the
Kruskal boundary" without that qualification.

One further published fact worth carrying: ten Berge and Sidiropoulos (S9, `partial`) prove that
Kruskal's condition is necessary as well as sufficient for `R = 2` and `R = 3`, but **not**
necessary for `R > 3`. So for `N > 3` the failure of Kruskal's inequality does not by itself prove
non-uniqueness; a separate argument is needed. Our `r = 2` non-uniqueness argument is separate
(explicit rotation freedom in the degenerate SVD), so this does not damage it, but the manuscript
must not infer sharpness *from* the failure of Kruskal's inequality alone.

### C807-C — the escape route (factors with repeated columns): **there is a substantial published literature; it is named "PARALIND" and the relevant uniqueness results are partial-uniqueness results.**

Located, all currently at `abstract/metadata only`:

- **Bro, Harshman, Sidiropoulos and Lundy**, *Modeling multi-way data with linearly dependent
  loadings*, DOI `10.1002/cem.1206`, J. Chemometrics 23 (2009) 324-340. This is the model class
  (PARALIND) for exactly the situation where a factor matrix has linearly dependent, in particular
  repeated, columns.
- **Guo, Miron, Brie and Stegeman**, *Uni-mode and partial uniqueness conditions for
  Candecomp/Parafac of three-way arrays with linearly dependent loadings*, DOI `10.1137/110825765`,
  SIAM J. Matrix Anal. Appl. 33 (2012) 111-129. Title-level match to the question as posed: what
  survives, mode by mode, when loadings are linearly dependent.
- **Domanov and De Lathauwer**, Parts I and II, DOIs `10.1137/120877234` and `10.1137/120877258`,
  SIAM J. Matrix Anal. Appl. 34 (2013) 855-875 and 876-903, and the later relaxed conditions
  DOI `10.1016/j.laa.2016.10.019`, Linear Algebra Appl. 513 (2017) 342-375. These are the current
  sharpest general uniqueness conditions and go beyond Kruskal.
- **Lovitz and Petrov** (S10, `partial`), DOI `10.1017/fms.2023.20`, arXiv `2103.15633`, Forum of
  Mathematics Sigma 11 (2023) e27. Their abstract states the point directly: "the k-rank condition
  of Kruskal's theorem is weakened to the standard notion of rank", their technique is new rather
  than a repackaging of Kruskal's permutation lemma, and they "can certify uniqueness below this
  threshold". This is the strongest currently available tool for the escape route.

**What this gives our coset case — auditor's assessment, flagged as mine.** None of these papers
treats repeats organised as cosets of a subgroup, which is our stabilizer situation. The two
structural facts that matter are visible without reading them: a factor matrix whose distinct
columns each repeat `|K|` times has k-rank 1, and within each repeated block the decomposition
acquires a genuine `GL` freedom — which is what the PARALIND literature exists to model. So the
expectation to hold, and this is a prediction not a finding, is that the escape route yields
**partial** uniqueness: recoverable axes at the parties where the projection is injective, and a
block-wise indeterminacy at the parties where it is not. That is precisely enough for the
recognition group at the good party, which is all Corollary G needs. Whether the compensating
inequality can be met for a non-minimal stabilizer support remains untested, exactly as the C804
mystery ledger says; the new information is that the right tool to test it with is Lovitz-Petrov
rather than Kruskal, because the k-rank of a coset-repeated factor is 1 and Kruskal's inequality
is hopeless there while a rank-based condition is not.

Recommendation: this is a real, named, live research direction with a tool built for it. If the
lane pursues it, the first read should be Lovitz-Petrov at full text, then Guo-Miron-Brie-Stegeman.

### C807-D — has anyone joined tensor uniqueness to local-unitary rigidity of a discrete operator basis? **No predecessor located for the conclusion. But the method has been published, and the closest prior art must be cited.**

**Closest prior art: Chang and Jing (S15), and Chang, Jing and Zhang (S16).** S15 expands an
`n`-qubit mixed state in the Pauli basis, forms the coefficient tensor, notes that a local unitary
acts on that tensor through the adjoint `SO(3)` action on the Pauli operators (their Lemma 1), and
then applies CP essential uniqueness with Kruskal's condition to obtain necessary-and-sufficient
criteria and invariants for local-unitary equivalence of generic states. That is the same
machine as our Theorem P: discrete operator basis, coefficient tensor, tensor uniqueness, local
unitaries constrained. It is published, it is 2022, and any manuscript adoption of Theorem P should
cite it.

**What they do not do, and where our statement is still unpre-empted (auditor's reading of the
sources, flagged as mine).** For qubits the normalization conclusion is vacuous: by their Lemma 1,
*every* `SU(2)` element carries the span of the Pauli operators to itself, so there is nothing to
prove about basis preservation, and their entire use of CP uniqueness is to build invariants
separating LU classes, not to force a local factor into the Clifford group. Our conclusion — that
the local factor must permute the *projective axes* of the Weyl operators, i.e. is monomial and
hence Clifford — is a different statement, and it is nontrivial precisely because at local
dimension `q > 2` the adjoint action of a general unitary does not preserve the Weyl axes. S16, the
qudit companion, works with coefficient tensors in the computational basis; a keyword sweep of its
text for `Weyl`, `Heisenberg`, `Pauli`, `stabilizer`, `monomial` and `k-rank` returned nothing in
the body, and Kruskal appears only in its bibliography.

**Forward-citation evidence for the negative.** See the screened-set records below. The short form:
of Kruskal's 1645-1780 citing works, the quantum-flavoured subset is about tensor rank, SLOCC
classification, entanglement catalysis and unextendible product bases; the only two members that
touch local-unitary equivalence are S15 and S16; and nothing in the set is about stabilizer states
or Clifford groups.

**Verdict:** the *conclusion* (local unitaries preserving a multipartite state must normalize a
Weyl/Heisenberg-Weyl basis, derived from tensor-decomposition uniqueness) — no predecessor located.
The *method* (operator-basis coefficient tensor plus CP/Kruskal uniqueness to constrain local
unitaries) — pre-empted by Chang and Jing 2022, and must be cited as such. Any "to our knowledge"
sentence must survive that citation, and must be scoped to the conclusion, not the method. Note
also that MathSciNet and zbMATH reviews of S15/S16 were not consulted (see coverage), and the
`abs:`-only reach of the arXiv API query is a real limitation on the negative.

### C807-E — SLOCC / local-unitary invariants and rigidity from marginals: **an adjacent literature exists; nothing located pre-empts Theorem P, and one result should be cited alongside our finiteness corollary.**

- **Gour, Kraus and Wallach** (S17, `abstract/metadata only`), DOI `10.1063/1.5003015`, JMP 58,
  092204 (2017): for 5 or more qubits, outside a measure-zero set the stabilizer group under
  invertible local operations is trivial, and almost all such states are LOCC-isolated. This is the
  generic counterpart of our finiteness corollary: they get triviality generically by measure, we
  get finiteness on an explicitly characterised class (full recognition groups) by structure. The
  C804 note's finiteness paragraph should cite it, and should say plainly that our contribution
  there is the *class*, not the finiteness.
- **Kraus** (S18, `abstract/metadata only`), DOI `10.1103/PhysRevA.82.032121`, PRA 82, 032121
  (2010), and its companion PRL 104, 020504 (2010) named in that abstract: necessary and sufficient
  conditions for LU equivalence of `n`-qubit pure states, with an explicit classification up to five
  qubits. This is the mainstream LU-invariant line; it is qubit-specific and does not address
  Clifford-ness or Weyl bases.
- **Linden, Popescu and Wootters** (S19, `abstract/metadata only`), DOI
  `10.1103/PhysRevLett.89.207901`, PRL 89, 207901 (2002): almost every pure three-qubit state is
  determined by its two-party marginals. This is the closest "rigidity from marginals" result. It
  determines the *state* from marginals; it does not constrain the *local symmetries*, which is
  what Theorem P does. Auditor's inference, flagged as mine: these are different statements and
  the second does not follow from the first, but a related-work paragraph should mention the line
  so a referee does not think it was missed.

No result was located in which reduced density operators force the form of a state's local
symmetry group in the sense of Theorem P.

## Screened sets

### Set 1 — works citing Kruskal 1977, screened for a quantum-information application

- **Counts, recorded separately per the tri-service requirement:**
  - **OpenAlex:** work `W2057503509` (resolved by DOI, not by title), `cited_by_count` **1645**.
  - **Crossref:** `is-referenced-by-count` **1230** on the DOI record. Crossref exposes no
    citing-works enumeration endpoint, so this is a count only and no Crossref set was screened.
  - **Semantic Scholar:** paperId `d87b35774d1641bff1f4867e736b108c69fcf9ce`, `citationCount`
    **1780**; the `/citations` endpoint enumerated **1780** records, matching the reported count.
- **Disagreement is itself a finding:** 1230 (Crossref) < 1645 (OpenAlex) < 1780 (Semantic
  Scholar), a spread of 550 works. The largest set (Semantic Scholar) was the one screened
  exhaustively.
- **Fields screened over:** title only, for the Semantic Scholar enumeration (fields requested:
  `title,year,externalIds`). OpenAlex was screened over its own `search` index, which covers title
  and abstract.
- **Verbatim discriminator, Semantic Scholar set:** Python regular expression
  `quantum|entangl|stabiliz|clifford|pauli|qubit|qudit|unitar`, case-insensitive, applied to the
  citing paper's title. **13 of 1780 matched.** The 13, in year order: separability criterion from
  the Bloch representation (2007); algebraic geometry tools for entanglement in spin-squeezed
  states (2011); a PARAFAC application to event-related potentials (2013); two versions of
  nonexistence of `n`-qubit unextendible product bases of size `2^n - 5` (2017); unitary PARAFAC for
  DOD/DOA estimation in bistatic MIMO radar (2017); tensor rank of the tensor product of two
  three-qubit W states (2017); rank of a tensor and quantum entanglement (2019); unitary PARAFAC
  for joint DOA and frequency estimation (2019); **Criteria for SLOCC and LU equivalence of generic
  multi-qudit states (2022)**; computing linear sections of varieties (2022); quantum version of
  Euler's problem (2022); **Local unitary equivalence of generic multi-qubits based on the CP
  decomposition (2022)**. Only the two bolded entries concern local-unitary equivalence; they are
  S15 and S16 and were promoted out of the set and read at `partial`.
- **OpenAlex sub-screens, same seed:** `filter=cites:W2057503509&search=quantum` → **71**;
  `&search=entanglement` → **27**; `&search=stabilizer` → **1**; `&search=unitary` → **58**. The
  27-member entanglement set and the 1-member stabilizer set were listed in full and screened over
  title and year. The single "stabilizer" hit is *Polystability in positive characteristic and
  degree lower bounds for invariant rings* (2022), which uses "stabilizer" in the
  geometric-invariant-theory sense and is not about stabilizer codes or states.
- **Empty versus error:** every request returned HTTP 200 with well-formed JSON carrying an
  explicit `meta.count` (OpenAlex) or a `data` array (Semantic Scholar). A zero was therefore read
  as a genuine zero. One earlier Semantic Scholar call returned HTTP 429 and was recorded as an
  error and retried with a contact-bearing User-Agent, not counted as empty.

### Set 2 — works citing Sidiropoulos and Bro 2000, same screen

- **OpenAlex:** `W2150059498`, `cited_by_count` **525**. **Semantic Scholar:** `/citations`
  enumerated **608**. **Crossref:** the DOI record was retrieved for bibliographic detail; no
  separate citing count is recorded here, so this set does **not** meet the tri-service bar and no
  verdict rests on it alone.
- Same verbatim title regular expression: **1 of 608** matched — *Rank of a tensor and quantum
  entanglement* (2019). OpenAlex sub-screens: `search=quantum` → 30, `search=entanglement` → 10,
  `search=stabilizer` → **0**.

### Set 3 — arXiv abstract search, quantum side

- Provenance: arXiv API `export.arxiv.org/api/query`, `sortBy=relevance`, `max_results=30`, fields
  screened: title and abstract (the `abs:` prefix searches the abstract).
- Verbatim queries and set sizes:
  - `abs:Kruskal AND cat:quant-ph` → **14** results, all about the Kruskal-Szekeres black-hole
    coordinates, the Bernstein-Greene-Kruskal modes, the Kruskal-Neishtadt-Henrard theorem, or
    graph algorithms. **No hit on tensor-decomposition uniqueness.**
  - `abs:"tensor decomposition" AND abs:"local unitary"` → **1** result, *Strong entanglement
    distribution of quantum networks* (`2109.12871`), which is not about decomposition uniqueness.
  - `abs:"local unitary" AND abs:"stabilizer" AND abs:"Clifford"` → **17** results, screened over
    title; the set is the LU-versus-LC line (including `quant-ph/0411115`, `quant-ph/0611214`,
    `0707.4000`, `0709.1266`) plus graph-state and surface-code work. **No member mentions tensor
    decomposition or Kruskal in its abstract.** This set belongs to the other C807 agent's half and
    is recorded here only as a negative on the tensor-uniqueness link.
- **Limitation, stated so the negative is not overread:** the arXiv API searches abstracts, not
  full text. A paper that used Kruskal's theorem inside a proof without saying so in the abstract
  would not appear. The forward-citation screens (Sets 1 and 2) are what cover that case, and they
  cover it only to the extent that such a paper cites Kruskal or Sidiropoulos-Bro.

## Additional verbatim queries

7. `https://api.openalex.org/works/doi:10.1016%2F0024-3795%2877%2990069-6` and the corresponding
   Sidiropoulos-Bro DOI lookup — seed resolution by DOI.
8. `https://api.openalex.org/works?filter=cites:W2057503509&search=<term>&per-page=1` for
   `term` in `quantum, entanglement, stabilizer, unitary`; same for `cites:W2150059498`.
9. `https://api.openalex.org/works?filter=cites:<W>&search=<term>&per-page=100&select=id,doi,title,publication_year`
   for the full listings screened above.
10. `https://api.semanticscholar.org/graph/v1/paper/DOI:<doi>/citations?fields=title,year,externalIds&limit=1000&offset=<n>`
    paged to exhaustion for both seeds.
11. arXiv API: `search_query=abs:Kruskal AND cat:quant-ph`,
    `search_query=abs:"tensor decomposition" AND abs:"local unitary"`,
    `search_query=abs:"local unitary" AND abs:"stabilizer" AND abs:"Clifford"`, each
    `max_results=30&sortBy=relevance`.
12. Crossref bibliographic queries (`query.bibliographic`, `rows=2` or `3`) for: ten Berge and
    Sidiropoulos 2002; Domanov and De Lathauwer; PARALIND (Bro, Harshman, Sidiropoulos, Lundy);
    Guo, Miron, Brie and Stegeman; Leurgans, Ross and Abel. Each returned a top hit whose title,
    authors, journal, volume and pages matched the sought work; DOIs were taken from those records.
13. OpenAlex `search=` queries for the two Chang-Jing papers and for the five quantum-side seeds in
    C807-E. Note that two of these returned an unrelated top hit alongside the correct one (for
    example a graphene roadmap and a quantum-dot review); the correct record was selected by title
    match, and the unrelated hits are not used anywhere.
14. WebSearch: `tensor decomposition uniqueness Kruskal local unitary equivalence stabilizer states
    Pauli basis normalizer` — this is what surfaced Lovitz-Petrov and the Chang-Jing line, which
    were then re-resolved by pinned identifier.

## Coverage statement

**Searched and found nothing** (licenses the negatives above):

- No work in the enumerated citing sets of Kruskal 1977 or Sidiropoulos-Bro 2000 derives that local
  unitaries preserving a multipartite state must normalize a Weyl or Pauli operator basis.
- No arXiv abstract in `quant-ph` mentions Kruskal in the tensor-uniqueness sense.
- No located work treats CP uniqueness when repeated columns are organised as cosets of a subgroup.

**Could not access** (licenses nothing; carried forward as open gaps):

- **Kruskal 1977 itself (S2).** Both open-access routes reported by Unpaywall and Semantic Scholar
  point at the same Elsevier ScienceDirect PDF, which returned HTTP 403 with a bot-protection HTML
  body. Everything attributed to Kruskal here comes from S1 and S15 as secondary sources. In
  particular the exact form of his condition, and whether his paper already states the
  full-column-rank case explicitly, are **unverified against the original**.
- **Sidiropoulos and Bro 2000 (S3), Stegeman and Sidiropoulos 2007 (S4), Rains 2000 (S5).** Pinned
  by DOI but not fetched; the `r`-factor condition attributed to S3 is taken from S1 §3.2. Rains
  was a named seed and was **not read at all** — the manuscript's existing citation to it is
  untouched by this audit and remains unverified from my side. It plausibly belongs to the other
  C807 agent's half, but that should be confirmed rather than assumed.
- **The PARALIND and Domanov-De Lathauwer papers (S11-S14).** Metadata only. The C807-C assessment
  is therefore a reasoned expectation about what they give, not a report of what they say.
- **MathSciNet: NOT COVERED.** Requires institutional authentication, not available in this
  session. Every "to our knowledge" claim that a review database would have gated stays qualified.
- **zbMATH Open: NOT COVERED in this pass.** It is freely reachable and was simply not queried
  before the budget ran out. This is a genuine gap, not an access failure, and it is the cheapest
  remaining improvement to the C807-D negative.
- **Google Scholar: NOT COVERED.** Blocks automated access.
- **Published versions of S15 and S16** (International Journal of Theoretical Physics). Only the
  arXiv v1 preprints were read.

## Recommended actions for the lane

1. Cite Jennrich's theorem as published in Harshman 1970 for Lemma "Diagonal-tensor axes", with
   Kruskal 1977 and Sidiropoulos-Bro 2000 for the general k-rank condition. Drop any framing that
   presents the lemma or its boundary as ours.
2. Rewrite the sharpness paragraph of the C804 note so that the `r = 2, N = 2` survival is
   attributed to unitarity plus the pinned identity term, not to Kruskal's inequality, and so that
   `r >= 3` is attributed to the tensor literature.
3. Cite Chang and Jing 2022 as the prior use of CP uniqueness for local-unitary equivalence, and
   scope any novelty sentence to the *conclusion* (Clifford-ness / Weyl-axis normalization at local
   dimension `q > 2`), which no located work reaches.
4. Cite Gour, Kraus and Wallach 2017 next to the finiteness corollary, and state that our
   contribution there is the explicitly characterised class rather than finiteness itself.
5. Before pursuing the k-rank escape route, read Lovitz and Petrov 2023 at full text; their
   rank-based condition, not Kruskal's k-rank condition, is the tool that can survive
   coset-repeated columns.
6. Close the two cheap gaps: query zbMATH Open, and obtain Kruskal 1977 itself through a route that
   is not the Elsevier bot wall.
