# C1210 — Datalog/Rel small repairs, cleanup first

**Lane**: `ergodis`
**Date**: 2026-09-22
**Status**: IN PROGRESS — cleanup-first implementation, coordinated/reviewed by the main
agent with Terra/Sol implementation assistance as requested by Tavis. Report:
`notes/2026-09-22-c1210-small-repairs-report.md`.
**Authority**: `notes/2026-09-22-c1208-follow-up-triage.md` (approved allocation and order).

Approved C1208 bundle (report section 4); Tavis requested small, low-risk cleanup first.
Work in core and private only at the cited sites and their tests/receipts. Read their local
AGENTS.md and the Ergodis performance guides before source work.

## Ordered milestones

1. Documentation and byte-preserving cleanup, separately committed by repository:
   correct the checker-independence claims (shared admission, stores, unification and
   completeness; independent trace-following versus search), correct fact_count for both
   routes, document Rule.order/Rir::join_order as chain-shape hints with core owning join
   order, and state the reference evaluator's comparisons/aggregates coverage and its shared
   scanner/parser/admission blind spot. Split Literal.reserved into two named u32 fields
   without changing its 32-byte stride or canonical emission order. Name the chain buffer
   constant without changing its value. Resolve moved certificate types in ergodis-contract.
2. Stage sequencing: first behavioral change, its own commit. Invalidate admission when a
   new parse starts and refuse lowering without valid successful admission for the current
   generation. Test fresh/unadmitted use, parse(a)/admit(a)/parse(b)/lower(b), failed
   admission, recovery, and the chosen wrap behavior. Do not claim a generation counter
   establishes arbitrary caller-supplied source-byte identity; document the remaining API
   precondition or enforce it without silently broadening the repair.
3. Record changes, separate from the above: add body_policy to bench receipts under v1,
   using rel-lower's spelling; add the three missing lowering counters to parity records
   under ergodis.rel_frontend_portability.v2 and record the regenerated digest.

## Acceptance

- Milestone 1 leaves canonical bytes, fingerprints and parity digest unchanged. State
  contract/checker identity changes honestly: comments can move the package hashes.
- Milestone 2 has a rejecting REL05xx regression, the allocation gate and required stage A/B.
- Milestone 3 updates readers/writers and records the intentional parity schema/digest change.
- No behavior, schema or certificate migration is hidden in the documentation commit.
- Professional source comments; no unrelated comment sweep. C1206 owns budget documentation.
- Dated report with per-item evidence and commit boundaries. Use current retained controls
  from C1209, re-retaining when required, rather than stale pre-split binaries.

This order supersedes the earlier recommendation to put the sequencing fix ahead of all
cleanup; it remains the first behavioral repair. No change is literally risk-free.

## Closeout

Write the dated task report and follow `notes/task-lifecycle-conventions.md` at completion.
Follow local repository instructions and the professional source-comment standard.
