# C1215 — Demand builder and Datalog/Rel API cleanup

**Lane**: `ergodis`
**Date**: 2026-09-22
**Status**: IN PROGRESS — initial trust-boundary audit under architecture Phase 2; the larger API migration remains open.
**Authority**: `notes/2026-09-22-c1208-follow-up-triage.md` (approved allocation and order).

Approved C1208 alloc-3. After C1205 milestone a's source enum and byte door; use C1213's
format. Prefer before any separately allocated growing-index successor.

## Scope

Current audit and bounded regression work: `2026-09-22-ergodis-phase2-remediation.org`.

- Consolidate Demand construction into a builder with production defaults.
- Expose one checker entry point over the source enum, retaining a clearly documented
  in-process admitted fast path where needed.
- Add a driver options struct and record body/index policies per layer.
- Rename the ambiguous Prepared type at its public boundary and update all owned callers.
- Put measurement-only Policy corners, counted entry point, plan reports and reservations()
  behind an instrument feature; production Auto and genuine product configuration remain
  usable without instrumentation.
- API-boundary id newtypes are optional only where their concrete benefit justifies the
  churn; do not broaden into internal identifier rewrites.

## Acceptance

Default and instrument builds work; tools explicitly opt into measurement APIs. All
constructor/entry-point call sites are migrated with no accidental production dependency
on the feature. Both source regimes, layer policy records, allocation gates and matched
native performance pass. Preserve bytes/identities except explicitly approved format
changes owned by C1213; source-hash changes are reported separately. No dispatch or
measurement overhead enters hot loops.

Dated report with old/new API mapping and remaining caller obligations. Frontend
instrumentation is owned by C1218, not this task.

## Closeout

Write the dated task report and follow `notes/task-lifecycle-conventions.md` at completion.
Follow local repository instructions and the professional source-comment standard.
