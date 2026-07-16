# Relative-conic lane after C201

**Lane**: `relconic`

**Date:** 2026-07-16
**Status:** READY — C154 is the recommended short publication gate

## Current state

C201 is reported as a negative bounded mechanism gate.  Its archived handoff
is [`done/2026-07-16-c201-even-field-quadratic-rank.md`](done/2026-07-16-c201-even-field-quadratic-rank.md),
and the final synthesis is
[`2026-07-16-c201-bounded-mechanism-closure.md`](../2026-07-16-c201-bounded-mechanism-closure.md).
The tested q=64 families fail at coverage before quadratic rank becomes
informative.  C209 therefore remains dormant.  C210 inherits only the bounded
“coverage first, rank second” design lesson.

The current manuscript was not edited by C201.

## Recommended order

1. **C154 — close the Reed--Muller deep-hole literature residual.**  This is
   the last unsearched qualifier on the paper's load-bearing “deep-hole set is
   a variety” positioning.  It is a bounded literature task and should be done
   before additional theorem work.  Start from
   [`2026-07-14-gem-lit-deep-holes.md`](../2026-07-14-gem-lit-deep-holes.md)
   and the C154 directions in
   [`2026-07-14-c153-c160-queue-rationale.md`](../2026-07-14-c153-c160-queue-rationale.md).
2. **C188 — prove `rho_C(5)=4`.**  The mathematical witness is already
   imported from Clebsch C187, but the relative-conic theorem, strict-kernel
   Lean proof, manuscript/result-table synchronization, and rebuild remain.
   See [`2026-07-15-c188-rhoc5-frame.md`](../2026-07-15-c188-rhoc5-frame.md).
3. **C144 — shared-library gate architecture.**  Run only in a quiescent build
   window; it is infrastructure rather than paper mathematics.
4. **C210 — square-root construction program.**  This is the high-ceiling,
   long-horizon route.  It should begin with construction/literature design,
   not another blind q=64 census.

## Entry action

If the user selects `relconic`, start C154 unless they explicitly choose a
different task.  C154 is a literature task: use the shared literature cache
before fetching sources, keep exact source attribution, and update the paper
only if the residual search changes the claim boundary.

## Durable companions

- C201 discovery track:
  [`2026-07-16-c201-discovery-track.md`](../2026-07-16-c201-discovery-track.md)
- live global queue:
  [`2026-07-07-codex-task-queue.md`](../2026-07-07-codex-task-queue.md)
- prior aggregate relconic map:
  [`2026-07-13-relative-conic-arcs-strengthening.md`](2026-07-13-relative-conic-arcs-strengthening.md)
