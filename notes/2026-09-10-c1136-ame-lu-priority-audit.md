# C1136 — AME verification publication-priority audit

**Lane:** `ame-lu`. **Date:** 2026-09-10 local (some retrievals September 11 UTC).
**Status:** completed bounded audit; unqualified publication priority remains unclosed.

**Read-depth summary: zero complete external texts; seventeen specified partial primary reads (nine carried forward from C1135 and eight new); five further individually discussed sources at abstract/metadata depth.** The unconditional version/access/pinpoint/hash register is `2026-09-10-c1136-ame-lu-priority-audit/source-register.md`. This is expanded title/abstract and selected-passage coverage, not a full-text review of hundreds of papers.

## Decision

The prospective novelty verdict lives in the two **“Proposed verification extension — not adopted (C1136)”** rows of `papers/ame_lu/claim-proof-novelty-ledger.md`. In that bounded sense, no identical AME theorem was located in the screened corpus and inspected passages. Unread sections, a blank graph record, the inaccessible largest Crossref citing list, and MathSciNet authentication prevent publication-priority closure. **No “first,” “best known,” or exhaustive literature-closure claim is approved.**

C1135's mathematical recommendation survives: consider a compact theorem about verification with bounded total party support. The addition is not efficient stabilizer verification, fidelity witnesses, the general gap method, or setting minimization. Those are established. Its mathematical content is the exact AME weighted/setting calculation, the universal complementary-star bound, and composition with the existing rounding theorem. No proposed theorem has been adopted into the manuscript.

## Three independent citation graphs

V1–V4 and A1–A5 are the nine seeds defined at **partial** depth in the incorporated C1135 register. `graph-counts.json` records 27 independently queried counts, pinned DOI/arXiv identifiers, resolved IDs, exact URLs, HTTP statuses and retries. No seed was resolved by a title search. `graph-table.md` reports every count separately and each retrieved-list size.

The largest discrepancies include V1: Crossref 44, OpenAlex 41, Semantic Scholar 41; V2: 118/133/141; A2: 219/282/222. OpenAlex lists sometimes exceed its work-level count: V2 lists 137, A2 290, A3 52, V3 16 and V4 12. These are observed discrepancies, not silently reconciled totals; indexing/caching lag is only a possible explanation.

All eighteen OpenAlex/Semantic Scholar lists were retrieved. The largest reported enumeratable service is represented for each seed. **V1 fails the stricter largest-set requirement:** Crossref's 44 cannot be equated with either 41-list or their union. The attempted reverse query `https://api.crossref.org/works?filter=reference:10.1103/PhysRevResearch.2.043323&rows=1000` returned HTTP 400, explicitly `filter-not-available`. This means this audit did not enumerate that list; it does not prove another route is impossible. Three Semantic Scholar requests initially returned 429 and succeeded on serial retry. Failures remain recorded and were never counted as zero citations.

API forms, with concrete substitutions preserved in each JSON:

- Crossref: `https://api.crossref.org/works/<DOI>`.
- OpenAlex identity: `https://api.openalex.org/works/https://doi.org/<DOI>`; citing works: `https://api.openalex.org/works?filter=cites:<W-ID>&per-page=200&cursor=*`, followed through returned cursors.
- Semantic Scholar identity: `/graph/v1/paper/DOI:<DOI>?fields=title,citationCount,externalIds`; citations: `/graph/v1/paper/<ID>/citations?fields=title,year,abstract,externalIds,url&limit=1000`.

This is a **one-hop forward screen from nine seeds**, not recursive closure. Descendants of newly encountered papers were not recursively enumerated.

## Screened sets, databases and stopping rule

`citation-screen.json` contains **602 normalized-title records**, not 602 established distinct publications. Normalization is exactly `re.sub('[^a-z0-9]', '', title.lower())`; it may merge variants while retaining other duplicates. Book chapters, theses and malformed records remain visible. All titles were inspected in bounded batches. **547 records have abstract fields; not all 547 abstracts were read in full.** The initial 550 records retain their IDs; 52 additions from successful retries were appended.

One record, OpenAlex `W3101774651`, has no title, DOI, year or abstract. A direct repeat identity request confirmed blank metadata. It remains **unclassifiable**, not irrelevant.

Manual promotion discriminator: **“Does the title or abstract concern AME/perfect-tensor marginal determination, verification gap, restrictions on total measured support, number of measurement settings, canonical support projectors, or a general verification construction that might subsume the proposed theorem?”** General construction, tomography, hardware and coding results were retained in the inventory without automatically being promoted to full-text reading.

Selected abstract fields inspected individually: IDs 235, 251, 264, 311, 339, 388, 426, 445, 447, 453, 455, 457, 486, 499, 504, 512, 527, 534, 541 (missing, then separately resolved), 545, 547, 551, 555, 566, 584. A supplementary mechanical scan of all available abstracts used the case-insensitive expression `absolutely maximally|perfect tensor|marginal|support.{0,35}(verif|certif)|verif.{0,35}support`; matching context windows were inspected. That is not a full read of the papers or abstracts.

