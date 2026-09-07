# C1102 — Forward-citation acquisition, first triage, and Paper V hand-back corrections

Date: 2026-09-07. Lane: `clebsch`. Status: **Gate 1 OPEN; manuscript drafting NOT released.**

This is a partial audit, not forward-citation closure. **One source was read at full text**
in this pass (Klappenecker–Rötteler v1); five at partial depth and seven at
abstract/metadata depth among the thirteen acquired PDFs. `sources.json` records every
acquired source's key, SHA-256, version, access URL, depth, and sections actually read.
Acquisition does not upgrade C1090/C1099's read depths. The largest available citing sets
were mechanically screened, but technical adjudication of the promotions remains unfinished.

Continuation: `USER-SCAN-FOLLOWUP.md` resolves Wang–Li access and records
Dai–Fu–Luo's explicit qubit product ceiling; the snapshot below is historical.

## Outcome and resume gate

1. All seven original seeds have independently obtained OpenAlex, Crossref, and Semantic
   Scholar citation counts. Both enumerating graphs were acquired completely for these seeds.
   The raw metadata and abstracts remain in the persistent cache; git-visible hashes,
   queries, titles, and screening decisions identify the screened sets.
2. The graph reveals omitted signed-qudit prior art: Watson–Campbell–Anwar–Browne 2015.
   C1090's blanket distinction “weighted qubits versus unweighted qudits” is unsafe.
   This changes positioning of the mechanism, not an established verdict on the code instances.
3. Klappenecker–Rötteler's primary Theorem 1 confirms the finite-field trace-cubic MUB
   construction. Knipfer et al.'s equation (2) concerns **two** prime-dimensional qudits;
   do not attribute a maximum-magic conjecture for arbitrary `k` odd-prime qudits to it.
4. The Paper V memo's operational hand-back survives, with two precision repairs below.
5. Next: finish primary-section and promoted-source adjudication; resolve Alltop/Wang–Li
   access and the added Hessian seed's graph gaps; issue the six final verdicts and the
   pre-draft claim–proof–novelty ledger. Only then can the companion manuscript begin.

## Citation sets and reproducible queries

`counts.json` pins the DOI of every seed, the graph-resolved title and identifier, UTC query
timestamp, each literal URL, status/error, count, page hashes, and complete enumeration hash.
Crossref supplies `is-referenced-by-count`; it is a third independent count, not an
enumerated reverse-citation list. Counts are observations at acquisition, not synchronized
snapshots across services. Even one service's summary count can disagree with its query set.

| Seed | OpenAlex count / returned set | Crossref count | Semantic Scholar count / returned set |
|---|---:|---:|---:|
| Haah, `10.1103/PhysRevA.97.042327` | 16 / 16 | 13 | 19 / 19 |
| Campbell–Howard, `10.1103/PhysRevA.95.022316` | 101 / 103 | 83 | 102 / 102 |
| Krishna–Tillich, `10.1103/PhysRevLett.123.070507` | 68 / 69 | 58 | 76 / 76 |
| Prakash–Saha, `10.22331/q-2025-06-12-1768` | 2 / 2 | 3 | 12 / 12 |
| Campbell–Anwar–Browne, `10.1103/PhysRevX.2.041021` | 164 / 168 | 164 | 245 / 245 |
| Leone–Oliviero–Hamma, `10.1103/PhysRevLett.128.050402` | 288 / 309 | 283 | 158 / 158 |
| Wang–Li, `10.1007/s11128-023-04186-9` | 23 / 25 | 25 | 17 / 17 |
| Additional: Kagamihara–Tsuchiya, `10.48550/arXiv.2602.23687` | 0 / 0 | unavailable: 404 | unavailable: 429, also on bounded retry |
| Additional: Chen–Yan–Zhou, `10.22331/q-2024-05-21-1351` | 24 / 27 | 25 | 29 / 29 |

