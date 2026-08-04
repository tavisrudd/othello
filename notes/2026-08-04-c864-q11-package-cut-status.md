# C864 — order-eleven package cut: authority side done, downstream blocked

**Date:** 2026-08-04
**Lane:** `build-sys`
**Decision taken:** the point-orbit rows join `finitegeom-clebsch-q11-certificates` rather than
forming their own package.

## Done and committed

The authority-side split is landed and gate-green. `RelativeConicArcs/Q11A5PointOrbitsBlocks.lean`
holds the interface — the canonical `Fin 133` index dictionary (`pointVec`, `canonicalIndex`), the
seven displayed blocks with sizes and labels, the witness and standard-conic index sets, and the
Brianchon code embedding. `Q11A5PointOrbitsData.lean` is reduced to the payload — sixty matrix
codes, sixty support permutations, the action, support powers, the order-five predicate, the
fixed-point sets, and the four leaf-discharging tactic macros — and now proves nothing.
`Q11A5PointOrbitsPartition.lean` and `Q11A5PointOrbitsBrianchon.lean` import the interface.

`RelativeConicArcs.Gates.ClebschRigidityTrust` rebuilt green over the whole sixty-leaf family in
17m18s at a 5.70 GiB peak, run `20260804-221837-1f57c43b`.

## Package drift, measured

All 121 Lean sources of `~/src/lean/finitegeom-clebsch-q11-certificates` were compared byte for
byte against the monorepo: 54 identical, 67 differing, none package-only. Sixty-six differ only in
the generated-source banner naming the generator path — `lean/scripts/generate-q11-a5-point-action.py`
in the package against `scripts/generate-q11-a5-point-action.py` in the monorepo, the latter reading
correctly from either Lean root. The sixty-seventh, `Q11A5PointOrbits.lean`, carries docstring
improvements the monorepo has and the package never received. The monorepo is the authority in
every case and no intentional package-only source difference exists.

## Why the cut cannot proceed further today

The package payload cannot compile without the displayed blocks: `pointAction` is defined from
`pointVec` and `canonicalIndex`, and the leaf-discharging macros normalize through `orbitPoints`,
`orbitIndex`, `witnessSet` and `standardConicIndices`. So the interface module has to be visible to
the package. The package depends on exactly one thing, the base library, resolved by public Git URL
at a pinned revision. Keeping a second copy of the blocks inside the package is not an option: it
is the source shadow this task exists to remove.

The base therefore has to carry `Q11A5PointOrbitsBlocks` — and today it carries no point-orbit
module at all, and no `ParametrizedHoles` either. Getting them there needs three artifacts that do
not exist:

- a monorepo gate module for the exported area. The base has `Gates/ClebschRigidityHuman.lean` and
  a `clebsch_rigidity_human` trust area; the monorepo has neither;
- a generated trust fact for that gate, which the companion exporter reads from the committed
  registry rather than the worktree. The extraction window is now open, so this is runnable once
  the gate exists;
- a companion-export configuration. `lean/trust/export/` holds three configs, none for the arcs or
  rigidity human areas, so the exports that seeded those areas in the base are not reproducible
  from the current tree.

Authoring those three fixes the exported surface of a published library, which is a boundary
decision rather than a mechanical step. After it, the chain still requires the base commit to be
published to `origin/main` before the package can pin it; publishing is the author's decision and
no push is part of this task.

## The remaining sequence, once unblocked

1. Author the export area for the point-orbit interface, extract its fact, companion-export, adopt
   the delta in `~/src/lean/finitegeom` as a forward commit, and publish it.
2. In the package: re-pin the base, refresh the sixty-seven drifted sources from the monorepo, take
   the payload half of the data module, delete the interface modules now provided by the base,
   rebuild the gate, refresh the axiom audit, and reseal `MANIFEST.json` in the two-commit order.
3. Pack, erase, restore, and require the gate trace-current with no leaf rebuilt; seal and pin the
   external trust fact.
4. Only then delete the payload sources from the monorepo, update the umbrella, gates and boundary
   checker, and reconcile the trust manifest and paper prose.
