# C1218 — Private Rel crate boundary and frontend instrumentation

**Lane**: `ergodis`
**Date**: 2026-09-22
**Status**: QUEUED — allocated by Tavis from C1208.
**Authority**: `notes/2026-09-22-c1208-follow-up-triage.md` (approved allocation and order).

Approved C1208 alloc-7. Mechanical extraction after C1205 milestone c leaves one backend
route. Scope the provider boundary early enough for C1216, without requiring ABI code here.

## Scope

Extract a std-only frontend crate and a core-dependent lowering/driver crate within the
private workspace. Retarget the bare-rustc parity harness to the frontend entry point;
remove the Rel subsystem's unnecessary whole-ergodis dependency where the actual cut permits.
Feature-gate frontend measurement aids. Keep all private implementation private.

## Acceptance

- Dependency inventory demonstrates the two boundaries and the actual core dependencies;
  no core-to-private edge, broad re-export workaround or duplicate backend.
- Bare-rustc parity, default/instrument builds, native/WASM conformance, reference
  differential and allocation gates pass on the moved code.
- Canonical bytes and semantics stay unchanged. Source-based identity changes are
  separately reported; no historical evidence is silently re-pinned.
- Inspect and measure cross-crate hot accessors/inlining: C1209 showed a move can lose
  inlining. Required matched stage and evaluator performance gates pass.
- Document how the result supports C1216's private provider, without preselecting an
  unapproved provider decomposition.

Dated move inventory, validation report and updated private module map. This remains lower
urgency than transferable evidence; early boundary scoping is not permission to extract
before C1205 c.

## Closeout

Write the dated task report and follow `notes/task-lifecycle-conventions.md` at completion.
Follow local repository instructions and the professional source-comment standard.

