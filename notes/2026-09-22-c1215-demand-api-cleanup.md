# C1215 — Demand builder and Datalog/Rel API cleanup

**Lane**: `ergodis`
**Date**: 2026-09-22
**Status**: COMPLETED 2026-09-22 — replay repair `ca52a3e` and the API migration (core `a63b444` / `8aec9ab`, private `0f41eb4`) are kept under separate user-approved performance exceptions. Functional/exactness gates pass. The full matrix's small instruction losses and timing/cache limits remain recorded in `2026-09-22-c1215-api-migration.org`; replay evidence is in `2026-09-22-c1215-replay-shape-validation.org`.
**Authority**: `notes/2026-09-22-c1208-follow-up-triage.md` (approved allocation and order).

Approved C1208 alloc-3. After C1205 milestone a's source enum and byte door; use C1213's
format. Prefer before any separately allocated growing-index successor.

## Scope

Current audit and bounded regression work: `2026-09-22-ergodis-phase2-remediation.org`.

Private `ec7bb32` replaces the two panic characterizations from `6e31900` with
explicit rejection, shared record/readout/closure validation and bounded adjacent
regressions. Native gates pass (116 relevant tests, formatting and Clippy).
`2026-09-22-c1215-replay-shape-validation.org` records the repair and limitations:
replay consistency does not authenticate missing source/layer certificates. The
whole private root still fails wasm32 compilation on its Unix control-plane
dependency. The trusted admitted fast path remains unchanged.

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
native measurement are documented; measured losses are kept under the scoped
exception recorded in the dated report. Preserve bytes/identities except explicitly approved format
changes owned by C1213; source-hash changes are reported separately. No dispatch or
measurement overhead enters hot loops.

Dated report with old/new API mapping and remaining caller obligations. Frontend
instrumentation is owned by C1218, not this task.

## Closeout

The dated API report records the scoped user exception, retained matrix and
remaining platform limits. The task row moved to the queue archive once; the
ergodis handoff now selects C1211.
