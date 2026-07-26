# C656 PRS literature delta after the 2026-07-25 audit

Date: 2026-07-26

## Opening summary and verdict

This is a bounded one-day delta against
`papers/beyond4_prs/literature-audit.md`, whose last substantive audit is
dated 2026-07-25.  It searched for new versions, newly indexed work, and new
forward citations relevant to the manuscript's R5--R7 and all-level
headlines.  It did not locate a new or revised work that pre-empts the
redundancy-five, -six, or -seven PRS classifications, coherent marked polar
contraction, the split-squarefree Hankel/catalecticant criterion, the
NRC-nucleus/Lucas-carrier comparison, or the all-level stable-component
theorem.

Five works are named individually below.  Four have earlier **full text**
reads that this delta reuses (Zhang--Wan--Kaipa, Kaipa, Wang, and
Wang--Wu--Hu); zero new full texts were opened in this delta.  The fifth,
Cheng--Wu--Zhou, was read at **abstract/metadata only**.  Its newly reachable
abstract closes a minor access gap in the earlier search log and confirms
that it studies a non-Reed--Solomon evaluation code, not PRS.  No paper bytes
were newly fetched, so there was no new cache-ingest operation.

The negative is deliberately narrow.  MathSciNet and Google Scholar remain
uncovered, Semantic Scholar was rate-limited on every current citation
request, and the Crossref recent-index search is relevance-ranked rather than
an enumerable complete result set.  The manuscript's permitted wording
therefore remains the baseline wording: “to our knowledge, no prior
classification was located within the recorded search boundary.”

## Pinned seeds, versions, access, and forward graphs

The four seed records were resolved by pinned arXiv identifier, never by
title.  The arXiv API query was

`https://export.arxiv.org/api/query?id_list=<PINNED_ARXIV_ID>`

and returned HTTP-success Atom entries in all four cases:

| Pinned seed | Current arXiv version and update | Read depth and cached bytes |
|---|---|---|
| `arXiv:1901.05445` | `v2`, 2019-09-03 | **full text**, earlier audit read arXiv v2, Sections I--IV; cache key `arXiv:1901.05445`, SHA-256 `5c2b9e2508c7200428c441b7a41da1596b1c9b0851f5632e2297cdbed41caf24` |
| `arXiv:1612.05447` | `v1`, 2016-12-16 | **full text**, earlier audit read especially Proposition 1, Sections IV--V; cache key `arXiv:1612.05447`, SHA-256 `1fe8de83c0b8cd3938e1a450fd49f376de795d7a317f099a730c63ab968178a4` |
| `arXiv:2606.12810` | `v1`, 2026-06-11 | **full text**, earlier audit read all sections; cache key `arXiv:2606.12810`, SHA-256 `5dd4e19544335ebc2c75a184074e94adb91b78331930b5e8a643ae606021a107` |
| `arXiv:2604.21183` | `v4`, 2026-06-04 | **full text**, earlier audit read arXiv v4, all sections, with theorem-level reliance on Theorem 1, Proposition 3, Theorem 2, Propositions 10--11, and the conclusion; cache key `arXiv:2604.21183v4`, SHA-256 `ad1e19b1a1bf7b1bbc016cc4617a59a718cf1a3f9396f6386f4b1b151149a811` |

Thus none of the four acquired a post-baseline arXiv version.

Current forward-graph results are kept separate:

| Pinned seed | OpenAlex | Crossref | Semantic Scholar |
|---|---:|---:|---:|
| `arXiv:1901.05445`; DOI `10.1109/TIT.2019.2940962`; OpenAlex `W2973880421` | 21 | 19 | **ERROR**, HTTP 429; baseline 2026-07-25 count was 24 |
| `arXiv:1612.05447`; DOI `10.1109/TIT.2017.2706677`; OpenAlex `W2563545890` | 20 | 16 | **ERROR**, HTTP 429; baseline count was 28 |
| `arXiv:2606.12810`; OpenAlex `W7164507418` (duplicate record `W7164701367`) | 0 on each OpenAlex record | **UNRESOLVED**, Crossref DOI lookup returned HTTP 404 | **ERROR**, HTTP 429 |
| `arXiv:2604.21183`; OpenAlex `W7155558292` | 0 | **UNRESOLVED**, Crossref DOI lookup returned HTTP 404 | **ERROR**, HTTP 429 |

For the first two seeds, OpenAlex returned complete citing lists of sizes 21
and 20 (HTTP success, response `meta.count` equal to the number returned).
Those title/year/identifier metadata sets were screened again.  Crossref
returned successful work records and `is-referenced-by-count` values 19 and
16.  Both pairs are unchanged from the baseline.  Semantic Scholar's 429s
are service errors, not empty results, so this delta does not claim a fresh
three-graph closure.  The larger baseline Semantic Scholar sets of 24 and 28
remain the largest screened sets and are not silently replaced by the
smaller current OpenAlex lists.

For the two 2026 seeds, OpenAlex citing queries returned HTTP success,
`meta.count = 0`, and empty result arrays; these are genuine empty OpenAlex
results.  Crossref's 404s mean that the arXiv-issued DOI records could not be
resolved there, and Semantic Scholar's 429s mean that no current count was
obtained.  Consequently no absence verdict rests on their incomplete
forward graphs.

The OpenAlex citing query used verbatim was

`https://api.openalex.org/works?filter=cites:<PINNED_OPENALEX_ID>&per-page=200`

