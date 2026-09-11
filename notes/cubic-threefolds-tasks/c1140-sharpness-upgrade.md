# C1140 — sharpness upgrade

**Lane:** cubic-threefolds

**Status:** complete, 2026-09-11; integrated, reviewed, checked and exported locally.

## Ownership

This is a new upgrade task, not a continuation of C956's existing manuscript
referee cycle. The author corrected that distinction on September 11.
Allocation: global reservation sequence 544. Authority:
`papers/cubic-stabilization-irrationality/`.

The pre-integration work remains committed under its original filenames:
`../2026-09-11-c956-sharpness-upgrade-audit.md`,
`../2026-09-11-c956-sharpness-ej-tt.md`, and the adjacent input/checker,
certificate, source search and independent referee reports. Their owning
implementation successor is C1140. Do not rename the frozen evidence bundle.

## Deliverable

Integrate the audited uniform three-parameter cubic family and the explicitly
separated arithmetic pencil. Keep the cubic example, independent surface upper
bound, exact level, and separated fourfold consequence intelligible to adjacent
geometers. Preserve the existing quotient and finite-index proofs and the
original AI disclosure verbatim. Use September 2026 and consistent title case.

Fix nonsplit evaluation wording where relevant, add the no-exceptional-line
bridge, preserve cubic/surface field quantifiers, and pin current companion
lower-bound/Hodge-conservation and precise reduction references. The integer
family is the main arithmetic result; optional height/S-unit/extended-action
material must not overload that route. Do not claim full moduli cancellation,
an implemented S-unit solver, a product principal polarization, an independently
verified companion proof, or exhaustive priority certification.

## Gates

1. Source interfaces and written deductions checked against the two audit reports.
2. New mathematical statements registered as formally absent; no manual Lean work.
3. Exact checker/evidence integration, existing twenty-quadric checks retained,
   metadata and all paper checks passing; source/certificates/hashes coherent.
4. Abstract at most 200 words; README and verification guide reflect final scope.
5. Fresh cold referee review of the integrated paper, repair and targeted re-review.
6. Clean typeset and rendered page inspection; retain prior PDF for comparison.
7. Update task/handoff and commit coherent changes. Synchronization follows the
   repository export conventions; no push or deposit.

## Current state

All seven gates passed. The integrated paper has 24 pages and a 142-word
abstract. Fresh mathematical review and two independent reader comparisons
were followed by repairs and accepted targeted rechecks. SGA7 reduction
pinpoints close the prior source placeholder. Authority and standalone checks
pass; PDFs are byte-identical. Source bundle `a2e59e9eb`, standalone `c7576a7`,
portfolio `b7cb8bb`. No push/deposit. No independent companion-proof or full
symbolic second-implementation claim is made.

Report: `../2026-09-11-c1140-integration.md`. C956 remains separately open.
