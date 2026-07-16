# Handoff: Baer-equivariant robust completion

**Lane**: `baer` — see CLAUDE.md § Lane routing.

**Date:** 2026-07-14
**Status:** FINISHED — the Baer core (C99 and C133–C141) is reported; publication upgrades continue
in the `alt-orbit-repair` successor lane
**Tasks:** C99, C133–C141 (closed)

> **LIVE-DOC WARNING — DO NOT LOG HERE.** This file is only the lane's important context and live
> routing map. Never append session history, build output, dated progress, validation transcripts,
> superseded plans, review chronology, or amendment trails here. Put them in
> [the companion archive](done/2026-07-14-baer-equivariant-robust-completion-archive.md) and keep
> this file written as the current final state.

## Routing state

The Baer core lane is finished. Its same-paper successor is `alt-orbit-repair`, routed through
[the alternate-orbit handoff](2026-07-14-alternate-orbit-repair.md). Archiving this handoff closes
only the foundational lane; it does **not** freeze or archive the
`papers/equivariant-robust-completion/` manuscript. Do not route `go baer` into successor work
implicitly—the user must select `alt-orbit-repair`.

While this handoff remains live, Baer-owned paths are the modules under
`lean/FiniteGeom/BaerCompletion/`, the Baer/Frobenius/Q25 modules under
`lean/RelativeConicArcs/`, the C99/C133–C141 reports, and
`papers/baer-equivariant-extension/` plus `papers/equivariant-robust-completion/`. Changes from all
other lanes remain foreign.

## Final result

C99 proves that every Frobenius-invariant eight-arc in `PG(2,25)` admits a fresh conjugate-pair
extension. All five fixed-point profiles are kernel-checked, and the public uniform theorem is
`Q25AllProfiles.pair_extension`. C136 identifies the semantic finset of fresh legal conjugate pairs
with the carrierwise union and with `PairExtensionData.legalCount`.

The general theory includes the carrierwise lower bound, exact collision correction, C133's
cross-pair invisibility bound, and C135's algebraic equality/excess classification. The 469,600-arc
census and its observed minimum 32 are external computational evidence, not assumptions of the
theorem and not claims of this finished lane.

The scoped declarations are kernel-checked without `sorry`, `admit`, or custom axioms; their
expected axiom profile is `[propext, Classical.choice, Quot.sound]`.

## Publication state and successor

The Baer core produced a complete focused submission artifact presenting the quadratic-Frobenius
structural criterion, exact collision correction, the all-prime-power consequence, and the uniform
Q25 theorem. The `alt-orbit-repair` lane subsequently strengthened that same paper with robust
deletion/replacement, the exact profile envelope, parameterized exchange, and the active Q25
extremal-classification program. Its handoff is authoritative for the manuscript's current upgrade
state. Generic completion material and the classical-radius table remain outside the paper's scope.

The bounded literature work found special-family exact completion and configuration-graph
predecessors, but no exact precursor for the arbitrary quadratic-Frobenius orbit-valued criterion.
Use only “no exact precursor located in a bounded search” or similarly qualified wording; never
make a historical-first claim. C135 is an algebraic equality/excess theorem, not a stronger
geometric structural inverse theorem.

The authoritative context is:

- [C99 result and trust report](../2026-07-13-c99-baer-collision-strengthening.md)
- [paper plan and theorem map](../2026-07-12-riffing-on-applications/paper-baer-equivariant-robust-completion.md)
- [adversarial novelty review](../2026-07-13-baer-completion-adversarial-novelty-review.md)
- [C135 inverse/equality report](../2026-07-14-c135-baer-inverse-equality.md)
- [companion archive](done/2026-07-14-baer-equivariant-robust-completion-archive.md)

## Closed task map

C99 and C133–C141 are reported. Their execution details and dispositions are in the reports and
companion archive, not here. The former optional census/minimum certification was allocated as C151
to `alt-orbit-repair`; it is not an open task in this finished foundational lane.
