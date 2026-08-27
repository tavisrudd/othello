# C975 full literature audit — high-weight GRS cosets under point deletion

**Lane:** `reed-solomon`

**Audit date:** 2026-08-26

**Claim owner:** proposed C975 headline theorem and its immediate coding corollaries

**Governing conventions:** `notes/literature-audit-conventions.md`, binding in full
**Status:** bounded claim-specific audit complete; no manuscript file edited

## Opening summary

**Seven sources were read at full text.** They are Seroussi--Roth, Dür, Kaipa,
Blokhuis--Pellikaan--Szőnyi, Davydov--Marcugini--Pambianco's codimension-four
paper, Xu--Hong--Xu, and Zhang--Wan--Kaipa. Eight further sources were read at
`partial`, and one at `abstract/metadata only`; no verdict below silently upgrades a partial read. The authoritative
version, access, section, cache key, and SHA-256 record for every named source
appears below.

**Verdict: the exact headline theorem is not pre-empted within the recorded
boundary.** I located no earlier result which, for arbitrary redundancy,
classifies every projective syndrome direction of coset weight at least
\(r-1\) for a normal-rational-curve parity-check system after an arbitrary
prescribed finite set of evaluation points is deleted. In particular, I did
not locate the three-family classification of the exact \(r-1\) shell in that
generality, its stated count, or the simultaneous cofinite-support statement
that the omitted curve points form the \(r\) shell.

That verdict is deliberately narrower than several claims the paper must not
make.

1. The syndrome-span/deep-hole/MDS-extension dictionary is prior art, with
   Dür, Seroussi--Roth, Kaipa, and Wu--Ding--Chen as the closest owners.
2. For full projective support and redundancy four, the tangent plus conjugate-
   secant shell and the count \(q(q+1)^2/2\) are prior art in geometric and
   coding form. Blokhuis--Pellikaan--Szőnyi and
   Davydov--Marcugini--Pambianco are direct predecessors; Zhang--Wan--Kaipa
   gives the same families as PRS deep holes.
3. Deleted-support projective RS deep-hole families are prior art. Xu--Hong--Xu
   studies exactly the projective evaluation set with finitely many affine
   points deleted, but gives selected degree/reciprocal families through
   subset-sum conditions, not the complete top two syndrome shells.
4. General one-column MDS extension criteria and recent frameworks constructing
   MDS/NMDS codes from deep holes are prior art. What remains paper-owned is the
   **classification of the extending projective columns for this cofinite GRS
   family**, as a corollary of the shell theorem, not the underlying identity.
5. The one-parameter NMDS weight-distribution recurrence is classical. The
   family-wise minimum-support identities and the resulting aggregate
   enumerators were not located as published formulas, but should be presented
   as derived enumerative consequences, without a priority adjective.

The novelty sentence must therefore be about the **complete arbitrary-
redundancy cofinite shell classification**, not about deep holes, appended
columns, NMDS construction, coset enumerators, or tangent/conjugate-secant
geometry separately.

## Exact claims audited

Let

\[
 A\subseteq \mathbf P^1(\mathbf F_q),\qquad |A|=s,\qquad
 S=\mathbf P^1(\mathbf F_q)\setminus A,
\]

and let \(H_S\) be an \(r\)-row GRS parity-check matrix on \(S\), with
arbitrary nonzero column multipliers. The proposed range is \(r\geq6\),
\(p>r-1\), and

\[
 q\geq 6(r+s)-16+
 \left\lfloor2\sqrt{6(r+s)-18}\right\rfloor,
\]

with a sharper binary variant outside the large-characteristic shell statement.
For a projective syndrome direction \([f]\), write \(d_S(f)\) for the least
number of columns of \(H_S\) spanning it.

The audited theorem asserts:

1. if \(s=0\), the covering radius is \(r-1\), and the directions of weight
   \(r-1\) are exactly the tangent and conjugate-secant interiors;
2. if \(s>0\), the covering radius is \(r\), the directions of weight \(r\)
   are exactly the omitted normal-rational-curve points, and the directions of
   weight \(r-1\) are exactly the tangent interiors, conjugate-secant
   interiors, and interiors of split secants incident with \(A\);
3. the projective-direction counts are

   \[
   N_r=s,
   \qquad
   N_{r-1}=\frac{q(q+1)^2}{2}
      +\frac{(q-1)s(2q+1-s)}2,
   \]

   and the corresponding numbers of nonzero literal cosets are
   \((q-1)N_r\) and \((q-1)N_{r-1}\);
4. for an appended projective column \(f\),

   \[
   d\bigl(\ker[H_S\mid f]\bigr)=d_S(f)+1,
   \]

   so omitted curve points give the MDS extensions, the exact \(r-1\) shell
   gives the NMDS extensions, and all remaining columns have Singleton defect
   at least two;
