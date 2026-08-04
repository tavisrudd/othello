# C864 — order-eleven point-orbit package cut

**Outcome: the cut is done.** The blocker described further down was dissolved by a change of
ownership decision, not by the base export it assumed. The point-orbit family, displayed blocks
included, now belongs to `finitegeom-clebsch-q11-certificates`; the monorepo keeps no point-orbit
module and consumes the package's pinned trust fact.

What landed, in order: package sources refreshed to the authority's bytes and the displayed-block
interface added (`9deca60`); manifest sealed over 122 modules (`27fc945`); cold gate green in the
package root in 17m33s at a 5.61 GiB peak; pack to
`/home/tavis/lean-backups/clebsch-q11-certificates-27fc945-cache.tgz` (39,336,154 bytes, sha256
`3ee72f7b0e327b5e4a38b6bc915b5ca9e13e58c526767a6c88c2459a7f0d1ef8`); the package build directory
quarantined, restored from that pack alone, and the gate then confirmed trace-current with no leaf
rebuilt; trust fact sealed over 171 declarations from the trace-only run and published (`76e7b43`);
the fact pinned into `lean/trust/certificate-packages.toml` by hash; the 113 monorepo point-orbit
modules and the generator deleted, the rigidity gate's four orbit audits and family import dropped,
and the monorepo gate green again (`ab1dc6cc`). `lean-external-fact.py check` and
`lean-certificate-boundary.py --verify-official-libraries` are both green, and the package tree is
clean.

Three findings worth keeping. The gate now also audits `pointVec_eq_projectiveVec`,
`pointVec_witnessIndex` and `mem_standardConicIndices_iff`, without which the orbit statements
identify the witness and the conic only by bare index. The sealed fact shows the rigidity terminal
depending on the two cited Dye 1991 inputs while every point-orbit statement depends on nothing
beyond `propext`, `Classical.choice` and `Quot.sound`, which is the separation the Dye audit item
needs. And sealing exposed a real defect in `lean-external-fact.py`: it compared axiom names as
printed, so one constant rendered unqualified inside its namespace and fully qualified elsewhere in
the same log read as two conflicting lists; names are now canonicalized when exactly one longer name
matches at a namespace boundary, with ambiguity still refusing, covered by two new tests.

**The published Dye boundary is true of the pinned base, and already behind the authority.** The
package resolves `RelativeConicArcs.Q11DyeAxioms` from the base at pin `85dfde9e`, where both
`dye1991_brianchon_bound` and `dye1991_equality_classification` are axioms, so the sealed fact
records the rigidity terminal depending on both.  In the monorepo authority only
`dye1991_equality_classification` remains an axiom: the triple-point bound was derived from the
general six-arc theorem in `RelativeConicArcs/SixArcConcurrenceBound.lean` earlier the same day, and
the second axiom's elimination is in progress.  Re-pinning the base therefore removes one cited
literature assumption from the package's published fact, which raises the value of the base
re-export beyond fixing the dropped-import defect.  Until that happens, neither the paper prose nor
the trust manifest may describe the package fact's two Dye axioms as the current boundary.

This also explains one row of the pruned-import audit recorded below: the base copy of
`Q11DyeAxioms` lacks the `SixArcConcurrenceBound` import the authority now has, and that is age
rather than breakage — the base version declares both axioms and needs no such import.  It is
evidence that the fifteen pruned imports must be triaged individually, and that a standalone base
build is the way to tell staleness from a real break.

Still owed before the point-orbit step is closed: the Clebsch-rigidity paper release chain, whose
`verification/build_trust_manifest.py` still pins package commit `9c5d474f` and must be advanced to
`76e7b43e` with the trust manifest, statement identity, PDFs and standalone mirror regenerated; and
a machine check that the modules the package and monorepo both carry stay byte-identical, so the
drift measured at the start of this cut cannot recur silently.

---

## Superseded: the blocker as it stood before the ownership decision

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
