# Open-problem source search log

## 2026-07-31 initial collection

Purpose: collect recent external problem lists across the broad portfolio
before filtering them against repository results.

### Search families

- recent open problems in finite geometry, arcs, caps and MDS codes;
- current PRS/RS deep-hole and covering-radius frontiers;
- recent LRC availability and hierarchical-repair questions;
- maintained and recent quantum-information/QEC problem lists;
- recent open problems in K-stability, Fano and rational-point geometry;
- current anomaly-free multi-`U(1)` classification literature;
- recent frame, equiangular-line, Hadamard and matrix problem collections;
- the current recurring list of unsolved combinatorial games.

Searches used web search over titles/abstracts with year filters 2024--2026,
then opened author, institutional, publisher or arXiv records.  Search-result
pages were used only for discovery.

### Screened source set

Twenty sources were promoted into four area catalogues or retained as
frontier leads.  Promotion required an explicit problem-list role or a direct
match to a major repository result family.  General popular lists, Reddit,
Wikipedia, ResearchGate mirrors, low-specificity workshop advertisements and
unrelated graph/computability problem collections were not promoted.

### Access and coverage

- Full-text count: **0** in this initial collection pass.
- `partial`: six sources (`FG-2025-Hirschfeld-Thas`,
  `COD-PRS-deep-holes`, `LRC-2025-Haymaker-Malmskog-Matthews`,
  `PHYS-2026-two-U1`, `AG-2026-K-stability`,
  `GAME-2025-Nowakowski`).
- All other promoted sources are `abstract/metadata only` or explicitly marked
  `secondary only`.
- The IQOQI maintained-list endpoint returned HTTP 502; its institutional
  description was reachable.  Current list contents are **NOT COVERED**.
- The 2025 discrete-mathematics problem collection was visible only through
  publisher abstract/section snippets.  Full list is **NOT COVERED**.
- MathSciNet and zbMATH were not used in this collection pass.  No novelty or
  absence verdict is licensed by this record.

### Cached source

- DOI `10.3390/math13091489`, published PDF, SHA-256
  `396813d44aebabc5a6a54520eaaafd9bee28dfbc3b701fae3ed3e1ba8a5f3f1e`.
- arXiv `2601.15576v2`, SHA-256
  `ee781c489365eb276474bf4b8908dc3dde2b6fcd36277e7587c24e32c154910c`.
- DOI `10.1017/9781009565486.005`, SLMath PDF, SHA-256
  `cc1b985ef7fa16d79877677a49b59eb65924a6d082341ae53348544c22cde1f1`.

### Next collection pass

1. Extract exact statement summaries for the 25 active K-stability problem
   environments.
2. Extract the current Games of No Chance 6 problem headings and status tags.
3. Capture the Oberwolfach matrix and coding problem lists.
4. Retry/archive the maintained IQOQI list.
5. Refresh the repository result index beyond the current routing summary,
   then expand the
   crosswalk without altering the raw source entries.

## 2026-07-31 generalist major-name pass

Purpose: add the canonical broad lists and famous named problems without
mixing their collection with judgments about repository relevance.

### Search families

- current official Millennium Prize status;
- 2026 status of Hilbert's problems;
- Smale, Arnold and Yau problem collections;
- maintained Erdos, Kourovka, AIM and TOPP databases;
- 2024--2026 AMS problem compendia in algebraic combinatorics and
  low-dimensional topology;
- Simon's mathematical-physics list and the DARPA 23 challenges;
- broad expert compilations and major standalone conjectures by field.

Searches used exact-title web queries and institutional/publisher records.
Promoted sources are recorded in `sources-generalist-major.md`; discovered
problem names are normalized in `sources-generalist-named-problems.md`.

### Coverage

- Sixteen major source sets were promoted.
- Full-text count: **0**.
- `partial`: Clay official page, 2026 Simons Hilbert review, the Landau IMU
  proceedings OCR, Thurston's AMS primary text, Springer Nash--Rassias
  contents, Erdos lists/FAQ, Kourovka current site, AIM index, TOPP index, AMS
  K3 description, AMS algebraic-combinatorics contents.
- `abstract/metadata only`: Hilbert primary AMS record, Smale, Arnold and Simon
  records.
- `secondary only`: Yau lists and the DARPA transcription, with their primary
  or institutional supporting records noted.

The 2024 Yau article, original 1982 Yau list, full Smale 18, full Arnold 861,
full Simon list, K3 chapters, Kourovka 21st-edition problem text and individual
AIM lists are **NOT COVERED**.  Their presence licenses discovery only.

Direct URL validation on 2026-07-31 found the University of Tennessee DARPA
transcription returning HTTP 404; its indexed text was used secondarily and the
live SAM.gov federal record returned HTTP 200.  AMS book/PDF and Eureka pages
returned HTTP 403 to command-line retrieval but remained visible through the
search index.  The Caltech Simon endpoints timed out in command-line validation
but were indexed by the web search.  These are recorded as access limitations,
not negative search results.

### Status policy

The named index distinguishes `official-open`, `live-lead`, `mixed`,
`disputed` and `refresh`.  Only the first is intended as a current status
assertion.  In particular, historical membership in Hilbert/Smale/Arnold and a
database `open` label are not enough for manuscript use.

### Result of local filtering

`generalist-results-crosswalk.md` records one direct partial bridge to the MDS
conjecture, a small number of finite-geometry/design or transversal-code
candidates, and explicit negative fences around tempting Hodge, Yang--Mills,
Jacobian/Dixmier, cubic-fourfold, SIC and MUB vocabulary matches.
