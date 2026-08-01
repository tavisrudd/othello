# External open-problem watchlist

**Started:** 2026-07-31

This directory separates two records that must not be conflated:

1. `sources-*.md` files catalogue externally stated open problems and problem
   lists, with stable references and read-depth markers.  They do not claim
   relevance to this repository.
2. `results-crosswalk.md` compares those external problems with proved results
   in this repository.  It is the only place where tractability or relevance
   judgments belong.

The source catalogues are append-only at the entry level.  A problem later
solved or reformulated is retained and annotated with a dated status note.
Crosswalk judgments may change as the portfolio changes.

## Files

- `sources-finite-geometry-coding.md`: arcs, caps, MDS/PRS deep holes, repair
  and locally recoverable codes.
- `sources-quantum-information.md`: maintained and curated quantum-information
  problem lists, QEC and transversal-gate frontiers.
- `sources-algebraic-geometry-physics.md`: Fano/K-stability, rational points,
  anomaly cancellation and related arithmetic geometry.
- `sources-frames-designs-games.md`: equiangular frames, Hadamard/conference
  matrices, discrete designs and combinatorial games.
- `local-results-index.md`: compact portfolio-side index used for matching;
  it is not an external-problem source.
- `results-crosswalk.md`: links external entries to our theorem inventory.
- `search-log.md`: queries, screened sets, access failures and update dates.

## Entry schema

Every source entry records a stable ID, date/version, URL or DOI, the kind of
list, its scope, and read depth using `notes/literature-audit-conventions.md`.
Problem statements are paraphrased unless a short exact formulation is useful.
An entry marked `lead only` has not yet been promoted into the crosswalk.

## Update protocol

- Collect first; filter second.
- Prefer author, publisher, society, workshop and arXiv sources.
- Verify current status before treating any listed question as open.
- Never infer that shared terminology constitutes a bridge.
- Put famous/field-defining, recognized specialist, and paper-local questions
  in distinct crosswalk tiers.