zbMATH's website returned 403, but its public API was accessible. Its OpenAPI schema supplied pagination parameters. Exact search strings and all returned titles were inspected:

| Exact `search_string` | Records |
|---|---:|
| `"quantum state verification"` | 10 |
| `"absolutely maximally entangled"` | 36 |
| `"perfect tensor"` | 13 |
| `"stabilizer" & "marginals"` | 2 |

Total: **61 returned records, with overlaps**. Exact URLs, IDs, titles, years and keywords are in `zbmath-search.json`. Endpoint: `https://api.zbmath.org/v1/document/_search`, with `page` and `results_per_page=100`. An earlier unquoted `quantum state verification` probe returned 100 of 375 results; it was **not exhaustively screened** and supplies no negative finding. The fourth query returned an irrelevant item: its punctuation is recorded literally rather than claiming a verified Boolean interpretation.

Google Scholar's first page was accessible, contrary to its usual automated-access limitation. Exact URL: `https://scholar.google.com/scholar?q=%22absolutely+maximally+entangled%22+verification`; its **ten titles** and destinations are in `scholar-search.json`. This is first-page coverage only. Potentially misleading titles were checked against primary arXiv abstracts.

MathSciNet returned HTTP 200 **for an institutional login page**, not results. It is **NOT COVERED**. The attempted URL and response classification are in `database-access.json`; no negative follows.

Additional web discovery used exact queries preserved in `web-discovery.json`, covering verification/marginal terminology, support locality, setting tradeoffs and newer witness/fidelity titles. A further orientation batch used `"AME" "verification" "spectral gap"`, `"absolutely maximally entangled" "marginals" "verification"`, `"perfect tensors" "certification"`, and `"stabilizer" "verification" "locality" "settings"`; this batch is discovery only, not a load-bearing negative inventory. Search-engine dates were not treated as publication dates.

Stop condition: finish accessible one-hop lists for nine pinned seeds; inspect all titles and the specified relevant abstracts; finish four exact zbMATH lists and first Scholar page; inspect the closest new primary passages; record unavailable services and unexamined models. These bounded steps are complete. They do not prove the absence of an unknown predecessor.

## What the expanded reading changes

All N-identifiers below have **partial** read depth with exact versions and passages in `source-register.md`. Comparisons are the auditor's inferences from those passages, not paper-wide exclusions.

1. **Minimum settings has direct predecessors.** N1 proves that a bipartite entangled pure state needs and admits two nonadaptive local projective settings (Theorem 1 and complete proof, pp. 3–4). It distinguishes an adaptive test from a laboratory setting. Use “binary tests/effects” for the proposal's optimization objects and define the count. Its bipartite tests act on both halves, not on at most `m+1` parties in total.
2. **Few-observable certification is another objective.** N2 uses randomized stabilizer bases and nonlinear minimum-of-estimates postprocessing with a good/bad-state tolerance gap. This is not automatically represented by the proposal's one perfectly complete verification operator. The linked full paper was not audited.
3. **General and subspace verification are substantial precedents.** N4 describes adaptive single-party protocols for arbitrary pure states and variants with two tests; N5 develops code-subspace verification and generator grouping. Their measurements may cover the system. These passages preclude motivating the proposal as the invention of efficient or constant-setting verification.
4. **Few-qubit measurement arity differs from total support.** N6 performs disjoint Bell measurements covering a copy and classically processes outcomes. Its optimality proofs were not audited. The metadata-only “Power of Two Bases” comparison likewise measures remaining qubits. Numerical gap comparisons require the full measurement class.
5. **Qudit witnesses deserve precise credit.** N8 uses prime local dimension in Section II.B and Theorems 1–3 despite broader abstract wording. Its stabilizer eigenbasis and coloring constructions are precedents. Cite the inspected version and theorem scope, without silently extending it to arbitrary additive prime powers.
6. **Verification/data-hiding duality is an adjacent general framework.** N3's introduction treats informationally complete measurement classes. Later proofs were not read, so no paper-wide exclusion is justified. State the proposal's theorem without an unsupported priority comparison.
7. **The AME survey supports the virtual-factor interpretation.** N7 p. 18 represents an even-party AME as a half-unitary image of Bell pairs. Together with A4/A5, this supports treating the one-star parent mechanism as standard structure. The complementary-star/error-filtration calculation is the proposed mathematical input; its prospective novelty is qualified in the owning ledger.

The five promoted metadata-only works are separately registered. In particular, a Scholar title mentioning “exact certification” resolves to exact algebraic certification of AME constructions in the newer arXiv abstract, not a noisy-state fidelity theorem. A generic mixed-state marginal result and an oscillator/GKP fidelity result are not elevated into full-text exclusions.

## Concrete proposed manuscript wording

These refine C1135's reviewed proposal; they are not adopted manuscript edits. Any prospective novelty language is owned by the two C1136 ledger rows and must point back to them.

**Model:** “In each round we choose a perfectly complete binary test whose effect acts on at most `m+1` of the `2m` parties. Operations within the selected subset may be joint. Thus the constraint concerns the total support of a test, rather than the arity of each measurement gate or the use of local measurements on every party. The number of tests below does not by itself count laboratory measurement bases.” Formally, each permitted effect is `E_S tensor I_(S^c)`, with `0 <= E_S <= I`, `|S| <= m+1`, and `(E_S tensor I) psi = psi`; randomization chooses among these effects before testing the copy.

