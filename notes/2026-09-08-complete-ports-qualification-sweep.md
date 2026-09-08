# Complete-ports: eventuality and README qualification sweep

**Lane**: `complete-ports`
**Date**: 2026-09-08
**Status**: complete; authority and standalone release gates pass.

The user supplied a source/diff follow-up on standalone `325d4de`, reporting
no new mathematical error and identifying two residual theorem-ending
ambiguities plus the public README's missing original-leaf boundary. No grades
or priority verdicts are adopted here. The optional optimizer and notation-table
reordering is outside this bounded consistency pass.

## Dispositions and proof check

Both theorem endings now say precisely what becomes eventual: the outer-distance
hypothesis. The preceding equivalence then applies, and the support-preserving
bijection still requires the displayed rho_T+d or M_t+d inequality. The
fixed-target proof already excludes nonzero sectors through radius r, then
uses the attained zero-sector cost for both directions; the rank-t proof
minimizes that same condition. Thus the endings restate their proved
quantifiers. Proof bodies are byte-identical.

The README now preserves the original leaf confinement region, target
coordinates and normalization, and requires the composed code to lie in the
appendix's context family. It expressly excludes escape costs recomputed at
new composite boundaries. The appendix and portfolio summary already have
compatible scope and need no change.

Both affected claim-map rows were re-examined. Their statement, conclusion,
and caution fields now retain the eventuality condition. The rank-t row's old
summary also compressed the finite-radius equivalence into an exact threshold
claim under the radius-dependent outer bound; corrected it to the actual iff
through radius r. The initial batch changes these two rows and their digests. Refreshed with
`python3 lean/verification/refresh_claim_digests.py thm:objectwise-confinement thm:ranked-confinement`
from the paper root. Coverage remains absent for both, with no new terminal.
No Lean source, build, or axiom audit occurred.

## Acceptance, ej + tt, and the full eventuality sweep

The first two corrections pass `make check` at 44 pages, warning-free, with
32 claims and four unchanged Lean terminals. The explicit ej + tt pass checked
whether other eventuality summaries have the same omitted inner restriction.
It found one further instance in `thm:projective-thresholds`: the exact collapsed
threshold C_t was already correct, but its closing sentence could imply
confinement at every fixed radius. Replaced that sentence by the explicit
eventual criterion r<C_t, reviewed the corresponding claim row, and refreshed
that row's digest. This is the third and final changed statement row.

The positive-density and service-rate eventuality sentences refer to minimal
support transfer, which does not need the additive inner condition. The
positive-density coefficient clause separately retains its theorem hypothesis.
The README and introduction already make the outer-distance eventuality precise.
No other hit in this bounded source sweep required a repair. No proof body changes.

### Mystery ledger

No genuine unresolved mathematical mystery remains in this consistency sweep.
The zero-sector perturbation explains every retained inner restriction. The
additional projective ending is task-owned, not an incidental discovery.
The optional structural changes and the remaining C325/C953 gates stay open.

The final deterministic rebuild passes at 44 pages, warning-free. Rendered
pages 28 and 36 were inspected: all three qualified endings are complete and
legible, and the projective table remains intact. The abstract and portfolio
summary are unchanged by this pass.

## Final identity

Authority `32f77d450` was synchronized by the guarded exporter to local
standalone forward commit `6e659b0`. Both release gates pass at 44 pages,
warning-free, 32 claims, and four unchanged Lean terminals. Export verification
passes with 59 tracked files and content SHA-256
`21c53551b190c9b75fbe26cb36d8a07ca14ab9d720ae5ef11669e96a7b3e1219`.
The two PDF hashes match:
`cb5e4f3ba7fd4ae8743bf7064af3e836301f247616a5305ad97380363d71a15b`.
The local standalone worktree is clean. No push or deposit occurred.