5. for

   \[
   \mu_S(f)=\#\{T\subseteq S: |T|=r-1,
        f\in\langle\nu_{r-1}(T)\rangle\},
   \]

   the proposed family-wise minimum-support sums are

   \[
   \begin{aligned}
   \sum_{f\in\mathrm{Tan}}\mu_S(f)
     &=(q-r+2)\binom{q+1-s}{r-1},\\
   \sum_{f\in\mathrm{Conj}}\mu_S(f)
     &=\frac{q(q-1)}2\binom{q+1-s}{r-1},\\
   \sum_{f\in\mathrm{Split}_A}\mu_S(f)
     &=\left[\binom s2+s(q-r+2-s)\right]
       \binom{q+1-s}{r-1},
   \end{aligned}
   \]

   followed by the standard NMDS recurrence to obtain family-aggregate and
   family-average weight enumerators.

The audit tests the mathematical conjunction above. It does not test the proof
of the field-size threshold; that is a proof-verification question rather than
a literature question.

## Claim-by-claim verdict

| Claim | Verdict | Closest collision / boundary |
|---|---|---|
| Complete classification of all directions with \(d_S(f)\ge r-1\), for arbitrary \(r\ge6\), cofinite projective support, and the stated large-\(q\) range | **Not located; headline novelty survives** | Fixed-redundancy full-support results and selected deleted-support deep-hole families only |
| Exact \(r-1\) shell: tangents, conjugate secants, and \(A\)-incident split-secant interiors | **Not located in this conjunction** | Tangent + conjugate-secant part is prior art for full support at redundancy four; split-secant contribution after deletion was not located |
| Counts \(N_r=s\) and \(N_{r-1}=q(q+1)^2/2+(q-1)s(2q+1-s)/2\) | **Not located for arbitrary \(r,s\)** | The \(s=0,r=4\) value \(q(q+1)^2/2\) is prior art |
| Literal coset count obtained by multiplying projective directions by \(q-1\) | **Elementary / standard, not novel** | Projective syndrome classes and the \(q-1\) lift are explicit in Zhang--Wan--Kaipa and Davydov--Marcugini--Pambianco |
| General identity \(d(\ker[H\mid f])=d_H(f)+1\) and MDS/deep-hole dictionary | **Prior art / elementary** | Dür; Kaipa; Wu--Ding--Chen |
| Exact MDS/NMDS classification of appended columns for this cofinite family | **Not located as a classification; valid corollary-level novelty** | General extension frameworks are prior art, including a 2026 MDS--NMDS/deep-hole framework |
| Definition and use of NMDS / AMDS weight recurrence | **Prior art** | Meneghetti--Pellegrini--Sala and the earlier literature they synthesize |
| Three family-wise sums of \(\mu_S\) and aggregate NMDS enumerators | **Not located as published formulas** | General MDS-coset and NMDS weight formulas exist; present these sums as new derivations, not as a new recurrence |
| Terminology “coset weight,” “projective syndrome,” “coset leader weight enumerator,” “MDS,” “AMDS,” “NMDS” | **Standard** | Jurrius--Pellikaan; Zhang--Wan--Kaipa; modern MDS-coset papers |

## Closest precedents and the exact noncollision

### 1. MDS extension and covering-radius line

Seroussi--Roth classifies one-coordinate MDS extensions of generalized and
doubly extended Reed--Solomon codes in its stated high-dimension range: apart
from the familiar even-characteristic exception, the extending column is a
missing normal-rational-curve point. Dür identifies covering radius with
completeness of the corresponding normal rational curve for full projective
support. Kaipa makes the deep-hole/MDS-extension correspondence explicit and
uses Seroussi--Roth to classify deep holes in a high-rate range. Wu--Ding--Chen
gives the modern general statement that a second-kind extension of an MDS code
remains MDS exactly when the relevant dual covering radius is maximal and the
extension vector is a deep hole.

These sources pre-empt any claim that the dictionary, the MDS half of the
one-column corollary, or “constructing MDS codes from deep holes” is new. They
do **not** determine the exact next shell for a point-deleted normal rational
curve at arbitrary redundancy.

### 2. Full-support PRS top shell

Zhang--Wan--Kaipa constructs the tangent and conjugate-secant PRS deep-hole
families at general redundancy, conditional on the expected covering radius,
and proves completeness for redundancy four. Its Theorem I.7 gives exactly
\(q(q+1)^2/2\) projective deep-hole classes in that case. The geometric remark
identifies \(q(q+1)\) tangent-interior directions and
\((q+1)q(q-1)/2\) rational points on conjugate secants.

Blokhuis--Pellikaan--Szőnyi independently computes the extended coset-leader
weight enumerator of the twisted-cubic code, i.e. the full-support
codimension-four case. Their \(a_3(q)=q(q+1)^2/2\) is the same top-shell count.
Davydov--Marcugini--Pambianco obtains the corresponding codimension-four GDRS
coset distributions and explicitly notes that each projective point represents
\(q-1\) nonzero syndromes/cosets.

