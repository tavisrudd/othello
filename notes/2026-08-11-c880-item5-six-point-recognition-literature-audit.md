# C880 item 5: six-point recognition literature audit

Date: 2026-08-11  
Scope: bounded, claim-specific precedence audit for importing one lemma into Paper V; no manuscript edits.

## Opening summary and verdict

**Exact claim audited.** Let \(\sigma(xyz)\in\{\pm1\}\) be the triangle signs of a two-graph on a six-point set, let
\[
  m(xy)=\sum_z\sigma(xyz),
\]
and call a four-set aligned when its four triangle signs are all equal. The claim is
\[
  16\,|\mathcal A|=\sum_{\{x,y\}}m(xy)^2,
\]
and consequently \(\mathcal A=\varnothing\) if and only if a (hence every) Seidel representative \(S\) is a symmetric conference matrix, \(S^2=5I\).

**Verdict.** No predecessor for the exact six-point defect/aligned-four-set identity, or for its stated recognition equivalence in this combinatorial form, was located in the bounded audit. A predecessor **was** located for the spectral equality criterion underlying the last implication: Iranmanesh--Askari Farsangi (2015), Theorem 2.4 at exponent \(\alpha=4\), proves the general fourth-power lower bound for a Seidel matrix with equality exactly for conference graphs. Gillespie (2018), Proposition 4.1, is also adjacent prior art: it counts coherent and incoherent four-sets in a *regular* two-graph from its regular parameters. Neither source states the six-point sum-of-pair-defects identity or its converse from absence of aligned four-sets.

**Read-depth headline.** Five individually discussed sources are named below. **One was read at `full text`; four were read at `partial` depth.** Database result sets are recorded separately as screened sets and are not counted as individually read sources.

**Safe conclusion.** Importing the lemma is not pre-empted by the sources or searches checked, but its novelty should be stated only with “to our knowledge” and the bounded-audit qualifier. The conference equality case should not be presented as wholly new.

## Mathematical comparison boundary

For a symmetric Seidel representative \(S\),
\[
  (S^2)_{xy}=S_{xy}m(xy),\qquad
  \operatorname{tr}(S^4)=150+2\sum_{\{x,y\}}m(xy)^2
\]
at order six. Thus the audited lemma refines the usual fourth spectral moment inequality by identifying its excess over \(150\) with \(32|\mathcal A|\). The 2015 spectral result supplies
\(\operatorname{tr}(S^4)\ge 150\), with equality exactly when \(S^2=5I\); it does **not** identify the excess with aligned four-sets. Gillespie's result supplies regular-case coherent/incoherent four-set design counts; it does **not** treat arbitrary order-six two-graphs or prove the converse recognition statement.

This distinction controls the verdict: there is prior art for both surrounding vocabularies and for the spectral equality endpoint, but no located source for the exact bridge.

## Individually consulted sources

### 1. Bussemaker--Mathon--Seidel, *Tables of two-graphs*

- **Read depth:** `partial`.
- **Access/cache/version:** shared cache key `10.1007/BFb0092256`; SHA-256 `ac9d300a4a0e5f46d4d4b36b66d5f620f616ffad3197ae93fad50b8ff224748a`; 102-page publisher-repository PDF. The PDF identifies itself as the publisher's PDF/version of record and as Eindhoven report 79-WSK-05 (October 1979); the cache metadata attached to the DOI records 1981, so this audit relies on the report's own 1979 date and does not silently conflate the two dates.
- **Sections/pages read:** Chapter 2, pp. 3--8 (definition, switching classes, Seidel spectrum, tables); the order-six discussion on pp. 12--13; Chapter 6, pp. 21--22; Table 9, p. 83.
- **What it establishes:** the usual two-graph/switching/Seidel correspondence; at order six the pentagon-plus-isolated-vertex switching class has full automorphism group \(A_5\); there is one order-six conference two-graph; Table 9 records its spectrum \((5,0,\sqrt5,-\sqrt5)\) in the table's convention and automorphism data.
- **Precedence result:** no pair-defect square identity, aligned/coherent four-set count, fourth-moment identity, or empty-aligned recognition statement appears in the inspected text.

