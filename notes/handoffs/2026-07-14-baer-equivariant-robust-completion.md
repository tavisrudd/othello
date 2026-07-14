# Handoff: Baer-equivariant robust completion

**Lane**: `baer` — see CLAUDE.md § Lane routing.

**Date:** 2026-07-14
**Status:** COMPLETE — awaiting archive/routing-table disposition
**Tasks:** C134 (closed), C135 (closed)

## Active-lane lock

This is the active sticky lane. Until the user explicitly switches lanes or this handoff is marked
finished, `go` and `next?` refer only to the next step recorded here. Recent commits and global-queue
priorities from other papers do not change that routing.

### Allowed paths

- `lean/FiniteGeom/BaerCompletion/`
- the Baer/Frobenius/Q25 modules under `lean/RelativeConicArcs/`, their aggregate, and their trust
  manifests
- `notes/2026-07-13-c99-*`
- `notes/2026-07-12-riffing-on-applications/paper-baer-equivariant-robust-completion.md`
- `notes/2026-07-12-riffing-on-applications/baer-completion-adversarial-review.md`
- `notes/2026-07-13-baer-completion-adversarial-novelty-review.md`
- `notes/2026-07-14-c135-baer-inverse-equality.md`
- `papers/baer-equivariant-extension/`, `papers/equivariant-robust-completion/`, and the associated
  rows in `papers/papers-index.md`
- this handoff, its future companion archive, and the C133–C135 registry rows in the global queue

### Foreign lanes

The Clebsch-hexagon/Q11 icosahedral paper, relative-conic coding strengthening, twisted-cubic and
RepairCodes papers, unrelated ProjectiveCap/Nofil tasks, and Queens/Othello work are out of scope.
Their commits and working-tree changes may be reported as foreign state but must not be reviewed,
edited, staged, or selected by `next?` without an explicit lane switch.

## Landed result

C99 proves that every Frobenius-invariant eight-arc in `PG(2,25)` admits a fresh conjugate-pair
extension. The exceptional profiles `f=0,2,4` and the strict-count profiles `f=6,8` are all
kernel-checked; the public uniform theorem is `Q25AllProfiles.pair_extension`. The 469,600 normalized
arc census and observed minimum legal-pair count 32 remain external computational evidence and are
not assumptions of the theorem.

Source of truth:

- [`2026-07-13-c99-baer-collision-strengthening.md`](../2026-07-13-c99-baer-collision-strengthening.md)
- [`paper-baer-equivariant-robust-completion.md`](../2026-07-12-riffing-on-applications/paper-baer-equivariant-robust-completion.md)
- [`2026-07-13-baer-completion-adversarial-novelty-review.md`](../2026-07-13-baer-completion-adversarial-novelty-review.md)

## Closed path — C133

C99.6 is valid generically and kernel-checked:

> A cross-pair secant orbit is invisible on at least `s+3-f-e` empty fixed carriers.

`QuadraticInvisible.card_occupied_through_crossPair_center_le` injects occupied center-lines into
the `f` selected fixed points plus all conjugate selected-point orbits except the two participating
endpoint orbits, giving `f+(e-2)`. The final theorem
`s_add_three_sub_f_sub_e_le_card_empty_through_crossPair_center` derives `e≥2` from the cross-pair
witness and subtracts from the `s+1` fixed lines through the center. Scoped build, forbidden-token,
and axiom audits pass; the axiom profile is exactly `[propext, Classical.choice, Quot.sound]`.

## Closed path — C134

The bounded zbMATH Open, Crossref, OpenAlex, and source-level search located no exact precursor for
the uniform `PG(2,25)` theorem. The strongest adjacent sources prove ordinary one-point
extendability, classify complete arcs, transfer Frobenius-invariant incidence data in the Hughes
plane, count small arcs, or treat ordinary MDS lengthening; none forces a fresh legal conjugate
pair. The result may be described only as “no exact precursor located in a bounded search,” never
as a certified first. Full queries, limitations, and source comparisons are recorded in the
[C134 priority section](../2026-07-13-baer-completion-adversarial-novelty-review.md#c134-bounded-priority-search--uniform-pg225-theorem).

## Closed path — C135

The exact collision balance now has kernel-checked inverse forms. Equality holds exactly when every
secant-orbit center avoids every empty fixed carrier and each visible orbit-to-candidate charge is
injective. More generally, first-order excess `k` is exactly the sum of center/empty-carrier
incidences and collision redundancy. The census and observed minimum remain external computational
evidence.

Report: [`2026-07-14-c135-baer-inverse-equality.md`](../2026-07-14-c135-baer-inverse-equality.md).

## Remaining optional gate

Keep the census/minimum computational by default; certify them only if publication needs them. This
is not an open task in the lane.
