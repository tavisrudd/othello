# Relative-conic lane after C201

**Lane**: `relconic`

**Date:** 2026-07-16
**Status:** C210 ACTIVE — Baer-transversal square-root design selected

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

1. **C210 — square-root construction program.**  The initial mechanism audit proves an
   infinite-family obstruction for arcs contained in one Baer subplane and selects the genuinely
   Baer-transversal route. The first two-layer parabola family is a uniform conic-disjoint `2s`-arc
   and an ordinary complete 6-arc at `s=3`, but direct relative coverage fails for `s=4,5,7,8`.
   Greedy completion remains near `3s` in the larger tested fields. A full parabola repair layer on
   a nontrivial additive coset succeeds sporadically at `s=5`, nearly succeeds at `s=4`, but has no
   arc-legal instance at `s=7`; that uniform mechanism is closed. Next derive the collision and
   coverage equations for a graph or partial-coset repair of at most `s` points. Those equations
   now reduce internal arc legality to the second-divided-difference condition
   `1+g[r,s,u] != 0`; full affine-height graphs add nothing beyond the constant layers throughout
   the five tested orders. For quadratic heights, each
   two-repair/one-seed collision is equivalent to one subfield quadratic splitting distinctly.
   Twelve genuinely nonlinear `3s=24` repair arcs survive at `s=8`, all with nineteen uncovered
   points; two points at infinity complete the best to an ordinary 26-arc. No nonlinear layer
   survives at `s=3,4,5,7`. Next normalize the twelve survivors under the conic stabilizer, seed
   exchange, and Frobenius and identify their trace/norm pattern; do not widen the order census. See
   [`2026-07-16-c210-square-root-mechanism-audit.md`](../2026-07-16-c210-square-root-mechanism-audit.md).

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