### 2. Goethals--Seidel, *Orthogonal matrices with zero diagonal*

- **Read depth:** `full text`.
- **Access/cache/version:** shared cache key `10.4153/CJM-1967-091-8`; SHA-256 `68c0ef0b8fda6d44325382a047a873d2075ed2ad3cf9d0e6ec27ba7ace60b734`; 10-page Cambridge publisher PDF of the 1967 published article.
- **Sections relied on:** §§1--4, especially the definition/equivalence operations in §2 and the symmetric conference-matrix condition in §3.
- **What it establishes:** symmetric zero-diagonal \(\{\pm1\}\)-off-diagonal matrices satisfying \(C^2=(v-1)I\), their equivalence operations, Paley constructions, and necessary conditions.
- **Precedence result:** it contains neither two-graph pair defects nor aligned/coherent four-set counts, and no fourth-moment excess identity.

### 3. Brouwer--Van Maldeghem, *Strongly Regular Graphs*

- **Read depth:** `partial`.
- **Access/cache/version:** shared cache key `10.1017/9781009057226`; SHA-256 `fa73d72e86bbd8dc3fbfcbca45679cb8f2671d777e91c009eeff0a563fd9289d`; author-hosted full-book PDF at `https://homepages.cwi.nl/~aeb/math/srg/rk3/srgw.pdf`, corresponding to the 2022 Cambridge book. This is not asserted to be byte-identical to the publisher PDF.
- **Sections/pages read:** §1.1.12, “Regular two-graphs,” pp. 8--9, plus the immediately preceding Seidel-matrix history lines needed for context.
- **What it establishes:** the standard two-graph/switching correspondence used in Papers I and III; regularity means constant coherent-triple pair degree, and descendants are strongly regular with the stated parameters.
- **Precedence result:** no aligned-four-set statistic, pair-defect square identity, or order-six recognition criterion occurs in the inspected section.

### 4. Gillespie, *Equiangular lines, incoherent sets and quasi-symmetric designs*

- **Read depth:** `partial`.
- **Access/cache/version:** shared cache key `arXiv:1809.05739`; SHA-256 `3d8e2103efefaf7c24a75129584acb9c968248b53e307989f62c7cf4e6c1fa75`; arXiv v3 dated 17 November 2018.
- **Sections read:** §2.2 and §4.1 through Proposition 4.1 and its proof.
- **What it establishes:** for a regular two-graph with parameters \((n,a,b)\), coherent, mixed, and incoherent four-sets form explicit 2-designs; in particular the coherent-four-set pair multiplicity is \(ab/2\). It also records \(n=3a-2b\).
- **Precedence result:** this is genuine adjacent coherent-four-set prior art, but it assumes regularity and does not state the audited defect identity, its arbitrary order-six scope, or the converse from an empty aligned family.

### 5. Iranmanesh--Askari Farsangi, *Upper and lower bounds for the power of eigenvalues in Seidel matrix*

- **Read depth:** `partial`.
- **Access/cache/version:** published 2015 article, DOI `10.14317/jami.2015.627`. Section 2 (Definitions 2.1--2.3, Theorem 2.4 and proof) and the reference list were read through the KoreaScience indexed HTML/full-text rendering returned by web search. Crossref supplied the version-of-record PDF URL `https://ocean.kisti.re.kr/downfile/crosscheck/kscam/JAKO201536553157741.pdf`, and `https://koreascience.kr/article/JAKO201536553157741.pdf` was also tried; both timed out with zero bytes on 2026-08-11. **No cache key or SHA-256 exists because no PDF bytes were obtained.** The published version is the version characterised here, but only the stated section was read.
- **Section relied on:** §2, especially Theorem 2.4.
- **What it establishes:** for \(\alpha\ge2\), the power sum of absolute Seidel eigenvalues has the Hölder lower bound, with equality exactly for a conference graph. At \(\alpha=4\), this is the general inequality \(\operatorname{tr}(S^4)\ge n(n-1)^2\), equality iff \(S^2=(n-1)I\).
- **Precedence result:** this pre-empts any claim that the fourth-spectral-moment equality characterization itself is new. It does not state the six-point aligned-four-set excess formula.

