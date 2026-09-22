# C1211 — Min-plus relational evaluator and certificate design memo

**Lane**: `ergodis`
**Date**: 2026-09-22
**Status**: QUEUED — allocated by Tavis from C1208.
**Authority**: `notes/2026-09-22-c1208-follow-up-triage.md` (approved allocation and order).

Precursor to C1194; approved C1208 alloc-1. Documentation/design only, before min-plus code.
Read the architecture map, C1194 and the current core/private rules and performance contract
before proposing implementation details.

## Scope and acceptance

- Compare weighted Demand reusing plans/indexes/workspace against a second kernel, with
  concrete data flow, memory/setup costs, update semantics and native/WASM implications.
- Specify cost-bearing facts, carrier/sentinel behavior, termination premises, and what a
  min-plus relational certificate asserts and carries; the grounded certificate is not
  automatically a certificate for the demand path.
- State the Boolean relational support argument on paper, separating support soundness
  from closure/completeness; identify the weighted extension and its evidence gaps.
- Include worked recursive cost examples and a distinguishing counterexample for each
  rejected shortcut. Name changes to the prepared seam and the oracle needed by C1194.
- Present one recommendation with alternatives and consequences; Tavis approves the
  evaluator/certificate architecture before C1194 implements it. Allocating this memo
  does not preselect weighted Demand or the second kernel.
- Update C1194's implementation scope only to reflect the approved decision. C1217 owns
  Lean formalization; do not run Lean for this document task.

Deliverable: dated design report and the resulting C1194 gate/decision reference.

## Closeout

Write the dated task report and follow `notes/task-lifecycle-conventions.md` at completion.
Follow local repository instructions and the professional source-comment standard.