**Motivation:** “The AME condition makes all tests confined to at most half the parties uninformative under perfect completeness. We therefore ask for the best conditioning at the first informative support size, and how it changes when only a prescribed number of tests can be used. Complementary families of marginal-support projectors give an explicit answer for stabilizer AME states and a universal bound for AME states.” This describes the theorem's question without asserting priority.

**Attribution:** “We use the standard spectral-gap framework for quantum-state verification and its canonical stabilizer-projector formulation [V1,V2]. Setting minimization is an established question [N1], and generator data and frustration-free parent Hamiltonians already provide fidelity certificates [V3,V4,A2]. Qudit witness constructions [N8] and general or subspace verification protocols [N4,N5] address related measurement models. Our optimization fixes the total party support of each binary effect.” Exact identifiers and reading limits are in the source register.

Retain the universal/stabilizer boundary and existing rounding constants. Present rejection-to-Clifford rounding as composition of the fidelity inequality with the existing product-unitary theorem. State verification permits arbitrary noisy states; the Clifford conclusion requires the product-unitary promise. No larger rounding radius, efficient implementation of arbitrary nonstabilizer projectors, device independence, or unstated sampling assumptions follow.

## Surfaces and adoption boundary

- Owning ledger: two prospective rows added, explicitly not adopted. Existing theorem rows are unchanged.
- Manuscript `papers/ame_lu/sections/01-introduction.tex`: proposed-claim vocabulary checked; no two-star result inserted.
- Paper public summary `papers/ame_lu/README.md`: checked and unchanged.
- Theorem snapshot `papers/ame_lu/theorem-map.md`: checked and unchanged; no new theorem declared.
- Portfolio public summary `papers/summary/README.md`: checked and unchanged; no proposed two-star claim found.
- C1135 proposal: remains the original reviewed draft. This report supplies the additional attribution/model paragraphs, with prospective novelty owned by the ledger.
- Standalone mirror: current exported paper remains C1134's `55e70c4`; no prospective ledger export, manuscript adoption, push or deposition. C979/Paper II is untouched.

## Evidence and validation

The task directory contains 27 counts, eighteen lists, normalized corpus, database outcomes, query inventories, seventeen PDF cache identities and the read-depth register. PDF bytes remain in `/tmp/persistent/tavis/lit-search`; API response caches remain in `/tmp/persistent/tavis/c1136`. No paper PDF is committed. `SHA256SUMS` pins compact evidence. Offline replay:

```sh
python3 notes/2026-09-10-c1136-ame-lu-priority-audit/verify_audit.py
```

Validation passed: 27 independent counts, eighteen lists containing 1,101 records before deduplication, 602 title keys, 61 zbMATH results, ten Scholar results, all evidence hashes, and all seventeen cached PDF hashes. The scoped whitespace check also passed. This checks recorded inventory arithmetic and integrity, not a literature-negative theorem. Original retrieval used inline Python with exact URLs recorded in JSON; live replay may return changed counts. There was no independent human re-screen of all titles; C1135's independent proof review is not a substitute.

Two execution incidents are bounded: an attempted whole historical handoff display exceeded the output cap and was truncated, and is not treated as a completed read; parallel cache-ingest processes lost three task-owned manifest entries, repaired by serial ingestion of the already downloaded identical PDFs. All seventeen task-owned entries and hashes were checked afterward. No foreign entries were reconstructed or modified.

## ej + tt closeout and Mystery ledger

The explicit post-validation ej + tt pass added the operator-level test definition to the proposed model paragraph. Its cheap additional value is terminology: distinguish **total support**, **measurement arity**, **binary test count**, and **basis count**. N1 and N6 expose a likely reviewer objection; the model paragraph now resolves it. The Tao-style question is whether a general optimization theorem already accounts for the result. Existing frameworks supply canonical projectors, eigenbasis optimization and gap-to-fidelity conversion. Expose the AME-specific combinatorial/error-space input explicitly instead of hiding it behind a generic certification headline.

| Item | State / evidence gap |
|---|---|
| Gap exceeding a product-measurement benchmark | Settled: incomparable measurement classes, not laboratory superiority. |
| Whether test count is laboratory-setting count | Settled: complete binary effects; implementation may require more bases or joint operations. |
| Nonstabilizer exact weighted attainment | Remains open in C1135; universal lower bound only. Not researched anew here. |
| Whether Crossref's 44-list contains another relevant V1 descendant | Open: list not enumerated; another reverse-citation route or supplied access required. |
| MathSciNet and blank OpenAlex record | Open access/metadata gaps; no absence inference. |
| Unread sections of broader verification papers | Not discharged by selected-passage audit. Use theorem-content wording, not publication priority. |

All findings were sought as part of this audit, so no incidental discovery-track entry is manufactured. Highest-EV next step: a bounded adoption decision on C1135's theorem package with C1136's model/attribution repairs and theorem-content wording. No implementation C-ID is allocated.