## Exact local full-text searches

The four cached texts above (items 1--4) were searched case-insensitively for the exact literal set

`pair degree`; `pair-degree`; `coherent 4-set`; `coherent four-set`; `aligned`; `fourth moment`; `fourth power`; `sum of squares`; `m(x`; `16 times`.

Occurrence counts, in the same order, were:

- Bussemaker--Mathon--Seidel: `0,0,0,0,0,0,0,1,0,0`.
- Goethals--Seidel: `0,0,0,0,0,0,0,0,0,0`.
- Brouwer--Van Maldeghem: `0,0,0,0,0,0,4,1,0,0`; the hits were inspected and did not concern the audited identity.
- Gillespie: `0,0,13,0,0,0,0,0,0,0`; the relevant §4.1 hits led to the adjacent result described above.

The literal search supplemented, rather than replaced, the section reading recorded above.

## Bounded web and database search

### Web search batches

The displayed title, URL, and snippet fields of every returned record were screened. The mechanical discriminator was: **promote a record if its title/snippet jointly concerned two-graphs or Seidel matrices and any of pair degree/codegree, coherent or aligned four-sets, a fourth spectral moment/power sum, or conference equality.** Records about generic graph alignment, random-matrix fourth moments, physics “coherence,” or unrelated pair-degree extremal graph theory were rejected on the displayed fields.

1. Batch A, 40 displayed records combined, exact queries:
   - `"pair degree" two-graph aligned 4-set`
   - `two-graph coherent quadruples pair degrees identity`
   - `two-graph fourth moment Seidel matrix pair codegrees`
   - `"aligned" four-sets two-graph Seidel`
   This promoted no external predecessor; the only exact “aligned four-set” hits were current Othello-series material.
2. Batch B, 22 displayed records combined, exact queries:
   - `site:zbmath.org "two-graph" "coherent" pair`
   - `site:arxiv.org two-graph coherent triples pair degree quadruple`
   - `site:doi.org two-graph Seidel matrix fourth power trace`
   - `"coherent 4-set" two-graph`
   This promoted Gillespie and Iranmanesh--Askari Farsangi for individual checking.
3. Batch C, 37 displayed records combined, exact queries:
   - `"tr(S^4)" Seidel conference matrix`
   - `"trace" "S^4" "Seidel matrix" conference`
   - `Seidel matrix fourth spectral moment conference equality`
   - `two-graph coherent 4-sets trace fourth power`
   This produced conference-matrix spectral papers but no snippet stating the audited identity; the 2015 equality result remained the closest direct predecessor.
4. Retrieval batch, 18 displayed records combined, exact queries:
   - `"UPPER AND LOWER BOUNDS FOR THE POWER OF EIGENVALUES IN SEIDEL MATRIX" pdf`
   - `10.14317/jami.2015.627 pdf`
   This was used to resolve and inspect the 2015 candidate, not as an independent novelty set.

### OpenAlex

Endpoint: OpenAlex Works search; `per-page=20`; fields screened were displayed title and work identity. Exact queries and returned sets:

- `"two-graph" "pair degree"`: 19 total/19 returned; all 19 rejected on title as unrelated uses of “two graph” and pair degree.
- `"two-graph" "coherent quadruple"`: 0 total; the API returned a valid empty result, not an error.
- `"two-graph" "aligned four-set"`: 5 total/5 returned; all five were duplicate/version records of current Othello-series work and therefore not external predecessors.
- `"Seidel matrix" "fourth moment"`: 0 total; valid empty result.

### Crossref

Endpoint: Crossref Works, `query.bibliographic`, `rows=20`; fields screened were the first 20 titles plus DOI/record metadata when relevant. Exact queries were the same four quoted strings used for OpenAlex. Crossref reported total-result counts `2,105,956`, `2,007,189`, `2,484,465`, and `642,626`, respectively; the top 20 from each (80 titles total) were screened. All were rejected on title as query-token noise. These huge totals are reported rather than treated as exhaustively screened sets: **only the first 20 ranked records for each query were screened.** Crossref DOI resolution for `10.14317/jami.2015.627` separately supplied the bibliographic record and version-of-record PDF link used above.