Thus neither “tangent and conjugate-secant deep holes” nor the full-support
formula \(q(q+1)^2/2\) can carry novelty by itself. The new burden is the
uniform exclusion theorem at arbitrary redundancy and its behavior under
point deletion.

### 3. Deleted projective support

Xu--Hong--Xu studies generalized projective Reed--Solomon codes on
\(D=(\mathbf F_q\setminus\{a_1,\ldots,a_ell\})\cup\{\infty\}\), so it is a
direct support-model predecessor. It characterizes two received-word families
using subset-sum and subset-product conditions. It does not classify every
projective syndrome direction of either of the top two shells, and does not
give the tangent/conjugate/split-secants partition or the C975 count.

This paper must be cited in the theorem's deleted-support context. Calling the
support model itself new would be false.

### 4. Recent MDS/NMDS construction work

Li--Lu--Ling--Lam (2026) develops a unified framework that turns deep holes of
MDS or NMDS base codes with maximal covering radius into longer MDS or NMDS
codes, and recovers Wu--Ding--Chen's MDS result as a special case. Its theorem
extends a generator matrix by a new row and coordinate; it is not a complete
classification of the appended projective columns of an MDS parity-check
system by the top two syndrome shells. Zhi--Zhu and Wang--Chen--Yan give
necessary and sufficient MDS/NMDS criteria for specific multi-column or
twisted-GRS constructions. These are code-construction papers, not top-shell
censuses.

The collision is rhetorical but serious: “a framework for constructing MDS
and NMDS codes from deep holes” is already a 2026 title-level claim. C975
should instead say that its shell theorem **determines all one-column MDS and
NMDS extensions in the stated GRS family**.

### 5. Enumerators

Jurrius--Pellikaan establishes standard coset-leader and list-weight-enumerator
language. Davydov--Marcugini--Pambianco gives general formulas for MDS coset
weight distributions and notes the uniformity of maximum-weight cosets under
the usual maximal-radius hypothesis. Meneghetti--Pellegrini--Sala gives a
modern form of the classical one-parameter recurrence for AMDS/NMDS weight
distributions. Davydov's 2026 preprint studies weight-two cosets of full-support
GDRS codes of arbitrary minimum distance; this is a different shell (fixed
coset weight two) and does not imply the proposed family-wise top-shell sums.

No searched source gives the three displayed sums over the tangent,
conjugate-secant, and deletion-incident split-secant families. Because these
are elementary double counts once the shell theorem is known, the safe and
strong presentation is “we derive” rather than “for the first time.”

## Forward-citation negative searches

Each seed was pinned by DOI, resolved independently in OpenAlex, Crossref, and
Semantic Scholar, and title-checked before use. Counts are service-native and
were recorded on 2026-08-26; they are not added together. Semantic Scholar
had the largest set for all three seeds, so those sets were screened in full.

The screen used the returned **title, year, external identifiers, publication
type, and abstract when present**. The mechanical discriminator was the
following case-insensitive regular expression, applied to title plus abstract:

```text
Reed.?Solomon|GRS|projective|coset|deep hole|covering radius|MDS|NMDS|
weight distribution|punctur|delet|evaluation set|normal rational|twisted cubic|
extension|secant|tangent
```

Every matching record was read at title-and-abstract level. In addition, every
record whose title mentioned a twisted cubic or a code was manually promoted,
even if the expression missed it. Duplicate preprint/published records were
identified by title and external identifiers rather than counted as new
mathematical results.

| Seed | Pinned identifiers | OpenAlex count | Crossref count | Semantic Scholar count / set screened | Outcome |
|---|---|---:|---:|---:|---|
| Blokhuis--Pellikaan--Szőnyi, twisted-cubic coset enumerator | DOI `10.1007/s10623-022-01060-0`; OpenAlex `W3148163570`; S2 `18da046b2cacc19312cdb85421ffc59dbdc11b8f` | 13 | 10 | **21 / 21** | One full-support GDRS coset-distribution continuation and one 2026 weight-two continuation; the remainder is twisted-cubic incidence/orbit geometry. No arbitrary-redundancy deletion-shell theorem. |
| Kaipa, deep holes and MDS extensions | DOI `10.1109/TIT.2017.2706677`; OpenAlex `W2563545890`; S2 `72dd1f6925426b6983d72235c8bb44001a771fa2` | 20 | 16 | **29 / 29** | Promoted PRS redundancy-four, deleted-support, MDS-extension, MDS/NMDS-framework, twisted-code, distance-distribution, and GDRS-coset papers. None gives the audited conjunction. |
| X. Xu--Y. Xu published successor to the deleted-support preprint | DOI `10.3934/math.2019.2.176`; OpenAlex `W2916027880`; S2 `82efe68d53bf7ea255873753a5e3e5b7275e7044` | 5 | 3 | **6 / 6** | Full set screened. Hits concern twisted-cubic planes, general MDS coset distributions, ordinary RS words, Cauchy codes, and 2026 full-support weight-two GDRS cosets. No cofinite top-two-shell classification. |

