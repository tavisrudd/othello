# Reconstructing projective frames from their continuation graphs

**Lane**: `continuation`

**Date**: 2026-09-07

Discovery companion: `notes/2026-07-19-continuation-discovery-track.md`.

## Goal

Prepare the upgraded first draft and a validated standalone export for the author.
The user owns GitHub and DOI actions. Independent mathematical/prose review and
C273's formalization remain subsequent publication-readiness work. Full-complex
reconstruction remains outside the headline under the existing N1-only ruling.

## Current status

- The 11-page first draft is `papers/continuation-graph-rigidity/continuation_graph_rigidity.tex`
  and its deterministic PDF. The stable q>=13 proof is written mathematics; the graph
  determines q and every graph isomorphism extends uniquely semilinearly.
- C1108 reconciled completed C295 with the paper and compared exact hypergraph/cross-ratio
  reconstruction hypotheses. This was not a comprehensive renewed priority audit. Report:
  `notes/2026-09-07-c1108-continuation-reconciliation.md`.
- C1109 completed polynomial recognition over a supplied finite field, using a completed
  cyclic division table, with independent coordinate-certificate checking. Its exact finite
  census finds q=5,8 have two resolutions and an index-two ambient subgroup; q=7,9,11 are rigid.
  All nonambient cosets and all four-pencil resolutions are recorded in the public bundle.
  Report: `notes/2026-09-07-c1109-certified-continuation-reconstruction.md`.
- The finite data replay under independent Python/nauty construction and Sage 10.7/10.9.
  Source-only claim/evidence checks and reproducible PDF builds pass. No Lean theorem is claimed.
  The prototype recognizer is slower than generic graph isomorphism on the recorded controls.
- C1110 is active: the first draft is exported and locally verified; independent
  cold mathematical/prose review and the exact public Clebsch comparison remain open.
  Export/validation record: `notes/2026-09-07-c1110-continuation-upgraded-manuscript.md`.

## Next steps

- **C1110** — review the prepared draft and finish its independent mathematical/prose and
  publication-ownership checks. The author handles GitHub and DOI actions.
- **C271** — obtain/read the named Drake–Sané and Metsch sources and complete the auth-gated
  citation diligence for N2; keep N2 softened meanwhile. Existing audit:
  `notes/2026-07-11-continuation-rigidity-audit-scope.md`.
- **C273** — implement the planned `ContinuationRigidity` Lean library; no library has been
  built. The recorded collaborator route remains the fallback if formalization stalls.

Approved task scope: `notes/2026-09-07-continuation-ergodis-reconstruction-plan.md`.
The larger-arc extension problem, exact m(k)/r(k), computation-free q=7/8 boundary,
and competitive recognition performance remain open research, not new allocations.

## Ownership and consumers

- This lane owns the manuscript, graph convention, stable proof, exact frame boundary and
  reconstruction code. Owned paths are the paper root, continuation reports/handoffs, and the
  continuation entries of shared task/paper/export maps.
- C295 is complete. Its stable-frame corollary is integrated. Its six-point Clebsch pilot at
  q=11 remains distinct from the four-frame graph at that order; do not conflate their data.
- C1111–C1113 in `ergodis` consume this paper read-only for preservation-contract corpora,
  autonomous representation discovery and conditional transfer. They do not widen C273.
- C296 remains gated until reconstructed data contribute to a game-value theorem on the same
  class. Static recognition is not a game-value result.

## Standalone draft

Verified local Git repository: `~/src/math-papers/continuation-graph-rigidity`, exported through
`papers/scripts/export-paper-repos.py`. `.zenodo.json`, CFF and the MIT license are
included in the authority. No GitHub operation or DOI assignment is part of this task.