and the Crossref record query was

`https://api.crossref.org/works/<PINNED_DOI>`.

## Screened discovery sets

### arXiv object searches

Eight arXiv API queries were run over title, abstract, and arXiv metadata,
with `start=0`, `max_results=100`, `sortBy=lastUpdatedDate`, and
`sortOrder=descending`.  Each request returned HTTP success; therefore every
zero below is an empty result, not a service error.

| Exact `search_query` | Total/returned | Screen disposition |
|---|---:|---|
| `all:"projective Reed-Solomon" AND all:"deep holes"` | 4/4 | all four are the already audited 2016--2019 PRS corpus |
| `all:"projective Reed-Solomon" AND (all:"redundancy five" OR all:"redundancy six" OR all:"redundancy seven")` | 0/0 | empty |
| `all:"coherent polar" AND all:"Reed-Solomon"` | 0/0 | empty |
| `all:"marked contraction" AND all:"Reed-Solomon"` | 0/0 | empty |
| `all:catalecticant AND all:"split squarefree"` | 0/0 | empty |
| `all:Hankel AND all:"split squarefree"` | 0/0 | empty |
| `all:"normal rational curve" AND (all:nuclei OR all:Lucas)` | 2/2 | two already audited 2013 NRC-nuclei/background records; neither is new or revised |
| `all:"stable component" AND all:"Reed-Solomon"` | 0/0 | empty |

The discriminator was mechanical: retain a record only when its
title/abstract/metadata contained all concepts in its exact query, then
promote it if its date/version was post-baseline or its theorem object
overlapped one of the seven target axes.  No record was promoted.

The two 2013 NRC records are covered here as a screened set, not named-source
characterizations; neither was newly indexed or revised.

### Crossref recent-index probe

Crossref was queried with

`filter=from-index-date:2026-07-25,until-index-date:2026-07-27&rows=100`

and each of these exact `query.bibliographic` values:

1. `projective Reed-Solomon deep holes`
2. `Reed-Solomon redundancy five six seven`
3. `coherent polar contraction Reed-Solomon`
4. `split squarefree Hankel catalecticant`
5. `normal rational curve nuclei Lucas`
6. `stable component Reed-Solomon`

All six requests succeeded.  Crossref reported respectively
`8709/2853/2002/258/3329/3971` relevance-ranked total hits; the first 100
title/abstract/DOI metadata records from each were screened.  The verbatim
mechanical discriminators were respectively
`deep hole AND reed-solomon`,
`reed-solomon AND redundancy`,
`reed-solomon AND polar`,
`split AND hankel`,
`normal rational curve AND nuc`, and
`reed-solomon AND stable component`.
They promoted `0/0/0/0/0/0` records.  Because only the first 100 of each
large relevance-ranked set were screened, this probe is discovery evidence,
not an exhaustive Crossref negative.

## Promoted access-gap resolution

Cheng, Wu, and Zhou, *On deep holes of non-Reed-Solomon codes*, DOI
`10.1016/j.ffa.2026.102882`, OpenAlex `W7167234643` — **abstract/metadata
only**.  The publisher abstract and theorem synopsis were accessed through
the ScienceDirect article page; publication metadata were compared with
OpenAlex.  No full text was obtained or characterized.

This work already appeared in the 2026-07-22 forward-citation screen, where
the abstract was unavailable and the title-only dismissal was explicitly
left as a minor gap.  The now-accessible abstract says that the code uses
the evaluation-polynomial subspace
`\langle 1,x,\ldots,x^{k-2},x^k\rangle`, determines its covering radius,
and classifies deep holes in stated even- and odd-characteristic ranges.
The even case explicitly leaves `k=q-4` open.  This confirms that the paper
does not treat projective Reed--Solomon codes, R5--R7 PRS syndrome
classification, marked polar contraction, or the manuscript's stable
components.  It is adjacent twisted/non-RS work, not a pre-emption.

This characterization is based only on the publisher abstract and displayed
theorem synopsis.  Any claim about its proofs or full theorem boundary would
require full-text access.

## Coverage and cache statement

Covered in this delta:

- exact arXiv-version resolution for all four pinned seeds;
- current OpenAlex and Crossref counts where those services resolved the
  seeds, with current Semantic Scholar failures recorded separately;
- complete returned arXiv object sets for the eight exact queries;
- the first 100 Crossref title/abstract/DOI metadata records for each of six
  recent-index probes;
- the newly reachable publisher abstract for Cheng--Wu--Zhou.

Not covered:

- MathSciNet (institutional authentication unavailable);
- Google Scholar (automated access blocked);
- a current Semantic Scholar citation count or list (HTTP 429 on every
  request);
- a Crossref record or citing count for the two arXiv-only 2026 seeds
  (HTTP 404);
- full text of Cheng--Wu--Zhou;
- Crossref results below rank 100 in the six large recent-index sets.

Before any paper operation, the shared cache was queried for all four pinned
seeds.  The keys and SHA-256 values are recorded above.  No new PDF was
downloaded, so there was no fetched paper requiring cache ingestion.

## Durable conclusion

No post-2026-07-25 revision, newly discovered citation, or newly indexed
paper in the completed search boundary changes the baseline positioning.
The one positive delta is evidentiary: the Cheng--Wu--Zhou abstract is now
reachable and resolves the earlier title-only access gap in the expected
non-PRS direction.  This delta does not strengthen the qualified novelty
wording into an unqualified priority claim.
