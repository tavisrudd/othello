# C1217 — Lean relational support and completeness argument

**Lane**: `ergodis`
**Date**: 2026-09-22
**Status**: QUEUED — allocated by Tavis from C1208.
**Authority**: `notes/2026-09-22-c1208-follow-up-triage.md` (approved allocation and order).

Approved C1208 alloc-6. After C1211 states the relational certificate argument; reconcile
the formal statement with C1214's checker contracts and C1205's construction evidence.

## Scope and acceptance

State and formalize the finite Boolean relational support argument: valid rooted/ranked
support establishes derivability; closure/completeness plus admitted input facts establishes
the least fixed point. Expose finiteness, rank and rule-admission premises explicitly.
Record which concrete trace/ranked certificate fields discharge which premises.

Include the statement of per-column complement-domain exactness and identify its additional
range-restriction/layer premises; connect to C1205's documented argument. Do not silently
extend a positive-rule theorem to stratified negation or weighted optimization. C1211 owns
the weighted design; any weighted formalization beyond its agreed scope needs a scoped plan.

Before any Lean operation read ../lean/AGENTS.md from the monorepo context and use only its
guarded entry point. Consult the applicable expert routing before nontrivial proof work.
Required guarded checks and axiom/coverage report, exact theorem-to-implementation limits,
dated report, and the required ej/tt Mystery ledger closeout.

No claim that Rust is mechanically verified merely because the abstract theorem is proved.

## Closeout

Write the dated task report and follow `notes/task-lifecycle-conventions.md` at completion.
Follow local repository instructions and the professional source-comment standard.
