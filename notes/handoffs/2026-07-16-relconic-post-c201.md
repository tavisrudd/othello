# Relative-conic lane after C201

**Lane**: `relconic`

**Date:** 2026-07-16
**Status:** C144, C188, and C223 REPORTED — per-lane, registry, and paper gates pass

## Current state

C201 is reported as a negative bounded mechanism gate.  Its archived handoff
is [`done/2026-07-16-c201-even-field-quadratic-rank.md`](done/2026-07-16-c201-even-field-quadratic-rank.md),
and the final synthesis is
[`2026-07-16-c201-bounded-mechanism-closure.md`](../2026-07-16-c201-bounded-mechanism-closure.md).
The tested q=64 families fail at coverage before quadratic rank becomes
informative.  C209 therefore remains dormant.  C210 inherits only the bounded
“coverage first, rank second” design lesson.

The current manuscript was not edited by C201.

C154 is now reported in
[`2026-07-16-c154-reed-muller-deep-holes.md`](../2026-07-16-c154-reed-muller-deep-holes.md).
The dedicated Reed--Muller pass found exact descriptions by bent functions, Hamming association
subschemes, explicit maximizers, and affine/coset types, but no complete deep-hole locus equal to
the full rational-point set of a named positive-dimensional variety.  The precise bounded-audit
novelty posture survives.  The paper needed no claim-boundary change; its conclusion received one
independent proof-stage copyedit requested by the user.

C144 is reported in
[`2026-07-14-c144-shared-library-gate-architecture.md`](../2026-07-14-c144-shared-library-gate-architecture.md).
Import-only validation targets now separate the relconic, Baer, and alternate-orbit closures; the
alternate-orbit lane uses three compatible modules because its independently compiled terminals
cannot all share one Lean environment. Build orchestration and notification mechanics remain owned
by the `build-sys` lane.

## Recommended order

1. **C210 — square-root construction program.**  This is the high-ceiling,
   long-horizon route.  It should begin with construction/literature design,
   not another blind q=64 census.

## Entry action

If the user selects `relconic`, C188 and C223 need no residual work. Read the nested Lean guide
before any new Lean edit, generator run, build, or staleness probe.

## Durable companions

- C201 discovery track:
  [`2026-07-16-c201-discovery-track.md`](../2026-07-16-c201-discovery-track.md)
- live global queue:
  [`2026-07-07-codex-task-queue.md`](../2026-07-07-codex-task-queue.md)
- prior aggregate relconic map:
  [`2026-07-13-relative-conic-arcs-strengthening.md`](2026-07-13-relative-conic-arcs-strengthening.md)