The service disagreement matters: a Crossref-only screen would have seen less
than half of the Semantic Scholar set for the first seed and only a little over
half for the second. No negative conclusion here rests on Crossref alone.

### Cached citation-set artifacts

| Artifact | Provenance and fields | SHA-256 |
|---|---|---|
| `c975-openalex-bps-citing.json` | OpenAlex `filter=cites:W3148163570`, `per-page=100`; `id,doi,title,publication_year,type,authorships,abstract_inverted_index` | `429009bbecd267376ffb9ba4f7be503f61df0a72dd7c3dc91d1e42b551f59570` |
| `c975-s2-bps-citing.json` | Semantic Scholar citations endpoint for S2 seed above, `limit=50`; `title,year,externalIds,publicationTypes,abstract` | `287224f37b24f953ce61657906235f8c9abe67eb3f3aba14101c1d0935018598` |
| `c975-openalex-kaipa-citing.json` | OpenAlex `filter=cites:W2563545890`, same selected fields | `fa95f716bc9eb1c83b906653752268b9899748d39baaaf0b23e880f94e8a3194` |
| `c975-s2-kaipa-citing.json` | Semantic Scholar citations endpoint for S2 seed above, `limit=100`; same fields | `cfaed9acdcb6bd9768ab82078eeec0d85c855888187e23a193b817e18b67cc3a` |
| `c975-openalex-xu-citing.json` | OpenAlex `filter=cites:W2916027880`, same selected fields | `5ae2650ee0cda54204ed4aa68e803f0865ace8d7c70f3f1956585d7a393f8d92` |
| `c975-s2-xu-citing.json` | Semantic Scholar citations endpoint for S2 seed above, `limit=100`; same fields | `610355eaff1c4b81442837cdb919446dd66d17a900f2f9bc59e8217fda6bd956` |

All artifacts are in `/tmp/persistent/tavis/lit-search/`. A first Semantic
Scholar request for one seed returned HTTP 429; the request was retried, and
the successful 21-record response, not the error body, is the artifact and
screened set reported above.

## Targeted database searches

### zbMATH Open

The exact API endpoint was `/v1/document/_search`, with the shown
`search_string` and `results_per_page=20`. Both successful response files are
cached. Read depth for all hits in this subsection is `title/metadata only`,
unless the source is separately listed in the source table at a greater depth.

| Query | Count | Screen result |
|---|---:|---|
| `any:"deep holes" any:"projective Reed-Solomon"` | 3 | Zhang--Wan--Kaipa; a primitive PRS paper; Xu's published successor. No omitted item contains the proposed arbitrary-\(r\) deletion shell. |
| `any:"near MDS" any:"Reed-Solomon"` | 13 | Twisted-GRS, self-dual, subcode, Roth--Lempel, and generic NMDS-construction papers; none is a high-weight coset classification for cofinite NRC support. |
| `any:"coset weight" any:"doubly extended Reed-Solomon"` | empty (HTTP 404, “No results found”) | Genuine empty result, not an access failure. |

Artifacts:

- `c975-zb-deep-prs.json`, SHA-256
  `0e1a46db1936bd9f8d43abd777fb4ff3a158bd8c25860845cf1f1051f016c44f`;
- `c975-zb-nmds-rs.json`, SHA-256
  `952bc665a43f597c0f8052b872f49558efdab4a5c2233e7ce64d8f5415811748`.

### OpenAlex targeted phrase screens

The endpoint was `/works?search=<query>&per-page=5` with fields
`id,doi,title,publication_year,type,abstract_inverted_index`. Read depth was
`title/abstract/metadata only` unless upgraded in the source table.

| Verbatim search string | OpenAlex total | Relevant head |
|---|---:|---|
| `"next-to-deep holes" Reed-Solomon` | 0 | — |
| `"coset weight" "projective Reed-Solomon"` | 2 | Davydov's 2026 weight-two GDRS paper; an unrelated binary-code construction |
| `"one-column" NMDS Reed-Solomon` | 6 | Zhi--Zhu's specific non-GRS/NMDS construction; no shell census |
| `"punctured" "normal rational curve" coset` | 2 | A moduli paper and a finite-geometries book; neither relevant |
| `"deleted" "projective Reed-Solomon" deep holes` | 2 | False-positive Gabidulin and invariant-design results |
| `"cofinite" "Reed-Solomon" coset` | 0 | — |

