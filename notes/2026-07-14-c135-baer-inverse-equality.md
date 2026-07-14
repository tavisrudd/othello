# C135 — Baer inverse/equality classification

**Date:** 2026-07-14
**Lane:** `baer`
**Status:** REPORTED

## Goal

Classify equality and near-equality in the exact aggregate collision balance

```text
L + E M = E N + B + R.
```

The first exact target is the zero-correction inverse theorem: equality in the first-order bound
holds exactly when every obstruction orbit is visible on every carrier and every visible charge
map is collision-free. The quadratic specialization should identify visibility with the existing
fixed-center/carrier incidence predicate and retain the existing candidate semantics.

The census size and observed minimum legal-pair count remain external computational evidence and
are not part of C135.

## Result

The abstract inverse theorem is now kernel-checked in
`FiniteGeom.BaerCompletion.CollisionProfile`:

- `invisibleOrbits_eq_empty_iff` identifies zero invisible mass with `orbits ⊆ visible`;
- `collisionRedundancy_eq_zero_iff` identifies zero collision redundancy with
  `Set.InjOn charge visible`;
- `aggregate_firstOrder_equality_iff_universal_visibility_and_collisionFree` lifts both local
  criteria to equality in the aggregate first-order bound;
- `aggregate_firstOrder_excess_eq_iff_correction_eq` classifies every near-equality level `k`:
  first-order excess `k` is exactly aggregate invisible mass plus collision redundancy.

The quadratic specialization is kernel-checked in `QuadraticCollision` and
`QuadraticInvisible`. Its final geometric forms are:

- `aggregate_firstOrder_equality_iff_centers_avoid_carriers_and_collisionFree`: equality holds
  exactly when every secant-orbit center avoids every empty fixed carrier and each visible
  orbit-to-candidate charge is injective;
- `aggregate_firstOrder_excess_eq_iff_centerIncidence_add_redundancy_eq`: excess `k` is exactly
  the total number of center/empty-carrier incidences plus aggregate collision redundancy.

Thus the existing exact balance has both a sharp equality classification and a quantitative
near-equality classification, without importing the census or its observed minimum.

## Validation

Scoped builds passed:

```text
choom -n 1000 -- nix develop --command lake build FiniteGeom.BaerCompletion.CollisionProfile
choom -n 1000 -- nix develop --command lake build RelativeConicArcs.QuadraticCollision
choom -n 1000 -- nix develop --command lake build RelativeConicArcs.QuadraticInvisible
```

`#print axioms` on the two abstract and three principal quadratic declarations reports exactly
`[propext, Classical.choice, Quot.sound]`.
