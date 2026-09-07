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

- The 12-page first draft is `papers/continuation-graph-rigidity/continuation_graph_rigidity.tex`
  and its deterministic PDF. The stable q>=13 proof is written mathematics; the graph
  determines q and every graph isomorphism extends uniquely semilinearly.
- C1108 reconciled completed C295 with the paper and compared exact hypergraph/cross-ratio
  reconstruction hypotheses. This was not a comprehensive renewed priority audit. Report:
  `notes/2026-09-07-c1108-continuation-reconciliation.md`.
- C1109 completed polynomial recognition over a supplied finite field, using a completed
  cyclic division table, with independent coordinate-certificate checking. Its exact finite
  census finds q=5,8 have two resolutions and an index-two ambient subgroup; q=7,9,11 are rigid.
  All nonambient cosets and all resolutions into four parallel classes are recorded in the public bundle.
  Report: `notes/2026-09-07-c1109-certified-continuation-reconstruction.md`.
- The finite data replay under independent Python/nauty construction and Sage 10.7/10.9.
  Source-only claim/evidence checks and reproducible PDF builds pass. No Lean theorem is claimed.
  The prototype recognizer is slower than generic graph isomorphism on the recorded controls.
- C1110 is active: the exported draft received a fresh-context sub-agent referee review.
  No main-result defect was found; all local findings R1–R5 are now corrected
  and the authority checks pass. The uncited Clebsch aside was removed.
  Review: `notes/2026-09-07-c1110-continuation-cold-referee.md`.
  A second fresh-reader exposition review and percentile estimates are complete;
  local polish is applied. Report: `notes/2026-09-07-c1110-continuation-layering-review.md`.
  Motivation now emphasizes unique map extension, coordinate certificates and
  nonlinear-code isometries; closest-source comparison is documented in
  `notes/2026-09-07-c1110-continuation-motivation-positioning.md`.
  Same-reader paired reassessment: overall 75→80, positioning 65→75,
  motivation 75→80, adjacent accessibility 65→75 (subjective percentiles).
  Remaining small edits and grading limits:
  `notes/2026-09-07-c1110-continuation-exposition-grade-deltas.md`.
  Terminology and notation audit corrected pencils, clarified resolutions and
  simplified local proof wording; report:
  `notes/2026-09-07-c1110-continuation-terminology-audit.md`.
  README now gives a mathematical overview before verification commands:
  `notes/2026-09-07-c1110-continuation-readme.md`.
  Export/validation record: `notes/2026-09-07-c1110-continuation-upgraded-manuscript.md`.

## Next steps

- **C1110** — complete publication-readiness review. The same-reader final pass
  finds the local exposition concerns resolved; preserve the current structure.
  Feedback: `notes/2026-09-07-c1110-continuation-final-reader-polish.md`.
  Qualified external subject review and priority diligence remain distinct from
  the completed sub-agent review and local corrections.
  The author handles GitHub and DOI actions; add the published artifact citation
  to the verification appendix using version DOI `10.5281/zenodo.22651106`.
  Concept DOI `10.5281/zenodo.22651105` is verified and linked in the README.
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