Crossref's broad bibliographic keyword endpoint returned very large bag-of-
words totals and was used only for candidate discovery, not as a negative
instrument. Its DOI records were used for the independently reported citation
counts above.

### arXiv and general web discovery

Title and phrase searches were run for projective RS deep holes, generalized
projective/deleted evaluation sets, GDRS coset weight distributions,
one-column MDS/NMDS extensions, and 2024--2026 MDS/NMDS-from-deep-hole work.
They surfaced the recent 2026 framework and weight-two papers included below.
No source was accepted from a search snippet alone when a full-text copy was
available.

## Source records

The cache is `/tmp/persistent/tavis/lit-search/`. “Full text” means the whole
cached extraction was read, not merely term-searched. Published and preprint
versions are distinguished explicitly.

| Source | Exact version read | Read depth | Access / persistent cache record |
|---|---|---|---|
| G. Seroussi and R. M. Roth, *On MDS extensions of generalized Reed--Solomon codes*, IEEE TIT (1986), DOI `10.1109/TIT.1986.1057188` | Published six-page paper | `full text` — complete paper, especially Theorem 1 and Corollary 1 | Cache key `10.1109/TIT.1986.1057188`; SHA-256 `0b5c152819f91d5e410146ada3527b5b795a55fc6170c14a27e43b8c3e39a5f9`; author-hosted copy; fetched 2026-07-25 |
| A. Dür, *On the covering radius of Reed--Solomon codes*, Discrete Math. (1994), DOI `10.1016/0012-365X(94)90256-9` | Published seven-page paper | `full text` — complete paper, including Theorem 2.4 | Cache key `10.1016/0012-365X(94)90256-9`; SHA-256 `b28e0b84b00255aadf38d6f6b8d2204a76228f5acc0eacb73066cd40401ed9b1`; user-supplied DeepDyve copy; fetched 2026-08-07 |
| K. Kaipa, *Deep holes and MDS extensions of Reed--Solomon codes*, IEEE TIT (2017), DOI `10.1109/TIT.2017.2706677` | arXiv:1612.05447v1, not the published typesetting | `full text` — complete 14-page preprint, including Proposition 1 and Theorem 2 | Cache key `arXiv:1612.05447`; SHA-256 `1fe8de83c0b8cd3938e1a450fd49f376de795d7a317f099a730c63ab968178a4`; fetched 2026-07-18 |
| J. Zhang, D. Wan, and K. Kaipa, *Deep Holes of Projective Reed--Solomon Codes*, IEEE TIT (2020), DOI `10.1109/TIT.2019.2940962` | arXiv:1901.05445v2, 3 Sep 2019 | `full text` — complete 12-page preprint, including Theorems I.5--I.7, geometric remarks, and Section III | Cache key `arXiv:1901.05445`; SHA-256 `5c2b9e2508c7200428c441b7a41da1596b1c9b0851f5632e2297cdbed41caf24`; fetched 2026-07-19 |
| A. Blokhuis, R. Pellikaan, and T. Szőnyi, *The extended coset leader weight enumerator of a twisted cubic code*, DCC (2022), DOI `10.1007/s10623-022-01060-0` | Published open-access 25-page version | `full text` — complete paper, especially Theorem 3.2 and the twisted-cubic orbit count | Cache key `10.1007/s10623-022-01060-0`; SHA-256 `df47fa06d2beb4b626dd7b7d96ceaaba3332bc3bc0cf03bd40571e4ea3cc840f`; fetched 2026-08-16 |
| A. Davydov, S. Marcugini, and F. Pambianco, *On cosets weight distributions of the doubly-extended Reed--Solomon codes of codimension 4* | arXiv:2007.08798v2, 22 Feb 2021 | `full text` — complete 20-page preprint, including the coset-class tables and the projective-direction/\(q-1\) convention | Cache key `arXiv:2007.08798`; SHA-256 `c07254e4aeffada926e0738427d210a93b6c34118aa27d8fe7d474716a4060bd`; fetched 2026-08-26 |
| Y. Xu, C. Hong, and G. Xu, *On Deep Holes of Generalized Projective Reed--Solomon Codes* | arXiv:1705.07823v1, 22 May 2017; the published successor has DOI `10.3934/math.2019.2.176` | `full text` — complete 16-page preprint, including both deleted-support families and subset-sum/product criteria | Cache key `arXiv:1705.07823`; SHA-256 `165e577d9ab0a34d8590c303b069e47f59d430430199442adc65ba2678098729`; fetched 2026-08-07 |
| Y. Wu, C. Ding, and T. Chen, *When Does the Extended Code of an MDS Code Remain MDS?*, IEEE TIT 71(1) (2025), DOI `10.1109/TIT.2024.3494813` | Published author-hosted PDF | `partial` — abstract, introduction, definitions of second-kind extension, Theorem 1 and its proof context, GRS corollaries, conclusion | Cache key `10.1109/TIT.2024.3494813`; SHA-256 `1af77849e56681a99ee4fcb049cc5356fa9e16cf148b1eba107a9fcbe9336187`; 10 pages; fetched 2026-08-26 |
| Y. Li, Z. Lu, S. Ling, and K.-Y. Lam, *A framework for constructing non-GRS MDS--NMDS codes from deep holes and its application* | arXiv:2605.12133v1, 12 May 2026 | `partial` — abstract and Sections I, III-A--B (Lemma 6, Theorems 7 and 10, Corollary 8), algorithm/conclusion vicinity | Cache key `arXiv:2605.12133`; SHA-256 `8f854dcb3ad549b8bfdcaac6f585edc9d9516c7ea9674e970f54020657c0fa7d`; 22 pages; fetched 2026-07-18 |
| Y. Zhi and S. Zhu, *New MDS codes of non-GRS type and NMDS codes* | arXiv:2406.03693v2, 13 Dec 2024 | `partial` — abstract, introduction and contribution statement, theorem index, conclusion | Cache key `arXiv:2406.03693`; SHA-256 `ff6966e7085bfd5209f7d1ce08262d812f35d6ffa60ff53216ca8ad76160d7a2`; 25 pages; fetched 2026-08-26 |
| Y. Wang, Y. Chen, and T. Yan, *MDS and NMDS Codes from the Extended Twisted Generalized Reed--Solomon Codes* | arXiv:2605.23329v1, 22 May 2026 | `partial` — abstract, introduction, construction summary, and section map | Cache key `arXiv:2605.23329`; SHA-256 `9b64b0835a1fc16b0258dda707c9c5b16a4ca35f245cdd8b41d21d7d9218dc15`; 21 pages; fetched 2026-08-26 |
| A. Davydov, *Weight distributions of cosets of weight 2 of the generalized doubly extended Reed--Solomon codes* | arXiv:2605.10594v1, 11 May 2026 | `partial` — abstract, introduction, statement of the weight-two problem, organization and main result summary | Cache key `arXiv:2605.10594`; SHA-256 `7d1263a552922d1d4e72a871db9eabd431a9a35cbcca3ece8affdacd06225e2e`; 32 pages; fetched 2026-08-26 |
| M. Meneghetti, M. Pellegrini, and M. Sala, *A formula on the weight distribution of linear codes with applications to AMDS codes* | arXiv:2003.14063v2, 25 Sep 2021 | `partial` — introduction, Section 4, and Theorem 10 | Cache key `arXiv:2003.14063`; SHA-256 `245fb371b7afb83e629a558e4bec8786b4c67719d0c67299b120b5038e0ee2e5`; 12 pages; fetched 2026-08-26 |
| R. Jurrius and R. Pellikaan, *The coset leader and list weight enumerator*, Contemp. Math. 632 (2015), DOI `10.1090/conm/632/12631` | Corrected version dated 7 Nov 2019 | `partial` — abstract, definitions, Theorem 5.7 vicinity, and MDS examples | Cache key `10.1090/conm/632/12631`; SHA-256 `99a2c5d1625af85d4c5560276b45728acaba347dd13f88d789d49b792f714b95`; 23 pages; fetched 2026-07-16 |
| A. Davydov, S. Marcugini, and F. Pambianco, *On the weight distribution of the cosets of MDS codes* | arXiv:2101.12722v2, 30 Jun 2021; published DOI `10.3934/amc.2021042` | `partial` — abstract, introduction/main-results summary, Theorem 4.2 and Corollary 4.3 | Cache key `arXiv:2101.12722`; SHA-256 `7d025799078793d01db22f845dec8c46e851f63e6f0c9343462545b7d46944e9`; 32 pages; fetched 2026-07-21 |
| Y. Li, S. Zhu, and Z. Sun, *Covering Radii and Deep Holes of Two Classes of Extended Twisted GRS Codes and Their Applications*, IEEE TIT (2025), DOI `10.1109/TIT.2025.3541799` | Published metadata and abstract; no full-text copy obtained | `abstract/metadata only` — publisher/search abstract and bibliographic record | No valid arXiv identifier located; **full text NOT COVERED**. An incorrect cache association was repaired as described below. |

