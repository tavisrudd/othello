# C864 — is the order-eleven point-orbit data module certificate payload?

**Date:** 2026-08-04
**Lane:** `build-sys`
**Question left open by** `notes/2026-08-04-c864-q11-split-feasibility.md`: whether
`RelativeConicArcs/Q11A5PointOrbitsData.lean` stays in the monorepo, keeping the four audited
point-orbit statements verbatim, or the statements are reformulated intrinsically so the data can
leave with the rest of the family.

**Verdict: the module is two things, and the cut runs between them.** Its group-action half is
certificate payload and leaves with the row leaves. Its displayed-block half is the interface and
stays. No statement has to be reformulated, and the paper-facing surface is preserved verbatim.

## Why the action half is payload

The module declares sixty explicit `3 × 3` matrices over `F_11` as a row-major code, the sixty
corresponding permutations of the six witness directions, the entry/vector/determinant accessors,
the canonical-index normalization, the projective action `pointAction`, iterated support powers,
the order-five predicate, per-element fixed-point sets, their order-five union, and the image
`pointOrbit`. It also declares four tactic macros — `q11_witness_action_norm`,
`q11_orbit_action_norm`, `q11_representative_orbit_norm`, `q11_fixed_union_norm` — whose only
purpose is to discharge the exhaustive per-row obligations in the leaves, and it raises both the
heartbeat and recursion limits although it proves nothing but one small injectivity lemma. That is
the definitions-only base of a finite certificate, together with its package-private checker
tactics: payload by every clause of the ownership boundary.

## Why the displayed-block half is the interface

All five theorems in the family's interface modules are decidable statements about displayed
finite tables, and not one of them mentions `pointAction`, `matrixCode`, `supportPerm`, or any
other action declaration:

- `mem_orbitPoints_iff_orbitIndex` and `point_orbit_partition` say that the seven displayed blocks
  are distinct, cover all 133 canonical indices, and have the sizes recorded in `orbitSize`.
- `unique_six_orbit` and `unique_twelve_orbit` say that the six-element block is exactly the
  witness index set and the twelve-element block exactly the standard-conic index set.
- `brianchon_points_one_orbit` says the ten Brianchon indices are block three, and
  `triplePointSet_eq_brianchonSet` identifies the triple-point ledger with them.

Each is `decide` or `fin_cases <;> decide` over tables of at most 133 elements. They are cheap,
they need none of the sixty matrices, and they are exactly what the rigidity gate audits:
`RelativeConicArcs/Gates/ClebschRigidityTrust.lean` is the only consumer of the whole family from
outside it, and it names precisely `point_orbit_partition`, `unique_six_orbit`,
`unique_twelve_orbit` and `brianchon_points_one_orbit`. The family is otherwise a closed island.

## The boundary

Stays in the monorepo, in an interface module carrying namespace
`RelativeConicArcs.Examples.Q11A5PointOrbits`, which the rigidity gate audits by fully qualified
name: `PointIndex`; `pointVec` and `canonicalIndex`, the formulas giving each index its projective
meaning; `orbitPoints`, `orbitIndex`, `orbitSize`, `orbitRepresentative`; `witnessIndex` and
`witnessSet`; `standardConicIndices`; `codeIndex`, `codeIndex_injective`, `codeEmbedding`,
`brianchonSet` and `triplePointSet`; and the five theorems above. All of these are displayed
tables or transparent formulas that the manuscript prints anyway, and none carries a raised limit.

Moves to the official order-eleven certificate package: `matrixCode`, `supportPerm`,
`matrixEntry`, `matrixVec`, `matrixDet`, `pointAction`, `supportPower`, `OrderFive`, `fixedPoints`,
`orderFiveFixedUnion`, `pointOrbit`, the four tactic macros, the sixty generated row leaves, the
seventy-two row aggregators, and the matrix, support and fixed-point satellites, together with the
exhaustive theorems that tie the displayed blocks to the action.

## What changes, and what the manifest must say

After the cut the monorepo proves that the seven displayed blocks partition the plane's canonical
indices with the recorded sizes, and that the six-, ten- and twelve-element blocks are the witness,
the Brianchon set and the standard conic. It no longer proves inside the monorepo that those blocks
are the orbits of the icosahedral `A5` action — that theorem, and the exhaustive verification
behind it, become an external package result consumed as a pinned trust fact, exactly as the
order-sixteen split established.

The trust manifest must say that full checking requires enumerating both halves: the local block
theorems here, and the package's own import-only gate over its sealed sources. That is a statement
about where each enumeration runs, not a gap in what can be checked — the same kind of reliance as
building against a cached Mathlib rather than compiling Mathlib from source, with the pinned
revision, manifest digest and toolchain recording exactly what to re-run to remove it. It is not
the same as the manifest's explicit external boundary, where a cited result has no reproducible
enumeration behind it at all. `RelativeConicArcs/TRUST.md` now carries that distinction as its own
section; the manuscript prose needs the matching sentence at the cut.

## Sequencing

Do the data split in the same window as the package cut, not before it. Editing
`Q11A5PointOrbitsData.lean` invalidates all sixty row leaves and the seventy-two aggregators, which
are the dominant elaboration cost in this family; splitting it now and again at package time pays
that rebuild twice for no intermediate benefit.
