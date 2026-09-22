# C1213 — Datalog schema and contract/checker provenance

**Lane**: `ergodis`
**Date**: 2026-09-22
**Status**: QUEUED — allocated by Tavis from C1208.
**Authority**: `notes/2026-09-22-c1208-follow-up-triage.md` (approved allocation and order).

Approved C1208 alloc-4, refined after C1209. C1205 milestone a was recorded complete during
allocation (2026-09-22): migrate its delivered byte interface, do not redo it. Complete before
C1195 freezes artifacts. C1196 builds on the resulting contract.

## Scope

Give the Datalog admission language its own schema string rather than sharing the grounded
language's string. Specify provenance for both Datalog certificate families using C1209's
separate contract and checker identities. Work in contract types/encoding, checker records,
producers and narrowly affected fixtures/docs across core/private.

## Acceptance

- Distinguish a producer's certificate metadata from a verification record emitted only
  after successful checking. A supplied checker identity is not proof checking occurred.
- Specify what each identity binds, compatibility and mismatch behavior, and which fields
  belong in certificate versus verification record. Include admission's contract identity.
- Preserve the grounded language's meaning; inventory exactly which wire identities and
  certificates change and regenerate the affected fixtures/receipts honestly.
- Keep PREPARED_SCHEMA and existing prepared source identities stable unless a separately
  justified decision requires otherwise; C1205 currently promises their preservation.
- Tests discriminate grounded/Datalog schemas, malformed/unknown versions, provenance
  mismatches and certificates from both wire/prepared regimes.
- Carry a migration table and replay evidence, including the regression-seed handling;
  do not re-pin historical measurements as though they were rerun.
- Coordinate the final format with C1205 a and C1196; required gates pass.

The approved direction is distinct schema plus explicit provenance. Resolve record placement
in the design section before implementation; do not conflate identity with acceptance.

## Closeout

Write the dated task report and follow `notes/task-lifecycle-conventions.md` at completion.
Follow local repository instructions and the professional source-comment standard.