### Cache integrity correction

During the audit, cache metadata had incorrectly assigned the title of the
2025 extended-twisted-GRS paper to `arXiv:2312.04261`. The cached PDF itself is
the unrelated paper *New ternary self-orthogonal codes and related LCD codes
from weakly regular plateaued functions*. The record was corrected to its
actual title, authors, and identifier and was **excluded from the evidence**.
Likewise, the first metadata entered for `arXiv:2406.03693` had wrong authors;
the PDF title page was controlling, and the cache record was corrected to
Yujie Zhi and Shixin Zhu. Neither error affects the verdict.

## Coverage and explicit gaps

**Searched and screened** — this licenses the bounded negative:

- full text of the seven closest classical/fixed-redundancy/deleted-support
  sources listed above;
- partial text of the nine general-extension, NMDS, enumerator, and 2026
  sources listed above;
- the complete 21-, 29-, and 6-record Semantic Scholar citing sets of the
  three pinned seeds, with OpenAlex and Crossref counts independently recorded;
- targeted zbMATH Open, OpenAlex, Crossref candidate-discovery, arXiv, and web
  searches over both geometric and coding vocabularies.

**NOT COVERED** — licenses nothing and forces “to our knowledge”:

- **MathSciNet: NOT COVERED.** Institutional authentication was unavailable.
- **Google Scholar automated full-index search: NOT COVERED.** Automated
  access was unavailable; no negative rests on a claimed Scholar search.