The added Kagamihara seed is **not** a three-source zero. Its Crossref 404 is a missing
record, and its Semantic Scholar 429 is a request failure. Neither licenses a negative.
An empty successful graph page is distinguished from an error by HTTP success, parsed JSON,
and the service's empty result array; `enumeration_complete` concerns transport/pagination
only. It does not assert that a service indexes all literature.

Query templates (the fully substituted URLs are retained in `counts.json`):

```
https://api.openalex.org/works/doi:<DOI>
https://api.crossref.org/works/<DOI>
https://api.semanticscholar.org/graph/v1/paper/DOI:<DOI>?fields=title,citationCount,externalIds
https://api.openalex.org/works?filter=cites:<resolved-ID>&per_page=200&cursor=<cursor>&select=id,doi,title,publication_year,abstract_inverted_index
https://api.semanticscholar.org/graph/v1/paper/<resolved-ID>/citations?fields=title,abstract,year,externalIds&limit=1000&offset=<offset>
```

For Kagamihara the Semantic Scholar identifier is `ARXIV:2602.23687`, pinned before querying.
No title search resolves a citation seed. Browser API access initially failed with a tool
URL-safety error; direct HTTPS requests succeeded and supply the authoritative records.

### Screened set

Both available graph sets were screened: **1,377 memberships**, not 1,377 unique papers.
The screen uses title and abstract where supplied; availability is recorded per membership.
OpenAlex's abstract index contributes its words, sufficient for this word-pattern screen.
The verbatim case-insensitive discriminator in `screen.py` is:

```
qudit|qutrit|ququint|cubic|triorthogon|divisib|synthillation|synthesis|diagonal|transversal|invariant|hypergraph|mutually unbiased|maximal magic|maximum magic|nonlocal magic|non-local magic|multipartite|product state|Waring|Alltop
```

`screening.json` retains every membership and match; `promoted.json` contains **336**
normalized-title-deduplicated promotions. Deduplication removes non-word characters and
lowercases titles; it is an aid to review, not bibliographic identity resolution. Different
versions/titles can survive as separate entries. `NO_PATTERN_MATCH` means no matching
title/abstract term; it is not a claim about unread full text. This broad first pass does
not license the six instance negatives. Promoted technical reading remains an explicit gate.

## Technical findings and six provisional verdicts

### Omitted predecessor: signed qudit gates

Watson, Campbell, Anwar, Browne, *Qudit Colour Codes and Gauge Colour Codes in All Spatial
Dimensions*, arXiv:1503.08800v2, DOI `10.1103/PhysRevA.92.022312`. **Read depth: partial**, PDF
IV.B, Definition 2 and equation (18); V, Lemmas 7–8; VIII discussion. Exact bytes in
`sources.json`. They introduce a diagonal sign matrix and star-orthogonality of coordinatewise
row products, then implement a cubic phase with conjugation on the starred sites.
Inference for C1102: signed qudit moment cancellation is prior art. Their cubic lemma fixes
one logical qudit and a single logical cubic; this reading does not identify our coupled
invariant phase or the translation/conic configurations with their codes.

| Requested verdict | Safe result at this checkpoint |
|---|---|
| General signed-moment CSS mechanism | **Partially known, with direct signed-qudit prior art.** The particular all-weights iff formulation requires comparison; no novelty claim released. |
| Translation-trade `[[2p,p-1,2]]_p` family | **Unresolved priority.** No final absence claim follows from first triage. |
| Conic trades at `p=7,11,13` | **Unresolved priority.** The construction/census bundle is banked, but the graph review is unfinished. |
| Invariant-theoretic logical phase | **Unresolved priority.** Kalra–Prakash's abstract treats constraints on weight enumerators; that is a different use of invariants, but an abstract does not exclude all overlap. |
| Hessian-rank SRE formula | **Partially known.** Kagamihara–Tsuchiya III.1, Theorem 1, gives the qubit rank reduction; arbitrary odd-prime cubic priority remains open. |
| Bipartition product exclusion | **Standard ingredients; specific application priority unresolved.** Retain the C1099 argument as an elementary consequence, not a claimed new measure. |

