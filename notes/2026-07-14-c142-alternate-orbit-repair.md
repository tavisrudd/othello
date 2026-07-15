# C142 — alternate-orbit repair

**Date:** 2026-07-14
**Lane:** `alt-orbit-repair`
**Status:** REPORTED — certificate-free repair theorem and nonexceptional Q25 bounds complete

## Goal

Turn the semantic legal-pair count for invariant eight-arcs into an erasure-repair theorem for
invariant ten-arcs.  The replacement must differ from the selected nonfixed Frobenius orbit that
was deleted.

## Result

Let `A` be an invariant ten-arc over a quadratic extension, and let `q` be any selected nonfixed
Frobenius orbit contained in `A`.  The formal deletion `D = A \ q.toFinset` is an invariant
eight-arc, and `q` itself belongs to the semantic global legal-pair finset of `D`.

If the base-field order is at least seven, the checked quadratic count gives at least nine legal
pairs for `D`.  Removing the one restoration pair `q` leaves at least **eight alternate repairs**.
The quantifier is over every selected nonfixed orbit, not merely the existence of a repairable
deletion.

Over base order five, the existing nonexceptional profile bounds transport to the following
alternate-repair counts:

| Fixed profile of `D` | Total legal pairs | Alternate repairs after excluding `q` |
|---:|---:|---:|
| 0 | at least 5 | at least 4 |
| 4 | at least 4 | at least 3 |
| 6 | at least 36 | at least 35 |
| 8 | at least 110 | at least 109 |

The exceptional `f=2` profile is deliberately absent.  Its current certificate proves existence
of one legal pair, which may be the erased orbit itself; C143 owns the gated two-witness upgrade.

## Formalization

[`AlternateOrbitRepair.lean`](../lean/RelativeConicArcs/AlternateOrbitRepair.lean) is the
certificate-free core.  It defines selected unordered nonfixed Frobenius orbits, semantic orbit
deletion, and the alternate legal-pair finset.  Its paper-facing declarations are:

- `delete_selected_nonfixed_orbit`, which proves the arc, invariance, cardinality-eight, and
  restoration-pair facts simultaneously;
- `nine_le_card_globalLegalPairs_of_card_eight`, the uniform eight-arc multiplicity theorem; and
- `eight_le_alternateLegalPairs_of_seven_le`, the arbitrary-deletion repair theorem.

[`Q25AlternateOrbitRepair.lean`](../lean/RelativeConicArcs/Q25AlternateOrbitRepair.lean) is a
separate order-five wrapper.  This split keeps the `s ≥ 7` theorem free of generated-certificate
imports.  It reindexes the existing bundled carrier sum to the semantic global finset and proves
`four_le_alternateLegalPairs_profile_zero`, `three_le_alternateLegalPairs_profile_four`,
`thirty_five_le_alternateLegalPairs_profile_six`, and
`one_hundred_nine_le_alternateLegalPairs_profile_eight`.

## Validation and trust

The scoped build was pinned to core 22 and capped at one Lean worker because another Lean aggregate
was already running:

```text
LEAN_NUM_THREADS=1 choom -n 1000 -- taskset -c 22 nix develop --command bash \
  -lc 'export LEAN_NUM_THREADS=1; exec lake build \
    RelativeConicArcs.AlternateOrbitRepair \
    RelativeConicArcs.Q25AlternateOrbitRepair'
```

It completed successfully, rebuilding the two new modules in 5.6 and 4.4 seconds.  A subsequent
`lake build --no-build` probe reported `All targets up-to-date (3288 jobs)`.

A declaration-level `#check` and `#print axioms` audit covered the deletion bridge, the nine-pair
theorem, the headline eight-alternative theorem, and all four Q25 profile conclusions.  Every
audited declaration reports exactly

```text
[propext, Classical.choice, Quot.sound]
```

The two sources contain none of `sorry`, `admit`, `axiom`, `unsafe`, or `native_decide`, and
`git diff --check` passes.

## Manuscript audit

The manuscript now defines alternate-orbit repair and states two numbered corollaries matching the
Lean declarations:

- arbitrary selected-orbit deletion leaves at least nine total and eight alternate legal pairs for
  every prime-power base order `s ≥ 7`;
- the four nonexceptional Q25 profiles have alternate bounds `4, 3, 35, 109`.

It explicitly withholds a uniform Q25 repair theorem pending C143 and makes no historical-priority
claim.  Tectonic rebuilt
[`frobenius_pair_extension.pdf`](../papers/equivariant-robust-completion/frobenius_pair_extension.pdf)
without errors; its SHA-256 is
`df38138b947b0648f4dc834aea3a4922a827eab5882ac60366ff449ae4d0aafe`.

## Discovery Track disposition

Two unplanned leads are retained in the live handoff rather than promoted here: exact profile
minimization suggests a much stronger uniform 318-alternative bound at the smallest permitted order
`s=7`, and
orbit swaps define a high-branching reconfiguration graph on invariant ten-arcs.  Both remain
`LEAN-OPEN` and `LIT-OPEN`; neither appears in the manuscript.