- **Scopus and Web of Science: NOT COVERED.** No authenticated access.
- **IEEE published typesetting for several arXiv-read papers: NOT COVERED.**
  The exact preprint version is recorded and is the object characterized.
- **The full text of the published 2025 extended-twisted-GRS paper with DOI
  `10.1109/TIT.2025.3541799`: NOT COVERED.** Its title, DOI, authors, and
  abstract were checked at metadata/abstract depth through its publisher and
  citation records; the poisoned arXiv cache mapping was not used. This paper
  studies two specific non-GRS ETGRS classes, not a cofinite GRS shell census,
  but it cannot license any finer negative.
- **Article-body search outside the cached full texts: NOT COVERED.** A theorem
  of this form could occur inside a paper whose title and abstract use only
  finite-geometric language. The citation sets and zbMATH vocabulary screen
  reduce but do not eliminate that risk.

Accordingly, the correct epistemic status is “not located in the recorded
search boundary,” never an unqualified “first.”

## Terminology and collision controls

1. **Use “coset weight” or “coset-leader weight.”** Both are standard for the
   minimum Hamming weight in a coset. “High-weight cosets” is defensible because
   the theorem determines all cosets whose coset-leader weight is at least
   \(r-1\).
2. **Use “projective syndrome direction” for the geometric quotient.** State
   once that one direction represents \(q-1\) nonzero syndromes/cosets. Do not
   call a direction a coset.
3. **Use “tangent line,” “secant line,” “conjugate secant,” and “normal rational
   curve.”** These are standard. “Imaginary chord” also appears in the
   codimension-four literature, but “conjugate secant” is clearer and already
   standard in the PRS paper.
4. **Use “point-deleted projective support” in exposition.** “Cofinite support”
   is mathematically intelligible, but should not be advertised as a coined
   code-family name.
5. **Distinguish ordinary GRS from extended/doubly extended GRS.** The proposed
   title “High-weight cosets of generalized and extended Reed--Solomon codes”
   survives the terminology check.
6. **Do not call the aggregate object an “extended coset leader weight
   enumerator.”** That phrase already has a precise owner and meaning in the
   twisted-cubic paper. “Family-aggregate NMDS weight enumerator” accurately
   describes the new sum over appended codes.
7. **Do not headline “MDS--NMDS codes from deep holes.”** That wording collides
   directly with 2024--2026 construction papers. The exact-column
   classification is the consequence worth stating.

## Manuscript-safe novelty wording

### Recommended main sentence

> To our knowledge, no earlier result classifies, for arbitrary redundancy,
> every projective syndrome direction of a generalized or extended
> Reed--Solomon code supported on a projective line with finitely many
> prescribed points deleted that has coset weight at least \(r-1\). In the
> range of Theorem X, these directions are exactly the omitted curve points in
> weight \(r\), and the tangent, conjugate-secant, and deleted-point-incident
> split-secant directions in weight \(r-1\).

### Recommended count sentence

> The classification gives \(s\) projective directions of weight \(r\) and
> \(q(q+1)^2/2+(q-1)s(2q+1-s)/2\) of weight \(r-1\); multiplying by \(q-1\)
> gives the corresponding numbers of nonzero cosets.

### Recommended extension sentence

> As a consequence, the theorem determines all appended projective columns
> that yield MDS or NMDS one-coordinate extensions in this family.

### Recommended enumerator sentence

> Double counting the minimum supports in each geometric family yields the
> three aggregate identities below; the standard NMDS recurrence then gives
> the complete family-aggregate weight enumerators.

### Claims to avoid

- “the first classification of projective Reed--Solomon deep holes”;
- “the first arbitrary-redundancy deep holes” without the cofinite top-shell
  and large-field qualifiers;
- “we discover tangent and conjugate-secant deep holes”;
- “a new correspondence between deep holes and MDS extensions”;
- “a new framework for constructing MDS and NMDS codes from deep holes”;
- “the first exact coset-leader enumerator” — only the top one or two shells
  are classified, not the whole coset-leader enumerator;