Krishna–Tillich arXiv:1811.08461v2, **partial**, Definition 2 and Theorem 3, supplies the
unweighted qudit triorthogonal comparison. Camps-Moreno et al., arXiv:2601.21514v1,
**partial**, introduction/notation, explicitly set up qubits; do not infer qudit coverage
from their intermediate use of codes over `Z_N`. Kalra–Prakash arXiv:2501.10163v3,
**abstract/metadata only**, is a pending full technical comparison. The other original seed
PDFs have been acquired but not technically re-read here; `sources.json` marks that explicitly.

### Trace cubic and the scope of the maximal-magic comparison

Klappenecker–Rötteler, arXiv:quant-ph/0309120v1, **full text**, Theorem 1 and proof in
section 2: their finite-field cubic-phase bases give the trace-cubic state used in C1099.
This establishes the known construction from a primary preprint, without claiming to have
read the published LNCS version. Their reference 1 and historical discussion attribute the
prime-field precursor to Alltop. Alltop himself remains **secondary only**, through this
fully read source; the primary-access gate is not discharged by that chain.

Knipfer et al., arXiv:2607.07197v1, **partial**, HTML abstract and introduction through
equation (2): the proposed bound is for a pair of prime-dimensional qudits. C1099's
trace-cubic entropy formula can be compared with it at `k=2`; the same numerical expression
for general `k` does not extend the scope of their conjecture. No claim of general maximality
is established here. Kagamihara–Tsuchiya arXiv:2602.23687, **partial**, HTML III.1, supports
the characteristic-two rank formula; the unversioned HTML retrieval and acquired v2 PDF
are distinguished in `sources.json`.

## Paper V hand-back: what to do

The user-selected memo is `notes/2026-09-07-c1099-logical-cubic-vs-paper-v-cubics.md`.
Its existing projectivity and Hessian-census conclusions were reviewed, not recomputed.

- Preserve the identification with the **chordal** shadow and the operational distinction:
  sheet reversal gives gate inversion; the residual chordal-line torsor gives a linear
  Clifford frame change between the two shadow cubics.
- Correct the memo's full-gate claim to the exact domain its section 10 allows: failure of
  the identity-on-`1+V_4` extension and of geometric `PGL_2(11)` lifts. Arbitrary linear
  extensions have not been classified. The task card now carries this limit too.
- Correct the singular-scheme sentence: `A_5/C_5` describes the twelve rational points as
  a subscheme of the rational normal quartic; the whole chordal singular scheme is a curve.
- Once the companion exists, hand back one scoped operational sentence to Paper V for its
  owner's next forward release. No Paper V manuscript edit, mirror write, or release is
  performed here. There is no reason to add an unsupported general non-lift theorem.

## Access coverage and outstanding work

`access-attempts.json` records the final bounded fallbacks. Alltop's OpenAlex record points
to Zenodo 1281588; both the API and landing page timed out in direct requests, and browser
access failed. Wang–Li's Springer PDF URL returned HTTP 200 **HTML**, redirected to an
authentication/cookie failure page. INSPIRE record 2737445 has no document or arXiv eprint;
OpenAlex reports closed access. Wang–Li remains **abstract/metadata only**, from its
publisher/INSPIRE metadata, DOI `10.1007/s11128-023-04186-9`. These are access failures,
not negative search results.

Still required: technical adjudication of promotions (including the card's asymptotic-code
and synthesis comparisons); remaining primary seed sections; Alltop and Wang–Li primary
access; added Hessian-seed citation coverage; a ledger before manuscript novelty language.
No institutional MathSciNet access was available; **NOT COVERED**. zbMATH Open and Google
Scholar were not queried in this pass; neither is represented as a negative.

Additional web searches, verbatim (2026-09-07; title/snippet discovery only, no negative
based on their result counts):

