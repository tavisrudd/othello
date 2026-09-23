# C1214 — Datalog checker mutation tests and independent completeness

**Lane**: `ergodis`
**Date**: 2026-09-22
**Status**: IN PROGRESS — milestone a bounded fixtures delivered and reviewed (core `b1b3686`); milestone b remains open.
**Authority**: `notes/2026-09-22-c1208-follow-up-triage.md` (approved allocation and order).

Approved C1208 alloc-2. Two separately reviewable milestones; use C1205 milestone a's
delivered byte-door fixtures. Its completion permits the test-only milestone immediately
after C1210; extend those tests when C1213 migrates formats. This is distinct from C1205's
new-door tests, and does not wait for the format migration to start.

## Milestone a — tests first

Current implementation and coverage record: `2026-09-22-ergodis-phase2-remediation.org`.

Delivered: 128 tiny sources, 1,024 independent closure comparisons across both
formats/source doors/store layouts, exact mutation rejection families and retained
decoder/source bounds. Gates pass; source review accepted by Astra. The report
states unary/fixed-grammar limits and the unchanged shared production completeness
pass. No general completeness or formal soundness claim follows from the tests.

Build checker-crate fixtures and mutate both certificate families, including cases no
producer emits: support/rank errors, missing/extra/duplicate facts, bad premises and
indices, source mismatches, incomplete closure, n-ary bodies and decoder bounds. State
the tested finite domain; independently compute expected tiny closures. Show each
mutation family is exercised and rejected for the intended reason, not an earlier
unrelated failure. Retain minimized regressions.

## Milestone b — independent completeness

Write one checker's closed-world/completeness pass independently of the shared pass,
with its own algorithmic explanation and tests. Name remaining shared admission, stores
and helpers; do not claim full implementation independence. Keep witness checking and
completeness distinct. Compare against the bounded oracle and deliberate omissions,
including cyclic and n-ary programs; measure time/memory and comply with performance rules.

## Acceptance and ownership

Milestone a lands before milestone b. Report mutation coverage, known shared trust and
all retained failures. Coordinate C1196 so compact encodings do not silently bypass the
suite. Core verify owns checker code; contract owns formats, not the verdict.
Dated report per milestone; no formal soundness claim from tests alone.

## Closeout

Write the dated task report and follow `notes/task-lifecycle-conventions.md` at completion.
Follow local repository instructions and the professional source-comment standard.