- “a new NMDS recurrence”;
- “the full-support count \(q(q+1)^2/2\) is new.”

## Literature obligations for the eventual paper

The introduction or theorem discussion should cite, at minimum:

1. Dür and Seroussi--Roth for covering radius / NRC completeness and MDS
   extensions;
2. Kaipa and Zhang--Wan--Kaipa for projective syndromes and the tangent /
   conjugate-secant PRS families;
3. Blokhuis--Pellikaan--Szőnyi and Davydov--Marcugini--Pambianco for the
   complete codimension-four coset census and count;
4. Xu--Hong--Xu for deleted projective evaluation support;
5. Wu--Ding--Chen and Li--Lu--Ling--Lam for modern extension/deep-hole and
   MDS/NMDS framing;
6. Meneghetti--Pellegrini--Sala for the standard NMDS recurrence;
7. Jurrius--Pellikaan if “coset leader weight enumerator” language is used.

The proof should not bury the distinction with the fixed-redundancy predecessor:
the full-support \(r=4\) theorem should appear as a recovered specialization,
while the novelty paragraph says explicitly that arbitrary \(r\), prescribed
point deletion, the exact \(r-1\) shell, and uniform exclusion off the carrier
are the new conjunction.

## Surfaces and novelty-ledger state

| Surface | Audit action |
|---|---|
| `notes/reed-solomon-tasks/c975-2026-08-26-full-literature-audit.md` | Created; this is the durable audit record |
| `papers/high_weight_grs_cosets/claim-proof-novelty-ledger.md` | **Not edited.** No C975-owned row exists yet, and creating the manuscript claim row belongs to the separate paper-update item. Existing R5--R10 rows were outside this audit's ownership. |
| Beyond4 manuscript files | **Not edited**, as required |
| Paper snapshot / public summary | Not yet applicable; the theorem is not yet integrated |

When the paper-update item creates the owning ledger row, the recommended main
sentence above should be copied there verbatim and treated as the single home
of the novelty claim. The manuscript should quote or faithfully paraphrase that
row rather than independently escalating it.

## Mystery ledger and closeout

| Mystery | Status after audit | Evidence / residual risk |
|---|---|---|
| Could the complete arbitrary-\(r\) shell already be implicit in full-support PRS work? | **Closed negatively within boundary** | Full reads of Kaipa and Zhang--Wan--Kaipa show constructions at arbitrary redundancy but completeness only through redundancy four; fixed-codimension census papers agree. Article bodies outside the cache remain a residual risk. |
| Could deleted-support deep-hole work already contain the split-secant shell? | **Closed negatively within boundary** | Full read of Xu--Hong--Xu plus its complete six-record S2 citing set; it treats selected word families via subset sums/products, not all syndromes. |
| Is the one-column MDS/NMDS statement itself novel? | **Closed: no, not as a general mechanism** | Dür/Kaipa/Wu--Ding--Chen and the 2026 Li--Lu--Ling--Lam framework. Only the exact classification for this family remains. |
| Is the \(s=0\) count new? | **Closed: no at \(r=4\)** | Zhang--Wan--Kaipa, Blokhuis--Pellikaan--Szőnyi, and Davydov--Marcugini--Pambianco all recover \(q(q+1)^2/2\). Uniformity in arbitrary \(r\) is the new content. |
| Are the family-wise \(\mu_S\) sums published? | **Not located** | Enumerator sources and targeted searches found general recurrences and fixed-coset formulas only. Because the identities are short double counts, no priority adjective is warranted. |
| Could “extended coset leader weight enumerator” name the proposed aggregate? | **Closed: no** | The term already names the full twisted-cubic coset-leader census; use “family-aggregate NMDS weight enumerator.” |

### `ej` pass

The strongest alternative formulation tested was to make the appended-column
MDS/NMDS theorem the headline. The 2025 and 2026 extension papers make that a
lower-EV and collision-prone choice: they own the general construction
language, while C975 owns something they do not provide, namely the complete
geometric census of the top syndrome shells. The literature therefore
strengthens the theorem-driven spine: **shell classification first; extensions
and enumerators as consequences**.

### `tt` pass

The verdict was stress-tested in four ways:

1. coding and finite-geometric vocabularies were searched separately;
2. the largest forward-citation set from three independent services was
   screened for each of three pinned seeds;
3. the two most dangerous specializations — full support at redundancy four
   and deleted projective evaluation support — were read at full text rather
   than inferred from abstracts;
4. the newest 2024--2026 MDS/NMDS and GDRS-coset papers were promoted and read
   far enough to compare their exact theorem shape.

The result is stable under those tests. The only defensible residual qualifier
is “to our knowledge,” forced by the explicit NOT COVERED surfaces above.