```
"Complex sequences with low periodic correlations" DOI pdf Alltop
"Constructions of mutually unbiased bases" Klappenecker Rotteler arxiv
"Low overhead qutrit magic state distillation" 1768 DOI
"Stabilizer Rényi entropy on qudits" filetype:pdf Wang Li
"Complex sequences with low periodic correlations" Alltop pdf 1281588
"Qudit color codes and gauge color codes" arxiv star orthogonality
```

Only individually discussed sources above are used technically. Other returned search
snippets were discovery noise, not evidence of non-overlap; the pinned graph sets own the
recorded screen. The Prakash–Saha DOI was verified on the Quantum publisher landing page,
`https://quantum-journal.org/papers/q-2025-06-12-1768/`, **abstract/metadata only**.

## Bounded extraction, `ej` + `tt`, and Mystery ledger

The new predecessor pre-empts a broad mechanism claim, not C1102's construction-paper task.
One bounded adjacent extraction inspected Watson et al.'s discussion and the existing seed
graph. Its decoder, composite-dimension, and lattice-classification questions are outside
this companion's scope. Two cheap comparison candidates were tested against its statement:

1. **Signed-qudit terminology as a novelty:** rejected by equation (18) and Lemma 8.
2. **Coupled invariant logical phase versus the lemma's one-logical-qudit phase:** a surviving
   distinction in the statements inspected, already owned by C1102; not a new task allocation
   or a completed novelty verdict. No adjacent research task is allocated.

The `ej` + `tt` checkpoint pass asks whether the proposed contribution survives a change of
presentation. It exposed cheap corrections already applied to the Paper V memo/card and
the maximum-magic attribution. Gate 1 has not passed; this is not the final post-acceptance
closeout required when C1102 completes.

**Mystery ledger.**

- **Settled editorially:** the apparent twelve-point “singular scheme” was a conflation of
  rational points with the entire curve. No new mathematical mystery remains there.
- **Settled attribution:** the two-qudit conjecture was extrapolated to arbitrary `k` in
  C1099's wording. General maximality is not supplied by that citation.
- **Open mathematics, not needed for the hand-back:** arbitrary lifts of the outer shadow
  map to the full logical cubic; exact missing evidence is a full automorphism/extension
  classification. Do not promote it from failed restricted tests.
- **Open gate, not a mathematical mystery:** priority of the six requested claims awaits
  the stated reading/access work. Citation-count disagreements remain graph observations.

No incidental discovery-track entry is needed: each finding answers a named audit or
Paper V review question. No research computation or Lean build was performed.

## Surfaces and validation

Updated: this report, source/count/screen records and replay scripts, the C1102 card and
Clebsch live handoff, and the user-selected Paper V memo. The live queue keeps C1102 open.
Historical C1090/C1099 reports and the earlier magic literature check are **not rewritten**;
their broad mechanism/non-lift/general-conjecture wording must be read with this correction.
No companion manuscript, paper ledger, public snapshot, or public summary exists in the
proposed `papers/clebsch-cubic-phase/` root; none was created. Series manuscripts and public
summaries were not changed by this partial audit, and no new novelty claim is released.

Replay from the repository root:

```
python3 notes/2026-09-07-c1102-forward-citations/audit.py
python3 notes/2026-09-07-c1102-forward-citations/screen.py
python3 notes/2026-09-07-c1102-forward-citations/verify.py
```

The first command performs fresh network queries and will change counts; the third verifies
the banked acquisition without contacting services. Use the current snapshot for reproducing
this report. Validation checks query/cache hashes, pagination membership counts, source PDF
hashes, and screening reproducibility. It does not certify novelty or source-reading completeness.

Command-shaping corrections: an early combined prerequisite read exceeded the local 10,000-token
producer cap; subsequent reads used bounded sections. A title-filter display also exceeded the
20-line ceiling and was replaced with indexed batches. The initial cross-filesystem rename of
newly acquired JSON failed without moving data; checked copying to the persistent cache repaired
it and the screen was regenerated. No evidence was lost and no such failure is counted as a
successful acquisition or review.