### Semantic Scholar

Endpoint: Graph API paper search, `limit=20`, fields `title,year,externalIds`. Exact queries without quotation marks:

- `two-graph pair degree`: HTTP 429; **NOT COVERED**.
- `two-graph coherent quadruple`: HTTP 429; **NOT COVERED**.
- `two-graph aligned four-set`: HTTP 429; **NOT COVERED**.
- `Seidel matrix fourth moment`: 508 reported total, 20 returned and screened on title; all 20 were unrelated random-matrix/numerical-analysis uses of the terms.

## Coverage gaps and unreachable services

- **MathSciNet: NOT COVERED.** Institutional authentication was unavailable. This gap licenses no negative and is why any novelty sentence must retain “to our knowledge.”
- **Google Scholar: NOT COVERED.** Automated access was not attempted because it is blocked/unreliable in this environment.
- **zbMATH Open direct result set: NOT COVERED.** The web UI was reachable, but direct encoded result URLs yielded neither a machine-distinguishable result set nor an error payload in this session. A web-search batch restricted to `site:zbmath.org` was screened, but that is not represented as an exhaustive zbMATH database search.
- **Semantic Scholar:** three of four exact queries were rate-limited as recorded above.
- **2015 article PDF:** both resolved PDF hosts timed out with zero bytes; the load-bearing theorem was available in indexed HTML and is therefore marked `partial`, not `full text`.
- No citation-graph negative is asserted. This was a claim-specific terminology/formula search, not an exhaustive forward-citation closure; consequently the three-graph citing-count rule is not invoked.

## Recommended attribution wording for Paper V

Safe theorem-adjacent wording:

> The fourth-power equality characterization of conference Seidel matrices is classical in spectral form; see Iranmanesh--Askari Farsangi, Theorem 2.4, at \(\alpha=4\). The following order-six identity refines that equality by expressing the entire fourth-moment excess as the number of aligned four-sets. To our knowledge, this exact defect identity and the resulting empty-family recognition criterion have not previously been stated.

More conservative wording if Paper V does not want a novelty sentence:

> At order six, the fourth-moment excess admits the following direct two-graph count. Combined with the standard conference equality criterion, it recognizes the conference switching class from the absence of aligned four-sets.

Do **not** say that “conference iff fourth-moment equality” is new. Do **not** cite Bussemaker--Mathon--Seidel or Goethals--Seidel as if they contained the defect identity; they support the classical order-six conference class and conference-matrix background only. Gillespie may be cited for the regular-two-graph coherent/incoherent four-set counts, with the present lemma clearly identified as the arbitrary order-six refinement/converse.

## Mystery ledger (ej + tt closeout)

- **Settled in this audit:** why the closest spectral predecessor does not pre-empt the lemma. The identity
  \(\operatorname{tr}(S^4)-150=2\sum m(xy)^2=32|\mathcal A|\) isolates the genuinely additional order-six combinatorial statement.
- **Settled in this audit:** why regular-two-graph four-set counts are adjacent rather than identical prior art. They assume constant pair degree and count coherent/incoherent blocks from regular parameters; the audited lemma applies before regularity and derives conference regularity from a vanishing family.
- **Open evidence mystery:** an older source could state the same equality under principal-minor, signed-walk, or Seidel-energy language not reached by the terminology search. The exact gaps are MathSciNet, direct zbMATH results, three rate-limited Semantic Scholar queries, and the inaccessible 2015 PDF. A later expanded precedence audit or referee query owns that gap; it is not evidence against import with “to our knowledge.”
- **Mathematical mystery:** none remains for this bounded item. The remaining uncertainty is bibliographic coverage, not the content or comparison of the claim.

## Closing answer

- **Exact predecessor found?** No, within the bounded and explicitly gapped coverage above.
- **Adjacent predecessor found?** Yes: the general spectral equality endpoint (2015) and regular coherent-four-set design counts (2018).
- **Attribution posture:** import is safe with the spectral endpoint credited and any novelty statement qualified by “to our knowledge.”
