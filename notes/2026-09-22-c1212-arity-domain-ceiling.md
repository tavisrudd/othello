# C1212 — Arity-dependent Datalog domain ceiling

**Lane**: `ergodis`
**Date**: 2026-09-22
**Status**: QUEUED — allocated by Tavis from C1208.
**Authority**: `notes/2026-09-22-c1208-follow-up-triage.md` (approved allocation and order).

Approved C1208 alloc-5. Coordinate with C1206's structured refusal record; preferred
execution after that record exists. Complete before C1195 fixes cohort sizes.

## Scope

Replace the blanket 65,536 domain cap with a largest-arity-dependent representability rule
shared in meaning by wire/prepared admission and the private value dictionary. Work in
ergodis-contract admission, the evaluator/checker consumers only as needed, and the private
lowering/driver guards. Keep resource bounds distinct from key representability.

## Acceptance

- State the exact domain cardinality and maximum value, including whether all 2^32 distinct
  values can be represented with the chosen domain field. Do not promise the full range
  merely because terms are u32.
- Preserve the valid arity-four endpoint: count 2^64 is not representable in u64, but its
  largest packed key is. Treat saturating universe estimates separately from exact counts.
- Boundary tests for arities 1–4, both admission doors, key injectivity at boundary samples,
  private/core agreement, and correctly attributed domain refusals.
- No huge dense allocation is required by accepting a large sparse domain; test practical
  sparse cases and the existing memory/capacity refusals.
- Existing admitted programs retain semantics and identities unless an explicit format
  dependency requires migration; report any such interaction with C1213 before landing.
- Required correctness/allocation/performance gates and a dated report with exact reach.

No widened arithmetic carrier, new index strategy or benchmark-suite implementation.

## Closeout

Write the dated task report and follow `notes/task-lifecycle-conventions.md` at completion.
Follow local repository instructions and the professional source-comment standard.
